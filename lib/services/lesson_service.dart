import 'package:shared_preferences/shared_preferences.dart';

import '../game/logic_coach.dart';

/// The lessons the player has finished, and the levels that have already
/// suggested their lesson (each does it once, the first time it is played).
/// Persisted with shared_preferences.
class LessonService {
  LessonService._();
  static final instance = LessonService._();

  static const _doneKey = 'lessons_done';
  static const _suggestedKey = 'lessons_suggested';

  SharedPreferences? _prefs;
  final Set<CoachTechnique> _done = {};
  final Set<int> _suggested = {};

  /// Reads the stored progress. Call once in `main()` before `runApp`.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _done.clear();
    _suggested.clear();
    for (final name in prefs.getStringList(_doneKey) ?? const <String>[]) {
      // An unknown name (from a later version) is skipped.
      for (final technique in CoachTechnique.values) {
        if (technique.name == name) _done.add(technique);
      }
    }
    for (final level in prefs.getStringList(_suggestedKey) ?? const []) {
      final number = int.tryParse(level);
      if (number != null) _suggested.add(number);
    }
  }

  bool isDone(CoachTechnique technique) => _done.contains(technique);

  /// Whether [level] has already suggested its lesson.
  bool wasSuggested(int level) => _suggested.contains(level);

  Future<void> markDone(CoachTechnique technique) async {
    _done.add(technique);
    await _prefs?.setStringList(_doneKey, [for (final t in _done) t.name]);
  }

  Future<void> markSuggested(int level) async {
    _suggested.add(level);
    await _prefs?.setStringList(_suggestedKey, [
      for (final l in _suggested) '$l',
    ]);
  }
}
