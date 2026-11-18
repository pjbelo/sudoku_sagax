import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================================
// Sagax Games theme: dark (the original look) and light
// ============================================================
//
// The app follows the system's light or dark setting. Widgets never use the
// raw brand colours below: they read the colours of the current theme with
// `AppColors.of(context)`, whose names say what a colour is for (text,
// card, primary…), so the same code works in both themes.
//
// The light palette is planned for the whole Sagax Games brand (Slidox,
// Memorex, MasterCode…): docs/brand-palette.md explains the choices.

/// The Sagax Games brand colours, as raw values. Use [AppColors.of] in
/// widgets; these are for the two palettes below and for store art, which
/// always uses the dark look.
abstract final class SagaxPalette {
  // Dark: the original Sagax look.
  static const midnightNavy = Color(0xFF0F172A);
  static const cardDark = Color(0xFF1E293B);
  static const electricCyan = Color(0xFF38BDF8);
  static const softSlate = Color(0xFF94A3B8);
  static const snowWhite = Color(0xFFF8FAFC);

  /// Wrong digits when "Show errors" is on (Memorex's Reverse red).
  static const errorRed = Color(0xFFEF4444);

  /// Hint button and hinted digits (Slidox's hint amber).
  static const hintAmber = Color(0xFFFFC107);

  // Light: the same hues, darkened until they read well on white (at least
  // 4.5:1 for text, the WCAG AA level).
  static const mistWhite = Color(0xFFF1F5F9);
  static const paperWhite = Color(0xFFFFFFFF);
  static const deepCyan = Color(0xFF0369A1);
  static const slateGrey = Color(0xFF475569);
  static const deepRed = Color(0xFFB91C1C);
  static const deepAmber = Color(0xFFB45309);
}

/// The colours of the current theme, by what they are for. Read them with
/// `AppColors.of(context)`.
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.card,
    required this.primary,
    required this.onPrimary,
    required this.text,
    required this.muted,
    required this.error,
    required this.hint,
  });

  /// Behind everything (the scaffold).
  final Color background;

  /// Cards, tiles, dialogs and the board.
  final Color card;

  /// The brand colour: buttons, links, the player's digits, highlights.
  final Color primary;

  /// Text and icons on a [primary] (or [hint]) fill.
  final Color onPrimary;

  /// Main text and the puzzle's given digits.
  final Color text;

  /// Secondary text, thin lines, notes.
  final Color muted;

  /// Wrong digits and clashes.
  final Color error;

  /// Hints, and the coach's candidates.
  final Color hint;

  static const dark = AppColors(
    background: SagaxPalette.midnightNavy,
    card: SagaxPalette.cardDark,
    primary: SagaxPalette.electricCyan,
    onPrimary: SagaxPalette.midnightNavy,
    text: SagaxPalette.snowWhite,
    muted: SagaxPalette.softSlate,
    error: SagaxPalette.errorRed,
    hint: SagaxPalette.hintAmber,
  );

  static const light = AppColors(
    background: SagaxPalette.mistWhite,
    card: SagaxPalette.paperWhite,
    primary: SagaxPalette.deepCyan,
    onPrimary: SagaxPalette.paperWhite,
    text: SagaxPalette.midnightNavy,
    muted: SagaxPalette.slateGrey,
    error: SagaxPalette.deepRed,
    hint: SagaxPalette.deepAmber,
  );

  /// The colours of the theme around [context] (the dark ones if the theme
  /// has none, as in a bare test widget).
  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? dark;

  // ThemeExtension needs these two; the app only switches between the two
  // palettes, so they just pick one.
  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) =>
      other == null || t < 0.5 ? this : other;
}

/// The dark theme: the original Sagax look.
final ThemeData sagaxTheme = _buildTheme(AppColors.dark, Brightness.dark);

/// The light theme, used when the system is set to light.
final ThemeData sagaxLightTheme = _buildTheme(
  AppColors.light,
  Brightness.light,
);

ThemeData _buildTheme(AppColors colors, Brightness brightness) {
  return ThemeData(
    brightness: brightness,
    primaryColor: colors.primary,
    scaffoldBackgroundColor: colors.background,
    // Material widgets that aren't styled by hand (the text field's cursor,
    // the default switch) take their colours from here instead of
    // Material's default purple.
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.primary,
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      surface: colors.card,
      onSurface: colors.text,
      error: colors.error,
    ),
    extensions: [colors],
    // Cupertino widgets (e.g. the Info screen's nav bar on iOS) would
    // otherwise pick up Material's default purple.
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: brightness,
      primaryColor: colors.primary,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colors.primary,
      selectionColor: colors.primary.withValues(alpha: 0.35),
      selectionHandleColor: colors.primary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colors.background,
      foregroundColor: colors.text,
      elevation: 0,
      titleTextStyle: GoogleFonts.exo2(
        color: colors.text,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.exo2(
        color: colors.text,
        fontWeight: FontWeight.bold,
        fontSize: 48,
        letterSpacing: 1.2,
      ),
      headlineMedium: GoogleFonts.exo2(
        color: colors.text,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
      bodyLarge: GoogleFonts.inter(color: colors.text, fontSize: 18),
      bodyMedium: GoogleFonts.inter(color: colors.muted, fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.exo2(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
