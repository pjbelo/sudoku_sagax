import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_generator.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/settings_service.dart';
import '../widgets/fade_route.dart';
import '../widgets/level_selector.dart';
import '../widgets/sudoku_logo.dart';
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

  void _open(Widget screen, String event, [Map<String, Object>? parameters]) {
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85));
    _analytics.log(event, parameters);
    Navigator.push(context, fadeRoute<void>(screen));
  }

  void _showLanguagePicker() {
    const primary = AppColors.electricCyan;
    final currentCode = Localizations.localeOf(context).languageCode;
    unawaited(_audio.playSfx(AudioService.buttonSfx, volume: 0.85));

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
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
                    color: code == currentCode ? primary : AppColors.snowWhite,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SudokuLogo(),
                  const SizedBox(height: 14),
                  Text(
                    l10n.bySagaxGames,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: primary,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    l10n.tagline,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),

                  // Seletor de nível
                  Text(
                    l10n.selectLevel,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  LevelSelector(
                    selected: _selectedLevel,
                    onSelected: (level) {
                      if (level == _selectedLevel) return;
                      unawaited(
                        _audio.playSfx(
                          AudioService.levelSelectSfx,
                          volume: 0.75,
                        ),
                      );
                      _analytics.log('level_chip_tapped', {'level': level});
                      setState(() => _selectedLevel = level);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    levelSummary(l10n, _selectedLevel),
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppColors.softSlate,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Botão Jogar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _open(
                        GameScreen(initialLevel: _selectedLevel),
                        'level_selected',
                        {
                          'level': _selectedLevel,
                          'clues': sudokuLevels[_selectedLevel - 1].clues,
                        },
                      ),
                      child: Text(l10n.play),
                    ),
                  ),
                  const SizedBox(height: 14),

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
                          onPressed: () =>
                              _open(const OptionsScreen(), 'options_opened'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Botões Info + Língua
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    children: [
                      TextButton.icon(
                        onPressed: () =>
                            _open(const InfoScreen(), 'info_opened'),
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
                          _languageLabel(
                            Localizations.localeOf(context).languageCode,
                          ),
                          style: GoogleFonts.exo2(fontSize: 16, color: primary),
                        ),
                      ),
                    ],
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
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.exo2(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
