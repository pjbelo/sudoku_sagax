import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../sagax_theme.dart';

/// Sudoku Sagax wordmark: a 3×3 box with a few digits above the name.
/// Drawn in code so it stays crisp at any size; swap for an image asset
/// (like Slidox's `slidox-transp.png`) once a designed logo exists.
class SudokuLogo extends StatelessWidget {
  const SudokuLogo({super.key, this.height = 200});

  final double height;

  // Digits shown in the 3×3 box (0 = empty); the centre one is highlighted.
  static const _digits = [5, 0, 3, 0, 9, 0, 7, 0, 1];

  @override
  Widget build(BuildContext context) {
    final scale = height / 200;
    final cell = 26.0 * scale;
    final gap = 4.0 * scale;

    return SizedBox(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: cell * 3 + gap * 2,
            height: cell * 3 + gap * 2,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [for (int i = 0; i < 9; i++) _cell(i, cell)],
            ),
          ),
          SizedBox(height: 14 * scale),
          Text(
            'SUDOKU',
            style: GoogleFonts.exo2(
              fontSize: 44 * scale,
              height: 1,
              fontWeight: FontWeight.bold,
              letterSpacing: 6 * scale,
              color: AppColors.snowWhite,
            ),
          ),
          SizedBox(height: 6 * scale),
          Text(
            'SAGAX',
            style: GoogleFonts.exo2(
              fontSize: 22 * scale,
              height: 1,
              fontWeight: FontWeight.w600,
              letterSpacing: 14 * scale,
              color: AppColors.electricCyan,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell(int i, double size) {
    final digit = _digits[i];
    final isCenter = i == 4;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCenter ? AppColors.electricCyan : AppColors.cardDark,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: AppColors.electricCyan.withValues(alpha: isCenter ? 1 : 0.4),
          width: 1.5,
        ),
        boxShadow: isCenter
            ? [
                BoxShadow(
                  color: AppColors.electricCyan.withValues(alpha: 0.45),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Center(
        child: digit == 0
            ? null
            : Text(
                '$digit',
                style: GoogleFonts.exo2(
                  fontSize: size * 0.62,
                  height: 1,
                  fontWeight: FontWeight.bold,
                  color: isCenter
                      ? AppColors.midnightNavy
                      : AppColors.snowWhite,
                ),
              ),
      ),
    );
  }
}
