import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const midnightNavy = Color(0xFF0F172A);
  static const cardDark = Color(0xFF1E293B);
  static const electricCyan = Color(0xFF38BDF8);
  static const softSlate = Color(0xFF94A3B8);
  static const snowWhite = Color(0xFFF8FAFC);

  /// Wrong digits when "Show errors" is on (Memorex's Reverse red).
  static const errorRed = Color(0xFFEF4444);

  /// Hint button and hinted digits (Slidox's hint amber).
  static const hintAmber = Color(0xFFFFC107);
}

final ThemeData sagaxTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.electricCyan,
  scaffoldBackgroundColor: AppColors.midnightNavy,
  // Cupertino widgets (e.g. the Info screen's nav bar on iOS) would otherwise
  // pick up Material's default purple.
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: AppColors.electricCyan,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.midnightNavy,
    elevation: 0,
    titleTextStyle: GoogleFonts.exo2(
      color: AppColors.snowWhite,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.exo2(
      color: AppColors.snowWhite,
      fontWeight: FontWeight.bold,
      fontSize: 48,
      letterSpacing: 1.2,
    ),
    headlineMedium: GoogleFonts.exo2(
      color: AppColors.snowWhite,
      fontWeight: FontWeight.bold,
      fontSize: 32,
    ),
    bodyLarge: GoogleFonts.inter(color: AppColors.snowWhite, fontSize: 18),
    bodyMedium: GoogleFonts.inter(color: AppColors.softSlate, fontSize: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.electricCyan,
      foregroundColor: AppColors.midnightNavy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: GoogleFonts.exo2(fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
);
