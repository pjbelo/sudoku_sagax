import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../game/sudoku_game.dart';

/// A game left unfinished, with its clock.
class SavedGame {
  const SavedGame({required this.game, required this.seconds});

  final SudokuGame game;

  /// Elapsed play time, hint penalties included.
  final int seconds;

  int get level => game.puzzle.level;
}

/// Keeps the game in progress on the device, so the player can leave the
/// game screen, or have the app closed, and continue later. There is one
/// saved game at most, stored as JSON in shared_preferences.
class SavedGameService {
  SavedGameService._();
  static final instance = SavedGameService._();

  static const _key = 'saved_game';

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
      );
    } catch (_) {
      return null;
    }
  }

  /// Replaces the saved game with [game] and its clock.
  Future<void> save(SudokuGame game, int seconds) async {
    final json = jsonEncode({
      'version': _version,
      'game': game.toJson(),
      'seconds': seconds,
    });
    _json = json;
    await _prefs?.setString(_key, json);
  }

  Future<void> clear() async {
    _json = null;
    await _prefs?.remove(_key);
  }
}
