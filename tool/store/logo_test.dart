// Renders the Sudoku Sagax logo to a transparent PNG for the home screen
// (assets/images/sudoku-sagax-transp.png, like Slidox's slidox-transp.png).
//
//   flutter test tool/store/logo_test.dart --update-goldens
//
// The design lives in lib/widgets/sudoku_logo.dart; regenerate after changing it.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_sagax/widgets/sudoku_logo.dart';

/// Logo height in pixels: 5× the in-app size, so it stays crisp when scaled
/// down. (Golden captures are taken at 1 px per logical pixel.)
const _height = 480.0;

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('logo', (tester) async {
    tester.view.physicalSize = const Size(3000, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // No background anywhere, so the PNG stays transparent around the logo.
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: RepaintBoundary(
            // Room for the centre cell's glow, which reaches past the grid.
            child: Padding(
              padding: EdgeInsets.all(40),
              child: SudokuLogo(height: _height),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(RepaintBoundary).first,
      matchesGoldenFile('../../assets/images/sudoku-sagax-transp.png'),
    );
  });
}
