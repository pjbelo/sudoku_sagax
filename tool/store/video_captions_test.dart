// Renders the captions of the store preview video as transparent PNGs, one
// per scene, device and locale, plus the caption band behind them, into
// build/store_video/captions/. Run by tool/store/video.sh;
// tool/store/compose_video.dart lays the band over the top of the video for
// its whole length and fades the captions in and out on it.
//
// The band is store art, not app UI: a violet gradient (the feature
// graphic's glow) with pale-yellow accents, so the captions stand apart from
// the app's own navy and cyan.
//
// Captions are store copy, not app strings. Keep them within what
// docs/research.md supports: Sudoku *engages* memory, attention and logic;
// never claim it improves them.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_sagax/sagax_theme.dart';

/// Caption per scene (see integration_test/store_video_test.dart): a white
/// first line and a cyan second line.
const _captions = {
  'en': [
    ('Classic Sudoku.', 'Pure logic.'),
    ('9 levels', 'Beginner to Expert'),
    ('Every move', 'is a deduction'),
    ('Mark candidates', 'with Notes'),
    ('Stuck?', 'Use a hint'),
    ('Memory, attention', 'and logic at work'),
    ('Beat your', 'best times'),
    ('Ready for your', 'next challenge?'),
  ],
  'pt': [
    ('Sudoku clássico.', 'Lógica pura.'),
    ('9 níveis', 'De Iniciante a Especialista'),
    ('Cada jogada', 'é uma dedução'),
    ('Marca candidatos', 'com Notas'),
    ('Encravado?', 'Usa uma ajuda'),
    ('Memória, atenção', 'e lógica em ação'),
    ('Bate os teus', 'melhores tempos'),
    ('Pronto para o', 'próximo desafio?'),
  ],
  'es': [
    ('Sudoku clásico.', 'Lógica pura.'),
    ('9 niveles', 'De Principiante a Experto'),
    ('Cada jugada', 'es una deducción'),
    ('Marca candidatos', 'con Notas'),
    ('¿Atascado?', 'Usa una pista'),
    ('Memoria, atención', 'y lógica en acción'),
    ('Supera tus', 'mejores tiempos'),
    ('¿Listo para el', 'próximo reto?'),
  ],
  'fr': [
    ('Sudoku classique.', 'Logique pure.'),
    ('9 niveaux', 'De Débutant à Expert'),
    ('Chaque coup', 'est une déduction'),
    ('Marquez les candidats', 'avec Notes'),
    ('Bloqué ?', 'Utilisez un indice'),
    ('Mémoire, attention', 'et logique en action'),
    ('Battez vos', 'meilleurs temps'),
    ('Prêt pour le', 'prochain défi ?'),
  ],
  'de': [
    ('Klassisches Sudoku.', 'Reine Logik.'),
    ('9 Level', 'Vom Anfänger zum Experten'),
    ('Jeder Zug', 'ist eine Schlussfolgerung'),
    ('Markiere Kandidaten', 'mit Notizen'),
    ('Festgefahren?', 'Nimm einen Tipp'),
    ('Gedächtnis, Aufmerksamkeit', 'und Logik in Aktion'),
    ('Schlag deine', 'Bestzeiten'),
    ('Bereit für die nächste', 'Herausforderung?'),
  ],
};

/// Caption band size per device. Keep in sync with `_devices` in
/// tool/store/compose_video.dart.
const _bands = {
  'iphone': (size: Size(886, 290), fontSize: 54.0, radius: 40.0),
  'ipad': (size: Size(1200, 210), fontSize: 58.0, radius: 36.0),
};

/// Room below the band for its shadow, which falls onto the footage.
const _shadowRoom = 40.0;

const _bandStart = Color(0xFF7C3AED);
const _bandEnd = Color(0xFF4F46E5);
const _accent = Color(0xFFFDE68A);

/// The band behind the captions: a violet gradient with rounded bottom
/// corners and a soft shadow.
class VideoCaptionBand extends StatelessWidget {
  const VideoCaptionBand({super.key, required this.size, required this.radius});

  final Size size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height + _shadowRoom,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [_bandStart, _bandEnd],
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(radius),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoCaption extends StatelessWidget {
  const VideoCaption({
    super.key,
    required this.lines,
    required this.size,
    required this.fontSize,
  });

  final (String, String) lines;
  final Size size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
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
      size: size,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
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
    );
  }
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final MapEntry(key: device, value: band) in _bands.entries) {
    testWidgets('video caption band $device', (tester) async {
      tester.view.physicalSize = band.size + const Offset(0, _shadowRoom);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        Center(
          child: RepaintBoundary(
            child: VideoCaptionBand(size: band.size, radius: band.radius),
          ),
        ),
      );
      await expectLater(
        find.byType(VideoCaptionBand),
        matchesGoldenFile('../../build/store_video/captions/$device/band.png'),
      );
    });

    for (final MapEntry(key: lang, value: captions) in _captions.entries) {
      testWidgets('video captions $device $lang', (tester) async {
        tester.view.physicalSize = band.size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        for (int n = 0; n < captions.length; n++) {
          await tester.pumpWidget(
            Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: RepaintBoundary(
                  child: VideoCaption(
                    lines: captions[n],
                    size: band.size,
                    fontSize: band.fontSize,
                  ),
                ),
              ),
            ),
          );
          // Let the bundled fonts load for real before capturing.
          await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 300)),
          );
          await tester.pumpAndSettle();
          await expectLater(
            find.byType(VideoCaption),
            matchesGoldenFile(
              '../../build/store_video/captions/$device/$lang/${n + 1}.png',
            ),
          );
        }
      });
    }
  }
}
