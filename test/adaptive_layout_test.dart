import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/game_review.dart';
import 'package:sudoku_sagax/game/logic_coach.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/l10n/app_localizations.dart';
import 'package:sudoku_sagax/screens/game_screen.dart';
import 'package:sudoku_sagax/screens/home_screen.dart';
import 'package:sudoku_sagax/screens/info_screen.dart';
import 'package:sudoku_sagax/screens/lesson_screen.dart';
import 'package:sudoku_sagax/screens/lessons_screen.dart';
import 'package:sudoku_sagax/screens/options_screen.dart';
import 'package:sudoku_sagax/screens/review_screen.dart';
import 'package:sudoku_sagax/screens/scoreboard_screen.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/services/statistics_service.dart';
import 'package:sudoku_sagax/widgets/adaptive_layout.dart';
import 'package:sudoku_sagax/widgets/coach_card.dart';
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

/// A level 8 game left unfinished after an hour, for the Continue button
/// (the longest label: two-digit hours never happen in practice).
Future<void> _saveUnfinishedGame() async {
  final game = SudokuGame(generatePuzzle(8, seed: 1))..hint();
  await SavedGameService.instance.save(game, 4567);
}

/// A review with long lines: a level 9 puzzle, a hint and a mistake whose
/// available step is an X-Wing (the longest technique texts).
ReviewScreen _reviewScreen() {
  final puzzle = generatePuzzle(9, seed: 2);
  final step = findCoachStep(SudokuGame(puzzle))!;
  return ReviewScreen(
    puzzle: puzzle,
    events: [
      ReviewEvent.hint(step, 3725),
      ReviewEvent(
        kind: ReviewEventKind.mistake,
        seconds: 3790,
        cell: 80,
        digit: 9,
        technique: CoachTechnique.boxLineReduction,
        stepCell: 72,
        stepDigit: 8,
      ),
    ],
  );
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() async {
    SharedPreferences.setMockInitialValues(_fullScoreboard());
    await SettingsService.instance.load();
    SettingsService.instance.showErrors = true; // the widest row of stats
    await ScoreboardService.instance.load();
    // Long values for the statistics: an hour-long win and a 3-digit count.
    final stats = StatisticsService.instance;
    await stats.load();
    for (int i = 0; i < 120; i++) {
      await stats.recordStart(1);
    }
    await stats.recordWin(
      1,
      seconds: 4567,
      hints: 0,
      mistakes: 2,
      now: DateTime.now(),
    );
    await SavedGameService.instance.load();
    await StatisticsService.instance.load();
    await skipLessonSuggestions();
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
      'statistics': const ScoreboardScreen(showStatistics: true),
      'options': const OptionsScreen(),
      'info': const InfoScreen(),
      'review': _reviewScreen(),
      'lessons': const LessonsScreen(),
      // The X-Wing lesson has the longest texts.
      'lesson': const LessonScreen(technique: CoachTechnique.xWing),
    };

    for (final MapEntry(key: windowName, value: window) in windows.entries) {
      for (final locale in AppLocalizations.supportedLocales) {
        testWidgets('$windowName, ${locale.languageCode}', (tester) async {
          // An overflow is reported as an error, which fails the test.
          for (final screen in screens.values) {
            await pumpScreen(tester, screen, window, locale: locale);
            await tester.pumpWidget(const SizedBox());
          }
          // The game with the coach card open on its longest step.
          await pumpScreen(tester, const GameScreen(), window, locale: locale);
          await tester.tap(find.byIcon(Icons.lightbulb_outline));
          await tester.pumpAndSettle();
          await tester.tap(
            find.descendant(
              of: find.byType(CoachCard),
              matching: find.byType(ElevatedButton),
            ),
          );
          await tester.pumpAndSettle();
          await tester.pumpWidget(const SizedBox());
          // Home again, with Continue for a game left unfinished.
          await _saveUnfinishedGame();
          await pumpScreen(tester, const HomeScreen(), window, locale: locale);
          expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
          await tester.pumpWidget(const SizedBox());
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

    testWidgets('Continue fits without scrolling on phones', (tester) async {
      await _saveUnfinishedGame();
      // Spanish has the tallest home screen (its tagline takes two lines).
      for (final locale in const [Locale('en'), Locale('es')]) {
        for (final window in [phonePortrait, phoneLandscape, duoOuter]) {
          await pumpScreen(tester, const HomeScreen(), window, locale: locale);
          await waitForFonts(tester);
          final bottom = window.size.height - window.padding.bottom;
          for (final icon in [
            Icons.play_arrow_rounded, // Continue
            Icons.emoji_events_outlined, // Scoreboard
          ]) {
            expect(
              tester.getRect(find.byIcon(icon)).bottom,
              lessThanOrEqualTo(bottom),
              reason: '${window.size}, ${locale.languageCode}',
            );
          }
        }
      }
    });

    testWidgets('Continue under Play in one column, under the brand in two', (
      tester,
    ) async {
      await _saveUnfinishedGame();
      Rect continueButton() => tester.getRect(
        find.ancestor(
          of: find.byIcon(Icons.play_arrow_rounded),
          matching: find.byType(OutlinedButton),
        ),
      );

      await pumpScreen(tester, const HomeScreen(), phonePortrait);
      expect(find.text('Continue · Level 8 · 1:16:07'), findsOneWidget);
      final play = tester.getRect(find.text('PLAY'));
      expect(continueButton().top, greaterThan(play.bottom));
      expect(
        continueButton().bottom,
        lessThan(tester.getRect(find.text('Scoreboard')).top),
      );

      await pumpScreen(tester, const HomeScreen(), ipad13Landscape);
      final tagline = tester.getRect(
        find.text('Fill the grid, sharpen your mind'),
      );
      expect(continueButton().right, lessThan(688));
      expect(continueButton().top, greaterThan(tagline.bottom));
    });

    testWidgets('Continue leaves out the time with the timer off', (
      tester,
    ) async {
      await _saveUnfinishedGame();
      SettingsService.instance.timer = false;
      await pumpScreen(tester, const HomeScreen(), phonePortrait);
      expect(find.text('Continue · Level 8'), findsOneWidget);
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

    testWidgets('tablet in landscape: no app bar, the board gains its height', (
      tester,
    ) async {
      await pumpScreen(tester, const GameScreen(), ipad13Landscape);
      expect(find.byType(AppBar), findsNothing);
      final board = tester.getRect(find.byType(SudokuBoard));
      // The whole safe height (1032 - 24 - 20) minus the margins.
      expect(board.height, closeTo(1032 - 24 - 20 - 24, 1));
      // Back and Pause at the top of the panel, beside the board.
      final back = tester.getRect(find.byType(BackButton));
      final pause = tester.getRect(find.byIcon(Icons.pause_rounded));
      expect(back.left, greaterThan(board.right));
      expect(pause.left, greaterThan(back.right));
      expect(back.bottom, lessThan(tester.getRect(find.text('Level')).top));
    });

    testWidgets('tablet in portrait keeps the app bar', (tester) async {
      await pumpScreen(tester, const GameScreen(), ipad13Portrait);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('tablet in landscape: Back keeps the game for Continue', (
      tester,
    ) async {
      await pumpScreen(tester, const HomeScreen(), ipad13Landscape);
      await tester.tap(find.text('PLAY'));
      await tester.pumpAndSettle();
      await useHint(tester);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.byType(GameScreen), findsNothing);
      expect(find.textContaining('Continue · Level 1'), findsOneWidget);
    });

    testWidgets('left-handed: the keys on the left in landscape', (
      tester,
    ) async {
      SettingsService.instance.leftHanded = true;
      for (final window in [
        ipadMiniLandscape,
        ipad13Landscape,
        androidTabletLandscape,
        phoneLandscape,
      ]) {
        await pumpScreen(tester, const GameScreen(), window);
        final board = tester.getRect(find.byType(SudokuBoard));
        final pad = tester.getRect(find.byType(NumberPad));
        expect(pad.right, lessThan(board.left), reason: '${window.size}');
        expect(
          tester.getRect(find.byType(BackButton)).right,
          lessThan(board.left),
          reason: '${window.size}',
        );
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('left-handed: portrait keeps the keys below the board', (
      tester,
    ) async {
      SettingsService.instance.leftHanded = true;
      await pumpScreen(tester, const GameScreen(), ipad13Portrait);
      final board = tester.getRect(find.byType(SudokuBoard));
      expect(
        tester.getRect(find.byType(NumberPad)).top,
        greaterThan(board.bottom),
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

  group('coach card', () {
    testWidgets('its buttons stay in view in every game layout', (
      tester,
    ) async {
      for (final window in [
        smallPhone,
        phonePortrait,
        phoneLandscape,
        ipadMiniLandscape,
        ipad13Portrait,
        duoOuter,
        duoInnerLandscape,
        duoBook,
        duoLaptop,
      ]) {
        await pumpScreen(tester, const GameScreen(), window);
        await tester.tap(find.byIcon(Icons.lightbulb_outline));
        await tester.pumpAndSettle();
        final button = find.descendant(
          of: find.byType(CoachCard),
          matching: find.byType(ElevatedButton),
        );
        final bottom = window.size.height - window.padding.bottom;
        expect(
          tester.getRect(button).bottom,
          lessThanOrEqualTo(bottom),
          reason: '${window.size}',
        );
        await tester.pumpWidget(const SizedBox());
      }
    });
  });

  group('statistics', () {
    testWidgets('the switch shows the statistics of the level', (tester) async {
      await pumpScreen(tester, const ScoreboardScreen(), phonePortrait);
      expect(find.text('#4'), findsOneWidget);
      expect(find.text('Played'), findsNothing);

      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();
      expect(find.text('#4'), findsNothing);
      expect(find.text('120'), findsOneWidget); // played
      expect(find.text('1 · 1%'), findsOneWidget); // solved
      expect(find.text('1:16:07'), findsNWidgets(2)); // best and average
      expect(find.text('1 day'), findsNWidgets(2)); // both streaks
      expect(find.text('Reset statistics'), findsOneWidget);

      // Another level has nothing yet.
      await tester.tap(
        find.descendant(
          of: find.byType(LevelSelector),
          matching: find.text('2'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('–'), findsNWidgets(2));
    });

    testWidgets('landscape: the switch sits above the levels', (tester) async {
      await pumpScreen(
        tester,
        const ScoreboardScreen(showStatistics: true),
        ipad13Landscape,
      );
      final selector = tester.getRect(find.byType(LevelSelector));
      final switcher = tester.getRect(find.byType(SegmentedButton<bool>));
      expect(switcher.bottom, lessThan(selector.top));
      expect(tester.getRect(find.text('Played')).left, greaterThan(688));
    });

    testWidgets('Reset statistics asks, then clears them', (tester) async {
      await pumpScreen(
        tester,
        const ScoreboardScreen(showStatistics: true),
        phonePortrait,
      );
      await tester.tap(find.text('Reset statistics'));
      await tester.pumpAndSettle();
      expect(find.text('Reset the statistics?'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(StatisticsService.instance.isEmpty, isTrue);
      expect(find.text('Reset statistics'), findsNothing);
      expect(find.text('0 days'), findsNWidgets(2));
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

    testWidgets('the Left-handed switch saves the option', (tester) async {
      await pumpScreen(tester, const OptionsScreen(), ipad13Landscape);
      expect(SettingsService.instance.leftHanded, isFalse);
      await tester.tap(find.text('Left-handed'));
      await tester.pumpAndSettle();
      expect(SettingsService.instance.leftHanded, isTrue);
      await tester.tap(find.text('Restore defaults'));
      await tester.pumpAndSettle();
      expect(SettingsService.instance.leftHanded, isFalse);
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
