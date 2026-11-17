import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/lessons.dart';
import 'package:sudoku_sagax/game/logic_coach.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/screens/home_screen.dart';
import 'package:sudoku_sagax/screens/lesson_screen.dart';
import 'package:sudoku_sagax/screens/lessons_screen.dart';
import 'package:sudoku_sagax/services/lesson_service.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/services/statistics_service.dart';
import 'package:sudoku_sagax/widgets/number_pad.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';

import 'layout_test_helpers.dart';

/// Taps cell [i], then [digit] on the number pad.
Future<void> move(WidgetTester tester, int i, int digit) async {
  final board = tester.getRect(find.byType(SudokuBoard));
  final cell = (board.width - 4) / 9;
  await tester.tapAt(
    board.topLeft +
        Offset(2 + cell * (colOf(i) + 0.5), 2 + cell * (rowOf(i) + 0.5)),
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find.descendant(
      of: find.byType(NumberPad),
      matching: find.byWidgetPredicate(
        (w) =>
            w is Text &&
            w.data == '$digit' &&
            (w.style?.fontFamily ?? '').startsWith('Exo2'),
      ),
    ),
  );
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
    await LessonService.instance.load();
  });

  group('boards', () {
    test('every lesson has a board where its technique is the next step', () {
      for (final technique in lessonTechniques) {
        final lesson = lessonFor(technique);
        final step = findCoachStep(SudokuGame(lesson.puzzle))!;
        expect(step.technique, technique, reason: technique.name);
        expect(step.cell, lesson.step.cell);
        expect(step.digit, lesson.puzzle.solution[step.cell]);
        expect(lesson.showsCandidates, step.eliminations.isNotEmpty);
        // The technique alone: no other elimination needed first.
        expect(step.eliminations.length, lesson.showsCandidates ? 1 : 0);
      }
    });

    test('the levels bring in their lessons', () {
      expect(lessonsIntroducedAt(1), [
        CoachTechnique.hiddenSingle,
        CoachTechnique.nakedSingle,
      ]);
      expect(lessonsIntroducedAt(9), [CoachTechnique.xWing]);
      expect(lessonsIntroducedAt(3), isEmpty);
    });
  });

  test('progress is saved', () async {
    final lessons = LessonService.instance;
    expect(lessons.isDone(CoachTechnique.xWing), isFalse);
    await lessons.markDone(CoachTechnique.xWing);
    await lessons.markSuggested(7);
    await lessons.load();
    expect(lessons.isDone(CoachTechnique.xWing), isTrue);
    expect(lessons.wasSuggested(7), isTrue);
    expect(lessons.wasSuggested(8), isFalse);
  });

  testWidgets('a wrong move shows the reasoning; the right one finishes', (
    tester,
  ) async {
    final lesson = lessonFor(CoachTechnique.nakedPair);
    final step = lesson.step;
    await pumpScreen(
      tester,
      const LessonScreen(technique: CoachTechnique.nakedPair),
      phonePortrait,
    );
    expect(find.textContaining('If two cells of a row'), findsOneWidget);
    expect(find.textContaining('Find the move'), findsOneWidget);

    // A wrong digit in the right cell.
    await move(tester, step.cell, step.digit % 9 + 1);
    expect(find.textContaining('Not this one.'), findsOneWidget);
    expect(find.textContaining('the two highlighted cells'), findsOneWidget);
    expect(LessonService.instance.isDone(CoachTechnique.nakedPair), isFalse);

    await move(tester, step.cell, step.digit);
    expect(find.textContaining('Well done!'), findsOneWidget);
    expect(LessonService.instance.isDone(CoachTechnique.nakedPair), isTrue);
    expect(find.text('Finish'), findsOneWidget);
  });

  testWidgets('the list ticks the finished lessons', (tester) async {
    await LessonService.instance.markDone(CoachTechnique.hiddenSingle);
    await pumpScreen(tester, const LessonsScreen(), phonePortrait);
    expect(find.text('Hidden single'), findsOneWidget);
    expect(find.text('From level 1 · Done'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    await tester.scrollUntilVisible(find.text('X-Wing'), 100);
    expect(find.text('From level 9'), findsOneWidget);
  });

  testWidgets('Home opens the lessons', (tester) async {
    await pumpScreen(tester, const HomeScreen(), phonePortrait);
    await tester.tap(find.text('Lessons'));
    await tester.pumpAndSettle();
    expect(find.byType(LessonsScreen), findsOneWidget);
  });

  testWidgets('a level suggests its lesson once', (tester) async {
    await pumpScreen(tester, const GameScreen(initialLevel: 7), phonePortrait);
    expect(find.text('New technique: Naked pair'), findsOneWidget);
    expect(
      find.text('Level 7 needs it. A short lesson shows how it works.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Lesson'));
    await tester.pumpAndSettle();
    expect(find.byType(LessonScreen), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);
    expect(find.text('Paused'), findsNothing); // the game goes on

    // Not again for that level.
    await tester.pumpWidget(const SizedBox());
    await pumpScreen(tester, const GameScreen(initialLevel: 7), phonePortrait);
    expect(find.text('New technique: Naked pair'), findsNothing);
  });

  testWidgets('no suggestion when the lessons are done', (tester) async {
    await LessonService.instance.markDone(CoachTechnique.xWing);
    await pumpScreen(tester, const GameScreen(initialLevel: 9), phonePortrait);
    expect(find.textContaining('New technique'), findsNothing);
    await pumpScreen(tester, const GameScreen(initialLevel: 3), phonePortrait);
    expect(find.textContaining('New technique'), findsNothing);
  });
}
