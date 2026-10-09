// Shared pieces of the store artwork (Google Play feature graphic, App Store
// header and search results assets): the showcase board, the navy backdrop
// with its faint grid, and soft glows.

import 'package:flutter/material.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/sagax_theme.dart';

/// Violet of the glows (store art only, not an app colour).
const storeViolet = Color(0xFF7C3AED);

/// A mid-game board that shows off entries, notes, a hint and highlights.
({SudokuGame game, int selected}) showcaseBoard() {
  final game = SudokuGame(generatePuzzle(4, seed: 2026));
  final empty = [
    for (int i = 0; i < 81; i++)
      if (game.values[i] == 0) i,
  ];
  // Player entries in the top half.
  for (final i in empty.where((i) => i < 36).take(9)) {
    game.enterDigit(i, game.solution[i]);
  }
  // Pencil notes: the right digit plus a couple of candidates.
  for (final i in empty.where((i) => i >= 45).take(3)) {
    final d = game.solution[i];
    for (final n in {d, d % 9 + 1, (d + 3) % 9 + 1}) {
      game.toggleNote(i, n);
    }
  }
  final hinted = game.hint(preferred: empty.firstWhere((i) => i >= 36))!;
  return (game: game, selected: hinted);
}

/// Navy with a soft radial lift around [center] and a faint cyan grid.
class StoreBackdrop extends StatelessWidget {
  const StoreBackdrop({
    super.key,
    this.center = const Alignment(0.55, -0.1),
    this.radius = 1.1,
    this.gridSpacing = 32,
  });

  final Alignment center;
  final double radius;
  final double gridSpacing;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: center,
          radius: radius,
          colors: const [Color(0xFF1C2B4F), AppColors.midnightNavy],
        ),
      ),
      child: CustomPaint(painter: StoreGridPainter(gridSpacing)),
    );
  }
}

/// A soft circular glow of [color], fading out from [alpha] at the centre.
Widget storeGlow(Color color, double size, double alpha) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [color.withValues(alpha: alpha), color.withValues(alpha: 0)],
      ),
    ),
  );
}

class StoreGridPainter extends CustomPainter {
  const StoreGridPainter(this.spacing);

  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricCyan.withValues(alpha: 0.05)
      ..strokeWidth = spacing / 32;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant StoreGridPainter oldDelegate) =>
      oldDelegate.spacing != spacing;
}
