import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/l10n/app_localizations.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/screens/home_screen.dart';
import 'package:sudoku_sagax/screens/info_screen.dart';
import 'package:sudoku_sagax/screens/options_screen.dart';
import 'package:sudoku_sagax/screens/scoreboard_screen.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/widgets/adaptive_layout.dart';
import 'package:sudoku_sagax/widgets/level_selector.dart';
import 'package:sudoku_sagax/widgets/number_pad.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';

import 'layout_test_helpers.dart';

/// The top 10 of level 1.
Map<String, Object> _fullScoreboard() {
  final date = DateTime(2026, 11, 2).millisecondsSinceEpoch;
  final entries = [
    for (int i = 0; i < 10; i++)
      {'s': 200 + i * 30, 'h': i % 3, 'm': i % 2, 'd': date},
  ];
  return {'scores_level_1': jsonEncode(entries)};
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() async {
    SharedPreferences.setMockInitialValues(_fullScoreboard());
    await SettingsService.instance.load();
    SettingsService.instance.showErrors = true; // the widest row of stats
    await ScoreboardService.instance.load();
  });

  group('no screen overflows', () {
    final windows = {
      'small phone': smallPhone,
      'phone portrait': phonePortrait,
      'phone landscape': phoneLandscape,
      'iPad Split View': ipadSplitView,
      'iPad mini portrait': ipadMiniPortrait,
      'iPad mini landscape': ipadMiniLandscape,
      'iPad 13 portrait': ipad13Portrait,
      'iPad 13 landscape': ipad13Landscape,
      'Android tablet portrait': androidTabletPortrait,
      'Android tablet landscape': androidTabletLandscape,
      'iPhone Duo outer': duoOuter,
      'iPhone Duo inner portrait': duoInnerPortrait,
      'iPhone Duo inner landscape': duoInnerLandscape,
      'iPhone Duo book': duoBook,
      'iPhone Duo laptop': duoLaptop,
    };
    final screens = <String, Widget>{
      'home': const HomeScreen(),
      'game': const GameScreen(),
      'scoreboard': const ScoreboardScreen(),
      'options': const OptionsScreen(),
      'info': const InfoScreen(),
    };

    for (final MapEntry(key: windowName, value: window) in windows.entries) {
      for (final locale in AppLocalizations.supportedLocales) {
        testWidgets('$windowName, ${locale.languageCode}', (tester) async {
          // An overflow is reported as an error, which fails the test.
          for (final screen in screens.values) {
            await pumpScreen(tester, screen, window, locale: locale);
            await tester.pumpWidget(const SizedBox());
          }
        });
      }
    }
  });

  group('text and control size', () {
    double scaleIn(WidgetTester tester) {
      return uiScaleOf(tester.element(find.byType(HomeScreen)));
    }

    testWidgets('phones and iPhone Duo keep the phone size', (tester) async {
      await pumpScreen(tester, const HomeScreen(), phonePortrait);
      expect(scaleIn(tester), 1);
      await pumpScreen(tester, const HomeScreen(), duoInnerPortrait);
      expect(scaleIn(tester), 1);
    });

    testWidgets('grows with the tablet, up to the limit', (tester) async {
      await pumpScreen(tester, const HomeScreen(), ipadMiniPortrait);
      final mini = scaleIn(tester);
      await pumpScreen(tester, const HomeScreen(), ipad13Landscape);
      expect(mini, greaterThan(1));
      expect(scaleIn(tester), 1.3);
    });

    testWidgets('follows the window, not the device', (tester) async {
      await pumpScreen(tester, const HomeScreen(), ipadSplitView);
      expect(scaleIn(tester), 1);
    });

    testWidgets('adds to the text size chosen in the system', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await pumpScreen(tester, const HomeScreen(), ipad13Landscape);
      final context = tester.element(find.byType(HomeScreen));
      expect(MediaQuery.textScalerOf(context).scale(10), closeTo(19.5, 0.01));
    });

    testWidgets('board text ignores it and still fits the cells', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), ipad13Landscape);
      final digit = find.descendant(
        of: find.byType(SudokuBoard),
        matching: find.byType(Text),
      );
      final context = tester.element(digit.first);
      expect(MediaQuery.textScalerOf(context), TextScaler.noScaling);
    });
  });

  group('home', () {
    testWidgets('one column on a tablet in portrait', (tester) async {
      await pumpScreen(tester, const HomeScreen(), ipad13Portrait);
      final tagline = tester.getRect(
        find.text('Fill the grid, sharpen your mind'),
      );
      final selector = tester.getRect(find.byType(LevelSelector));
      expect(tagline.bottom, lessThan(selector.top));
    });

    testWidgets('two panes on a tablet in landscape', (tester) async {
      await pumpScreen(tester, const HomeScreen(), ipad13Landscape);
      final tagline = tester.getRect(
        find.text('Fill the grid, sharpen your mind'),
      );
      final selector = tester.getRect(find.byType(LevelSelector));
      expect(tagline.right, lessThan(688));
      expect(selector.left, greaterThan(688));
      expect(tester.getRect(find.text('PLAY')).left, greaterThan(688));
    });

    testWidgets('chips grow with the screen', (tester) async {
      await pumpScreen(tester, const HomeScreen(), ipad13Landscape);
      final tablet = tester.getSize(find.byType(LevelSelector)).width;
      await pumpScreen(tester, const HomeScreen(), phonePortrait);
      final phone = tester.getSize(find.byType(LevelSelector)).width;
      expect(tablet, greaterThan(phone * 1.25));
    });
  });

  group('game', () {
    testWidgets('tablet in landscape: the board takes the full height', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), ipad13Landscape);
      final board = tester.getRect(find.byType(SudokuBoard));
      // Height left under the status bar and the app bar, minus the margins.
      expect(board.height, greaterThan(900));
      expect(board.width, board.height);
      expect(
        tester.getRect(find.byType(NumberPad)).left,
        greaterThan(board.right),
      );
    });

    testWidgets('tablet in landscape: the keys are close to square', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), ipad13Landscape);
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
      expect(key.height / key.width, greaterThan(0.85));
    });

    testWidgets('tablet in portrait: the board is larger than the old cap', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), ipad13Portrait);
      expect(tester.getSize(find.byType(SudokuBoard)).width, greaterThan(820));
    });

    testWidgets('tablet in portrait: board and keys share their edges', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), ipad13Portrait);
      final board = tester.getRect(find.byType(SudokuBoard));
      final pad = tester.getRect(find.byType(NumberPad));
      expect(pad.left, closeTo(board.left, 3));
      expect(pad.right, closeTo(board.right, 3));
      expect(pad.top, greaterThan(board.bottom));
    });

    testWidgets('a cell tap lands on the right cell of a large board', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), ipad13Landscape);
      final rect = tester.getRect(find.byType(SudokuBoard));
      final cellSize = rect.width / 9;
      await tester.tapAt(rect.topLeft + Offset(cellSize * 8.5, cellSize * 8.5));
      await tester.pump();
      expect(tester.widget<SudokuBoard>(find.byType(SudokuBoard)).selected, 80);
    });

    testWidgets('narrow panes stack the controls in two rows', (tester) async {
      await pumpScreen(tester, const GameScreen(), duoInnerLandscape);
      final undo = tester.getRect(find.text('Undo'));
      final notes = tester.getRect(find.text('Notes'));
      expect(notes.top, greaterThan(undo.bottom));
    });

    // The windows that show the keys beside the board, below the status.
    final sideBySide = {
      'iPad mini landscape': ipadMiniLandscape,
      'iPad 13 landscape': ipad13Landscape,
      'Android tablet landscape': androidTabletLandscape,
      'iPhone Duo inner landscape': duoInnerLandscape,
      'iPhone Duo book': duoBook,
    };
    for (final MapEntry(key: windowName, value: window) in sideBySide.entries) {
      testWidgets('$windowName: the keys stay put when the status changes', (
        tester,
      ) async {
        for (final locale in AppLocalizations.supportedLocales) {
          await pumpScreen(tester, const GameScreen(), window, locale: locale);
          final pad = find.byType(NumberPad);
          final before = tester.getRect(pad);

          await tester.tap(find.byIcon(Icons.edit_outlined)); // notes on
          await tester.pumpAndSettle();
          expect(tester.getRect(pad), before, reason: 'notes, $locale');

          await tester.tap(find.byIcon(Icons.pause_rounded));
          await tester.pumpAndSettle();
          expect(tester.getRect(pad), before, reason: 'paused, $locale');

          await tester.pumpWidget(const SizedBox());
        }
      });
    }

    testWidgets('tablet in landscape: the panel fits without scrolling', (
      tester,
    ) async {
      final tablets = [
        ipadMiniLandscape,
        ipad13Landscape,
        androidTabletLandscape,
      ];
      for (final window in tablets) {
        for (final locale in AppLocalizations.supportedLocales) {
          await pumpScreen(tester, const GameScreen(), window, locale: locale);
          await waitForFonts(tester);
          // The longest status message, which takes two lines.
          await tester.tap(find.byIcon(Icons.edit_outlined));
          await tester.pumpAndSettle();
          final panel = tester.state<ScrollableState>(find.byType(Scrollable));
          expect(
            panel.position.maxScrollExtent,
            0,
            reason: '${window.size}, $locale',
          );
          await tester.pumpWidget(const SizedBox());
        }
      }
    });
  });

  group('scoreboard', () {
    testWidgets('landscape: levels beside the list, all 10 in view', (
      tester,
    ) async {
      await pumpScreen(tester, const ScoreboardScreen(), ipad13Landscape);
      final selector = tester.getRect(find.byType(LevelSelector));
      final tenth = tester.getRect(find.text('#10'));
      expect(selector.right, lessThan(tenth.left));
      expect(tenth.bottom, lessThan(1032 - 20));
    });

    testWidgets('portrait: the row of chips lines up with the list', (
      tester,
    ) async {
      await pumpScreen(tester, const ScoreboardScreen(), ipad13Portrait);
      final firstChip = tester.getRect(
        find
            .descendant(
              of: find.byType(LevelSelector),
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      final list = tester.getRect(find.byType(ListView));
      final firstRow = tester.getTopLeft(find.text('#4'));
      expect(list.left, 0); // it fills the width, so its margins scroll too
      expect(firstChip.left, closeTo(firstRow.dx, 30));
    });
  });

  group('options', () {
    testWidgets('side by side on a tablet', (tester) async {
      await pumpScreen(tester, const OptionsScreen(), ipad13Landscape);
      final sound = tester.getRect(find.text('Sound'));
      final timer = tester.getRect(find.text('Timer'));
      expect(timer.left, greaterThan(sound.right));
      expect(timer.top, sound.top);
    });

    testWidgets('one under the other on a phone', (tester) async {
      await pumpScreen(tester, const OptionsScreen(), phonePortrait);
      final sound = tester.getRect(find.text('Sound'));
      final timer = tester.getRect(find.text('Timer'));
      expect(timer.left, sound.left);
      expect(timer.top, greaterThan(sound.bottom));
    });
  });

  group('info', () {
    testWidgets('benefits in two columns on a tablet', (tester) async {
      await pumpScreen(tester, const InfoScreen(), ipad13Landscape);
      final first = tester.getRect(
        find.text('🔢 Logical and Deductive Reasoning'),
      );
      final second = tester.getRect(find.text('🧠 Working Memory'));
      expect(second.left, greaterThan(first.right));
      expect(second.top, first.top);
    });

    testWidgets('dragging in the margin of a large screen scrolls', (
      tester,
    ) async {
      await pumpScreen(tester, const InfoScreen(), ipad13Landscape);
      final before = tester.getTopLeft(find.text('How to play')).dy;
      await tester.dragFrom(const Offset(8, 700), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.text('How to play')).dy, lessThan(before));
    });
  });
}
