// Plays the scripted session for the store preview video (App Store app
// preview / Google Play promo video), in one language.
//
//   tool/store/video.sh <iphone|ipad> [en,pt,...]
//
// The script records the simulator screen while this test runs. The test
// prints timed cues, `CUE:<ms>:<event>`, where <ms> is measured from the
// first cue:
//
//   ready              app settled; the script starts recording now
//   start / end        the part of the recording that goes into the video
//   sync               first change on screen after the still pre-roll; lines
//                      the cues up with the recording's frame timestamps
//   scene:<n>          caption <n> (tool/store/video_captions_test.dart)
//   cut_out / cut_in   jump cut: most of the grid is filled in between
//   sfx:<asset>:<vol>  a sound the app would play at this moment
//
// Firebase and audio are never initialised, so the run is silent and logs
// nothing; tool/store/compose_video.dart adds the app's music and sounds back
// from the sfx cues, with the same volumes as the app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/main.dart';
import 'package:sudoku_sagax/services/audio_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/widgets/level_selector.dart';
import 'package:sudoku_sagax/widgets/number_pad.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';

const _lang = String.fromEnvironment('LANG', defaultValue: 'en');

/// Level played in the video ("Easy · 38 clues"), as in the screenshots.
const _level = 3;

/// Earlier results, so the solve in the video lands on top as a new best.
const _seededScores = [
  (seconds: 221, hints: 0, mistakes: 0, day: 2),
  (seconds: 252, hints: 0, mistakes: 1, day: 5),
  (seconds: 327, hints: 1, mistakes: 0, day: 3),
  (seconds: 365, hints: 0, mistakes: 2, day: 6),
  (seconds: 496, hints: 2, mistakes: 1, day: 1),
];

final _clock = Stopwatch();

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  // Taps are sent as device input (see _tapAt), which the binding passes to
  // the app without drawing its debug crosshairs over the footage.
  binding.shouldPropagateDevicePointerEvents = true;
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('store video $_lang', (tester) async {
    await _resetState(_lang);
    await tester.pumpWidget(const SudokuSagaxApp());
    await tester.pumpAndSettle();
    await _wait(1000);

    // Pre-roll: the screen stays still while the recorder starts, so the
    // first level tap is the first new frame in the recording.
    _clock.start();
    _cue('ready');
    await _wait(5000);

    // 1. Home: logo and tagline.
    _cue('start');
    _cue('scene:1');
    await _wait(2000);

    // 2. The nine levels, then back to the one we play.
    _cue('sync');
    _cue('scene:2');
    for (final level in [2, 3, 4, 5, 6, 7, 8, 9, _level]) {
      _sfx(AudioService.levelSelectSfx, 0.75);
      await _tap(
        tester,
        find.descendant(
          of: find.byType(LevelSelector),
          matching: find.text('$level'),
        ),
      );
      await tester.pump();
      await _wait(level == _level ? 600 : 260);
    }

    // 3. Play: a few entries at a person's pace.
    _sfx(AudioService.buttonSfx, 0.85);
    await _tap(tester, find.byType(ElevatedButton)); // PLAY
    await tester.pumpAndSettle();
    _cue('scene:3');
    await _wait(300);
    final game = tester.widget<SudokuBoard>(find.byType(SudokuBoard)).game;
    final empty = [
      for (int i = 0; i < 81; i++)
        if (game.values[i] == 0) i,
    ];
    for (final i in empty.where((i) => i < 36).take(7)) {
      await _enter(tester, i, game.solution[i], pace: 460);
    }

    // 4. Notes: pencil marks in three cells.
    _cue('scene:4');
    _sfx(AudioService.buttonSfx, 0.7);
    await _tap(tester, find.byIcon(Icons.edit_outlined)); // notes on
    await tester.pump();
    await _wait(350);
    for (final i in empty.where((i) => i >= 45).take(3)) {
      await _tapCell(tester, i);
      await _wait(200);
      for (final d in _candidates(game, i)) {
        _sfx(AudioService.digitSfx, 0.5);
        await _tapDigit(tester, d);
        await _wait(230);
      }
    }
    _sfx(AudioService.buttonSfx, 0.7);
    await _tap(tester, find.byIcon(Icons.edit)); // notes off
    await tester.pump();
    await _wait(400);

    // 5. A hint, on an empty cell in the middle band.
    _cue('scene:5');
    await _tapCell(tester, empty.firstWhere((i) => i >= 36 && i < 45));
    await _wait(300);
    _sfx(AudioService.hintSfx, 0.85);
    await _tap(tester, find.byIcon(Icons.lightbulb_outline));
    await tester.pump();
    await _wait(1400);
    _cue('cut_out');

    // Off camera: fill all but the last three cells, and let the clock run
    // so the final time looks like a person's (as in the screenshots).
    final rest = [
      for (int i = 0; i < 81; i++)
        if (!game.isLocked(i) && game.values[i] != game.solution[i]) i,
    ];
    final last = rest.sublist(rest.length - 3);
    for (final i in rest.take(rest.length - 3)) {
      await _enter(tester, i, game.solution[i], pace: 40, sound: false);
    }
    await _wait(70000);
    await _tapCell(tester, last.first);
    await _wait(800);
    _cue('cut_in');

    // 6. The last entries and the win.
    _cue('scene:6');
    await _wait(300);
    for (final i in last) {
      await _enter(tester, i, game.solution[i], pace: 480);
    }
    _sfx(AudioService.winSfx, 0.9);
    await tester.pumpAndSettle();
    await _wait(1300);

    // 7. Summary with the new best time, then the scoreboard.
    _cue('scene:7');
    _sfx(AudioService.buttonSfx, 0.85);
    await _tap(tester, find.byType(ElevatedButton)); // OK
    await tester.pumpAndSettle();
    await _wait(2000);
    _sfx(AudioService.buttonSfx, 0.85);
    await _tap(tester, find.byType(TextButton).last); // Back to Menu
    await tester.pumpAndSettle();
    await _wait(400);
    _sfx(AudioService.buttonSfx, 0.85);
    await _tap(tester, find.byIcon(Icons.emoji_events_outlined));
    await tester.pumpAndSettle();
    await _wait(1900);

    // 8. Back home to close on the logo.
    _cue('scene:8');
    _sfx(AudioService.buttonSfx, 0.85);
    await _tap(
      tester,
      find.byType(BackButton),
    ); // not pageBack(): its tooltip is localised
    await tester.pumpAndSettle();
    await _wait(2600);
    _cue('end');
    await _wait(1500);
  });
}

/// Fresh options (defaults), the language and a seeded scoreboard.
Future<void> _resetState(String lang) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await SettingsService.instance.load();
  SettingsService.instance.locale = Locale(lang);
  await ScoreboardService.instance.load();
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

void _cue(String event) {
  // ignore: avoid_print
  print('CUE:${_clock.elapsedMilliseconds}:$event');
}

void _sfx(String asset, double volume) => _cue('sfx:$asset:$volume');

Future<void> _wait(int ms) => Future<void>.delayed(Duration(milliseconds: ms));

int _pointer = 1;

/// Taps at [position] as device input, so no crosshair is drawn.
Future<void> _tapAt(WidgetTester tester, Offset position) async {
  final binding = tester.binding as LiveTestWidgetsFlutterBinding;
  final pointer = _pointer++;
  binding.handlePointerEventForSource(
    PointerDownEvent(pointer: pointer, position: position),
    source: TestBindingEventSource.device,
  );
  await _wait(30);
  binding.handlePointerEventForSource(
    PointerUpEvent(pointer: pointer, position: position),
    source: TestBindingEventSource.device,
  );
  await tester.pump();
}

Future<void> _tap(WidgetTester tester, Finder finder) =>
    _tapAt(tester, tester.getCenter(finder));

Future<void> _tapCell(WidgetTester tester, int i) async {
  final board = tester.getRect(find.byType(SudokuBoard));
  final cell = (board.width - 4) / 9;
  await _tapAt(
    tester,
    board.topLeft +
        Offset(2 + cell * (colOf(i) + 0.5), 2 + cell * (rowOf(i) + 0.5)),
  );
}

Future<void> _tapDigit(WidgetTester tester, int digit) async {
  await _tap(
    tester,
    find.descendant(
      of: find.byType(NumberPad),
      matching: find.byWidgetPredicate(
        (w) => w is Text && w.data == '$digit' && (w.style?.fontSize ?? 0) > 14,
      ),
    ),
  );
  await tester.pump();
}

/// Taps cell [i], then [digit], spending about [pace] ms in all.
Future<void> _enter(
  WidgetTester tester,
  int i,
  int digit, {
  required int pace,
  bool sound = true,
}) async {
  await _tapCell(tester, i);
  await _wait(pace * 2 ~/ 5);
  if (sound) _sfx(AudioService.digitSfx, 0.8);
  await _tapDigit(tester, digit);
  await _wait(pace * 3 ~/ 5);
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
