import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// One solved game on the scoreboard.
class ScoreEntry {
  const ScoreEntry({
    required this.seconds,
    required this.hints,
    required this.mistakes,
    required this.date,
  });

  /// Final time, hint penalties included.
  final int seconds;
  final int hints;
  final int mistakes;
  final DateTime date;

  Map<String, Object> toJson() => {
    's': seconds,
    'h': hints,
    'm': mistakes,
    'd': date.millisecondsSinceEpoch,
  };

  factory ScoreEntry.fromJson(Map<String, dynamic> json) => ScoreEntry(
    seconds: json['s'] as int,
    hints: json['h'] as int,
    mistakes: json['m'] as int,
    date: DateTime.fromMillisecondsSinceEpoch(json['d'] as int),
  );

  /// Ranking order: faster first, then fewer hints, fewer mistakes, earlier.
  static int compare(ScoreEntry a, ScoreEntry b) {
    var c = a.seconds.compareTo(b.seconds);
    if (c != 0) return c;
    c = a.hints.compareTo(b.hints);
    if (c != 0) return c;
    c = a.mistakes.compareTo(b.mistakes);
    if (c != 0) return c;
    return a.date.compareTo(b.date);
  }
}

/// Best times per level (top [maxEntries]), persisted with shared_preferences.
class ScoreboardService {
  ScoreboardService._();
  static final instance = ScoreboardService._();

  static const maxEntries = 10;
  static const _keyPrefix = 'scores_level_';

  SharedPreferences? _prefs;
  final Map<int, List<ScoreEntry>> _scores = {};

  /// Reads the stored scores. Call once in `main()` before `runApp`.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _scores.clear();
    for (int level = 1; level <= 9; level++) {
      final raw = prefs.getString('$_keyPrefix$level');
      if (raw == null) continue;
      try {
        final list = (jsonDecode(raw) as List)
            .map((e) => ScoreEntry.fromJson(e as Map<String, dynamic>))
            .toList();
        _scores[level] = list..sort(ScoreEntry.compare);
      } catch (_) {
        // Corrupt entry: drop it rather than crash on startup.
        await prefs.remove('$_keyPrefix$level');
      }
    }
  }

  List<ScoreEntry> scoresFor(int level) =>
      List.unmodifiable(_scores[level] ?? const []);

  bool get isEmpty => _scores.values.every((l) => l.isEmpty);

  /// Records a solved game. Returns its 1-based rank, or null when it
  /// didn't make the top [maxEntries].
  Future<int?> add(int level, ScoreEntry entry) async {
    final list = [...?_scores[level], entry]..sort(ScoreEntry.compare);
    final rank = list.indexOf(entry) + 1;
    final kept = list.take(maxEntries).toList();
    _scores[level] = kept;
    await _save(level);
    return rank <= maxEntries ? rank : null;
  }

  Future<void> clear() async {
    _scores.clear();
    for (int level = 1; level <= 9; level++) {
      await _prefs?.remove('$_keyPrefix$level');
    }
  }

  Future<void> _save(int level) async {
    final list = _scores[level] ?? const [];
    await _prefs?.setString(
      '$_keyPrefix$level',
      jsonEncode([for (final e in list) e.toJson()]),
    );
  }
}
