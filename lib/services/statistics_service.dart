import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Counters for one level.
class LevelStats {
  /// Games in which the player made at least one move.
  int started = 0;
  int solved = 0;

  /// Sum of the final times of the solved games, for the average.
  int totalSeconds = 0;

  /// Fastest final time, or null before the first win.
  int? bestSeconds;
  int solvedWithoutHints = 0;
  int solvedWithoutMistakes = 0;

  /// Average final time, or null before the first win.
  int? get averageSeconds => solved == 0 ? null : totalSeconds ~/ solved;

  /// Solved games as a share of the started ones, from 0 to 100, or null
  /// before the first game.
  int? get solvedPercent {
    if (started == 0) return null;
    final percent = (solved * 100 / started).round();
    // A game resumed from before the statistics existed was never counted
    // as started, so the share could pass 100.
    return percent > 100 ? 100 : percent;
  }

  bool get isEmpty => started == 0 && solved == 0;

  Map<String, Object?> toJson() => {
    'started': started,
    'solved': solved,
    'totalSeconds': totalSeconds,
    'bestSeconds': bestSeconds,
    'noHints': solvedWithoutHints,
    'noMistakes': solvedWithoutMistakes,
  };

  static LevelStats fromJson(Map<String, dynamic> json) {
    return LevelStats()
      ..started = json['started'] as int
      ..solved = json['solved'] as int
      ..totalSeconds = json['totalSeconds'] as int
      ..bestSeconds = json['bestSeconds'] as int?
      ..solvedWithoutHints = json['noHints'] as int
      ..solvedWithoutMistakes = json['noMistakes'] as int;
  }
}

/// Games played and solved per level, and the streak of days with a solved
/// puzzle. Persisted as one JSON value in shared_preferences.
class StatisticsService {
  StatisticsService._();
  static final instance = StatisticsService._();

  static const _key = 'statistics';

  /// Raised when the saved format changes; data in an older format is then
  /// dropped instead of being read wrongly.
  static const _version = 1;

  SharedPreferences? _prefs;

  /// Index 0 is level 1.
  List<LevelStats> _levels = _emptyLevels();

  /// The last day with a solved puzzle (a UTC date, time at midnight).
  DateTime? _lastSolvedDay;
  int _streak = 0;
  int _bestStreak = 0;

  static List<LevelStats> _emptyLevels() =>
      List.generate(9, (_) => LevelStats());

  /// Reads the stored statistics. Call once in `main()` before `runApp`.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _reset();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      if (data['version'] != _version) throw const FormatException('version');
      final levels = data['levels'] as List;
      if (levels.length != 9) throw const FormatException('levels');
      _levels = [
        for (final level in levels)
          LevelStats.fromJson(level as Map<String, dynamic>),
      ];
      final day = data['lastSolvedDay'] as String?;
      _lastSolvedDay = day == null ? null : DateTime.parse(day);
      _streak = data['streak'] as int;
      _bestStreak = data['bestStreak'] as int;
    } catch (_) {
      // Damaged or in an older format: start again rather than crash.
      _reset();
      await prefs.remove(_key);
    }
  }

  /// The counters of [level] (1 to 9).
  LevelStats levelStats(int level) => _levels[level - 1];

  bool get isEmpty => _levels.every((l) => l.isEmpty) && _bestStreak == 0;

  int get bestStreak => _bestStreak;

  /// Days in a row with a solved puzzle, up to [now]. It stays alive until
  /// the end of the day after the last win, so it isn't lost in the morning
  /// before the day's first puzzle is solved.
  int currentStreak(DateTime now) {
    final last = _lastSolvedDay;
    if (last == null) return 0;
    return _daysBetween(last, now) <= 1 ? _streak : 0;
  }

  /// Counts a game of [level] as started: called at the player's first move.
  Future<void> recordStart(int level) async {
    levelStats(level).started++;
    await _save();
  }

  /// Counts a solved game of [level] that took [seconds] (penalties
  /// included), and adds [now]'s date to the day streak.
  Future<void> recordWin(
    int level, {
    required int seconds,
    required int hints,
    required int mistakes,
    required DateTime now,
  }) async {
    final stats = levelStats(level);
    stats.solved++;
    stats.totalSeconds += seconds;
    final best = stats.bestSeconds;
    if (best == null || seconds < best) stats.bestSeconds = seconds;
    if (hints == 0) stats.solvedWithoutHints++;
    if (mistakes == 0) stats.solvedWithoutMistakes++;

    final today = _dateOf(now);
    final last = _lastSolvedDay;
    if (last == null || _daysBetween(last, now) > 1) {
      _streak = 1; // the first win, or the streak was broken
    } else if (_daysBetween(last, now) == 1) {
      _streak++; // the next day
    } // else: already counted today
    _lastSolvedDay = today;
    if (_streak > _bestStreak) _bestStreak = _streak;
    await _save();
  }

  Future<void> clear() async {
    _reset();
    await _prefs?.remove(_key);
  }

  void _reset() {
    _levels = _emptyLevels();
    _lastSolvedDay = null;
    _streak = 0;
    _bestStreak = 0;
  }

  Future<void> _save() async {
    await _prefs?.setString(
      _key,
      jsonEncode({
        'version': _version,
        'levels': [for (final level in _levels) level.toJson()],
        'lastSolvedDay': _lastSolvedDay?.toIso8601String(),
        'streak': _streak,
        'bestStreak': _bestStreak,
      }),
    );
  }

  /// The calendar date of [time] in local time, as a UTC midnight, so that
  /// day differences don't depend on daylight saving time.
  static DateTime _dateOf(DateTime time) =>
      DateTime.utc(time.year, time.month, time.day);

  /// Whole days from the date [day] to the local date of [now].
  static int _daysBetween(DateTime day, DateTime now) =>
      _dateOf(now).difference(day).inDays;
}
