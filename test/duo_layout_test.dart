import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/l10n/app_localizations.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/screens/home_screen.dart';
import 'package:sudoku_sagax/screens/options_screen.dart';
import 'package:sudoku_sagax/screens/scoreboard_screen.dart';
import 'package:sudoku_sagax/services/daily_service.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/services/statistics_service.dart';
import 'package:sudoku_sagax/widgets/level_selector.dart';
import 'package:sudoku_sagax/widgets/number_pad.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';

import 'layout_test_helpers.dart';

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

  group('outer display', () {
    testWidgets('game: Back and the stats in the side rail', (tester) async {
      await pumpScreen(tester, const GameScreen(), duoOuter);
      expect(find.byType(AppBar), findsNothing);
      final back = tester.getRect(find.byType(BackButton));
      expect(back.left, greaterThanOrEqualTo(382)); // in the side strip
      expect(back.top, greaterThanOrEqualTo(174)); // below the camera
      expect(
        tester.getRect(find.text('Level')).left,
        greaterThanOrEqualTo(382),
      );
      expect(
        tester.getRect(find.byIcon(Icons.pause_rounded)).left,
        greaterThan(382),
      );
    });

    testWidgets('game: the board uses all the width left', (tester) async {
      await pumpScreen(tester, const GameScreen(), duoOuter);
      final board = tester.getRect(find.byType(SudokuBoard));
      expect(board.width, greaterThan(350));
      expect(board.right, lessThan(382));
      final pad = tester.getRect(find.byType(NumberPad));
      expect(pad.bottom, lessThanOrEqualTo(678 - 34));
    });

    testWidgets('game: Back keeps the game for Continue', (tester) async {
      await pumpScreen(tester, const HomeScreen(), duoOuter);
      await tester.tap(find.text('PLAY'));
      await tester.pumpAndSettle();
      await useHint(tester);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(GameScreen), findsNothing);
      expect(find.textContaining('Continue · Level 1'), findsOneWidget);
    });

    testWidgets('home: everything fits without scrolling', (tester) async {
      await pumpScreen(tester, const HomeScreen(), duoOuter);
      final scoreboard = tester.getRect(find.text('Scoreboard'));
      expect(scoreboard.bottom, lessThanOrEqualTo(678 - 34));
    });

    testWidgets('home: Info and the language in the side rail', (tester) async {
      await pumpScreen(tester, const HomeScreen(), duoOuter);
      final info = tester.getRect(find.byIcon(Icons.info_outline));
      expect(info.left, greaterThanOrEqualTo(382));
      expect(info.top, greaterThanOrEqualTo(174));
      expect(find.text('Info'), findsNothing); // no second copy in the column
    });
  });

  group('flat inner display', () {
    testWidgets('portrait keeps the usual layout', (tester) async {
      await pumpScreen(tester, const GameScreen(), duoInnerPortrait);
      expect(find.byType(AppBar), findsOneWidget);
      final board = tester.getRect(find.byType(SudokuBoard));
      expect(tester.getRect(find.text('Level')).bottom, lessThan(board.top));
      expect(
        tester.getRect(find.byType(NumberPad)).top,
        greaterThan(board.bottom),
      );
    });

    testWidgets('landscape: the board crosses the flat fold', (tester) async {
      await pumpScreen(tester, const GameScreen(), duoInnerLandscape);
      final board = tester.getRect(find.byType(SudokuBoard));
      expect(board.right, greaterThan(496));
      expect(board.height, greaterThan(600));
    });

    testWidgets('landscape: the narrow pane has keys taller than wide', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), duoInnerLandscape);
      final key = tester.getSize(
        find
            .ancestor(
              of: find.descendant(
                of: find.byType(NumberPad),
                matching: find.text('5'),
              ),
              matching: find.byType(InkWell),
            )
            .first,
      );
      expect(key.height, greaterThan(key.width * 1.2));
      // All the keys stay above the home indicator.
      final pad = tester.getRect(find.byType(NumberPad));
      expect(pad.bottom, lessThanOrEqualTo(669 - 21));
    });

    testWidgets('landscape: the win title stays on one line', (tester) async {
      for (final locale in AppLocalizations.supportedLocales) {
        await pumpScreen(
          tester,
          const GameScreen(),
          duoInnerLandscape,
          locale: locale,
        );
        // Level 1 has 81 - 46 = 35 empty cells.
        for (int i = 0; i < 35; i++) {
          await useHint(tester);
        }

        final title = find.text(lookupAppLocalizations(locale).congratulations);
        // The title is about 46 points high on one line and 92 on two.
        expect(tester.getSize(title).height, lessThan(60), reason: '$locale');
        // Shrunk to fit between the board and the side rail.
        final shown = tester.getRect(title);
        final board = tester.getRect(find.byType(SudokuBoard));
        expect(shown.left, greaterThan(board.right), reason: '$locale');
        expect(shown.right, lessThan(951 - 84), reason: '$locale');

        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets(
      'a fold still marked active just after laying flat is ignored',
      (tester) async {
        await pumpScreen(tester, const GameScreen(), duoJustLaidFlat);
        expect(
          tester.getRect(find.byType(SudokuBoard)).right,
          greaterThan(496),
        );
      },
    );
  });

  group('partly folded like a book', () {
    testWidgets('game: board and keys on either side of the fold', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), duoBook);
      expect(tester.getRect(find.byType(SudokuBoard)).right, lessThan(455));
      expect(tester.getRect(find.byType(NumberPad)).left, greaterThan(496));
      expect(tester.getRect(find.text('Undo')).left, greaterThan(496));
    });

    testWidgets('game, left-handed: the keys before the fold', (tester) async {
      SettingsService.instance.leftHanded = true;
      await pumpScreen(tester, const GameScreen(), duoBook);
      expect(tester.getRect(find.byType(NumberPad)).right, lessThan(455));
      expect(tester.getRect(find.text('Undo')).right, lessThan(455));
      final board = tester.getRect(find.byType(SudokuBoard));
      expect(board.left, greaterThan(496));
      expect(board.right, lessThan(951 - 84)); // clear of the side rail
    });

    testWidgets('home: brand and menu on either side of the fold', (
      tester,
    ) async {
      await pumpScreen(tester, const HomeScreen(), duoBook);
      final tagline = find.text('Fill the grid, sharpen your mind');
      expect(tester.getRect(tagline).right, lessThan(455));
      expect(tester.getRect(find.text('PLAY')).left, greaterThan(496));
    });

    testWidgets('scoreboard: levels and list on either side of the fold', (
      tester,
    ) async {
      await pumpScreen(tester, const ScoreboardScreen(), duoBook);
      expect(tester.getRect(find.byType(LevelSelector)).right, lessThan(455));
    });

    testWidgets('options: cards on either side of the fold', (tester) async {
      await pumpScreen(tester, const OptionsScreen(), duoBook);
      expect(tester.getRect(find.text('Timer')).right, lessThan(455));
      expect(tester.getRect(find.text('Show errors')).left, greaterThan(496));
    });

    testWidgets('a dialog stays on one side of the fold', (tester) async {
      // With a saved game, PLAY asks before replacing it.
      final game = SudokuGame(generatePuzzle(1, seed: 1))..hint();
      await SavedGameService.instance.save(game, 60);
      await pumpScreen(tester, const HomeScreen(), duoBook);
      await tester.tap(find.text('PLAY'));
      await tester.pumpAndSettle();
      expect(find.text('Start a new game?'), findsOneWidget);
      expect(tester.getRect(find.byType(Dialog)).right, lessThanOrEqualTo(455));
    });

    testWidgets('the language sheet stays on one side of the fold', (
      tester,
    ) async {
      await pumpScreen(tester, const HomeScreen(), duoBook);
      await tester.tap(find.byIcon(Icons.language));
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byType(BottomSheet)).right,
        lessThanOrEqualTo(455),
      );
    });
  });

  group('partly folded like a laptop', () {
    testWidgets('game: only the board above the fold', (tester) async {
      await pumpScreen(tester, const GameScreen(), duoLaptop);
      expect(find.byType(AppBar), findsNothing);
      final board = tester.getRect(find.byType(SudokuBoard));
      expect(board.bottom, lessThan(455));
      expect(board.height, greaterThan(360));
    });

    testWidgets('game: Back, stats, Pause and keys below the fold', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), duoLaptop);
      expect(tester.getRect(find.byType(BackButton)).top, greaterThan(496));
      expect(tester.getRect(find.text('Level')).top, greaterThan(496));
      expect(
        tester.getRect(find.byIcon(Icons.pause_rounded)).top,
        greaterThan(496),
      );
      final pad = tester.getRect(find.byType(NumberPad));
      expect(pad.top, greaterThan(496));
      expect(pad.bottom, lessThanOrEqualTo(951 - 34));
    });

    testWidgets('home: brand above and menu below the fold', (tester) async {
      await pumpScreen(tester, const HomeScreen(), duoLaptop);
      final tagline = find.text('Fill the grid, sharpen your mind');
      expect(tester.getRect(tagline).bottom, lessThan(455));
      expect(tester.getRect(find.byType(LevelSelector)).top, greaterThan(496));
      expect(
        tester.getRect(find.text('Scoreboard')).bottom,
        lessThan(951 - 34),
      );
    });

    testWidgets('the language sheet shows all 5 languages above the fold', (
      tester,
    ) async {
      await pumpScreen(tester, const HomeScreen(), duoLaptop);
      await tester.tap(find.byIcon(Icons.language).first);
      await tester.pumpAndSettle();
      expect(
        tester.getRect(find.byType(BottomSheet)).bottom,
        lessThanOrEqualTo(455),
      );
      expect(
        tester.getRect(find.textContaining('Deutsch')).bottom,
        lessThan(455),
      );
    });
  });
}
