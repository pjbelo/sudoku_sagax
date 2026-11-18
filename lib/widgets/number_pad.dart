import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';

/// Digits 1–9 in a row, or as a 3×3 keypad when [grid] is set. Each key
/// shows how many of that digit are still missing; a digit already placed 9
/// times is dimmed (but stays tappable, so a wrong entry elsewhere never
/// locks the player out). The digit picked for digit-first entry is lit.
class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.game,
    required this.notesMode,
    this.activeDigit,
    required this.onDigit,
    this.height = 58,
    this.grid = false,
    this.highContrast = false,
  });

  final SudokuGame game;
  final bool notesMode;

  /// The digit picked for digit-first entry, shown as a lit key.
  final int? activeDigit;
  final ValueChanged<int> onDigit;

  /// Height of one row of keys.
  final double height;
  final bool grid;

  /// Stronger key borders and digits (see [SudokuBoard.highContrast]).
  final bool highContrast;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context)!;
    final strong = highContrast || MediaQuery.highContrastOf(context);
    // The digits are sized from the keys, so system text scaling stays out.
    return MediaQuery.withNoTextScaling(
      child: grid
          ? Column(
              children: [
                for (int first = 1; first <= 7; first += 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _row(colors, l10n, first, 3, 4, strong),
                  ),
              ],
            )
          : _row(colors, l10n, 1, 9, 2.5, strong),
    );
  }

  Widget _row(
    AppColors colors,
    AppLocalizations l10n,
    int first,
    int count,
    double gap,
    bool strong,
  ) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          for (int d = first; d < first + count; d++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: gap),
                child: _key(colors, l10n, d, strong),
              ),
            ),
        ],
      ),
    );
  }

  Widget _key(AppColors colors, AppLocalizations l10n, int digit, bool strong) {
    final remaining = (9 - game.placedCount(digit)).clamp(0, 9);
    final active = digit == activeDigit;
    final Color color;
    if (active) {
      color = colors.onPrimary;
    } else if (notesMode && !strong) {
      color = colors.muted;
    } else {
      color = colors.text;
    }
    // Screen readers hear "5, 3 left" rather than the two numbers.
    return Semantics(
      label: l10n.numberKey(digit, remaining),
      button: true,
      selected: active,
      onTap: () => onDigit(digit),
      excludeSemantics: true,
      child: _keyFace(colors, digit, remaining, active, color, strong),
    );
  }

  Widget _keyFace(
    AppColors colors,
    int digit,
    int remaining,
    bool active,
    Color color,
    bool strong,
  ) {
    return Opacity(
      opacity: remaining == 0 && !active ? 0.35 : 1,
      child: Material(
        color: active ? colors.primary : colors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: colors.primary.withValues(
              alpha: strong ? 0.9 : (notesMode || active ? 0.6 : 0.3),
            ),
            width: strong ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onDigit(digit),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$digit',
                style: GoogleFonts.exo2(
                  fontSize: notesMode ? height * 0.36 : height * 0.44,
                  height: 1,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: height * 0.05),
              Text(
                '$remaining',
                style: GoogleFonts.inter(
                  fontSize: max(10, height * 0.15),
                  height: 1,
                  color: active
                      ? colors.onPrimary
                      : colors.primary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
