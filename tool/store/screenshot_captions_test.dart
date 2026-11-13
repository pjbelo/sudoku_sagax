// Adds a caption above each store screenshot. Run by tool/store/screenshots.sh
// after the captures:
//
//   flutter test tool/store/screenshot_captions_test.dart --update-goldens \
//     --dart-define=TARGET=iphone-6.3 --dart-define=LANGS=en,pt
//
// Reads the raw captures in build/store_screenshots/raw/<target>/<lang>/ and
// writes each framed image, at the same size as the capture (the size the
// store expects), to build/store_screenshots/framed/<target>/<lang>/. The
// script then removes the alpha channel and copies them to docs/.
//
// The look is store art, as in the preview video and the creative assets:
// the navy backdrop with its faint grid and a violet glow, a white first
// line and a pale-yellow second line in Exo 2, and the real screenshot below
// with rounded corners.
//
// Captions are store copy, not app strings. Keep them within what
// docs/research.md supports: Sudoku *engages* memory, attention and logic;
// never claim it improves them.

import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_sagax/sagax_theme.dart';

import 'store_art.dart';

const _target = String.fromEnvironment('TARGET', defaultValue: 'iphone-6.3');
const _langs = String.fromEnvironment('LANGS', defaultValue: 'en,pt,es,fr,de');

/// Second caption line colour, as in the preview video.
const _accent = Color(0xFFFDE68A);

/// Caption per scene, keyed by the scene name in the file name (`1_game` →
/// `game`; see integration_test/store_screenshots_test.dart): a white first
/// line and a pale-yellow second line.
const _captions = {
  'en': {
    'game': ('Classic Sudoku.', 'Pure logic.'),
    'solved': ('One solution.', 'No guessing.'),
    'info': ('Memory, attention', 'and logic at work'),
    'home': ('9 levels', 'Beginner to Expert'),
    'scoreboard': ('Beat your', 'best times'),
    'options': ('Play your way', 'Timer and hints optional'),
  },
  'pt': {
    'game': ('Sudoku clássico.', 'Lógica pura.'),
    'solved': ('Uma só solução.', 'Sem adivinhar.'),
    'info': ('Memória, atenção', 'e lógica em ação'),
    'home': ('9 níveis', 'De Iniciante a Especialista'),
    'scoreboard': ('Bate os teus', 'melhores tempos'),
    'options': ('Joga à tua maneira', 'Cronómetro e ajudas opcionais'),
  },
  'es': {
    'game': ('Sudoku clásico.', 'Lógica pura.'),
    'solved': ('Una sola solución.', 'Sin adivinar.'),
    'info': ('Memoria, atención', 'y lógica en acción'),
    'home': ('9 niveles', 'De Principiante a Experto'),
    'scoreboard': ('Supera tus', 'mejores tiempos'),
    'options': ('Juega a tu manera', 'Cronómetro y pistas opcionales'),
  },
  'fr': {
    'game': ('Sudoku classique.', 'Logique pure.'),
    'solved': ('Une seule solution.', 'Sans deviner.'),
    'info': ('Mémoire, attention', 'et logique en action'),
    'home': ('9 niveaux', 'De Débutant à Expert'),
    'scoreboard': ('Battez vos', 'meilleurs temps'),
    'options': ('Jouez à votre façon', 'Chrono et indices en option'),
  },
  'de': {
    'game': ('Klassisches Sudoku.', 'Reine Logik.'),
    'solved': ('Eine Lösung.', 'Kein Raten.'),
    'info': ('Gedächtnis, Fokus', 'und Logik in Aktion'),
    'home': ('9 Level', 'Vom Anfänger zum Experten'),
    'scoreboard': ('Schlag deine', 'Bestzeiten'),
    'options': ('Spiel, wie du willst', 'Timer und Tipps optional'),
  },
};

/// Captions of the landscape scenes (`7_landscape_game`, `8_landscape_home`),
/// which show the large-screen layouts, keyed by device and scene.
const _landscapeCaptions = {
  'en': {
    'ipad_game': ('Made for iPad', 'Grid and keys side by side'),
    'ipad_home': ('Portrait or landscape', 'the layout adapts'),
    'duo_game': ('Made for iPhone Duo', 'Grid and keys side by side'),
  },
  'pt': {
    'ipad_game': ('Feito para iPad', 'Grelha e teclado lado a lado'),
    'ipad_home': ('Vertical ou horizontal', 'o ecrã adapta-se'),
    'duo_game': ('Feito para iPhone Duo', 'Grelha e teclado lado a lado'),
  },
  'es': {
    'ipad_game': ('Hecho para iPad', 'Cuadrícula y teclado lado a lado'),
    'ipad_home': ('Vertical u horizontal', 'la pantalla se adapta'),
    'duo_game': ('Hecho para iPhone Duo', 'Cuadrícula y teclado lado a lado'),
  },
  'fr': {
    'ipad_game': ('Conçu pour iPad', 'Grille et clavier côte à côte'),
    'ipad_home': ('Portrait ou paysage', "l'écran s'adapte"),
    'duo_game': ('Conçu pour iPhone Duo', 'Grille et clavier côte à côte'),
  },
  'de': {
    'ipad_game': ('Gemacht für iPad', 'Gitter und Ziffern nebeneinander'),
    'ipad_home': ('Hoch- oder Querformat', 'das Layout passt sich an'),
    'duo_game': ('Gemacht für iPhone Duo', 'Gitter und Ziffern nebeneinander'),
  },
};

/// The caption of [scene] in [lang]: landscape scenes have their own, per
/// device.
(String, String)? _captionFor(String lang, String scene) {
  const prefix = 'landscape_';
  if (!scene.startsWith(prefix)) return _captions[lang]?[scene];
  final device = _target.startsWith('duo') ? 'duo' : 'ipad';
  return _landscapeCaptions[lang]?['${device}_${scene.substring(prefix.length)}'];
}

/// The raw capture with its caption above it, at the capture's own size.
class FramedScreenshot extends StatelessWidget {
  const FramedScreenshot({
    super.key,
    required this.shot,
    required this.shotSize,
    required this.lines,
  });

  final ImageProvider shot;
  final Size shotSize;
  final (String, String) lines;

  @override
  Widget build(BuildContext context) {
    final canvas = shotSize; // the framed image keeps the capture's size
    final portrait = canvas.height > canvas.width;
    final unit = min(canvas.width, canvas.height);

    // Caption at the top, the screenshot in the space left below it.
    final captionHeight = canvas.height * (portrait ? 0.17 : 0.2);
    final fontSize = captionHeight * 0.3;
    final sideMargin = canvas.width * 0.07;
    final bottomMargin = canvas.height * 0.03;
    final boxWidth = canvas.width - sideMargin * 2;
    final boxHeight = canvas.height - captionHeight - bottomMargin;
    final scale = min(boxWidth / shotSize.width, boxHeight / shotSize.height);
    final shotWidth = shotSize.width * scale;
    final shotHeight = shotSize.height * scale;
    // Rounded like a phone in portrait. Landscape tablets keep a smaller
    // radius: Android puts the status bar clock right at the screen's edge.
    final radius = portrait ? shotWidth * 0.05 : shotHeight * 0.03;

    Text line(String text, Color color) => Text(
      text,
      maxLines: 1,
      style: GoogleFonts.exo2(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        height: 1.15,
        color: color,
      ),
    );

    return SizedBox.fromSize(
      size: canvas,
      child: Stack(
        children: [
          Positioned.fill(
            child: StoreBackdrop(
              center: const Alignment(0, -0.7),
              gridSpacing: unit / 28,
            ),
          ),
          // Violet glow behind the caption, as in the creative assets.
          Positioned(
            left: canvas.width / 2 - unit * 0.6,
            top: captionHeight / 2 - unit * 0.6,
            child: storeGlow(storeViolet, unit * 1.2, 0.35),
          ),
          Positioned(
            left: canvas.width * 0.06,
            right: canvas.width * 0.06,
            top: 0,
            height: captionHeight,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    line(lines.$1, AppColors.snowWhite),
                    line(lines.$2, _accent),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: (canvas.width - shotWidth) / 2,
            top: captionHeight,
            width: shotWidth,
            height: shotHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(
                  color: AppColors.electricCyan.withValues(alpha: 0.35),
                  width: unit * 0.003,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: unit * 0.04,
                    offset: Offset(0, unit * 0.01),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: Image(image: shot, fit: BoxFit.fill),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final lang in _langs.split(',')) {
    final rawDir = Directory('build/store_screenshots/raw/$_target/$lang');
    final shots = rawDir.existsSync()
        ? (rawDir
              .listSync()
              .whereType<File>()
              .where((f) => f.path.endsWith('.png'))
              .toList()
            ..sort((a, b) => a.path.compareTo(b.path)))
        : <File>[];

    for (final file in shots) {
      final fileName = file.uri.pathSegments.last; // e.g. 1_game.png
      final scene = fileName.substring(
        fileName.indexOf('_') + 1,
        fileName.length - '.png'.length,
      );

      testWidgets('screenshot caption $_target $lang $fileName', (
        tester,
      ) async {
        final lines = _captionFor(lang, scene);
        if (lines == null) {
          fail('No caption for scene "$scene" in language "$lang"');
        }

        // Read the capture and its size outside the fake test clock.
        final bytes = file.readAsBytesSync();
        final size = (await tester.runAsync(() async {
          final codec = await ui.instantiateImageCodec(bytes);
          final frame = await codec.getNextFrame();
          return Size(
            frame.image.width.toDouble(),
            frame.image.height.toDouble(),
          );
        }))!;

        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        final shot = MemoryImage(bytes);
        await tester.pumpWidget(
          Directionality(
            textDirection: TextDirection.ltr,
            child: Center(
              child: RepaintBoundary(
                child: FramedScreenshot(
                  shot: shot,
                  shotSize: size,
                  lines: lines,
                ),
              ),
            ),
          ),
        );
        // Decode the image and let the bundled fonts load for real.
        await tester.runAsync(() async {
          await precacheImage(shot, tester.element(find.byType(Image)));
          await Future<void>.delayed(const Duration(milliseconds: 300));
        });
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(FramedScreenshot),
          matchesGoldenFile(
            '../../build/store_screenshots/framed/$_target/$lang/$fileName',
          ),
        );
      });
    }
  }
}
