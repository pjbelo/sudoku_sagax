import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/main.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/widgets/level_selector.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';

// AudioService.init() is never called here, so every sound is a no-op.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1170, 2532); // phone, portrait
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const SudokuSagaxApp());
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsService.instance.load();
    await ScoreboardService.instance.load();
  });

  testWidgets('home shows the level selector and menu', (tester) async {
    await pumpApp(tester);

    expect(
      find.image(const AssetImage('assets/images/sudoku-sagax-transp.png')),
      findsOneWidget,
    );
    expect(find.text('PLAY'), findsOneWidget);
    expect(find.text('Scoreboard'), findsOneWidget);
    expect(find.text('Options'), findsOneWidget);
    expect(find.text('Beginner · 46 clues'), findsOneWidget);

    await tester.tap(
      find.descendant(of: find.byType(LevelSelector), matching: find.text('9')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Expert · 24 clues'), findsOneWidget);
  });

  testWidgets('solving a game with hints records a score', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();

    expect(find.byType(SudokuBoard), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Mistakes'), findsNothing); // Show errors is OFF

    // Level 1 has 81 - 46 = 35 empty cells.
    for (int i = 0; i < 35; i++) {
      await tester.tap(find.text('Hint +30s'));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text('Solved!'), findsOneWidget);
    expect(find.text('Congratulations!'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Hints: 35 · Mistakes: 0'), findsOneWidget);
    expect(find.text('🏆 New best time for this level!'), findsOneWidget);
    expect(ScoreboardService.instance.scoresFor(1), hasLength(1));
    // 35 hints × 30 s penalty.
    expect(
      ScoreboardService.instance.scoresFor(1).single.seconds,
      greaterThanOrEqualTo(35 * 30),
    );

    await tester.tap(find.text('Back to Menu'));
    await tester.pumpAndSettle();
    expect(find.text('PLAY'), findsOneWidget);

    await tester.tap(find.text('Scoreboard'));
    await tester.pumpAndSettle();
    expect(find.text('🥇'), findsOneWidget);
  });

  testWidgets('show errors adds the mistakes counter', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Show errors'));
    await tester.pumpAndSettle();
    expect(SettingsService.instance.showErrors, isTrue);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();
    expect(find.text('Mistakes'), findsOneWidget);
  });

  testWidgets('hint and timer can be switched off', (tester) async {
    SettingsService.instance
      ..hints = false
      ..timer = false;
    await pumpApp(tester);
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();

    expect(find.text('Hint +30s'), findsNothing);
    expect(find.text('Time'), findsNothing);
    expect(find.byTooltip('Pause'), findsNothing);
  });

  testWidgets('notes mode and pause', (tester) async {
    await pumpApp(tester);
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Notes'));
    await tester.pumpAndSettle();
    expect(find.text('Notes: tap numbers to mark candidates'), findsOneWidget);

    await tester.tap(find.byTooltip('Pause'));
    await tester.pumpAndSettle();
    expect(find.text('Resume'), findsOneWidget);
    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();
    expect(find.text('Resume'), findsNothing);
  });

  testWidgets('leaving a game in progress asks for confirmation', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hint +30s'));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Leave this game?'), findsOneWidget);

    await tester.tap(find.text('Keep playing'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsNothing);
    expect(find.text('PLAY'), findsOneWidget);
  });
}
