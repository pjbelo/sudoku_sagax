import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// The daily puzzles solved, by date, with their times; and the daily
/// streak worked out from them. Persisted with shared_preferences.
class DailyService {
  DailyService._();
  static final instance = DailyService._();

  static const _key = 'daily_solved';

  SharedPreferences? _prefs;

  /// Date key ("2026-11-17") → final time in seconds.
  final Map<String, int> _solved = {};

  /// Reads the stored days. Call once in `main()` before `runApp`.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _solved.clear();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      data.forEach((day, seconds) => _solved[day] = seconds as int);
    } catch (_) {
      // Damaged: start again rather than crash.
      _solved.clear();
      await prefs.remove(_key);
    }
  }

  /// "2026-11-17" for the local date of [day].
  static String keyOf(DateTime day) =>
      '${day.year}-${'${day.month}'.padLeft(2, '0')}-'
      '${'${day.day}'.padLeft(2, '0')}';

  bool isSolved(DateTime day) => _solved.containsKey(keyOf(day));

  /// The final time of [day]'s puzzle, or null when it isn't solved.
  int? secondsFor(DateTime day) => _solved[keyOf(day)];

  Future<void> recordSolved(DateTime day, int seconds) async {
    // The first time counts: a day can't be solved twice.
    _solved.putIfAbsent(keyOf(day), () => seconds);
    await _prefs?.setString(_key, jsonEncode(_solved));
  }

  /// Daily puzzles solved on the days in a row up to [now]. Today's puzzle
  /// not solved yet doesn't break it: it counts from yesterday then.
  int currentStreak(DateTime now) {
    var day = DateTime(now.year, now.month, now.day);
    if (!isSolved(day)) day = _previous(day);
    var streak = 0;
    while (isSolved(day)) {
      streak++;
      day = _previous(day);
    }
    return streak;
  }

  /// The longest run of days in a row with the daily puzzle solved.
  int get bestStreak {
    var best = 0;
    for (final key in _solved.keys) {
      final day = DateTime.parse(key);
      // Count each run once, from its first day.
      if (isSolved(_previous(day))) continue;
      var length = 0;
      var next = day;
      while (isSolved(next)) {
        length++;
        next = DateTime(next.year, next.month, next.day + 1);
      }
      if (length > best) best = length;
    }
    return best;
  }

  /// The day before [day]. Built from the calendar date, so a clock change
  /// can't make it skip or repeat a day.
  static DateTime _previous(DateTime day) =>
      DateTime(day.year, day.month, day.day - 1);
}
