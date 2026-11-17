import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foldable/foldable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../game/sudoku_generator.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/saved_game_service.dart';
import '../services/scoreboard_service.dart';
import '../services/settings_service.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/duo_layout.dart';
import '../widgets/fade_route.dart';
import '../widgets/level_selector.dart';
import '../widgets/number_pad.dart';
import '../widgets/sudoku_board.dart';

// ============================================================
// Sudoku Sagax — Game Screen
// ============================================================

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.initialLevel = 1, this.savedGame});

  /// The level of a new game.
  final int initialLevel;

  /// A game to continue; [initialLevel] is then ignored.
  final SavedGame? savedGame;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  final _audio = AudioService.instance;
  final _analytics = AnalyticsService.instance;
  final _settings = SettingsService.instance;
  final _savedGames = SavedGameService.instance;
  final _focusNode = FocusNode();

  /// iPhone Duo side strip for the controls (set in build); null elsewhere.
  SideRail? _rail;

  /// Whether the window is wide enough for the keys beside the board (set
  /// in build). The app bar is then left out to give the board its height,
  /// and Back and Pause go to the top of the panel.
  bool _sideBySide = false;

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
    final saved = widget.savedGame;
    if (saved != null) {
      _resume(saved);
    } else {
      _resetFor(widget.initialLevel.clamp(1, sudokuLevels.length));
    }
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
    if (background == _appPaused) return;
    // The system may close the app from the background: save the clock too.
    if (background) _saveProgress();
    setState(() => _appPaused = background);
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
    // A new game replaces the saved one (the home screen asks first).
    unawaited(_savedGames.clear());
    _analytics.log('game_session_start', {
      'level': level,
      'clues': _game.puzzle.clueCount,
      'timer_shown': _settings.timer ? 1 : 0,
      'show_errors': _settings.showErrors ? 1 : 0,
      'left_handed': _settings.leftHanded ? 1 : 0,
    });
  }

  /// Continues a game the player left unfinished.
  void _resume(SavedGame saved) {
    _level = saved.level;
    _game = saved.game;
    _seconds = saved.seconds;
    _analytics.log('game_resumed', {'level': _level, 'seconds': _seconds});
  }

  void _startLevel(int level) => setState(() => _resetFor(level));

  /// Keeps the game on the device, so it can be continued after leaving the
  /// screen or the app. Called after every move, when the app goes to the
  /// background and when the player leaves the screen.
  void _saveProgress() {
    if (_solved) return;
    if (_game.hasProgress) {
      unawaited(_savedGames.save(_game, _seconds));
    } else {
      unawaited(_savedGames.clear());
    }
  }

  /// Back, from any layout: the game stays saved for Continue.
  void _onLeave() {
    if (_solved) return;
    _saveProgress();
    if (_game.hasProgress) {
      _analytics.log('game_left', {
        'level': _level,
        'seconds': _seconds,
        'hints': _game.hintsUsed,
        'filled': _game.values.where((v) => v != 0).length,
      });
    }
  }

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
        _saveProgress();
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
    if (_game.isSolved) {
      unawaited(_onSolved());
    } else {
      _saveProgress();
    }
  }

  void _onErase() {
    final i = _selected;
    if (i == null || !_canPlay) return;
    if (_game.erase(i)) {
      unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.6));
      setState(() {});
      _saveProgress();
    }
  }

  void _onUndo() {
    if (!_canPlay) return;
    if (_game.undo()) {
      unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.6));
      setState(() {});
      _saveProgress();
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
    if (_game.isSolved) {
      unawaited(_onSolved());
    } else {
      _saveProgress();
    }
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
    unawaited(_savedGames.clear()); // nothing left to continue
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

  // --- UI ---

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // iPhone Duo with a side strip: Back, the stats and Pause go there. Folded
    // like a laptop they go below the fold, which leaves the whole upper half
    // to the board. In a wide window they go to the top of the panel beside
    // the board, which then gets the full height.
    _rail = sideRailOf(context);
    final rail = _rail;
    final window = MediaQuery.sizeOf(context);
    _sideBySide = window.width > window.height * 1.1;
    final showAppBar = rail == null && !isLaptopPose(context) && !_sideBySide;

    return PopScope(
      // Leaving needs no confirmation: the game is kept for Continue.
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) _onLeave();
      },
      child: Scaffold(
        appBar: showAppBar
            ? AppBar(
                title: Text(l10n.appTitle),
                centerTitle: true,
                actions: [if (_canPause) _buildPauseButton(l10n)],
              )
            : null,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Focus(
              focusNode: _focusNode,
              autofocus: true,
              onKeyEvent: _onKey,
              child: SafeArea(
                child: FoldAwareBuilder(
                  builder: (context, constraints, fold) {
                    final foldRect = foldAcross(fold, constraints.biggest);
                    if (foldRect != null) {
                      return _buildFolded(l10n, foldRect, constraints.biggest);
                    }
                    // Decided from the window, as the app bar is, so that
                    // the layout without the app bar always has Back.
                    return _sideBySide
                        ? _buildLandscape(l10n, constraints)
                        : _buildPortrait(l10n, constraints);
                  },
                ),
              ),
            ),
            if (rail != null)
              RailBar(
                rail: rail,
                children: [
                  const BackButton(color: AppColors.electricCyan),
                  ..._statBadges(l10n, compact: true),
                  if (_canPause) _buildPauseButton(l10n),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortrait(AppLocalizations l10n, BoxConstraints constraints) {
    // Phones use the full width. On larger screens the height decides: the
    // board takes what the other rows leave, and they line up with the board.
    var width = constraints.maxWidth;
    if (width >= 600) {
      final otherRows = 276 * uiScaleOf(context);
      width = (constraints.maxHeight - otherRows).clamp(400.0, width);
    }
    // With the stats in the side rail, the keys of iPhone Duo's outer display
    // can use the height they free.
    final padHeight = _rail != null
        ? 72.0
        : (width / 9 * 0.95).clamp(58.0, 110.0);
    return Center(
      child: SizedBox(
        width: width,
        child: Column(
          children: [
            if (_rail == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: _buildStats(l10n),
              )
            else
              const SizedBox(height: 8),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildControls(l10n),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _buildNumberPad(height: padHeight),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLandscape(AppLocalizations l10n, BoxConstraints constraints) {
    // The board takes all the height, as long as the panel keeps enough
    // width. The side strip of the iPhone Duo already holds the stats.
    const margin = 12.0;
    final minPanelWidth = _rail == null ? 300.0 : 230.0;
    final boardSize = min(
      constraints.maxHeight - margin * 2,
      constraints.maxWidth - minPanelWidth - margin * 2,
    );
    final panelWidth = min(
      constraints.maxWidth - boardSize - margin * 2,
      520.0,
    );
    final board = Padding(
      padding: const EdgeInsets.all(margin),
      child: SizedBox.square(
        dimension: boardSize,
        child: _buildBoardArea(l10n),
      ),
    );
    final panel = SizedBox(
      width: panelWidth,
      child: _buildPanel(l10n, Size(panelWidth, constraints.maxHeight)),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // The Left-handed option puts the keys on the left.
      children: _settings.leftHanded ? [panel, board] : [board, panel],
    );
  }

  /// Partly folded iPhone Duo: the board on one side of the fold, the rest
  /// on the other. [area] is the space around the fold.
  Widget _buildFolded(AppLocalizations l10n, Rect fold, Size area) {
    final board = Padding(
      padding: const EdgeInsets.all(12),
      child: Center(child: _buildBoardArea(l10n)),
    );
    // Folded like a laptop: the board above the fold, the rest below.
    final sideBySide = fold.height >= fold.width;
    if (!sideBySide) {
      return FoldPanes(
        fold: fold,
        first: board,
        second: _buildLowerHalf(l10n, area.height - fold.bottom),
      );
    }
    // Folded like a book: the keys on the right of the fold, or on the left
    // with the Left-handed option.
    if (_settings.leftHanded) {
      return FoldPanes(
        fold: fold,
        first: _buildPanel(l10n, Size(fold.left, area.height)),
        second: board,
      );
    }
    return FoldPanes(
      fold: fold,
      first: board,
      second: _buildPanel(l10n, Size(area.width - fold.right, area.height)),
    );
  }

  /// Everything but the board, in one column, for a pane of [size]. The keys
  /// form a 3×3 block that grows into the free height, up to square keys
  /// (a little taller in a narrow pane).
  Widget _buildPanel(AppLocalizations l10n, Size size) {
    final scale = uiScaleOf(context);
    final narrow = size.width < 320;
    // Back and Pause, unless the app bar or the side rail holds them.
    final showNavigation = _rail == null && _sideBySide;
    // Rough heights of the rows above the keys. The status counts at its
    // tallest: its longest message takes 2 lines, or 3 in a narrow pane.
    final navigationHeight = showNavigation ? 48 : 0;
    final statsHeight = _rail == null ? 80 : 0;
    final statusHeight = narrow ? 98 : 74;
    final controlsHeight = narrow ? 130 : 70;
    final otherRows =
        navigationHeight + statsHeight + statusHeight + controlsHeight;
    final freeHeight = (size.height - otherRows * scale - 24) / 3 - 8;
    final keyWidth = (size.width - 20) / 3 - 8;
    // A narrow pane has height to spare, so its keys can be taller than wide.
    final maxKeyHeight = narrow ? keyWidth * 1.3 : keyWidth;
    final keyHeight = max(52.0, min(freeHeight, maxKeyHeight));
    // A small gap on the board's side, a wider one at the edge.
    final onLeft = _settings.leftHanded;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(onLeft ? 16 : 4, 12, onLeft ? 4 : 16, 12),
        child: Column(
          children: [
            if (showNavigation)
              Row(
                children: [
                  const BackButton(color: AppColors.electricCyan),
                  const Spacer(),
                  if (_canPause) _buildPauseButton(l10n),
                ],
              ),
            if (_rail == null) _buildStats(l10n),
            _buildStatus(l10n, keepHeight: true),
            const SizedBox(height: 8),
            if (_showWinBar)
              _buildWinBar(l10n)
            else if (!_solved) ...[
              _buildControls(l10n, twoRows: narrow),
              const SizedBox(height: 12),
              _buildNumberPad(height: keyHeight, grid: true),
            ],
          ],
        ),
      ),
    );
  }

  /// Below the fold of an iPhone Duo folded like a laptop: everything but the
  /// board, Back and Pause included, in a pane of [height].
  Widget _buildLowerHalf(AppLocalizations l10n, double height) {
    final padHeight = (height - 190).clamp(58.0, 90.0);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              children: [
                const BackButton(color: AppColors.electricCyan),
                Expanded(child: _buildStats(l10n)),
                // Keeps the stats centred when there is no Pause button.
                SizedBox(
                  width: 48,
                  child: _canPause ? _buildPauseButton(l10n) : null,
                ),
              ],
            ),
            _buildStatus(l10n),
            if (_showWinBar)
              _buildWinBar(l10n)
            else if (!_solved) ...[
              _buildControls(l10n),
              const SizedBox(height: 8),
              _buildNumberPad(height: padHeight),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPad({required double height, bool grid = false}) {
    return NumberPad(
      game: _game,
      notesMode: _notesMode,
      onDigit: _onDigit,
      height: height,
      grid: grid,
    );
  }

  Widget _buildStats(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _statBadges(l10n),
    );
  }

  /// Level, time and mistakes; [compact] for the iPhone Duo side rail.
  List<Widget> _statBadges(AppLocalizations l10n, {bool compact = false}) {
    return [
      _StatBadge(label: l10n.levelLabel, value: '$_level', compact: compact),
      if (_settings.timer)
        _StatBadge(
          label: l10n.timeLabel,
          value: formatTime(_seconds),
          compact: compact,
        ),
      if (_settings.showErrors)
        _StatBadge(
          label: l10n.mistakesLabel,
          value: '${_game.mistakes}',
          valueColor: _game.mistakes > 0 ? AppColors.errorRed : null,
          compact: compact,
        ),
    ];
  }

  bool get _canPause => _settings.timer && !_solved;

  Widget _buildPauseButton(AppLocalizations l10n) {
    return IconButton(
      tooltip: _userPaused ? l10n.resume : l10n.pause,
      onPressed: _onTogglePause,
      icon: Icon(
        _userPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
        color: AppColors.electricCyan,
        size: 24 * uiScaleOf(context),
      ),
    );
  }

  /// The message for the state of the game. With [keepHeight] it is always
  /// as tall as the longest message, so the rows below it (the keys beside
  /// the board) don't move when the message changes.
  Widget _buildStatus(AppLocalizations l10n, {bool keepHeight = false}) {
    final primary = Theme.of(context).primaryColor;
    final messages = [
      (l10n.solved, primary),
      (l10n.paused, AppColors.softSlate),
      (l10n.statusFullWrong, AppColors.hintAmber),
      (l10n.statusNotes, primary),
      (l10n.statusPlay, AppColors.softSlate),
    ];
    final int current;
    if (_solved) {
      current = 0;
    } else if (_userPaused) {
      current = 1;
    } else if (_game.isFull) {
      current = 2;
    } else if (_notesMode) {
      current = 3;
    } else {
      current = 4;
    }

    Widget message(int index) {
      final (text, color) = messages[index];
      return Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.exo2(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      // IndexedStack shows one child but is as large as its largest one.
      child: keepHeight
          ? IndexedStack(
              index: current,
              alignment: Alignment.center,
              children: [for (int i = 0; i < messages.length; i++) message(i)],
            )
          : message(current),
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

  /// Undo, Erase, Notes and Hint, in [twoRows] when the pane is narrow.
  Widget _buildControls(AppLocalizations l10n, {bool twoRows = false}) {
    final buttons = <Widget>[
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
    ];

    Widget row(Iterable<Widget> items) {
      return Row(children: [for (final item in items) Expanded(child: item)]);
    }

    if (!twoRows) return row(buttons);
    return Column(
      children: [
        row(buttons.take(2)),
        const SizedBox(height: 6),
        row(buttons.skip(2)),
      ],
    );
  }

  Widget _buildWinBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
      child: Column(
        children: [
          // Kept on one line and shrunk to fit: a narrow pane would
          // otherwise break the word in two.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l10n.congratulations,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
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
  const _StatBadge({
    required this.label,
    required this.value,
    this.valueColor,
    this.compact = false,
  });

  final String label;
  final String value;
  final Color? valueColor;

  /// Narrow and full-width, for the iPhone Duo side rail.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? double.infinity : null,
      constraints: BoxConstraints(
        minWidth: compact ? 0 : 88 * uiScaleOf(context),
      ),
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 6)
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: compact ? 11 : 13,
                color: AppColors.softSlate,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.exo2(
                fontSize: compact ? 18 : 22,
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.snowWhite,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
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
    final scale = uiScaleOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6 * scale),
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
              Icon(icon, color: fg, size: 26 * scale),
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

    final result = Column(
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
            rank == 1 ? l10n.newBestTime : l10n.rankOnScoreboard(rank, level),
            style: GoogleFonts.exo2(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: rank == 1 ? AppColors.hintAmber : primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    final actions = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
    );

    Widget pane(Widget child) {
      return CenteredPane(
        maxWidth: 480 * uiScaleOf(context),
        padding: 32,
        child: child,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.midnightNavy,
      body: SafeArea(
        child: TwoPaneLayout(
          // A large screen shows it all in one calm column; short windows
          // need both halves to avoid scrolling.
          splitWhenWide: isCompactHeight(context),
          first: pane(result),
          second: pane(actions),
          single: pane(
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [result, const SizedBox(height: 16), actions],
            ),
          ),
        ),
      ),
    );
  }
}
