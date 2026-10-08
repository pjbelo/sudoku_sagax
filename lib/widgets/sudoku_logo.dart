import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../sagax_theme.dart';

/// Sudoku Sagax wordmark: a 3×3 box with a few digits beside the name.
/// Source of `assets/images/sudoku-sagax-transp.png` (the home-screen logo),
/// rendered by tool/store/logo_test.dart. Also drawn live in the feature
/// graphic. Everything scales with [height].
class SudokuLogo extends StatelessWidget {
  const SudokuLogo({super.key, this.height = 84});

  final double height;

  // Digits shown in the 3×3 box (0 = empty); the centre one is highlighted.
  static const _digits = [5, 0, 3, 0, 9, 0, 7, 0, 1];

  @override
  Widget build(BuildContext context) {
    final scale = height / 96;
    final gap = 5.0 * scale;
    final cell = (height - gap * 2) / 3;

    // Scales down on narrow screens instead of overflowing.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: height,
            height: height,
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [for (int i = 0; i < 9; i++) _cell(i, cell, scale)],
            ),
          ),
          SizedBox(width: 18 * scale),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SUDOKU',
                style: GoogleFonts.exo2(
                  fontSize: 46 * scale,
                  height: 1,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5 * scale,
                  color: AppColors.snowWhite,
                ),
              ),
              SizedBox(height: 8 * scale),
              Text(
                'SAGAX',
                style: GoogleFonts.exo2(
                  fontSize: 24 * scale,
                  height: 1,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 14.5 * scale,
                  color: AppColors.electricCyan,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cell(int i, double size, double scale) {
    final digit = _digits[i];
    final isCenter = i == 4;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCenter ? AppColors.electricCyan : AppColors.cardDark,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(
          color: AppColors.electricCyan.withValues(alpha: isCenter ? 1 : 0.4),
          width: 1.5 * scale,
        ),
        boxShadow: isCenter
            ? [
                BoxShadow(
                  color: AppColors.electricCyan.withValues(alpha: 0.45),
                  blurRadius: 12 * scale,
                  spreadRadius: 1 * scale,
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
