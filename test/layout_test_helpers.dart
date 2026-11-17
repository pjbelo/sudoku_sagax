import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foldable/foldable.dart';
import 'package:sudoku_sagax/l10n/app_localizations.dart';
import 'package:sudoku_sagax/sagax_theme.dart';
import 'package:sudoku_sagax/services/lesson_service.dart';
import 'package:sudoku_sagax/widgets/adaptive_layout.dart';
import 'package:sudoku_sagax/widgets/coach_card.dart';

const _duo = FoldableCapabilities(
  supportLevel: FoldableSupportLevel.available,
  isFoldable: true,
  hingeApiPresent: true,
  regionApiPresent: true,
  angleUnitVerified: false,
  strategy: 'test',
);

FoldableData _duoData(HingeStatus status, List<ReservedRegion> regions) {
  return FoldableData(
    capabilities: _duo,
    status: status,
    angleDegrees: null,
    regions: regions,
    displayFeatures: const [],
  );
}

/// A window of the app: its size in points, its safe area and, on iPhone Duo,
/// the fold state as the foldable package reports it.
class TestWindow {
  const TestWindow(this.size, {this.padding = EdgeInsets.zero, this.fold});

  final Size size;
  final EdgeInsets padding;
  final FoldableData? fold;
}

// Tablets and phones.
const phonePortrait = TestWindow(
  Size(390, 844),
  padding: EdgeInsets.only(top: 47, bottom: 34),
);
const phoneLandscape = TestWindow(
  Size(844, 390),
  padding: EdgeInsets.only(left: 47, right: 47, bottom: 21),
);
const smallPhone = TestWindow(
  Size(320, 568),
  padding: EdgeInsets.only(top: 20),
);
const ipadMiniPortrait = TestWindow(
  Size(744, 1133),
  padding: EdgeInsets.only(top: 24, bottom: 20),
);
const ipadMiniLandscape = TestWindow(
  Size(1133, 744),
  padding: EdgeInsets.only(top: 24, bottom: 20),
);
const ipad13Portrait = TestWindow(
  Size(1032, 1376),
  padding: EdgeInsets.only(top: 24, bottom: 20),
);
const ipad13Landscape = TestWindow(
  Size(1376, 1032),
  padding: EdgeInsets.only(top: 24, bottom: 20),
);
const androidTabletPortrait = TestWindow(
  Size(800, 1280),
  padding: EdgeInsets.only(top: 24),
);
const androidTabletLandscape = TestWindow(
  Size(1280, 800),
  padding: EdgeInsets.only(top: 24),
);

/// iPad Split View, a third of a 13-inch screen.
const ipadSplitView = TestWindow(
  Size(375, 1032),
  padding: EdgeInsets.only(top: 24, bottom: 20),
);

// iPhone Duo, with the geometry measured on the simulator.
const _foldInLandscape = Rect.fromLTRB(455, 0, 496, 669);
const _foldInPortrait = Rect.fromLTRB(0, 455, 669, 496);

final duoOuter = TestWindow(
  const Size(466, 678),
  padding: const EdgeInsets.only(right: 84, bottom: 34),
  fold: _duoData(HingeStatus.closed, const [
    ReservedRegion(
      kind: ReservedRegionKind.occlusion,
      bounds: Rect.fromLTRB(382, 0, 466, 174),
      isActive: true,
    ),
  ]),
);
final duoInnerPortrait = TestWindow(
  const Size(669, 951),
  padding: const EdgeInsets.only(top: 59, bottom: 34),
  fold: _duoData(HingeStatus.fullyOpen, const [
    ReservedRegion(
      kind: ReservedRegionKind.division,
      bounds: _foldInPortrait,
      isActive: false,
    ),
  ]),
);
final duoInnerLandscape = TestWindow(
  const Size(951, 669),
  padding: const EdgeInsets.only(right: 84, bottom: 21),
  fold: _duoData(HingeStatus.fullyOpen, const [
    ReservedRegion(
      kind: ReservedRegionKind.division,
      bounds: _foldInLandscape,
      isActive: false,
    ),
  ]),
);

/// Partly folded like a book: panes to the left and right of the fold.
final duoBook = TestWindow(
  const Size(951, 669),
  padding: const EdgeInsets.only(right: 84, bottom: 21),
  fold: _duoData(HingeStatus.partiallyOpen, const [
    ReservedRegion(
      kind: ReservedRegionKind.division,
      bounds: _foldInLandscape,
      isActive: true,
    ),
  ]),
);

/// Partly folded like a laptop: panes above and below the fold.
final duoLaptop = TestWindow(
  const Size(669, 951),
  padding: const EdgeInsets.only(top: 59, bottom: 34),
  fold: _duoData(HingeStatus.partiallyOpen, const [
    ReservedRegion(
      kind: ReservedRegionKind.division,
      bounds: _foldInPortrait,
      isActive: true,
    ),
  ]),
);

/// Laid flat a moment ago: the fold region still reads as active, but the
/// posture says the screen is one flat surface again.
final duoJustLaidFlat = TestWindow(
  const Size(951, 669),
  padding: const EdgeInsets.only(right: 84, bottom: 21),
  fold: _duoData(HingeStatus.fullyOpen, const [
    ReservedRegion(
      kind: ReservedRegionKind.division,
      bounds: _foldInLandscape,
      isActive: true,
    ),
  ]),
);

/// Waits for the bundled fonts to load, so that text gets its real size.
/// Until then (the first screens of a test file) text is laid out with the
/// wider test font and wraps sooner. Call it after [pumpScreen] in tests
/// that depend on how many lines a text takes.
Future<void> waitForFonts(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 500)),
  );
  await tester.pumpAndSettle();
}

/// Shows [screen] in [window], set up like `SudokuSagaxApp` but with the fold
/// state of the window in place of the platform's.
Future<void> pumpScreen(
  WidgetTester tester,
  Widget screen,
  TestWindow window, {
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = window.size * 3;
  tester.view.devicePixelRatio = 3;
  final padding = window.padding;
  final viewPadding = FakeViewPadding(
    left: padding.left * 3,
    top: padding.top * 3,
    right: padding.right * 3,
    bottom: padding.bottom * 3,
  );
  tester.view.padding = viewPadding;
  tester.view.viewPadding = viewPadding;
  addTearDown(tester.view.reset);

  final fold = window.fold;
  await tester.pumpWidget(
    FoldableProvider(
      bridgeMode: DisplayFeatureBridgeMode.full,
      debugData: fold == null ? const Stream.empty() : Stream.value(fold),
      child: MaterialApp(
        theme: sagaxTheme,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => LargeScreenText(child: child!),
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.pump(); // FoldAwareBuilder re-reads its origin after layout
  await tester.pumpAndSettle();
}

/// Takes a hint through the logic coach's three steps, in any language:
/// the Hint button, then the card's main button for Show me, Apply and OK.
/// When the hint solves the grid, the card is already gone after Apply.
Future<void> useHint(WidgetTester tester) async {
  // Before the card opens, the only light bulb is the Hint button's.
  await tester.tap(find.byIcon(Icons.lightbulb_outline));
  await tester.pumpAndSettle();
  final next = find.descendant(
    of: find.byType(CoachCard),
    matching: find.byType(ElevatedButton),
  );
  for (int stage = 0; stage < 3 && next.evaluate().isNotEmpty; stage++) {
    await tester.tap(next);
    await tester.pumpAndSettle();
  }
}

/// Marks every level as having suggested its lesson already, so no dialog
/// opens when a test starts a game. Call after the services are loaded.
Future<void> skipLessonSuggestions() async {
  await LessonService.instance.load();
  for (int level = 1; level <= 9; level++) {
    await LessonService.instance.markSuggested(level);
  }
}
