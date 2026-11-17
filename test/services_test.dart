import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';
import 'package:sudoku_sagax/services/statistics_service.dart';

ScoreEntry entry(int seconds, {int hints = 0, int day = 1}) => ScoreEntry(
  seconds: seconds,
  hints: hints,
  mistakes: 0,
  date: DateTime(2026, 1, day),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsService', () {
    test('defaults: sound ON, timer ON, show errors OFF, hints ON, '
        'left-handed OFF', () async {
      SharedPreferences.setMockInitialValues({});
      final s = SettingsService.instance;
      await s.load();
      expect(s.sound, isTrue);
      expect(s.timer, isTrue);
      expect(s.showErrors, isFalse);
      expect(s.hints, isTrue);
      expect(s.leftHanded, isFalse);
      expect(s.isDefault, isTrue);
      expect(s.locale, isNull);
    });

    test('changes persist and restoreDefaults resets', () async {
      SharedPreferences.setMockInitialValues({});
      final s = SettingsService.instance;
      await s.load();
      s.sound = false;
      s.showErrors = true;
      s.leftHanded = true;
      s.locale = const Locale('pt');

      await s.load(); // read back from storage
      expect(s.sound, isFalse);
      expect(s.showErrors, isTrue);
      expect(s.leftHanded, isTrue);
      expect(s.locale, const Locale('pt'));
      expect(s.isDefault, isFalse);

      s.restoreDefaults();
      await s.load();
      expect(s.isDefault, isTrue);
      expect(s.leftHanded, isFalse);
    });
  });

  group('ScoreboardService', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await ScoreboardService.instance.load();
    });

    test('ranks by time, then hints', () async {
      final sb = ScoreboardService.instance;
      expect(await sb.add(1, entry(300)), 1);
      expect(await sb.add(1, entry(200)), 1);
      expect(await sb.add(1, entry(200, hints: 2)), 2);
      expect(await sb.add(1, entry(500)), 4);
      expect(sb.scoresFor(1).map((e) => e.seconds), [200, 200, 300, 500]);
      expect(sb.scoresFor(2), isEmpty);
    });

    test('keeps only the top 10 per level', () async {
      final sb = ScoreboardService.instance;
      for (int s = 1; s <= ScoreboardService.maxEntries; s++) {
        await sb.add(4, entry(s * 10));
      }
      expect(await sb.add(4, entry(999)), isNull);
      expect(await sb.add(4, entry(5)), 1);
      expect(sb.scoresFor(4), hasLength(ScoreboardService.maxEntries));
      expect(sb.scoresFor(4).last.seconds, 90);
    });

    test('persists and clears', () async {
      final sb = ScoreboardService.instance;
      await sb.add(9, entry(1234, day: 5));
      await sb.load();
      expect(sb.scoresFor(9).single.seconds, 1234);
      expect(sb.scoresFor(9).single.date, DateTime(2026, 1, 5));

      await sb.clear();
      await sb.load();
      expect(sb.isEmpty, isTrue);
    });

    test('corrupt data is dropped instead of crashing', () async {
      SharedPreferences.setMockInitialValues({'scores_level_3': 'not json'});
      await ScoreboardService.instance.load();
      expect(ScoreboardService.instance.scoresFor(3), isEmpty);
    });
  });

  group('SavedGameService', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SavedGameService.instance.load();
    });

    test('none at first', () {
      expect(SavedGameService.instance.hasSavedGame, isFalse);
      expect(SavedGameService.instance.savedGame, isNull);
    });

    test('saves, reads back from storage and clears', () async {
      final service = SavedGameService.instance;
      final game = SudokuGame(generatePuzzle(5, seed: 3));
      final cell = game.values.indexOf(0);
      game.enterDigit(cell, game.solution[cell]);
      await service.save(game, 125);

      await service.load(); // read back from storage
      final saved = service.savedGame!;
      expect(saved.level, 5);
      expect(saved.seconds, 125);
      expect(saved.game.values, game.values);

      // Each read is a new copy: playing it leaves the saved game alone.
      saved.game.erase(cell);
      expect(service.savedGame!.game.values[cell], game.solution[cell]);

      await service.clear();
      await service.load();
      expect(service.hasSavedGame, isFalse);
    });

    test('damaged or old-format data is dropped instead of crashing', () async {
      for (final raw in ['not json', '{"version": 0, "seconds": 3}']) {
        SharedPreferences.setMockInitialValues({'saved_game': raw});
        await SavedGameService.instance.load();
        expect(SavedGameService.instance.hasSavedGame, isFalse);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('saved_game'), isNull);
      }
    });
  });

  group('StatisticsService', () {
    final stats = StatisticsService.instance;
    DateTime day(int d, [int hour = 12]) => DateTime(2026, 3, d, hour);

    Future<void> win(int level, int seconds, DateTime now, {int hints = 0}) =>
        stats.recordWin(
          level,
          seconds: seconds,
          hints: hints,
          mistakes: seconds.isOdd ? 1 : 0,
          now: now,
        );

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await stats.load();
    });

    test('empty at first', () {
      expect(stats.isEmpty, isTrue);
      final level = stats.levelStats(1);
      expect(level.started, 0);
      expect(level.bestSeconds, isNull);
      expect(level.averageSeconds, isNull);
      expect(level.solvedPercent, isNull);
      expect(stats.currentStreak(day(1)), 0);
    });

    test('counts games, times, hints and mistakes per level', () async {
      for (int i = 0; i < 4; i++) {
        await stats.recordStart(3);
      }
      await win(3, 300, day(1));
      await win(3, 201, day(1), hints: 2); // odd: one mistake
      await win(3, 240, day(1));

      final level = stats.levelStats(3);
      expect(level.started, 4);
      expect(level.solved, 3);
      expect(level.solvedPercent, 75);
      expect(level.bestSeconds, 201);
      expect(level.averageSeconds, 247);
      expect(level.solvedWithoutHints, 2);
      expect(level.solvedWithoutMistakes, 2);
      expect(stats.levelStats(4).isEmpty, isTrue);
    });

    test('the solved share never passes 100%', () async {
      await win(2, 100, day(1)); // a game resumed from before the update
      expect(stats.levelStats(2).solvedPercent, isNull);
      await stats.recordStart(2);
      await win(2, 100, day(1));
      expect(stats.levelStats(2).solvedPercent, 100);
    });

    test('day streak: next days add up, a missed day starts again', () async {
      await win(1, 100, day(1, 23));
      await win(1, 100, day(1, 8)); // same day: counted once
      expect(stats.currentStreak(day(1)), 1);
      await win(1, 100, day(2, 0));
      await win(1, 100, day(3, 22));
      expect(stats.currentStreak(day(3)), 3);
      // Still alive the next day, before that day's first win.
      expect(stats.currentStreak(day(4, 7)), 3);
      // A whole day missed: broken.
      expect(stats.currentStreak(day(5)), 0);

      await win(1, 100, day(6));
      expect(stats.currentStreak(day(6)), 1);
      expect(stats.bestStreak, 3);
    });

    test('day streak across a month end and a clock change', () async {
      // Europe changes the clocks on the last Sunday of March (the 29th).
      await win(1, 100, DateTime(2026, 3, 28, 23, 30));
      await win(1, 100, DateTime(2026, 3, 29, 0, 30));
      await win(1, 100, DateTime(2026, 3, 30, 9));
      await win(1, 100, DateTime(2026, 3, 31, 9));
      await win(1, 100, DateTime(2026, 4, 1, 9));
      expect(stats.currentStreak(DateTime(2026, 4, 1, 20)), 5);
    });

    test('persists and clears', () async {
      await stats.recordStart(9);
      await win(9, 1234, day(1));
      await stats.load(); // read back from storage
      expect(stats.levelStats(9).started, 1);
      expect(stats.levelStats(9).bestSeconds, 1234);
      expect(stats.currentStreak(day(2)), 1);
      expect(stats.bestStreak, 1);

      await stats.clear();
      await stats.load();
      expect(stats.isEmpty, isTrue);
      expect(stats.currentStreak(day(1)), 0);
    });

    test('damaged or old-format data is dropped instead of crashing', () async {
      for (final raw in ['not json', '{"version": 0}', '{"version": 1}']) {
        SharedPreferences.setMockInitialValues({'statistics': raw});
        await stats.load();
        expect(stats.isEmpty, isTrue);
        final prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('statistics'), isNull);
      }
    });
  });
}
