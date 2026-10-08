import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';

/// Thin wrapper over Firebase Analytics.
///
/// Until [init] runs (after `Firebase.initializeApp` in `main()`), every call
/// is a no-op — so tests and platforms without Firebase (desktop, web) work
/// unchanged. Event names follow Slidox/Memorex (`level_completed`, …).
class AnalyticsService {
  AnalyticsService._();
  static final instance = AnalyticsService._();

  FirebaseAnalytics? _analytics;
  List<NavigatorObserver> _observers = const [];

  void init() {
    final analytics = FirebaseAnalytics.instance;
    _analytics = analytics;
    _observers = [FirebaseAnalyticsObserver(analytics: analytics)];
  }

  /// Screen-view tracking for `MaterialApp.navigatorObservers`.
  List<NavigatorObserver> get observers => _observers;

  /// Logs [name]. Parameter values must be `String` or `num` (bools as 0/1).
  void log(String name, [Map<String, Object>? parameters]) {
    final analytics = _analytics;
    if (analytics == null) return;
    unawaited(analytics.logEvent(name: name, parameters: parameters));
  }
}
