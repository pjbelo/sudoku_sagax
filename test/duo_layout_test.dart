import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/screens/home_screen.dart';
import 'package:sudoku_sagax/screens/options_screen.dart';
import 'package:sudoku_sagax/screens/scoreboard_screen.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
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

    testWidgets('game: Back leaves after the usual confirmation', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), duoOuter);
      await tester.tap(find.text('Hint +30s'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('Keep playing'), findsOneWidget);
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

    testWidgets('options: two cards on each side of the fold', (tester) async {
      await pumpScreen(tester, const OptionsScreen(), duoBook);
      expect(tester.getRect(find.text('Timer')).right, lessThan(455));
      expect(tester.getRect(find.text('Show errors')).left, greaterThan(496));
    });

    testWidgets('a dialog stays on one side of the fold', (tester) async {
      await pumpScreen(tester, const GameScreen(), duoBook);
      await tester.tap(find.text('Hint +30s'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
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
