import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Player options, persisted with shared_preferences.
///
/// Defaults: sound ON, timer ON, show errors OFF, hint button ON,
/// left-handed OFF, fill notes on easy levels OFF, vibration ON,
/// mark conflicts ON.
/// The chosen language is stored here too (null = follow the device).
class SettingsService extends ChangeNotifier {
  SettingsService._();
  static final instance = SettingsService._();

  static const defaultSound = true;
  static const defaultTimer = true;
  static const defaultShowErrors = false;
  static const defaultHints = true;
  static const defaultLeftHanded = false;
  static const defaultFillNotesEasy = false;
  static const defaultHaptics = true;
  static const defaultMarkConflicts = true;

  /// Levels from here on always offer Fill notes; below it, only with the
  /// "Fill notes on easy levels" option.
  static const fillNotesFromLevel = 6;

  static const _soundKey = 'sound';
  static const _timerKey = 'timer';
  static const _showErrorsKey = 'show_errors';
  static const _hintsKey = 'hints';
  static const _leftHandedKey = 'left_handed';
  static const _fillNotesEasyKey = 'fill_notes_easy';
  static const _hapticsKey = 'haptics';
  static const _markConflictsKey = 'mark_conflicts';
  static const _localeKey = 'locale';

  SharedPreferences? _prefs;

  bool _sound = defaultSound;
  bool _timer = defaultTimer;
  bool _showErrors = defaultShowErrors;
  bool _hints = defaultHints;
  bool _leftHanded = defaultLeftHanded;
  bool _fillNotesEasy = defaultFillNotesEasy;
  bool _haptics = defaultHaptics;
  bool _markConflicts = defaultMarkConflicts;
  Locale? _locale;

  bool get sound => _sound;
  bool get timer => _timer;
  bool get showErrors => _showErrors;
  bool get hints => _hints;

  /// Keys to the left of the board in the side-by-side game layouts.
  bool get leftHanded => _leftHanded;

  /// Fill notes on levels 1–5 too.
  bool get fillNotesEasy => _fillNotesEasy;

  /// Vibration on entries, errors and the win.
  bool get haptics => _haptics;

  /// Outline equal digits that share a row, column or box.
  bool get markConflicts => _markConflicts;

  /// Whether the game offers Fill notes at [level].
  bool fillNotesAt(int level) => level >= fillNotesFromLevel || _fillNotesEasy;
  Locale? get locale => _locale;

  bool get isDefault =>
      _sound == defaultSound &&
      _timer == defaultTimer &&
      _showErrors == defaultShowErrors &&
      _hints == defaultHints &&
      _leftHanded == defaultLeftHanded &&
      _fillNotesEasy == defaultFillNotesEasy &&
      _haptics == defaultHaptics &&
      _markConflicts == defaultMarkConflicts;

  /// Reads the stored options. Call once in `main()` before `runApp`.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _sound = prefs.getBool(_soundKey) ?? defaultSound;
    _timer = prefs.getBool(_timerKey) ?? defaultTimer;
    _showErrors = prefs.getBool(_showErrorsKey) ?? defaultShowErrors;
    _hints = prefs.getBool(_hintsKey) ?? defaultHints;
    _leftHanded = prefs.getBool(_leftHandedKey) ?? defaultLeftHanded;
    _fillNotesEasy = prefs.getBool(_fillNotesEasyKey) ?? defaultFillNotesEasy;
    _haptics = prefs.getBool(_hapticsKey) ?? defaultHaptics;
    _markConflicts = prefs.getBool(_markConflictsKey) ?? defaultMarkConflicts;
    final code = prefs.getString(_localeKey);
    _locale = code == null ? null : Locale(code);
  }

  set sound(bool value) => _update(_soundKey, value, () => _sound = value);
  set timer(bool value) => _update(_timerKey, value, () => _timer = value);
  set showErrors(bool value) =>
      _update(_showErrorsKey, value, () => _showErrors = value);
  set hints(bool value) => _update(_hintsKey, value, () => _hints = value);
  set leftHanded(bool value) =>
      _update(_leftHandedKey, value, () => _leftHanded = value);
  set fillNotesEasy(bool value) =>
      _update(_fillNotesEasyKey, value, () => _fillNotesEasy = value);
  set haptics(bool value) =>
      _update(_hapticsKey, value, () => _haptics = value);
  set markConflicts(bool value) =>
      _update(_markConflictsKey, value, () => _markConflicts = value);

  set locale(Locale? value) {
    _locale = value;
    final prefs = _prefs;
    if (prefs != null) {
      if (value == null) {
        prefs.remove(_localeKey);
      } else {
        prefs.setString(_localeKey, value.languageCode);
      }
    }
    notifyListeners();
  }

  void restoreDefaults() {
    sound = defaultSound;
    timer = defaultTimer;
    showErrors = defaultShowErrors;
    hints = defaultHints;
    leftHanded = defaultLeftHanded;
    fillNotesEasy = defaultFillNotesEasy;
    haptics = defaultHaptics;
    markConflicts = defaultMarkConflicts;
  }

  void _update(String key, bool value, VoidCallback apply) {
    apply();
    _prefs?.setBool(key, value);
    notifyListeners();
  }
}
