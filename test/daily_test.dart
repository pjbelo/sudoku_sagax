import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/daily_puzzle.dart';
import 'package:sudoku_sagax/game/logic_coach.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/screens/daily_screen.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/services/daily_service.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/services/statistics_service.dart';

import 'layout_test_helpers.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsService.instance.load();
    await ScoreboardService.instance.load();
    await SavedGameService.instance.load();
    await SavedGameService.daily.load();
    await StatisticsService.instance.load();
    await DailyService.instance.load();
    await skipLessonSuggestions();
  });

  group('the puzzle', () {
    test('GOLDEN: a day keeps its puzzle in every version', () {
      // If this fails, a change reached the daily puzzle (daily_puzzle.dart,
      // puzzle_bank.dart or a solver it uses): once shipped, players would
      // get another puzzle for the same day. Undo the change.
      expect(
        dailyPuzzle(DateTime(2026, 11, 16)).givens.join(),
        '036020010080005000050009608893602400104908060000470800549030286'
        '317080000060004007',
      );
      expect(
        dailyPuzzle(DateTime(2026, 11, 22)).givens.join(),
        '030720000500000010400900300000208040001060090000400007704000509'
        '203000000809670000',
      );
    });

    test('easier early in the week, harder at the weekend', () {
      // 16 November 2026 is a Monday.
      final week = [
        for (int d = 0; d < 7; d++) dailyLevel(DateTime(2026, 11, 16 + d)),
      ];
      expect(week, [3, 4, 5, 6, 6, 7, 8]);
    });

    test('the same all day, another the next day', () {
      final morning = dailyPuzzle(DateTime(2026, 11, 18, 0, 5));
      final night = dailyPuzzle(DateTime(2026, 11, 18, 23, 55));
      expect(morning.givens, night.givens);
      expect(dailyPuzzle(DateTime(2026, 11, 19)).givens, isNot(morning.givens));
    });

    test('every day fits its level, for a season', () {
      final seen = <String>{};
      for (int d = 0; d < 120; d++) {
        final day = DateTime(2026, 11, 1 + d);
        final p = dailyPuzzle(day);
        final spec = sudokuLevels[p.level - 1];
        expect(countSolutions(p.givens), 1);
        expect(p.clueCount, greaterThanOrEqualTo(spec.clues));
        expect(
          meetsLevel(spec.technique, hardestTechnique(p.givens)),
          isTrue,
          reason: '$day',
        );
        seen.add(p.givens.join());
      }
      expect(seen, hasLength(120));
    });
  });

  group('streaks', () {
    final daily = DailyService.instance;

    test('today unsolved still counts the days before', () async {
      for (final d in [10, 11, 12]) {
        await daily.recordSolved(DateTime(2026, 11, d), 300);
      }
      expect(daily.currentStreak(DateTime(2026, 11, 12, 20)), 3);
      expect(daily.currentStreak(DateTime(2026, 11, 13, 9)), 3);
      expect(daily.currentStreak(DateTime(2026, 11, 14)), 0);
      await daily.recordSolved(DateTime(2026, 11, 14), 200);
      expect(daily.currentStreak(DateTime(2026, 11, 14)), 1);
      expect(daily.bestStreak, 3);
    });

    test('a month end and a clock change keep the run', () async {
      for (final day in [
        DateTime(2026, 10, 24),
        DateTime(2026, 10, 25), // clocks go back in Europe
        DateTime(2026, 10, 26),
        DateTime(2026, 10, 31),
        DateTime(2026, 11, 1),
      ]) {
        await daily.recordSolved(day, 100);
      }
      expect(daily.bestStreak, 3);
      expect(daily.currentStreak(DateTime(2026, 11, 1)), 2);
    });

    test('the first time counts, and it is saved', () async {
      await daily.recordSolved(DateTime(2026, 11, 5), 300);
      await daily.recordSolved(DateTime(2026, 11, 5), 100);
      await daily.load();
      expect(daily.secondsFor(DateTime(2026, 11, 5)), 300);
      expect(daily.isSolved(DateTime(2026, 11, 6)), isFalse);
    });

    test('damaged data is dropped instead of crashing', () async {
      SharedPreferences.setMockInitialValues({'daily_solved': 'not json'});
      await daily.load();
      expect(daily.bestStreak, 0);
    });
  });

  testWidgets('today: play, leave, continue, solve', (tester) async {
    final monday = DateTime(2026, 11, 16);
    await pumpScreen(tester, DailyScreen(today: monday), phonePortrait);
    expect(find.text('Level 3 · Easy · singles'), findsOneWidget);
    expect(find.text('November 2026'), findsOneWidget);

    await tester.tap(find.text("Play today's puzzle"));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Daily puzzle'), findsOneWidget); // the app bar
    await useHint(tester);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Kept apart from the levels' Continue.
    expect(SavedGameService.daily.hasSavedGame, isTrue);
    expect(SavedGameService.instance.hasSavedGame, isFalse);
    await tester.tap(find.text("Continue today's puzzle"));
    await tester.pumpAndSettle();
    expect(SavedGameService.daily.savedGame!.game.hintsUsed, 1);

    // Solve it with the coach: 81 - 38 clues, one already placed.
    for (int i = 0; i < 42; i++) {
      await useHint(tester);
    }
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Come back tomorrow for a new puzzle.'), findsOneWidget);
    expect(find.text('Next Level'), findsNothing);
    await tester.tap(find.text('Back to Menu'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Solved today in'), findsOneWidget);
    expect(DailyService.instance.isSolved(monday), isTrue);
    expect(find.text('1 day'), findsNWidgets(2)); // both streaks
  });

  testWidgets("yesterday's unfinished game isn't continued", (tester) async {
    final monday = DateTime(2026, 11, 16);
    await pumpScreen(tester, DailyScreen(today: monday), phonePortrait);
    await tester.tap(find.text("Play today's puzzle"));
    await tester.pumpAndSettle();
    await useHint(tester);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // The next day, on a fresh screen.
    await tester.pumpWidget(const SizedBox());
    await pumpScreen(
      tester,
      DailyScreen(today: monday.add(const Duration(days: 1))),
      phonePortrait,
    );
    expect(find.text("Play today's puzzle"), findsOneWidget);
  });
}
