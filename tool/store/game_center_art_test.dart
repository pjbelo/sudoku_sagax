// Renders the Game Center achievement images (1024×1024) into
// docs/app-store/game-center/, one per Award.
//
//   tool/store/game_center_art.sh
//
// (runs this file with --update-goldens, then flattens the alpha channel,
// which App Store Connect does not accept). The images carry no text, so
// one set serves every language.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_sagax/game/awards.dart';
import 'package:sudoku_sagax/sagax_theme.dart';

import 'store_art.dart';

/// The medal for [award]: ring colour and what sits in the middle.
(Color, Widget) _medal(Award award) {
  const cyan = SagaxPalette.electricCyan;
  const amber = SagaxPalette.hintAmber;
  Widget icon(IconData data, [Color color = SagaxPalette.snowWhite]) =>
      Icon(data, size: 380, color: color);
  Widget number(String text, Color color) => Text(
    text,
    style: GoogleFonts.exo2(
      fontSize: 440,
      height: 1,
      fontWeight: FontWeight.bold,
      color: color,
    ),
  );

  final level = Award.values.indexOf(award) + 1;
  if (level <= 9) {
    // Levels 1–5 in cyan, the graded ones (6–9) in amber.
    final colour = level <= 5 ? cyan : amber;
    return (colour, number('$level', colour));
  }
  return switch (award) {
    Award.noHints => (amber, icon(Icons.psychology_rounded, amber)),
    Award.sevenDays => (
      amber,
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department_rounded,
            size: 220,
            color: amber,
          ),
          number('7', SagaxPalette.snowWhite),
        ],
      ),
    ),
    Award.firstLesson => (cyan, icon(Icons.school_outlined)),
    Award.allLessons => (amber, icon(Icons.school_rounded, amber)),
    Award.daily => (cyan, icon(Icons.event_available_rounded)),
    _ => (cyan, const SizedBox()),
  };
}

class AchievementArt extends StatelessWidget {
  const AchievementArt({super.key, required this.award});

  final Award award;

  @override
  Widget build(BuildContext context) {
    final (ring, centre) = _medal(award);
    return SizedBox(
      width: 1024,
      height: 1024,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(
            child: StoreBackdrop(center: Alignment.center, gridSpacing: 64),
          ),
          storeGlow(ring, 1000, 0.22),
          Container(
            width: 820,
            height: 820,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: SagaxPalette.cardDark,
              border: Border.all(color: ring, width: 36),
              boxShadow: [
                BoxShadow(color: ring.withValues(alpha: 0.45), blurRadius: 60),
              ],
            ),
            child: Center(child: centre),
          ),
        ],
      ),
    );
  }
}

Future<void> _loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
}

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    // flutter_tester lives in bin/cache/artifacts/engine/<platform>/.
    final artifacts = File(Platform.resolvedExecutable).parent.parent.parent;
    await _loadFont(
      'MaterialIcons',
      '${artifacts.path}/material_fonts/MaterialIcons-Regular.otf',
    );
  });

  for (final award in Award.values) {
    testWidgets('achievement ${award.key}', (tester) async {
      tester.view.physicalSize = const Size(1024, 1024);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: sagaxTheme,
          home: Scaffold(body: AchievementArt(award: award)),
        ),
      );
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 300)),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(AchievementArt),
        matchesGoldenFile('../../docs/app-store/game-center/${award.key}.png'),
      );
    });
  }
}
