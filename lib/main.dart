import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foldable/foldable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'sagax_theme.dart';
import 'screens/home_screen.dart';
import 'services/analytics_service.dart';
import 'services/audio_service.dart';
import 'services/daily_service.dart';
import 'services/games_service.dart';
import 'services/lesson_service.dart';
import 'services/saved_game_service.dart';
import 'services/scoreboard_service.dart';
import 'services/settings_service.dart';
import 'services/statistics_service.dart';
import 'widgets/adaptive_layout.dart';

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
  await SavedGameService.instance.load();
  await SavedGameService.daily.load();
  await DailyService.instance.load();
  await StatisticsService.instance.load();
  await LessonService.instance.load();
  await AudioService.instance.init();
  runApp(const SudokuSagaxApp());
  // Game Center / Play Games: signs in with its own sheet when needed.
  unawaited(GamesService.instance.init());
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
    // iPhone Duo: fold posture and regions for the two-pane layouts
    // (DuoMediaQuery). The full bridge also keeps dialogs and bottom sheets
    // on one side of the fold. Elsewhere it reports no hinge. The bridge is
    // for iOS only: Android already reports display features (folds, camera
    // cutouts) itself, and the package flags a second source in debug runs.
    return FoldableProvider(
      bridgeMode: defaultTargetPlatform == TargetPlatform.iOS
          ? DisplayFeatureBridgeMode.full
          : DisplayFeatureBridgeMode.none,
      // Rebuilds when the language or the appearance changes (stored with
      // the other options).
      child: ListenableBuilder(
        listenable: SettingsService.instance,
        builder: (context, _) => MaterialApp(
          title: 'Sudoku Sagax',
          debugShowCheckedModeBanner: false,
          // Light or dark: as the system is set, unless the Appearance
          // option picks one.
          theme: sagaxLightTheme,
          darkTheme: sagaxTheme,
          themeMode: SettingsService.instance.themeMode,
          locale: SettingsService.instance.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: AnalyticsService.instance.observers,
          builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            // Status bar icons that show on the theme's background, for the
            // screens without an app bar (the app bar sets its own).
            value: _statusBarFor(Theme.of(context).brightness),
            child: LargeScreenText(child: child!),
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}

/// Dark icons on the light theme, light icons on the dark one.
SystemUiOverlayStyle _statusBarFor(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    // Android reads the icons' brightness, iOS the bar's.
    statusBarIconBrightness: dark ? Brightness.light : Brightness.dark,
    statusBarBrightness: dark ? Brightness.dark : Brightness.light,
  );
}
