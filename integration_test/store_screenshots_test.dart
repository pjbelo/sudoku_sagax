// Drives the app through the store-screenshot scenes, once per language.
// At each scene it prints `SHOT:<lang>_<name>` and holds still while
// tool/store/screenshots.sh captures the device screen (status bar included).
//
//   tool/store/screenshots.sh <iphone-6.3|ipad|duo-outer|...> [en,pt,...]
//
// The scenes play in the app's natural order, but their numbers set the
// order on the store page, which leads with the game: 1_game, 2_solved,
// 3_info, 4_home, 5_scoreboard, 6_options. Each scene name needs a caption
// in tool/store/screenshot_captions_test.dart.
//
// Landscape mode (--dart-define=LANDSCAPE=game,home, used by the
// ipad-landscape and duo-inner-landscape targets) plays the same run but
// captures only the listed scenes, as 7_landscape_game and 8_landscape_home,
// after the store pages' portrait screenshots. Before each language it waits
// until the device is turned to landscape (by hand, in DeviceHub).
//
// Firebase and audio are never initialised here, so nothing is logged to
// Analytics and the run is silent.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/main.dart';
import 'package:sudoku_sagax/services/lesson_service.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/services/statistics_service.dart';
import 'package:sudoku_sagax/widgets/level_selector.dart';
import 'package:sudoku_sagax/widgets/coach_card.dart';
import 'package:sudoku_sagax/widgets/number_pad.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';

const _langs = String.fromEnvironment('LANGS', defaultValue: 'en,pt,es,fr,de');

/// Scenes to capture in landscape mode; empty for the usual portrait run.
const _landscape = String.fromEnvironment('LANDSCAPE');

/// File number of each landscape scene, after the six portrait ones.
const _landscapeNumbers = {'game': 7, 'home': 8};

/// Level shown in the screenshots ("Easy · 38 clues").
const _level = 3;

/// Earlier results on the scoreboard, so it isn't empty. The game solved
/// during the run is faster and lands on top as the new best time.
const _seededScores = [
  (seconds: 221, hints: 0, mistakes: 0, day: 2),
  (seconds: 252, hints: 0, mistakes: 1, day: 5),
  (seconds: 327, hints: 1, mistakes: 0, day: 3),
  (seconds: 365, hints: 0, mistakes: 2, day: 6),
  (seconds: 496, hints: 2, mistakes: 1, day: 1),
];

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  GoogleFonts.config.allowRuntimeFetching = false;

  for (final lang in _langs.split(',')) {
    testWidgets('store screenshots $lang', (tester) async {
      await _resetState(lang);
      await tester.pumpWidget(const SudokuSagaxApp());
      await tester.pumpAndSettle();
      if (_landscape.isNotEmpty) await _waitForLandscape(tester);

      // 1. Home, with a mid level selected.
      await tester.tap(
        find.descendant(
          of: find.byType(LevelSelector),
          matching: find.text('$_level'),
        ),
      );
      await _shot(tester, lang, '4_home');

      // 2. A game in progress: entries, a hint, notes and highlights.
      await tester.tap(find.byType(ElevatedButton)); // PLAY
      await tester.pumpAndSettle();
      final game = tester.widget<SudokuBoard>(find.byType(SudokuBoard)).game;
      final empty = [
        for (int i = 0; i < 81; i++)
          if (game.values[i] == 0) i,
      ];
      for (final i in empty.where((i) => i < 36).take(12)) {
        await _enter(tester, i, game.solution[i]);
      }
      // A hint through the coach: Show me, Apply, OK.
      await tester.tap(find.byIcon(Icons.lightbulb_outline));
      await tester.pumpAndSettle();
      for (int stage = 0; stage < 3; stage++) {
        await tester.tap(
          find.descendant(
            of: find.byType(CoachCard),
            matching: find.byType(ElevatedButton),
          ),
        );
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byIcon(Icons.edit_outlined)); // notes on
      await tester.pumpAndSettle();
      for (final i in empty.where((i) => i >= 45).take(4)) {
        for (final d in _candidates(game, i)) {
          await _enter(tester, i, d);
        }
      }
      await tester.tap(find.byIcon(Icons.edit)); // notes off
      await tester.pumpAndSettle();
      // Select a filled cell so its row, column, box and digit light up.
      final focus = empty.firstWhere(
        (i) => i >= 27 && i < 45 && game.values[i] == 0,
      );
      await _enter(tester, focus, game.solution[focus]);
      await _shot(tester, lang, '1_game');

      // 3. Solved grid with the Congratulations bar. Let the clock run first
      // so the final time looks like a person's, not a robot's.
      await Future<void>.delayed(const Duration(seconds: 80));
      for (int i = 0; i < 81; i++) {
        if (!game.isLocked(i) && game.values[i] != game.solution[i]) {
          await _enter(tester, i, game.solution[i]);
        }
      }
      await _shot(tester, lang, '2_solved');

      // Win summary → back to the menu.
      await tester.tap(find.byType(ElevatedButton)); // OK
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextButton).last); // Back to Menu
      await tester.pumpAndSettle();

      // 4. Scoreboard with the new best time on top.
      await tester.tap(find.byIcon(Icons.emoji_events_outlined));
      await _shot(tester, lang, '5_scoreboard');
      await tester.tap(
        find.byType(BackButton),
      ); // not pageBack(): its tooltip is localised
      await tester.pumpAndSettle();

      // 5. Options.
      await tester.tap(find.byIcon(Icons.tune));
      await _shot(tester, lang, '6_options');
      await tester.tap(
        find.byType(BackButton),
      ); // not pageBack(): its tooltip is localised
      await tester.pumpAndSettle();

      // 6. Info: how to play and brain benefits.
      await tester.tap(find.byIcon(Icons.info_outline));
      await _shot(tester, lang, '3_info');
    });
  }
}

/// Fresh options (defaults), the language under test and a seeded scoreboard.
Future<void> _resetState(String lang) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await SettingsService.instance.load();
  SettingsService.instance.locale = Locale(lang);
  await ScoreboardService.instance.load();
  await SavedGameService.instance.load();
  await StatisticsService.instance.load();
  // No lesson suggestion over the game.
  await LessonService.instance.load();
  for (int level = 1; level <= 9; level++) {
    await LessonService.instance.markSuggested(level);
  }
  for (final s in _seededScores) {
    await ScoreboardService.instance.add(
      _level,
      ScoreEntry(
        seconds: s.seconds,
        hints: s.hints,
        mistakes: s.mistakes,
        date: DateTime(2026, 10, s.day, 21, 15),
      ),
    );
  }
}

/// Taps cell [i] on the board, then [digit] on the number pad.
Future<void> _enter(WidgetTester tester, int i, int digit) async {
  final board = tester.getRect(find.byType(SudokuBoard));
  final cell = (board.width - 4) / 9;
  await tester.tapAt(
    board.topLeft +
        Offset(2 + cell * (colOf(i) + 0.5), 2 + cell * (rowOf(i) + 0.5)),
  );
  await tester.pump();
  await tester.tap(
    find.descendant(
      of: find.byType(NumberPad),
      matching: find.byWidgetPredicate(
        (w) =>
            w is Text &&
            w.data == '$digit' &&
            (w.style?.fontFamily ?? '').startsWith('Exo2'), // not the count
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 50));
}

/// Plausible pencil marks for cell [i]: the answer plus up to two other
/// digits not yet placed in its row, column or box.
List<int> _candidates(SudokuGame game, int i) {
  final used = {for (final p in peers[i]) game.values[p]};
  final others = [
    for (int d = 1; d <= 9; d++)
      if (d != game.solution[i] && !used.contains(d)) d,
  ];
  return [game.solution[i], ...others.take(2)]..sort();
}

/// Settles the UI, announces the scene and holds still for the capture. In
/// landscape mode, scenes that aren't listed are only settled.
Future<void> _shot(WidgetTester tester, String lang, String name) async {
  await tester.pumpAndSettle();
  final scene = name.substring(name.indexOf('_') + 1); // '1_game' -> 'game'
  if (_landscape.isNotEmpty) {
    if (!_landscape.split(',').contains(scene)) return;
    name = '${_landscapeNumbers[scene]}_landscape_$scene';
  }
  // Let tap indicators fade and the last animations finish.
  await Future<void>.delayed(const Duration(milliseconds: 1500));
  await tester.pumpAndSettle();
  // ignore: avoid_print
  print('SHOT:${lang}_$name');
  await Future<void>.delayed(const Duration(seconds: 3));
}

/// Waits until the device is in landscape, which is set by hand: simctl
/// can't rotate a simulator. Prints WAITING_FOR_LANDSCAPE once, which the
/// script relays.
Future<void> _waitForLandscape(WidgetTester tester) async {
  bool isLandscape() {
    final size = tester.view.physicalSize;
    return size.width > size.height;
  }

  if (isLandscape()) return;
  // ignore: avoid_print
  print('WAITING_FOR_LANDSCAPE');
  for (int second = 0; second < 600; second++) {
    await Future<void>.delayed(const Duration(seconds: 1));
    await tester.pump();
    if (isLandscape()) {
      // Let the rotation animation and the new layout settle.
      await Future<void>.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      return;
    }
  }
  fail('The device was not turned to landscape within 10 minutes');
}
