import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/sudoku_game.dart';
import '../game/sudoku_generator.dart';
import '../sagax_theme.dart';

/// The 9×9 grid. Highlights the selected cell, its row/column/box and every
/// cell holding the same digit; shows pencil notes as a 3×3 mini-grid.
class SudokuBoard extends StatelessWidget {
  const SudokuBoard({
    super.key,
    required this.game,
    required this.selected,
    required this.showErrors,
    required this.onCellTap,
    this.hidden = false,
  });

  final SudokuGame game;
  final int? selected;

  /// Paint wrong digits red (the "Show errors" option).
  final bool showErrors;
  final ValueChanged<int> onCellTap;

  /// Draws an empty grid, used while the game is paused.
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
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
                  foregroundPainter: _GridPainter(),
                  child: Column(
                    children: [
                      for (int r = 0; r < 9; r++)
                        Expanded(
                          child: Row(
                            children: [
                              for (int c = 0; c < 9; c++)
                                Expanded(child: _buildCell(r * 9 + c, cell)),
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
    );
  }

  Widget _buildCell(int i, double cell) {
    if (hidden) return const SizedBox.expand();

    final sel = selected;
    final selValue = sel == null ? 0 : game.values[sel];
    final value = game.values[i];
    final isSelected = i == sel;
    final sameDigit = selValue != 0 && value == selValue;
    final isPeer =
        sel != null &&
        (rowOf(i) == rowOf(sel) ||
            colOf(i) == colOf(sel) ||
            boxOf(i) == boxOf(sel));
    final showWrong = showErrors && game.isWrong(i);

    final Color background;
    if (isSelected) {
      background = AppColors.electricCyan.withValues(alpha: 0.38);
    } else if (showWrong) {
      background = AppColors.errorRed.withValues(alpha: 0.18);
    } else if (sameDigit) {
      background = AppColors.electricCyan.withValues(alpha: 0.22);
    } else if (isPeer) {
      background = AppColors.electricCyan.withValues(alpha: 0.07);
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
    } else if (game.notes[i] != 0) {
      content = _buildNotes(i, cell, selValue);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      color: background,
      alignment: Alignment.center,
      child: content,
    );
  }

  Widget _buildNotes(int i, double cell, int selValue) {
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
                        child: _note(i, r * 3 + c + 1, cell, selValue),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget? _note(int i, int digit, double cell, int selValue) {
    if (!game.hasNote(i, digit)) return null;
    final match = digit == selValue;
    return Text(
      '$digit',
      style: GoogleFonts.inter(
        fontSize: cell * 0.23,
        height: 1,
        fontWeight: match ? FontWeight.bold : FontWeight.w500,
        color: match ? AppColors.electricCyan : AppColors.softSlate,
      ),
    );
  }
}

/// Thin lines between cells, thick cyan lines between 3×3 boxes.
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final thin = Paint()
      ..color = AppColors.softSlate.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    final thick = Paint()
      ..color = AppColors.electricCyan.withValues(alpha: 0.55)
      ..strokeWidth = 2;
    final step = size.width / 9;
    for (int k = 1; k < 9; k++) {
      final paint = k % 3 == 0 ? thick : thin;
      final d = k * step;
      canvas.drawLine(Offset(d, 0), Offset(d, size.height), paint);
      canvas.drawLine(Offset(0, d), Offset(size.width, d), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
