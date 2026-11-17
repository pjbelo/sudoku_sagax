import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/services/saved_game_service.dart';
import 'package:sudoku_sagax/services/scoreboard_service.dart';
import 'package:sudoku_sagax/services/settings_service.dart';

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
}
