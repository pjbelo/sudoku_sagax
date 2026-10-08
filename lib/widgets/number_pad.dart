import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../sagax_theme.dart';

/// Digits 1–9 in a row, or as a 3×3 keypad when [grid] is set. Each key shows how many of that digit are still
/// missing; a digit already placed 9 times is dimmed (but stays tappable,
/// so a wrong entry elsewhere never locks the player out).
class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.game,
    required this.notesMode,
    required this.onDigit,
    this.height = 58,
    this.grid = false,
  });

  final SudokuGame game;
  final bool notesMode;
  final ValueChanged<int> onDigit;

  /// Height of one row of keys.
  final double height;
  final bool grid;

  @override
  Widget build(BuildContext context) {
    if (!grid) return _row(1, 9, 2.5);
    return Column(
      children: [
        for (int first = 1; first <= 7; first += 3)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: _row(first, 3, 4),
          ),
      ],
    );
  }

  Widget _row(int first, int count, double gap) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          for (int d = first; d < first + count; d++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: gap),
                child: _key(d),
              ),
            ),
        ],
      ),
    );
  }

  Widget _key(int digit) {
    final remaining = (9 - game.placedCount(digit)).clamp(0, 9);
    final color = notesMode ? AppColors.softSlate : AppColors.snowWhite;
    return Opacity(
      opacity: remaining == 0 ? 0.35 : 1,
      child: Material(
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: AppColors.electricCyan.withValues(
              alpha: notesMode ? 0.6 : 0.3,
            ),
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
                  fontSize: 10,
                  height: 1,
                  color: AppColors.electricCyan.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
