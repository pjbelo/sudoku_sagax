import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_generator.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';

/// Localised name of a difficulty band.
String bandName(AppLocalizations l10n, SudokuBand band) => switch (band) {
  SudokuBand.beginner => l10n.bandBeginner,
  SudokuBand.easy => l10n.bandEasy,
  SudokuBand.medium => l10n.bandMedium,
  SudokuBand.hard => l10n.bandHard,
  SudokuBand.expert => l10n.bandExpert,
};

/// "Medium · 32 clues" for [level].
String levelSummary(AppLocalizations l10n, int level) {
  final spec = sudokuLevels[level - 1];
  return l10n.levelSummary(bandName(l10n, spec.band), spec.clues);
}

/// The 9 levels as chips laid out like a 3×3 sudoku box (or in one row when
/// [singleRow] is set). Each chip shows the level and its clue count.
class LevelSelector extends StatelessWidget {
  const LevelSelector({
    super.key,
    required this.selected,
    required this.onSelected,
    this.chipSize = 64,
    this.singleRow = false,
  });

  final int selected;
  final ValueChanged<int> onSelected;
  final double chipSize;
  final bool singleRow;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    const spacing = 10.0;

    if (singleRow) {
      // Shrink the chips so all 9 fit the available width.
      return LayoutBuilder(
        builder: (context, constraints) {
          const gap = 6.0;
          final fit = (constraints.maxWidth - 32) / 9 - gap;
          final size = fit.clamp(28.0, chipSize);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final spec in sudokuLevels)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: gap / 2),
                    child: _chip(spec, primary, size),
                  ),
              ],
            ),
          );
        },
      );
    }

    return SizedBox(
      width: chipSize * 3 + spacing * 2,
      child: Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final spec in sudokuLevels) _chip(spec, primary, chipSize),
        ],
      ),
    );
  }

  Widget _chip(SudokuLevel spec, Color primary, double chipSize) {
    final isSelected = spec.level == selected;
    final showClues = chipSize >= 56;
    return GestureDetector(
      onTap: () => onSelected(spec.level),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: chipSize,
        height: chipSize,
        decoration: BoxDecoration(
          color: isSelected ? primary : AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : primary.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${spec.level}',
                style: GoogleFonts.exo2(
                  fontSize: showClues ? 20 : 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.midnightNavy
                      : AppColors.snowWhite,
                ),
              ),
              if (showClues)
                Text(
                  '${spec.clues}',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isSelected
                        ? AppColors.midnightNavy.withValues(alpha: 0.7)
                        : AppColors.softSlate,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
