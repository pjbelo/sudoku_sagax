import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../game/game_review.dart';
import '../game/sudoku_game.dart';

/// A game left unfinished, with its clock.
class SavedGame {
  const SavedGame({
    required this.game,
    required this.seconds,
    this.events = const [],
    this.shared = false,
  });

  final SudokuGame game;

  /// Elapsed play time, hint penalties included.
  final int seconds;

  /// The hints and mistakes so far, for the review after the win.
  final List<ReviewEvent> events;

  /// A puzzle opened from a friend's code: it stays off the scoreboard and
  /// Game Center.
  final bool shared;

  int get level => game.puzzle.level;
}

/// Keeps the game in progress on the device, so the player can leave the
/// game screen, or have the app closed, and continue later. Each instance
/// keeps one saved game, stored as JSON in shared_preferences: [instance]
/// for the levels (Continue on the home screen), [daily] for the daily
/// puzzle, so one doesn't replace the other.
class SavedGameService {
  SavedGameService._(this._key);
  static final instance = SavedGameService._('saved_game');
  static final daily = SavedGameService._('saved_daily');

  final String _key;

  /// Raised when the saved format changes; saves in an older format are
  /// then dropped instead of being read wrongly.
  static const _version = 1;

  SharedPreferences? _prefs;

  /// The saved game as JSON, or null when there is none.
  String? _json;

  /// Reads the saved game. Call once in `main()` before `runApp`.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _json = prefs.getString(_key);
    if (_json != null && savedGame == null) {
      // Damaged or in an older format: drop it rather than crash.
      _json = null;
      await prefs.remove(_key);
    }
  }

  bool get hasSavedGame => _json != null;

  /// A new copy of the saved game, or null when there is none. Playing the
  /// copy leaves the saved game as it is until the next [save].
  SavedGame? get savedGame {
    final json = _json;
    if (json == null) return null;
    try {
      final data = jsonDecode(json) as Map<String, dynamic>;
      if (data['version'] != _version) return null;
      return SavedGame(
        game: SudokuGame.fromJson(data['game'] as Map<String, dynamic>),
        seconds: data['seconds'] as int,
        // Saves from before the review have no events.
        events: [
          for (final e in data['events'] as List? ?? const [])
            ReviewEvent.fromJson(e as Map<String, dynamic>),
        ],
        // Saves from before shared puzzles have no flag.
        shared: data['shared'] as bool? ?? false,
      );
    } catch (_) {
      return null;
    }
  }

  /// Replaces the saved game with [game], its clock, its review [events]
  /// and whether it is a [shared] puzzle.
  Future<void> save(
    SudokuGame game,
    int seconds, {
    List<ReviewEvent> events = const [],
    bool shared = false,
  }) async {
    final json = jsonEncode({
      'version': _version,
      'game': game.toJson(),
      'seconds': seconds,
      'events': [for (final e in events) e.toJson()],
      'shared': shared,
    });
    _json = json;
    await _prefs?.setString(_key, json);
  }

  Future<void> clear() async {
    _json = null;
    await _prefs?.remove(_key);
  }
}
