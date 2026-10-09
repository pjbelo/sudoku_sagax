// Renders the App Store creative assets (iOS 27+) for every locale, using
// the app's own widgets:
//
//   tool/store/app_store_assets.sh [en,pt,...]
//
// - Product page header, 21:9, 3840×1646: logo and tagline.
// - Search results, 3:2, 3840×2560: a live board and a short phrase.
//
// The App Store crops these differently per device and orientation; only the
// centred "Art Safe Area" of Apple's templates is always visible (measured
// from the Photoshop templates on
// https://developer.apple.com/app-store/asset-best-practices/). Everything
// that matters sits inside it; the rest of the canvas is backdrop.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_sagax/l10n/app_localizations.dart';
import 'package:sudoku_sagax/sagax_theme.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';
import 'package:sudoku_sagax/widgets/sudoku_logo.dart';

import 'store_art.dart';

const _langs = String.fromEnvironment('LANGS', defaultValue: 'en,pt,es,fr,de');

const _headerSize = Size(3840, 1646);
const _headerSafe = Rect.fromLTWH(1097, 493, 1646, 661);
const _searchSize = Size(3840, 2560);
const _searchSafe = Rect.fromLTWH(836, 765, 2168, 1030);

/// Content keeps 4% inside the safe area, so nothing touches a crop edge.
EdgeInsets _inset(Rect safe) => EdgeInsets.symmetric(
  horizontal: safe.width * 0.04,
  vertical: safe.height * 0.04,
);

/// Search results copy (store copy, not app strings): a white and a cyan
/// line, then the levels.
const _searchCopy = {
  'en': ('Classic Sudoku.', 'Pure logic.', '9 levels · Beginner to Expert'),
  'pt': (
    'Sudoku clássico.',
    'Lógica pura.',
    '9 níveis · De Iniciante a Especialista',
  ),
  'es': (
    'Sudoku clásico.',
    'Lógica pura.',
    '9 niveles · De Principiante a Experto',
  ),
  'fr': (
    'Sudoku classique.',
    'Logique pure.',
    '9 niveaux · De Débutant à Expert',
  ),
  'de': (
    'Klassisches Sudoku.',
    'Reine Logik.',
    '9 Level · Vom Anfänger zum Experten',
  ),
};

TextStyle _headline(double size, Color color) => GoogleFonts.exo2(
  fontSize: size,
  fontWeight: FontWeight.bold,
  height: 1.15,
  color: color,
);

/// A live board with a cyan glow.
Widget _glowingBoard({double opacity = 1, double glow = 0.45}) {
  final board = showcaseBoard();
  return Opacity(
    opacity: opacity,
    child: DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricCyan.withValues(alpha: glow),
            blurRadius: 90,
            spreadRadius: 6,
          ),
        ],
      ),
      child: SudokuBoard(
        game: board.game,
        selected: board.selected,
        showErrors: false,
        onCellTap: (_) {},
      ),
    ),
  );
}

class AppStoreHeader extends StatelessWidget {
  const AppStoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final comma = l10n.tagline.indexOf(',');

    return SizedBox.fromSize(
      size: _headerSize,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned.fill(
            child: StoreBackdrop(
              center: Alignment.center,
              radius: 0.9,
              gridSpacing: 96,
            ),
          ),
          Positioned(
            left: 1920 - 1100,
            top: 823 - 1100,
            child: storeGlow(AppColors.electricCyan, 2200, 0.14),
          ),
          Positioned(
            left: -500,
            bottom: -900,
            child: storeGlow(storeViolet, 1900, 0.22),
          ),
          Positioned(
            right: -500,
            top: -900,
            child: storeGlow(storeViolet, 1900, 0.18),
          ),

          // Boards at the sides, dimmed: seen on wide screens, cropped on
          // narrow ones.
          Positioned(
            left: -60,
            top: 260,
            width: 1000,
            height: 1000,
            child: Transform.rotate(
              angle: -0.12,
              child: _glowingBoard(opacity: 0.32, glow: 0.3),
            ),
          ),
          Positioned(
            right: -60,
            top: 380,
            width: 1000,
            height: 1000,
            child: Transform.rotate(
              angle: 0.12,
              child: _glowingBoard(opacity: 0.32, glow: 0.3),
            ),
          ),

          // Safe area: logo and tagline.
          Positioned.fromRect(
            rect: _headerSafe,
            child: Padding(
              padding: _inset(_headerSafe),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SudokuLogo(height: 290),
                      const SizedBox(height: 80),
                      Text.rich(
                        TextSpan(
                          style: _headline(88, AppColors.snowWhite),
                          children: [
                            TextSpan(
                              text: l10n.tagline.substring(0, comma + 1),
                            ),
                            TextSpan(
                              text: l10n.tagline.substring(comma + 1),
                              style: const TextStyle(
                                color: AppColors.electricCyan,
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
          ),
        ],
      ),
    );
  }
}

class AppStoreSearchResult extends StatelessWidget {
  const AppStoreSearchResult({super.key, required this.lang});

  final String lang;

  @override
  Widget build(BuildContext context) {
    final copy = _searchCopy[lang]!;
    final boardSize = _searchSafe.height - _inset(_searchSafe).vertical;

    return SizedBox.fromSize(
      size: _searchSize,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned.fill(
            child: StoreBackdrop(
              center: Alignment(-0.25, 0),
              radius: 0.9,
              gridSpacing: 96,
            ),
          ),
          Positioned(
            left: _searchSafe.left + boardSize / 2 - 1150,
            top: 1280 - 1150,
            child: storeGlow(AppColors.electricCyan, 2300, 0.16),
          ),
          Positioned(
            right: -700,
            bottom: -800,
            child: storeGlow(storeViolet, 2400, 0.24),
          ),
          Positioned(
            left: -600,
            top: -700,
            child: storeGlow(storeViolet, 1800, 0.14),
          ),

          // Boards in opposite corners, dimmed and outside the safe area, as
          // in the header: seen on wide screens, cropped on narrow ones.
          Positioned(
            right: -180,
            top: -260,
            width: 1000,
            height: 1000,
            child: Transform.rotate(
              angle: 0.14,
              child: _glowingBoard(opacity: 0.3, glow: 0.3),
            ),
          ),
          Positioned(
            left: -180,
            bottom: -260,
            width: 1000,
            height: 1000,
            child: Transform.rotate(
              angle: -0.14,
              child: _glowingBoard(opacity: 0.3, glow: 0.3),
            ),
          ),

          // Safe area: the board, then logo, headline and levels.
          Positioned.fromRect(
            rect: _searchSafe,
            child: Padding(
              padding: _inset(_searchSafe),
              child: Row(
                children: [
                  SizedBox.square(dimension: boardSize, child: _glowingBoard()),
                  const SizedBox(width: 120),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SudokuLogo(height: 150),
                          const SizedBox(height: 90),
                          Text(
                            copy.$1,
                            style: _headline(124, AppColors.snowWhite),
                          ),
                          Text(
                            copy.$2,
                            style: _headline(124, AppColors.electricCyan),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            copy.$3,
                            style: GoogleFonts.inter(
                              fontSize: 64,
                              fontWeight: FontWeight.w500,
                              color: AppColors.softSlate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _render(
  WidgetTester tester, {
  required String lang,
  required Size size,
  required Widget child,
  required String name,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: sagaxTheme,
      locale: Locale(lang),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: RepaintBoundary(child: child)),
      ),
    ),
  );
  // Let the bundled fonts load for real before capturing.
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 500)),
  );
  await tester.pumpAndSettle();
  await expectLater(
    find.byWidget(child),
    matchesGoldenFile('../../docs/app-store/creative-assets/$lang/$name.png'),
  );
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final lang in _langs.split(',')) {
    testWidgets('App Store header $lang', (tester) async {
      await _render(
        tester,
        lang: lang,
        size: _headerSize,
        child: const AppStoreHeader(),
        name: 'header',
      );
    });

    testWidgets('App Store search results $lang', (tester) async {
      await _render(
        tester,
        lang: lang,
        size: _searchSize,
        child: AppStoreSearchResult(lang: lang),
        name: 'search-results',
      );
    });
  }
}
