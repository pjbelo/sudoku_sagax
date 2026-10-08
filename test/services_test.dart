import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    test('defaults: sound ON, timer ON, show errors OFF, hints ON', () async {
      SharedPreferences.setMockInitialValues({});
      final s = SettingsService.instance;
      await s.load();
      expect(s.sound, isTrue);
      expect(s.timer, isTrue);
      expect(s.showErrors, isFalse);
      expect(s.hints, isTrue);
      expect(s.isDefault, isTrue);
      expect(s.locale, isNull);
    });

    test('changes persist and restoreDefaults resets', () async {
      SharedPreferences.setMockInitialValues({});
      final s = SettingsService.instance;
      await s.load();
      s.sound = false;
      s.showErrors = true;
      s.locale = const Locale('pt');

      await s.load(); // read back from storage
      expect(s.sound, isFalse);
      expect(s.showErrors, isTrue);
      expect(s.locale, const Locale('pt'));
      expect(s.isDefault, isFalse);

      s.restoreDefaults();
      await s.load();
      expect(s.isDefault, isTrue);
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
}
