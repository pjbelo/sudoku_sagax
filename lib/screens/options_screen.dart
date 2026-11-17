import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/analytics_service.dart';
import '../services/audio_service.dart';
import '../services/settings_service.dart';
import '../widgets/adaptive_layout.dart';

/// Sound, Timer, Show errors, Hint button, Fill notes on easy levels,
/// Vibration and Left-handed switches.
/// Changes are saved immediately.
class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  void _click() => unawaited(
    AudioService.instance.playSfx(AudioService.buttonSfx, volume: 0.85),
  );

  void _logChange(String option, bool value) => AnalyticsService.instance.log(
    'option_changed',
    {'option': option, 'value': value ? 1 : 0},
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = SettingsService.instance;
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.optionsTitle), centerTitle: true),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: settings,
          builder: (context, _) {
            final cards = [
              _OptionCard(
                icon: Icons.volume_up_outlined,
                title: l10n.optSound,
                description: l10n.optSoundDesc,
                value: settings.sound,
                onChanged: (v) {
                  settings.sound = v;
                  _logChange('sound', v);
                  _click(); // after enabling, so turning sound on is heard
                },
              ),
              _OptionCard(
                icon: Icons.timer_outlined,
                title: l10n.optTimer,
                description: l10n.optTimerDesc,
                value: settings.timer,
                onChanged: (v) {
                  _click();
                  settings.timer = v;
                  _logChange('timer', v);
                },
              ),
              _OptionCard(
                icon: Icons.error_outline,
                title: l10n.optShowErrors,
                description: l10n.optShowErrorsDesc,
                value: settings.showErrors,
                onChanged: (v) {
                  _click();
                  settings.showErrors = v;
                  _logChange('show_errors', v);
                },
              ),
              _OptionCard(
                icon: Icons.lightbulb_outline,
                title: l10n.optHints,
                description: l10n.optHintsDesc(hintPenaltySeconds),
                value: settings.hints,
                onChanged: (v) {
                  _click();
                  settings.hints = v;
                  _logChange('hints', v);
                },
              ),
              _OptionCard(
                icon: Icons.auto_awesome,
                title: l10n.optFillNotes,
                description: l10n.optFillNotesDesc,
                value: settings.fillNotesEasy,
                onChanged: (v) {
                  _click();
                  settings.fillNotesEasy = v;
                  _logChange('fill_notes_easy', v);
                },
              ),
              _OptionCard(
                icon: Icons.vibration,
                title: l10n.optHaptics,
                description: l10n.optHapticsDesc,
                value: settings.haptics,
                onChanged: (v) {
                  _click();
                  settings.haptics = v;
                  _logChange('haptics', v);
                },
              ),
              _OptionCard(
                icon: Icons.swap_horiz,
                title: l10n.optLeftHanded,
                description: l10n.optLeftHandedDesc,
                value: settings.leftHanded,
                onChanged: (v) {
                  _click();
                  settings.leftHanded = v;
                  _logChange('left_handed', v);
                },
              ),
            ];

            final actions = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: settings.isDefault
                      ? null
                      : () {
                          _click();
                          settings.restoreDefaults();
                          AnalyticsService.instance.log('options_restored');
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primary,
                    side: BorderSide(color: primary.withValues(alpha: 0.6)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                  ),
                  icon: const Icon(Icons.restart_alt),
                  label: Text(
                    l10n.restoreDefaults,
                    style: GoogleFonts.exo2(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    _click();
                    Navigator.pop(context);
                  },
                  child: Text(
                    l10n.back,
                    style: GoogleFonts.exo2(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ),
              ],
            );

            Widget pane(List<Widget> children) {
              return CenteredPane(
                maxWidth: 560,
                padding: 16,
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: children,
                ),
              );
            }

            return TwoPaneLayout(
              splitWhenWide: false,
              first: pane(cards.sublist(0, 2)),
              second: pane([...cards.sublist(2), actions]),
              single: CenteredPane(
                maxWidth: 900 * uiScaleOf(context),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TwoColumnCards(children: cards),
                    actions,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, color: primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.exo2(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.snowWhite,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        color: AppColors.softSlate,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeTrackColor: primary,
                activeThumbColor: AppColors.midnightNavy,
                inactiveThumbColor: AppColors.softSlate,
                inactiveTrackColor: AppColors.midnightNavy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
