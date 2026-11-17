import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/main.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/services/statistics_service.dart';
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
    await SavedGameService.instance.load();
    await StatisticsService.instance.load();
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
    expect(SavedGameService.instance.hasSavedGame, isFalse);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Hints: 35 · Mistakes: 0'), findsOneWidget);
    final stats = StatisticsService.instance.levelStats(1);
    expect(stats.started, 1);
    expect(stats.solved, 1);
    expect(stats.solvedWithoutHints, 0);
    expect(stats.solvedWithoutMistakes, 1);
    expect(StatisticsService.instance.currentStreak(DateTime.now()), 1);
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

    await tester.tap(find.text('Statistics'));
    await tester.pumpAndSettle();
    expect(find.text('1 · 100%'), findsOneWidget); // solved
    expect(find.text('1 day'), findsNWidgets(2)); // both streaks
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

  testWidgets('a game left unfinished can be continued', (tester) async {
    final saves = SavedGameService.instance;
    await pumpApp(tester);
    expect(find.textContaining('Continue'), findsNothing);
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();

    // No moves yet: leaving keeps nothing.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(saves.hasSavedGame, isFalse);
    expect(StatisticsService.instance.levelStats(1).started, 0);
    expect(find.textContaining('Continue'), findsNothing);

    // One hint, then Back: no confirmation, and Home offers Continue.
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hint +30s'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsNothing);
    expect(saves.savedGame!.game.hintsUsed, 1);
    expect(find.textContaining('Continue · Level 1 · 0:3'), findsOneWidget);

    // Continue brings back the same game: a second hint adds to the first.
    await tester.tap(find.textContaining('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);
    await tester.tap(find.text('Hint +30s'));
    await tester.pumpAndSettle();
    expect(saves.savedGame!.game.hintsUsed, 2);
    // A continued game is still one game.
    expect(StatisticsService.instance.levelStats(1).started, 1);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // PLAY would replace the saved game, so it asks first.
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();
    expect(find.text('Start a new game?'), findsOneWidget);
    expect(
      find.text('The unfinished game on level 1 will be lost.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsNothing);
    expect(saves.hasSavedGame, isTrue);

    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New game'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);
    expect(saves.hasSavedGame, isFalse);
  });
}
