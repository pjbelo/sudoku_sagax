import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'l10n/app_localizations.dart';
import 'sagax_theme.dart';
import 'screens/home_screen.dart';
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
  await SettingsService.instance.load();
  await ScoreboardService.instance.load();
  await AudioService.instance.init();
  runApp(const SudokuSagaxApp());
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
        home: const HomeScreen(),
      ),
    );
  }
}
