import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/game_review.dart';
import 'package:sudoku_sagax/game/logic_coach.dart';
import 'package:sudoku_sagax/game/puzzle_code.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/main.dart';
import 'package:sudoku_sagax/sagax_theme.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/screens/home_screen.dart';
import 'package:sudoku_sagax/screens/puzzle_code_screen.dart';
import 'package:sudoku_sagax/services/daily_service.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/services/statistics_service.dart';
import 'package:sudoku_sagax/widgets/coach_card.dart';
import 'package:sudoku_sagax/widgets/level_selector.dart';
import 'package:sudoku_sagax/widgets/number_pad.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';

import 'layout_test_helpers.dart';

// AudioService.init() is never called here, so every sound is a no-op.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1170, 2532); // phone, portrait
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const SudokuSagaxApp());
  await tester.pumpAndSettle();
}

/// Opens [game] through Continue, so the test knows the puzzle.
Future<void> continueGame(WidgetTester tester, SudokuGame game) async {
  await SavedGameService.instance.save(game, 0);
  await tester.pumpWidget(const SizedBox()); // start the app afresh
  await pumpApp(tester);
  await tester.tap(find.textContaining('Continue'));
  await tester.pumpAndSettle();
}

/// Taps cell [i] of the board.
Future<void> tapCell(WidgetTester tester, int i) async {
  final board = tester.getRect(find.byType(SudokuBoard));
  final cell = (board.width - 4) / 9;
  await tester.tapAt(
    board.topLeft +
        Offset(2 + cell * (colOf(i) + 0.5), 2 + cell * (rowOf(i) + 0.5)),
  );
  await tester.pumpAndSettle();
}

/// Taps [digit] on the number pad (not the count of a key).
Future<void> tapDigit(WidgetTester tester, int digit) async {
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

/// The game as last saved: the screen saves after every move.
SudokuGame savedGame() => SavedGameService.instance.savedGame!.game;

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SettingsService.instance.load();
    await ScoreboardService.instance.load();
    await SavedGameService.instance.load();
    await StatisticsService.instance.load();
    await SavedGameService.daily.load();
    await DailyService.instance.load();
    await skipLessonSuggestions();
  });

  testWidgets('home shows the level selector and menu', (tester) async {
    await pumpApp(tester);

    // Tests run with a light system setting, so the light logo.
    expect(
      find.image(
        const AssetImage('assets/images/sudoku-sagax-transp-light.png'),
      ),
      findsOneWidget,
    );
    expect(find.text('PLAY'), findsOneWidget);
    expect(find.text('Scoreboard'), findsOneWidget);
    expect(find.text('Options'), findsOneWidget);
    expect(find.text('Beginner · singles'), findsOneWidget);

    await tester.tap(
      find.descendant(of: find.byType(LevelSelector), matching: find.text('9')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Expert · X-Wing'), findsOneWidget);
  });

  testWidgets("follows the system's light or dark setting", (tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    Color background() =>
        Theme.of(tester.element(find.byType(HomeScreen)))
            .scaffoldBackgroundColor;

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await pumpApp(tester);
    expect(background(), AppColors.light.background);

    // Switching the system to dark changes the open app at once.
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pumpAndSettle();
    expect(background(), AppColors.dark.background);
    expect(
      find.image(const AssetImage('assets/images/sudoku-sagax-transp.png')),
      findsOneWidget,
    );
  });

  testWidgets('the Appearance option overrides the system', (tester) async {
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    Color background() =>
        Theme.of(tester.element(find.byType(Scaffold).last))
            .scaffoldBackgroundColor;

    await pumpApp(tester);
    await tester.tap(find.text('Options'));
    await tester.pumpAndSettle();
    // The card's buttons are the first Exo 2 SemiBold text: let it load
    // before the taps, or the text changes size between layout and paint.
    await waitForFonts(tester);
    expect(background(), AppColors.light.background);

    // Dark while the system is light.
    await tester.ensureVisible(find.text('Dark'));
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(SettingsService.instance.themeMode, ThemeMode.dark);
    expect(background(), AppColors.dark.background);

    // Light while the system is dark.
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(background(), AppColors.light.background);

    // Back to the system's setting (dark now), also by Restore defaults.
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Restore defaults'));
    await tester.tap(find.text('Restore defaults'));
    await tester.pumpAndSettle();
    expect(SettingsService.instance.themeMode, ThemeMode.system);
    expect(background(), AppColors.dark.background);
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
      await useHint(tester);
    }
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

    // The review: what the puzzle needed, then the 35 hints.
    await tester.tap(find.text('Review'));
    await tester.pumpAndSettle();
    expect(find.text('Game review'), findsOneWidget);
    expect(find.text('What this puzzle needed'), findsOneWidget);
    expect(find.textContaining(' · Hint: '), findsWidgets);
    expect(find.text('No hints and no mistakes: a clean solve!'), findsNothing);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

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

    await tester.ensureVisible(find.text('Back')); // below the cards
    await tester.pumpAndSettle();
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
    await useHint(tester);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsNothing);
    expect(saves.savedGame!.game.hintsUsed, 1);
    expect(find.textContaining('Continue · Level 1 · 0:3'), findsOneWidget);

    // Continue brings back the same game: a second hint adds to the first.
    await tester.tap(find.textContaining('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(GameScreen), findsOneWidget);
    await useHint(tester);
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

  group('easier entry', () {
    late SudokuGame game;
    late List<int> empty;

    setUp(() {
      game = SudokuGame(generatePuzzle(1, seed: 4));
      empty = [
        for (int i = 0; i < 81; i++)
          if (game.values[i] == 0) i,
      ];
    });

    testWidgets('a digit first, then the cells that take it', (tester) async {
      await continueGame(tester, game);
      final digit = game.solution[empty[0]];
      final cells = empty.where((i) => game.solution[i] == digit).toList();

      await tapDigit(tester, digit);
      expect(find.text('$digit: tap the cells that take it'), findsOneWidget);
      for (final i in cells) {
        await tapCell(tester, i);
      }
      for (final i in cells) {
        expect(savedGame().values[i], digit);
      }
      // Tapping a placed digit again takes it out, as in cell-first entry.
      await tapCell(tester, cells.first);
      expect(savedGame().values[cells.first], 0);

      // The same key lets go of the digit.
      await tapDigit(tester, digit);
      expect(
        find.text('Pick a cell and a number, in either order'),
        findsOneWidget,
      );
    });

    testWidgets('cell first still works; a second tap lets go of the cell', (
      tester,
    ) async {
      await continueGame(tester, game);
      final i = empty[0];
      await tapCell(tester, i);
      await tapDigit(tester, game.solution[i]);
      expect(savedGame().values[i], game.solution[i]);

      // The cell is still selected: tap it again, then pick a digit.
      await tapCell(tester, i);
      await tapDigit(tester, 3);
      expect(find.text('3: tap the cells that take it'), findsOneWidget);
      expect(savedGame().values[i], game.solution[i]);
    });

    testWidgets('redo brings back what undo took away', (tester) async {
      await continueGame(tester, game);
      final i = empty[0];
      await tapCell(tester, i);
      await tapDigit(tester, game.solution[i]);

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      // Back to the start: nothing worth saving.
      expect(SavedGameService.instance.hasSavedGame, isFalse);
      await tester.tap(find.text('Redo'));
      await tester.pumpAndSettle();
      expect(savedGame().values[i], game.solution[i]);
    });

    testWidgets('fill notes: from level 6, or with the option', (tester) async {
      // Level 1: Notes mode, but no Fill notes.
      await continueGame(tester, game);
      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();
      expect(
        find.text('Notes: tap numbers to mark candidates'),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.auto_awesome), findsNothing);

      // Level 6 offers it; one tap writes every candidate.
      final hard = SudokuGame(generatePuzzle(6, seed: 4));
      await continueGame(tester, hard);
      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Notes · tap here to fill in every candidate'),
      );
      await tester.pumpAndSettle();
      for (int i = 0; i < 81; i++) {
        expect(
          savedGame().notes[i],
          hard.values[i] == 0 ? hard.candidates(i) : 0,
        );
      }

      // The option brings it to level 1 too.
      SettingsService.instance.fillNotesEasy = true;
      await continueGame(tester, game);
      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    });

    testWidgets('vibration follows its option', (tester) async {
      var vibrations = 0;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'HapticFeedback.vibrate') vibrations++;
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await continueGame(tester, game);
      await tapCell(tester, empty[0]);
      await tapDigit(tester, game.solution[empty[0]]);
      expect(vibrations, 1);

      SettingsService.instance.haptics = false;
      await tapCell(tester, empty[1]);
      await tapDigit(tester, game.solution[empty[1]]);
      expect(vibrations, 1);
    });
  });

  group('mark conflicts', () {
    Finder outlinedCells() => find.byWidgetPredicate(
      (w) => w is AnimatedContainer && w.foregroundDecoration != null,
    );

    testWidgets('outlines both digits of a clash, by default', (tester) async {
      final game = SudokuGame(generatePuzzle(1, seed: 4));
      final empty = game.values.indexOf(0);
      final digit =
          game.values[peers[empty].firstWhere((p) => game.values[p] != 0)];
      // Every given with that digit in the row, column or box clashes.
      final clashes = peers[empty].where((p) => game.values[p] == digit);

      await continueGame(tester, game);
      expect(outlinedCells(), findsNothing);
      await tapCell(tester, empty);
      await tapDigit(tester, digit);
      expect(outlinedCells(), findsNWidgets(1 + clashes.length));

      // Switched off, the outlines go.
      SettingsService.instance.markConflicts = false;
      await tapCell(tester, empty); // any rebuild
      expect(outlinedCells(), findsNothing);
    });
  });

  group('logic coach', () {
    testWidgets('three steps: where, why, then the digit; only it costs', (
      tester,
    ) async {
      final game = SudokuGame(generatePuzzle(1, seed: 4));
      final step = findCoachStep(game)!;
      final unit = step.lookAt;
      final unitLabel = switch (unit.kind) {
        UnitKind.row => 'Row ${unit.index + 1}',
        UnitKind.column => 'Column ${unit.index + 1}',
        UnitKind.box => 'Box ${unit.index + 1}',
      };
      BoardHighlight? highlight() =>
          tester.widget<SudokuBoard>(find.byType(SudokuBoard)).highlight;

      await continueGame(tester, game);
      await tester.tap(find.text('Hint +30s'));
      await tester.pumpAndSettle();
      expect(find.text('Hidden single'), findsOneWidget);
      expect(find.text('Where to look: $unitLabel.'), findsOneWidget);
      expect(highlight()!.area, unit.cells.toSet());

      // Closing costs nothing.
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(CoachCard), findsNothing);
      expect(highlight(), isNull);
      expect(savedGame().hintsUsed, 0);

      await tester.tap(find.text('Hint +30s'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show me'));
      await tester.pumpAndSettle();
      expect(find.textContaining('fits in only one cell'), findsOneWidget);
      expect(highlight()!.focus, {step.cell});
      expect(savedGame().values[step.cell], 0);

      await tester.tap(find.text('Apply +30s'));
      await tester.pumpAndSettle();
      expect(find.text('The ${step.digit} is in place.'), findsOneWidget);
      expect(savedGame().values[step.cell], step.digit);
      expect(savedGame().isLocked(step.cell), isTrue);
      expect(savedGame().hintsUsed, 1);
      expect(
        SavedGameService.instance.savedGame!.seconds,
        greaterThanOrEqualTo(hintPenaltySeconds),
      );

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(CoachCard), findsNothing);
      expect(find.text('Hint +30s'), findsOneWidget);
    });

    testWidgets('a wrong digit is found first', (tester) async {
      final game = SudokuGame(generatePuzzle(1, seed: 4));
      final cell = game.values.indexOf(0);
      final wrong = game.solution[cell] % 9 + 1;
      game.enterDigit(cell, wrong);

      await continueGame(tester, game);
      await tester.tap(find.text('Hint +30s'));
      await tester.pumpAndSettle();
      expect(find.text('Mistake'), findsOneWidget);
      await tester.tap(find.text('Show me'));
      await tester.pumpAndSettle();
      expect(
        find.text("The highlighted $wrong doesn't belong in this cell."),
        findsOneWidget,
      );
      await tester.tap(find.text('Apply +30s'));
      await tester.pumpAndSettle();
      expect(savedGame().values[cell], game.solution[cell]);
    });
  });

  testWidgets('a mistake is kept with the logic available then', (
    tester,
  ) async {
    final game = SudokuGame(generatePuzzle(1, seed: 4));
    final cell = game.values.indexOf(0);
    final available = findCoachStep(game, preferred: cell)!;
    final wrong = game.solution[cell] % 9 + 1;

    await continueGame(tester, game);
    await tapCell(tester, cell);
    await tapDigit(tester, wrong);
    final event = SavedGameService.instance.savedGame!.events.single;
    expect(event.kind, ReviewEventKind.mistake);
    expect(event.cell, cell);
    expect(event.digit, wrong);
    expect(event.technique, available.technique);
    expect(event.stepCell, available.cell);
  });

  group('accessibility', () {
    late SudokuGame game;
    late int given;
    late int empty;

    setUp(() {
      game = SudokuGame(generatePuzzle(1, seed: 4));
      given = game.values.indexWhere((v) => v != 0);
      empty = game.values.indexOf(0);
    });

    String cellName(int i) => 'row ${rowOf(i) + 1}, column ${colOf(i) + 1}';

    testWidgets('cells and keys speak to screen readers', (tester) async {
      final semantics = tester.ensureSemantics();
      await continueGame(tester, game);

      expect(
        find.bySemanticsLabel(
          '${cellName(given)}, ${game.values[given]}, given',
        ),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('${cellName(empty)}, empty'),
        findsOneWidget,
      );
      final placed = game.values.where((v) => v == 5).length;
      expect(find.bySemanticsLabel('5, ${9 - placed} left'), findsOneWidget);

      // Notes are read out too.
      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();
      await tapCell(tester, empty);
      await tapDigit(tester, 3);
      await tapDigit(tester, 7);
      expect(
        find.bySemanticsLabel('${cellName(empty)}, empty, notes 3 7'),
        findsOneWidget,
      );
      semantics.dispose();
    });

    testWidgets('a hint and an error have a shape as well as a colour', (
      tester,
    ) async {
      SettingsService.instance.showErrors = true;
      final semantics = tester.ensureSemantics();
      await continueGame(tester, game);
      final wrong = game.solution[empty] % 9 + 1;
      await tapCell(tester, empty);
      await tapDigit(tester, wrong);
      expect(find.byKey(ValueKey('wrong-$empty')), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('^${cellName(empty)}, $wrong, wrong')),
        findsOneWidget,
      );

      // The coach fixes the mistake first: the cell becomes a hint.
      await useHint(tester);
      expect(find.byKey(ValueKey('wrong-$empty')), findsNothing);
      expect(find.byKey(ValueKey('hint-$empty')), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          '${cellName(empty)}, ${game.solution[empty]}, hint',
        ),
        findsOneWidget,
      );
      semantics.dispose();
    });

    testWidgets('high contrast: from the option or from the system', (
      tester,
    ) async {
      await continueGame(tester, game);
      bool boardContrast() =>
          tester.widget<SudokuBoard>(find.byType(SudokuBoard)).highContrast;
      expect(boardContrast(), isFalse);

      SettingsService.instance.highContrast = true;
      await continueGame(tester, game);
      expect(boardContrast(), isTrue);
      expect(
        tester.widget<NumberPad>(find.byType(NumberPad)).highContrast,
        isTrue,
      );

      // The option off, but the system asking for more contrast: the
      // board's notes take the main text colour (the light theme's here).
      SettingsService.instance.highContrast = false;
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(highContrast: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final noted = SudokuGame(generatePuzzle(1, seed: 4))
        ..toggleNote(empty, 4);
      await continueGame(tester, noted);
      // The note, not a given 4: notes are in Inter, digits in Exo 2.
      final note = tester.widget<Text>(
        find.descendant(
          of: find.byType(SudokuBoard),
          matching: find.byWidgetPredicate(
            (w) =>
                w is Text &&
                w.data == '4' &&
                (w.style?.fontFamily ?? '').startsWith('Inter'),
          ),
        ),
      );
      expect(note.style?.color, AppColors.light.text);
    });
  });

  group('shared puzzle', () {
    testWidgets(
      'a pasted message opens the same grid, kept off the scoreboard',
      (tester) async {
        // Catch what the share sheet gets.
        final shared = <String>[];
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          const MethodChannel('dev.fluttercommunity.plus/share'),
          (call) async {
            shared.add((call.arguments as Map)['text'] as String);
            return 'dev.fluttercommunity.plus/share/unavailable';
          },
        );

        final puzzle = generatePuzzle(1, seed: 7);
        await pumpApp(tester);
        await tester.tap(find.text('Code'));
        await tester.pumpAndSettle();
        expect(find.byType(PuzzleCodeScreen), findsOneWidget);

        // Nothing to play until the text holds a valid code.
        await tester.enterText(find.byType(TextField), 'hello');
        await tester.pumpAndSettle();
        expect(
          find.text('No valid code yet. Check the message or the code.'),
          findsOneWidget,
        );
        final play = find.widgetWithText(ElevatedButton, 'Play this puzzle');
        expect(tester.widget<ElevatedButton>(play).onPressed, isNull);

        await tester.enterText(
          find.byType(TextField),
          'Can you do better?\n\nCode: ${puzzleCode(puzzle)}\n\nhttps://x',
        );
        await tester.pumpAndSettle();
        expect(find.text('Level 1 · Beginner · singles'), findsOneWidget);
        await tester.tap(play);
        await tester.pumpAndSettle();

        expect(find.text('Shared puzzle'), findsOneWidget);
        await useHint(tester);
        final saved = SavedGameService.instance.savedGame!;
        expect(saved.shared, isTrue);
        expect(saved.game.puzzle.givens, puzzle.givens);

        for (int i = 1; i < 81 - puzzle.clueCount; i++) {
          await useHint(tester);
        }
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();
        // Statistics only: no scoreboard.
        expect(find.text('🏆 New best time for this level!'), findsNothing);
        expect(ScoreboardService.instance.scoresFor(1), isEmpty);
        expect(StatisticsService.instance.levelStats(1).solved, 1);

        // Share: the message holds the code of this puzzle.
        await tester.tap(find.text('Share'));
        await tester.pumpAndSettle();
        expect(shared, hasLength(1));
        expect(shared.single, contains('(level 1)'));
        expect(puzzleFromText(shared.single)?.givens, puzzle.givens);

        // Back to the menu goes home, past the code screen.
        await tester.tap(find.text('Back to Menu'));
        await tester.pumpAndSettle();
        expect(find.byType(PuzzleCodeScreen), findsNothing);
        expect(find.text('PLAY'), findsOneWidget);
      },
    );

    testWidgets('a level game after a shared one counts again', (tester) async {
      final puzzle = generatePuzzle(1, seed: 8);
      await SavedGameService.instance.save(SudokuGame(puzzle), 0, shared: true);
      await pumpApp(tester);
      await tester.tap(find.textContaining('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Shared puzzle'), findsOneWidget);
      for (int i = 0; i < 81 - puzzle.clueCount; i++) {
        await useHint(tester);
      }
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(ScoreboardService.instance.scoresFor(1), isEmpty);

      await tester.tap(find.text('Same Level'));
      await tester.pumpAndSettle();
      expect(find.text('Sudoku Sagax'), findsOneWidget); // the usual title
      await useHint(tester);
      expect(SavedGameService.instance.savedGame!.shared, isFalse);
    });
  });
}
