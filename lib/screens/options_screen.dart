import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';
import '../services/audio_service.dart';
import '../services/settings_service.dart';

/// Sound, Timer, Show errors and Hint button switches.
/// Changes are saved immediately.
class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  void _click() => unawaited(
    AudioService.instance.playSfx(AudioService.buttonSfx, volume: 0.85),
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
          builder: (context, _) => Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  _OptionCard(
                    icon: Icons.volume_up_outlined,
                    title: l10n.optSound,
                    description: l10n.optSoundDesc,
                    value: settings.sound,
                    onChanged: (v) {
                      settings.sound = v;
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
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: settings.isDefault
                          ? null
                          : () {
                              _click();
                              settings.restoreDefaults();
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
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
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
