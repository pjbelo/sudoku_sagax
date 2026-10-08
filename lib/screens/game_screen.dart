import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../game/sudoku_generator.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/scoreboard_service.dart';
import '../services/settings_service.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/fade_route.dart';
import '../widgets/level_selector.dart';
import '../widgets/number_pad.dart';
import '../widgets/sudoku_board.dart';

// ============================================================
// Sudoku Sagax — Game Screen
// ============================================================

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.initialLevel = 1});

  final int initialLevel;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  final _audio = AudioService.instance;
  final _analytics = AnalyticsService.instance;
  final _settings = SettingsService.instance;
  final _focusNode = FocusNode();

  late int _level;
  late SudokuGame _game;
  int? _selected;
  bool _notesMode = false;

  /// Elapsed play time, hint penalties included. Counted even when the
  /// Timer option hides the clock, so every win can go on the scoreboard.
  int _seconds = 0;
  Timer? _ticker;
  bool _userPaused = false;
  bool _appPaused = false;

  bool _solved = false;

  /// Slim "Congratulations + OK" bar shown at the bottom once solved, so the
  /// finished grid stays visible; OK opens the summary screen.
  bool _showWinBar = false;

  /// Scoreboard position of the last win (null = outside the top 10).
  int? _rank;

  bool get _paused => _userPaused || _appPaused;

  /// Whether leaving now would throw away work worth a confirmation.
  bool get _hasProgress => !_solved && (_game.canUndo || _game.hintsUsed > 0);

  static final _digitKeys = <LogicalKeyboardKey, int>{
    for (final (i, key) in const [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
      LogicalKeyboardKey.digit9,
    ].indexed)
      key: i + 1,
    for (final (i, key) in const [
      LogicalKeyboardKey.numpad1,
      LogicalKeyboardKey.numpad2,
      LogicalKeyboardKey.numpad3,
      LogicalKeyboardKey.numpad4,
      LogicalKeyboardKey.numpad5,
      LogicalKeyboardKey.numpad6,
      LogicalKeyboardKey.numpad7,
      LogicalKeyboardKey.numpad8,
      LogicalKeyboardKey.numpad9,
    ].indexed)
      key: i + 1,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetFor(widget.initialLevel.clamp(1, sudokuLevels.length));
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Stop the clock whenever the app is not in the foreground.
    final background = state != AppLifecycleState.resumed;
    if (background != _appPaused) setState(() => _appPaused = background);
  }

  void _tick() {
    if (_paused || _solved) return;
    _seconds++;
    // Only repaint when the clock is actually on screen.
    if (_settings.timer) setState(() {});
  }

  // --- Game flow ---

  void _resetFor(int level) {
    _level = level;
    _game = SudokuGame(generatePuzzle(level));
    _selected = null;
    _notesMode = false;
    _seconds = 0;
    _userPaused = false;
    _solved = false;
    _showWinBar = false;
    _rank = null;
    _analytics.log('game_session_start', {
      'level': level,
      'clues': _game.puzzle.clueCount,
      'timer_shown': _settings.timer ? 1 : 0,
      'show_errors': _settings.showErrors ? 1 : 0,
    });
  }

  void _startLevel(int level) => setState(() => _resetFor(level));

  bool get _canPlay => !_solved && !_paused;

  void _onCellTap(int i) {
    if (!_canPlay) return;
    setState(() => _selected = i);
  }

  void _onDigit(int digit) {
    final i = _selected;
    if (i == null || !_canPlay) return;

    if (_notesMode) {
      if (_game.toggleNote(i, digit)) {
        unawaited(_audio.playSfx(AudioService.digitSfx, volume: 0.5));
        setState(() {});
      }
      return;
    }

    final result = _game.enterDigit(i, digit);
    if (result == EntryResult.ignored) return;
    if (result == EntryResult.wrong && _settings.showErrors) {
      unawaited(_audio.playSfx(AudioService.wrongSfx, volume: 0.8));
    } else {
      unawaited(_audio.playSfx(AudioService.digitSfx, volume: 0.8));
    }
    setState(() {});
    if (_game.isSolved) unawaited(_onSolved());
  }

  void _onErase() {
    final i = _selected;
    if (i == null || !_canPlay) return;
    if (_game.erase(i)) {
      unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.6));
      setState(() {});
    }
  }

  void _onUndo() {
    if (!_canPlay) return;
    if (_game.undo()) {
      unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.6));
      setState(() {});
    }
  }

  void _onToggleNotes() {
    if (!_canPlay) return;
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.7));
    setState(() => _notesMode = !_notesMode);
  }

  void _onHint() {
    if (!_canPlay) return;
    final cell = _game.hint(preferred: _selected);
    if (cell == null) return;
    unawaited(_audio.playSfx(AudioService.hintSfx, volume: 0.85));
    _analytics.log('hint_used', {
      'level': _level,
      'hints_used': _game.hintsUsed,
      'seconds': _seconds,
    });
    setState(() {
      _seconds += hintPenaltySeconds;
      _selected = cell;
    });
    if (_game.isSolved) unawaited(_onSolved());
  }

  void _onTogglePause() {
    if (_solved) return;
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.7));
    setState(() => _userPaused = !_userPaused);
  }

  void _moveSelection(int dRow, int dCol) {
    if (!_canPlay) return;
    final current = _selected ?? 40;
    final r = (rowOf(current) + dRow) % 9;
    final c = (colOf(current) + dCol) % 9;
    setState(() => _selected = r * 9 + c);
  }

  /// Keyboard play (desktop, web, tablets with keyboards).
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final digit = _digitKeys[key];
    if (digit != null) {
      _onDigit(digit);
    } else if (key == LogicalKeyboardKey.backspace ||
        key == LogicalKeyboardKey.delete) {
      _onErase();
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _moveSelection(-1, 0);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      _moveSelection(1, 0);
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      _moveSelection(0, -1);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      _moveSelection(0, 1);
    } else if (key == LogicalKeyboardKey.keyN && event is KeyDownEvent) {
      _onToggleNotes();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  Future<void> _onSolved() async {
    // Set before the await so the clock stops on this exact second.
    _solved = true;
    _selected = null;
    unawaited(_audio.playSfx(AudioService.winSfx));
    final rank = await ScoreboardService.instance.add(
      _level,
      ScoreEntry(
        seconds: _seconds,
        hints: _game.hintsUsed,
        mistakes: _game.mistakes,
        date: DateTime.now(),
      ),
    );
    _analytics.log('level_completed', {
      'level': _level,
      'seconds': _seconds,
      'hints': _game.hintsUsed,
      'mistakes': _game.mistakes,
      'rank': rank ?? 0, // 0 = outside the top 10
    });
    if (!mounted) return;
    setState(() {
      _rank = rank;
      _showWinBar = true;
    });
  }

  /// Opens the summary screen with the level stats and the follow-up actions.
  Future<void> _openWinSummary() async {
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85));
    setState(() => _showWinBar = false);

    final action = await Navigator.of(context).push<_WinAction>(
      fadeRoute(
        _WinSummaryScreen(
          level: _level,
          seconds: _seconds,
          hints: _game.hintsUsed,
          mistakes: _game.mistakes,
          rank: _rank,
          onButtonSfx: () =>
              unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85)),
        ),
        milliseconds: 250,
      ),
    );

    if (!mounted) return;

    switch (action) {
      case null:
        // Dismissed with the system back gesture: bring the bar back.
        setState(() => _showWinBar = true);
      case _WinAction.menu:
        _analytics.log('back_to_menu', {'level': _level});
        Navigator.of(context).pop();
      case _WinAction.sameLevel:
        _analytics.log('same_level', {'level': _level});
        _startLevel(_level);
      case _WinAction.nextLevel:
        unawaited(_audio.playSfx(AudioService.levelUpSfx));
        _analytics.log('next_level', {
          'completed_level': _level,
          'next_level': _level + 1,
        });
        _startLevel(_level + 1);
      case _WinAction.playAgain:
        unawaited(_audio.playSfx(AudioService.levelUpSfx));
        _analytics.log('play_again', {'completed_level': _level});
        _startLevel(1);
    }
  }

  Future<bool> _confirmLeave() async {
    final l10n = AppLocalizations.of(context)!;
    final wasPaused = _userPaused;
    setState(() => _userPaused = true);
    final leave = await showConfirmDialog(
      context,
      title: l10n.leaveGameTitle,
      message: l10n.leaveGameMessage,
      confirmLabel: l10n.leave,
      cancelLabel: l10n.stay,
      destructive: true,
    );
    if (mounted && !leave) setState(() => _userPaused = wasPaused);
    return leave;
  }

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: !_hasProgress,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await _confirmLeave();
        if (!leave || !context.mounted) return;
        _analytics.log('game_abandoned', {
          'level': _level,
          'seconds': _seconds,
          'hints': _game.hintsUsed,
          'filled': _game.values.where((v) => v != 0).length,
        });
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle),
          centerTitle: true,
          actions: [
            if (_settings.timer && !_solved)
              IconButton(
                tooltip: _userPaused ? l10n.resume : l10n.pause,
                onPressed: _onTogglePause,
                icon: Icon(
                  _userPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: AppColors.electricCyan,
                ),
              ),
          ],
        ),
        body: Focus(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: _onKey,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final landscape =
                    constraints.maxWidth > constraints.maxHeight * 1.1;
                return landscape
                    ? _buildLandscape(l10n, constraints)
                    : _buildPortrait(l10n);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortrait(AppLocalizations l10n) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: _buildStats(l10n),
            ),
            _buildStatus(l10n),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(child: _buildBoardArea(l10n)),
              ),
            ),
            const SizedBox(height: 12),
            if (_showWinBar)
              _buildWinBar(l10n)
            else if (!_solved) ...[
              _buildControls(l10n),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: NumberPad(
                  game: _game,
                  notesMode: _notesMode,
                  onDigit: _onDigit,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLandscape(AppLocalizations l10n, BoxConstraints constraints) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(child: _buildBoardArea(l10n)),
          ),
        ),
        SizedBox(
          width: min(400, constraints.maxWidth * 0.45),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(4, 12, 16, 12),
            child: Column(
              children: [
                _buildStats(l10n),
                _buildStatus(l10n),
                const SizedBox(height: 8),
                if (_showWinBar)
                  _buildWinBar(l10n)
                else if (!_solved) ...[
                  _buildControls(l10n),
                  const SizedBox(height: 12),
                  NumberPad(
                    game: _game,
                    notesMode: _notesMode,
                    onDigit: _onDigit,
                    height: 64,
                    grid: true,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStats(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatBadge(label: l10n.levelLabel, value: '$_level'),
        if (_settings.timer)
          _StatBadge(label: l10n.timeLabel, value: formatTime(_seconds)),
        if (_settings.showErrors)
          _StatBadge(
            label: l10n.mistakesLabel,
            value: '${_game.mistakes}',
            valueColor: _game.mistakes > 0 ? AppColors.errorRed : null,
          ),
      ],
    );
  }

  Widget _buildStatus(AppLocalizations l10n) {
    final primary = Theme.of(context).primaryColor;
    final (String text, Color color) = _solved
        ? (l10n.solved, primary)
        : _userPaused
        ? (l10n.paused, AppColors.softSlate)
        : _game.isFull
        ? (l10n.statusFullWrong, AppColors.hintAmber)
        : _notesMode
        ? (l10n.statusNotes, primary)
        : (l10n.statusPlay, AppColors.softSlate);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.exo2(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBoardArea(AppLocalizations l10n) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SudokuBoard(
          game: _game,
          selected: _selected,
          showErrors: _settings.showErrors,
          onCellTap: _onCellTap,
          hidden: _userPaused,
        ),
        if (_userPaused)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.paused,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _onTogglePause,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l10n.resume),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildControls(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ControlButton(
          icon: Icons.undo_rounded,
          label: l10n.undo,
          onPressed: _game.canUndo ? _onUndo : null,
        ),
        _ControlButton(
          icon: Icons.backspace_outlined,
          label: l10n.erase,
          onPressed: _onErase,
        ),
        _ControlButton(
          icon: _notesMode ? Icons.edit : Icons.edit_outlined,
          label: l10n.notes,
          onPressed: _onToggleNotes,
          active: _notesMode,
        ),
        if (_settings.hints)
          _ControlButton(
            icon: Icons.lightbulb_outline,
            label: l10n.hint(hintPenaltySeconds),
            onPressed: _onHint,
            color: AppColors.hintAmber,
          ),
      ],
    );
  }

  Widget _buildWinBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
      child: Column(
        children: [
          Text(
            l10n.congratulations,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _openWinSummary,
              child: Text(l10n.okButton),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small stat badge used in the header.
class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 88),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.softSlate),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.exo2(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.snowWhite,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon + label button under the board (Undo, Erase, Notes, Hint).
class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.active = false,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool active;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = color ?? AppColors.electricCyan;
    final enabled = onPressed != null;
    final fg = enabled ? base : base.withValues(alpha: 0.35);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: active ? base.withValues(alpha: 0.18) : null,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? base : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.exo2(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// What the player chose on the win summary screen.
enum _WinAction { menu, sameLevel, nextLevel, playAgain }

/// Post-win screen: level stats plus the follow-up actions. Shown after the
/// player dismisses the "Congratulations" bar with OK.
class _WinSummaryScreen extends StatelessWidget {
  const _WinSummaryScreen({
    required this.level,
    required this.seconds,
    required this.hints,
    required this.mistakes,
    required this.rank,
    required this.onButtonSfx,
  });

  final int level;
  final int seconds;
  final int hints;
  final int mistakes;
  final int? rank;
  final VoidCallback onButtonSfx;

  void _close(BuildContext context, _WinAction action) {
    onButtonSfx();
    Navigator.of(context).pop(action);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = Theme.of(context).primaryColor;
    final hasNext = level < sudokuLevels.length;
    final rank = this.rank;

    return Scaffold(
      backgroundColor: AppColors.midnightNavy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.congratulations,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.levelCompleted(level, formatTime(seconds)),
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.hintsAndMistakes(hints, mistakes),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  if (rank != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      rank == 1
                          ? l10n.newBestTime
                          : l10n.rankOnScoreboard(rank, level),
                      style: GoogleFonts.exo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: rank == 1 ? AppColors.hintAmber : primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    hasNext
                        ? l10n.nextLevelInfo(
                            bandName(l10n, sudokuLevels[level].band),
                            sudokuLevels[level].clues,
                          )
                        : l10n.allLevelsComplete,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _close(
                        context,
                        hasNext ? _WinAction.nextLevel : _WinAction.playAgain,
                      ),
                      child: Text(hasNext ? l10n.nextLevel : l10n.playAgain),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _close(context, _WinAction.sameLevel),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primary,
                        side: BorderSide(color: primary.withValues(alpha: 0.6)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(
                        l10n.sameLevel,
                        style: GoogleFonts.exo2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _close(context, _WinAction.menu),
                    child: Text(
                      l10n.backToMenu,
                      style: GoogleFonts.exo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.electricCyan,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
