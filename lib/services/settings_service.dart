import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Player options, persisted with shared_preferences.
///
/// Defaults: sound ON, timer ON, show errors OFF, hint button ON.
/// The chosen language is stored here too (null = follow the device).
class SettingsService extends ChangeNotifier {
  SettingsService._();
  static final instance = SettingsService._();

  static const defaultSound = true;
  static const defaultTimer = true;
  static const defaultShowErrors = false;
  static const defaultHints = true;

  static const _soundKey = 'sound';
  static const _timerKey = 'timer';
  static const _showErrorsKey = 'show_errors';
  static const _hintsKey = 'hints';
  static const _localeKey = 'locale';

  SharedPreferences? _prefs;

  bool _sound = defaultSound;
  bool _timer = defaultTimer;
  bool _showErrors = defaultShowErrors;
  bool _hints = defaultHints;
  Locale? _locale;

  bool get sound => _sound;
  bool get timer => _timer;
  bool get showErrors => _showErrors;
  bool get hints => _hints;
  Locale? get locale => _locale;

  bool get isDefault =>
      _sound == defaultSound &&
      _timer == defaultTimer &&
      _showErrors == defaultShowErrors &&
      _hints == defaultHints;

  /// Reads the stored options. Call once in `main()` before `runApp`.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _sound = prefs.getBool(_soundKey) ?? defaultSound;
    _timer = prefs.getBool(_timerKey) ?? defaultTimer;
    _showErrors = prefs.getBool(_showErrorsKey) ?? defaultShowErrors;
    _hints = prefs.getBool(_hintsKey) ?? defaultHints;
    final code = prefs.getString(_localeKey);
    _locale = code == null ? null : Locale(code);
  }

  set sound(bool value) => _update(_soundKey, value, () => _sound = value);
  set timer(bool value) => _update(_timerKey, value, () => _timer = value);
  set showErrors(bool value) =>
      _update(_showErrorsKey, value, () => _showErrors = value);
  set hints(bool value) => _update(_hintsKey, value, () => _hints = value);

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
  }

  void _update(String key, bool value, VoidCallback apply) {
    apply();
    _prefs?.setBool(key, value);
    notifyListeners();
  }
}
