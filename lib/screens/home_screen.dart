import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../game/sudoku_generator.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/saved_game_service.dart';
import '../services/settings_service.dart';
import '../widgets/adaptive_layout.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/duo_layout.dart';
import '../widgets/fade_route.dart';
import '../widgets/level_selector.dart';
import 'game_screen.dart';
import 'info_screen.dart';
import 'options_screen.dart';
import 'scoreboard_screen.dart';

// ============================================================
// Ecrã Inicial
// ============================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedLevel = 1;

  final _audio = AudioService.instance;
  final _analytics = AnalyticsService.instance;

  static const _languages = [
    ('en', '🇬🇧  English'),
    ('pt', '🇵🇹  Português'),
    ('fr', '🇫🇷  Français'),
    ('es', '🇪🇸  Español'),
    ('de', '🇩🇪  Deutsch'),
  ];

  @override
  void initState() {
    super.initState();
    unawaited(_audio.startMusic());
  }

  String _languageLabel(String code) {
    return _languages
        .firstWhere((l) => l.$1 == code, orElse: () => _languages[0])
        .$2;
  }

  Future<void> _open(
    Widget screen,
    String event, [
    Map<String, Object>? parameters,
  ]) async {
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85));
    _analytics.log(event, parameters);
    await Navigator.push(context, fadeRoute<void>(screen));
    // Back home: a game left unfinished now shows Continue.
    if (mounted) setState(() {});
  }

  /// Starts a new game at the selected level. It replaces the saved game,
  /// so the player confirms first when there is one.
  Future<void> _play() async {
    final saved = SavedGameService.instance.savedGame;
    if (saved != null) {
      final l10n = AppLocalizations.of(context)!;
      unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85));
      final replace = await showConfirmDialog(
        context,
        title: l10n.newGameTitle,
        message: l10n.newGameMessage(saved.level),
        confirmLabel: l10n.newGame,
        cancelLabel: l10n.cancel,
        destructive: true,
      );
      if (!replace || !mounted) return;
      _analytics.log('saved_game_replaced', {'level': saved.level});
    }
    await _open(GameScreen(initialLevel: _selectedLevel), 'level_selected', {
      'level': _selectedLevel,
      'clues': sudokuLevels[_selectedLevel - 1].clues,
    });
  }

  /// Opens the saved game where the player left it.
  void _continue() {
    final saved = SavedGameService.instance.savedGame;
    if (saved == null) return;
    unawaited(
      _open(GameScreen(savedGame: saved), 'continue_selected', {
        'level': saved.level,
      }),
    );
  }

  /// "Continue · Level 5 · 12:34" (the time only with the Timer option).
  String _continueLabel(AppLocalizations l10n, SavedGame saved) {
    var label = '${l10n.continueGame} · ${l10n.levelLabel} ${saved.level}';
    if (SettingsService.instance.timer) {
      label += ' · ${formatTime(saved.seconds)}';
    }
    return label;
  }

  void _showLanguagePicker() {
    const primary = AppColors.electricCyan;
    final currentCode = Localizations.localeOf(context).languageCode;
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85));

    showModalBottomSheet(
      context: context,
      // As tall as the 5 languages need, up to the height there is: only half
      // the screen on an iPhone Duo folded like a laptop.
      isScrollControlled: true,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        // Scrolls in short windows, such as a phone held sideways.
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.softSlate,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              for (final (code, label) in _languages)
                ListTile(
                  leading: code == currentCode
                      ? const Icon(Icons.check_circle, color: primary)
                      : const Icon(
                          Icons.circle_outlined,
                          color: AppColors.softSlate,
                        ),
                  title: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: code == currentCode
                          ? primary
                          : AppColors.snowWhite,
                      fontWeight: code == currentCode
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    unawaited(
                      _audio.playSfx(AudioService.buttonSfx, volume: 0.85),
                    );
                    _analytics.log('language_changed', {'language_code': code});
                    SettingsService.instance.locale = Locale(code);
                    Navigator.pop(ctx);
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _openInfo() => unawaited(_open(const InfoScreen(), 'info_opened'));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scale = uiScaleOf(context);
    // iPhone Duo with a side strip: Info and the language go there.
    final rail = sideRailOf(context);

    final compact = isCompactHeight(context);
    final gap = compact ? 14.0 : 28.0 * scale;
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    final logoHeight = (shortestSide * 0.18).clamp(98.0, 190.0);

    Widget pane(Widget child) => CenteredPane(
      maxWidth: 480 * scale,
      padding: compact ? 12 : 24,
      child: child,
    );

    final links = rail == null ? _buildLinks(l10n) : null;
    // Continue, for a game left unfinished. In two panes it goes under the
    // brand, where there is room; in one column, under Play.
    final saved = SavedGameService.instance.savedGame;
    final continueButton = saved == null
        ? null
        : _buildContinueButton(l10n, saved);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: TwoPaneLayout(
              first: pane(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBrand(l10n, logoHeight: logoHeight, gap: gap),
                    if (continueButton != null) ...[
                      SizedBox(height: gap),
                      continueButton,
                    ],
                    if (links != null) ...[SizedBox(height: gap), links],
                  ],
                ),
              ),
              second: pane(_buildMenu(l10n, compact: compact, gap: gap)),
              single: pane(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBrand(
                      l10n,
                      logoHeight: compact ? 84 : logoHeight,
                      gap: gap,
                    ),
                    SizedBox(height: gap),
                    _buildMenu(
                      l10n,
                      compact: compact,
                      gap: gap,
                      continueButton: continueButton,
                    ),
                    if (links != null) ...[
                      SizedBox(height: compact ? 10 : 24 * scale),
                      links,
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (rail != null)
            RailBar(
              rail: rail,
              children: [
                IconButton(
                  tooltip: l10n.info,
                  onPressed: _openInfo,
                  icon: const Icon(
                    Icons.info_outline,
                    color: AppColors.electricCyan,
                  ),
                ),
                IconButton(
                  tooltip: _languageLabel(
                    Localizations.localeOf(context).languageCode,
                  ),
                  onPressed: _showLanguagePicker,
                  icon: const Icon(
                    Icons.language,
                    color: AppColors.electricCyan,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Logo, developer and tagline.
  Widget _buildBrand(
    AppLocalizations l10n, {
    required double logoHeight,
    required double gap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rendered from SudokuLogo by tool/store/logo_test.dart. The PNG has
        // 1/12 padding per side for the glow, so a height of 98 shows the
        // logo itself at 84.
        Image.asset(
          'assets/images/sudoku-sagax-transp.png',
          height: logoHeight,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.bySagaxGames,
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: gap),
        Text(
          l10n.tagline,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Full-width "Continue · Level 5 · 12:34" button.
  Widget _buildContinueButton(AppLocalizations l10n, SavedGame saved) {
    return SizedBox(
      width: double.infinity,
      child: _SecondaryButton(
        icon: Icons.play_arrow_rounded,
        label: _continueLabel(l10n, saved),
        onPressed: _continue,
      ),
    );
  }

  /// Level selector, Play, [continueButton] (when given), Scoreboard and
  /// Options.
  Widget _buildMenu(
    AppLocalizations l10n, {
    required bool compact,
    required double gap,
    Widget? continueButton,
  }) {
    final scale = uiScaleOf(context);
    final buttonGap = compact ? 10.0 : 14.0 * scale;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Seletor de nível
        Text(
          l10n.selectLevel,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: compact ? 8 : 16 * scale),
        LevelSelector(
          selected: _selectedLevel,
          chipSize: (compact ? 52 : 64) * scale,
          onSelected: (level) {
            if (level == _selectedLevel) return;
            unawaited(
              _audio.playSfx(AudioService.levelSelectSfx, volume: 0.75),
            );
            _analytics.log('level_chip_tapped', {'level': level});
            setState(() => _selectedLevel = level);
          },
        ),
        SizedBox(height: compact ? 8 : 12 * scale),
        Text(
          levelSummary(l10n, _selectedLevel),
          style: GoogleFonts.inter(fontSize: 15, color: AppColors.softSlate),
        ),
        SizedBox(height: gap),

        // Botão Jogar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: _play, child: Text(l10n.play)),
        ),
        SizedBox(height: buttonGap),

        // Continuar o jogo guardado
        if (continueButton != null) ...[
          continueButton,
          SizedBox(height: buttonGap),
        ],

        // Recordes + Opções
        Row(
          children: [
            Expanded(
              child: _SecondaryButton(
                icon: Icons.emoji_events_outlined,
                label: l10n.scoreboard,
                onPressed: () => _open(
                  ScoreboardScreen(initialLevel: _selectedLevel),
                  'scoreboard_opened',
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SecondaryButton(
                icon: Icons.tune,
                label: l10n.options,
                onPressed: () => _open(const OptionsScreen(), 'options_opened'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Info and language buttons.
  Widget _buildLinks(AppLocalizations l10n) {
    final primary = Theme.of(context).primaryColor;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      children: [
        TextButton.icon(
          onPressed: _openInfo,
          icon: Icon(Icons.info_outline, color: primary),
          label: Text(
            l10n.info,
            style: GoogleFonts.exo2(fontSize: 16, color: primary),
          ),
        ),
        TextButton.icon(
          onPressed: _showLanguagePicker,
          icon: Icon(Icons.language, color: primary),
          label: Text(
            _languageLabel(Localizations.localeOf(context).languageCode),
            style: GoogleFonts.exo2(fontSize: 16, color: primary),
          ),
        ),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: BorderSide(color: primary.withValues(alpha: 0.6)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(icon, size: 20 * uiScaleOf(context)),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.exo2(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
