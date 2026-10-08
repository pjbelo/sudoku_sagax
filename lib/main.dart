import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'sagax_theme.dart';
import 'screens/home_screen.dart';
import 'services/analytics_service.dart';
import 'services/audio_service.dart';
import 'services/scoreboard_service.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Fonts are bundled in google_fonts/; never fetch them over the network.
  GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    for (final font in ['Exo2', 'Inter']) {
      final license = await rootBundle.loadString('google_fonts/OFL-$font.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    }
  });
  await _initFirebase();
  await SettingsService.instance.load();
  await ScoreboardService.instance.load();
  await AudioService.instance.init();
  runApp(const SudokuSagaxApp());
}

/// Firebase is configured for Android and iOS only (project
/// `sudoku-sagax-games`). Elsewhere — desktop and web dev runs — it is
/// skipped and analytics stays a no-op.
Future<void> _initFirebase() async {
  final supported =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  if (!supported) return;

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final crashlytics = FirebaseCrashlytics.instance;
  // Keep debug-session crashes out of the Crashlytics dashboard.
  await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = crashlytics.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    crashlytics.recordError(error, stack, fatal: true);
    return true;
  };
  AnalyticsService.instance.init();
}

class SudokuSagaxApp extends StatelessWidget {
  const SudokuSagaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds when the language changes (stored with the other options).
    return ListenableBuilder(
      listenable: SettingsService.instance,
      builder: (context, _) => MaterialApp(
        title: 'Sudoku Sagax',
        debugShowCheckedModeBanner: false,
        theme: sagaxTheme,
        locale: SettingsService.instance.locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        navigatorObservers: AnalyticsService.instance.observers,
        home: const HomeScreen(),
      ),
    );
  }
}
