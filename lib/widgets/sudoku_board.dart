import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../game/sudoku_generator.dart';
import '../l10n/app_localizations.dart';
import '../sagax_theme.dart';

/// What the logic coach shows on the board while it explains a step. It
/// replaces the usual selection highlights.
class BoardHighlight {
  const BoardHighlight({
    this.area = const {},
    this.focus = const {},
    this.removed = const {},
    this.candidates = const {},
  });

  /// Where to look: a light amber tint.
  final Set<int> area;

  /// The cells of the pattern and the cell to fill: a strong amber tint.
  final Set<int> focus;

  /// Cells that lose candidates: a light red tint.
  final Set<int> removed;

  /// Candidates to show (cell → digits mask), in amber, in place of the
  /// player's notes.
  final Map<int, int> candidates;
}

/// The 9×9 grid. Highlights the selected cell, its row/column/box and every
/// cell holding the same digit; outlines conflicts; shows pencil notes as a
/// 3×3 mini-grid.
///
/// Accessibility: each cell tells screen readers its row, column, digit or
/// notes and what it is (given, hint, wrong, conflict); errors, conflicts
/// and hints carry a shape as well as a colour (an underline, an outline, a
/// corner dot); and [highContrast] strengthens lines, notes and highlights.
class SudokuBoard extends StatelessWidget {
  const SudokuBoard({
    super.key,
    required this.game,
    required this.selected,
    this.activeDigit,
    required this.showErrors,
    this.markConflicts = false,
    this.highlight,
    required this.onCellTap,
    this.hidden = false,
    this.highContrast = false,
  });

  final SudokuGame game;
  final int? selected;

  /// The digit picked for digit-first entry: its cells and notes light up
  /// as if a cell holding it were selected.
  final int? activeDigit;

  /// Paint wrong digits red (the "Show errors" option).
  final bool showErrors;

  /// Outline equal digits that share a row, column or box (the "Mark
  /// conflicts" option). An outline, not a fill, so it can't be mistaken for
  /// Show errors, which may be on at the same time.
  final bool markConflicts;

  /// The logic coach's highlights, while it explains a step.
  final BoardHighlight? highlight;
  final ValueChanged<int> onCellTap;

  /// Draws an empty grid, used while the game is paused.
  final bool hidden;

  /// The "High contrast" option. The board also turns it on when the
  /// system asks for more contrast.
  final bool highContrast;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final strong = highContrast || MediaQuery.highContrastOf(context);
    return AspectRatio(
      aspectRatio: 1,
      // The digits are sized from the cells, so system text scaling stays out.
      child: MediaQuery.withNoTextScaling(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth;
            final cell = size / 9;
            return Container(
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.electricCyan.withValues(alpha: 0.6),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: hidden
                      ? null
                      : (d) {
                          // Account for the 2px border around the cells.
                          final inner = (size - 4) / 9;
                          final r = (d.localPosition.dy ~/ inner).clamp(0, 8);
                          final c = (d.localPosition.dx ~/ inner).clamp(0, 8);
                          onCellTap(r * 9 + c);
                        },
                  child: CustomPaint(
                    foregroundPainter: _GridPainter(strong: strong),
                    child: Column(
                      children: [
                        for (int r = 0; r < 9; r++)
                          Expanded(
                            child: Row(
                              children: [
                                for (int c = 0; c < 9; c++)
                                  Expanded(
                                    child: _buildCell(
                                      l10n,
                                      r * 9 + c,
                                      cell,
                                      strong,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCell(AppLocalizations l10n, int i, double cell, bool strong) {
    if (hidden) return const SizedBox.expand();

    final sel = selected;
    final selValue = activeDigit ?? (sel == null ? 0 : game.values[sel]);
    final value = game.values[i];
    final isSelected = i == sel;
    final sameDigit = selValue != 0 && value == selValue;
    final isPeer =
        sel != null &&
        (rowOf(i) == rowOf(sel) ||
            colOf(i) == colOf(sel) ||
            boxOf(i) == boxOf(sel));
    final showWrong = showErrors && game.isWrong(i);
    final showConflict = markConflicts && game.hasConflict(i);

    final coach = highlight;
    final Color background;
    if (coach != null) {
      if (coach.focus.contains(i)) {
        background = AppColors.hintAmber.withValues(alpha: 0.32);
      } else if (coach.removed.contains(i)) {
        background = AppColors.errorRed.withValues(alpha: 0.16);
      } else if (coach.area.contains(i)) {
        background = AppColors.hintAmber.withValues(alpha: 0.10);
      } else {
        background = Colors.transparent;
      }
    } else if (isSelected) {
      background = AppColors.electricCyan.withValues(
        alpha: strong ? 0.55 : 0.38,
      );
    } else if (showWrong) {
      background = AppColors.errorRed.withValues(alpha: strong ? 0.3 : 0.18);
    } else if (sameDigit) {
      background = AppColors.electricCyan.withValues(
        alpha: strong ? 0.35 : 0.22,
      );
    } else if (isPeer) {
      background = AppColors.electricCyan.withValues(
        alpha: strong ? 0.15 : 0.07,
      );
    } else {
      background = Colors.transparent;
    }

    Widget? content;
    if (value != 0) {
      final Color color;
      if (showWrong) {
        color = AppColors.errorRed;
      } else if (game.isGiven(i)) {
        color = AppColors.snowWhite;
      } else if (game.hinted[i]) {
        color = AppColors.hintAmber;
      } else {
        color = AppColors.electricCyan;
      }
      content = Text(
        '$value',
        style: GoogleFonts.exo2(
          fontSize: cell * 0.6,
          height: 1,
          fontWeight: game.isGiven(i) ? FontWeight.bold : FontWeight.w600,
          color: color,
        ),
      );
      // Shapes as well as colours: a wrong digit is underlined, a hint has
      // a dot in the corner.
      if (showWrong || game.hinted[i]) {
        content = Stack(
          alignment: Alignment.center,
          children: [
            content,
            if (showWrong)
              Positioned(
                key: ValueKey('wrong-$i'),
                left: cell * 0.25,
                right: cell * 0.25,
                bottom: cell * 0.1,
                height: cell * 0.07,
                child: const ColoredBox(color: AppColors.errorRed),
              ),
            if (game.hinted[i])
              Positioned(
                key: ValueKey('hint-$i'),
                top: cell * 0.08,
                right: cell * 0.08,
                width: cell * 0.14,
                height: cell * 0.14,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.hintAmber,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      }
    } else if (coach != null && coach.candidates.containsKey(i)) {
      content = _buildNotes(
        coach.candidates[i]!,
        cell,
        0,
        color: AppColors.hintAmber,
      );
    } else if (game.notes[i] != 0) {
      content = _buildNotes(
        game.notes[i],
        cell,
        selValue,
        color: strong ? AppColors.snowWhite : null,
      );
    }

    return Semantics(
      label: _cellLabel(l10n, i, wrong: showWrong, conflict: showConflict),
      button: true,
      selected: isSelected,
      onTap: () => onCellTap(i),
      // The label says it all; the digits inside would repeat it.
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: background,
        foregroundDecoration: showConflict
            ? BoxDecoration(
                border: Border.all(color: AppColors.errorRed, width: 2),
                borderRadius: BorderRadius.circular(cell * 0.12),
              )
            : null,
        alignment: Alignment.center,
        child: content,
      ),
    );
  }

  /// What a screen reader says for cell [i]: "row 3, column 5, 7, given",
  /// or "row 3, column 5, empty, notes 2 4 7".
  String _cellLabel(
    AppLocalizations l10n,
    int i, {
    required bool wrong,
    required bool conflict,
  }) {
    final parts = [l10n.cellName(rowOf(i) + 1, colOf(i) + 1)];
    final value = game.values[i];
    if (value == 0) {
      parts.add(l10n.cellEmpty);
      final notes = [
        for (int d = 1; d <= 9; d++)
          if (game.hasNote(i, d)) '$d',
      ];
      if (notes.isNotEmpty) parts.add(l10n.cellNotes(notes.join(' ')));
    } else {
      parts.add('$value');
      if (game.isGiven(i)) parts.add(l10n.cellGiven);
      if (game.hinted[i]) parts.add(l10n.cellHint);
      if (wrong) parts.add(l10n.cellWrong);
      if (conflict) parts.add(l10n.cellConflict);
    }
    return parts.join(', ');
  }

  /// The digits of [mask] as a 3×3 mini-grid, in [color] when given.
  Widget _buildNotes(int mask, double cell, int selValue, {Color? color}) {
    return Padding(
      padding: EdgeInsets.all(cell * 0.06),
      child: Column(
        children: [
          for (int r = 0; r < 3; r++)
            Expanded(
              child: Row(
                children: [
                  for (int c = 0; c < 3; c++)
                    Expanded(
                      child: Center(
                        child: _note(
                          mask,
                          r * 3 + c + 1,
                          cell,
                          selValue,
                          color,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget? _note(int mask, int digit, double cell, int selValue, Color? color) {
    if (mask & (1 << (digit - 1)) == 0) return null;
    final match = digit == selValue;
    return Text(
      '$digit',
      style: GoogleFonts.inter(
        fontSize: cell * 0.23,
        height: 1,
        fontWeight: match ? FontWeight.bold : FontWeight.w500,
        color: color ?? (match ? AppColors.electricCyan : AppColors.softSlate),
      ),
    );
  }
}

/// Thin lines between cells, thick cyan lines between 3×3 boxes; both
/// stronger with [strong] (high contrast).
class _GridPainter extends CustomPainter {
  _GridPainter({required this.strong});

  final bool strong;

  @override
  void paint(Canvas canvas, Size size) {
    final thin = Paint()
      ..color = strong
          ? AppColors.snowWhite.withValues(alpha: 0.55)
          : AppColors.softSlate.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    // A touch heavier on large boards, so the 3×3 boxes still stand out.
    final thick = Paint()
      ..color = AppColors.electricCyan.withValues(alpha: strong ? 1 : 0.55)
      ..strokeWidth = (size.width >= 600 ? 3 : 2) + (strong ? 1 : 0);
    final step = size.width / 9;
    for (int k = 1; k < 9; k++) {
      final paint = k % 3 == 0 ? thick : thin;
      final d = k * step;
      canvas.drawLine(Offset(d, 0), Offset(d, size.height), paint);
      canvas.drawLine(Offset(0, d), Offset(size.width, d), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) =>
      oldDelegate.strong != strong;
}
