// Renders the Google Play feature graphic (1024×500) for every locale, using
// the app's own widgets so it always matches the game.
//
//   tool/store/feature_graphic.sh
//
// (runs this file with --update-goldens, then strips the alpha channel,
// which Google Play does not accept).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_sagax/game/sudoku_game.dart';
import 'package:sudoku_sagax/game/sudoku_generator.dart';
import 'package:sudoku_sagax/l10n/app_localizations.dart';
import 'package:sudoku_sagax/sagax_theme.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';
import 'package:sudoku_sagax/widgets/sudoku_logo.dart';

/// Second line under the tagline (store copy only, not used in the app).
const _subline = {
  'en': '9 LEVELS · BEGINNER TO EXPERT',
  'pt': '9 NÍVEIS · DE INICIANTE A ESPECIALISTA',
  'es': '9 NIVELES · DE PRINCIPIANTE A EXPERTO',
  'fr': '9 NIVEAUX · DE DÉBUTANT À EXPERT',
  'de': '9 LEVEL · VOM ANFÄNGER ZUM EXPERTEN',
};

/// A mid-game board that shows off entries, notes, a hint and highlights.
({SudokuGame game, int selected}) _showcaseBoard() {
  final game = SudokuGame(generatePuzzle(4, seed: 2026));
  final empty = [
    for (int i = 0; i < 81; i++)
      if (game.values[i] == 0) i,
  ];
  // Player entries in the top half.
  for (final i in empty.where((i) => i < 36).take(9)) {
    game.enterDigit(i, game.solution[i]);
  }
  // Pencil notes: the right digit plus a couple of candidates.
  for (final i in empty.where((i) => i >= 45).take(3)) {
    final d = game.solution[i];
    for (final n in {d, d % 9 + 1, (d + 3) % 9 + 1}) {
      game.toggleNote(i, n);
    }
  }
  final hinted = game.hint(preferred: empty.firstWhere((i) => i >= 36))!;
  return (game: game, selected: hinted);
}

class FeatureGraphic extends StatelessWidget {
  const FeatureGraphic({super.key, required this.lang});

  final String lang;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final board = _showcaseBoard();
    final comma = l10n.tagline.indexOf(',');
    final first = l10n.tagline.substring(0, comma + 1);
    final second = l10n.tagline.substring(comma + 1);

    return SizedBox(
      width: 1024,
      height: 500,
      child: Stack(
        children: [
          // Background: navy with a soft cyan/violet glow and a faint grid.
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.55, -0.1),
                  radius: 1.1,
                  colors: [Color(0xFF1C2B4F), AppColors.midnightNavy],
                ),
              ),
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),
          Positioned(
            right: -60,
            bottom: -200,
            child: _glow(const Color(0xFF7C3AED), 460, 0.2),
          ),
          Positioned(
            right: 40,
            top: 20,
            child: _glow(AppColors.electricCyan, 460, 0.16),
          ),

          // Left: logo, tagline, levels.
          Positioned(
            left: 60,
            top: 0,
            bottom: 40,
            width: 460,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SudokuLogo(height: 118),
                const SizedBox(height: 44),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts.exo2(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: AppColors.snowWhite,
                      ),
                      children: [
                        TextSpan(text: first),
                        TextSpan(
                          text: second,
                          style: const TextStyle(color: AppColors.electricCyan),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _subline[lang]!,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                    color: AppColors.softSlate,
                  ),
                ),
              ],
            ),
          ),

          // Right: a live board with a glow.
          Positioned(
            right: 64,
            top: 50,
            width: 400,
            height: 400,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricCyan.withValues(alpha: 0.45),
                    blurRadius: 36,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: SudokuBoard(
                game: board.game,
                selected: board.selected,
                showErrors: false,
                onCellTap: (_) {},
              ),
            ),
          ),

          // Sagax Games mark, its dark backdrop faded into the background.
          Positioned(
            left: 52,
            bottom: 14,
            width: 132,
            child: _fadeEdges(
              Axis.horizontal,
              _fadeEdges(
                Axis.vertical,
                Image.asset('assets/images/sagax-games-logo.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Fades the edges of [child] along [axis] to transparent: 10% at the
  /// sides (the wordmark is wide), 30% at the top (empty backdrop).
  Widget _fadeEdges(Axis axis, Widget child) {
    final stops = axis == Axis.horizontal
        ? const [0.0, 0.1, 0.9, 1.0]
        : const [0.0, 0.3, 0.9, 1.0];
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => LinearGradient(
        begin: axis == Axis.horizontal
            ? Alignment.centerLeft
            : Alignment.topCenter,
        end: axis == Axis.horizontal
            ? Alignment.centerRight
            : Alignment.bottomCenter,
        colors: const [
          Colors.transparent,
          Colors.white,
          Colors.white,
          Colors.transparent,
        ],
        stops: stops,
      ).createShader(rect),
      child: child,
    );
  }

  Widget _glow(Color color, double size, double alpha) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: alpha),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricCyan.withValues(alpha: 0.05)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  for (final lang in _subline.keys) {
    testWidgets('feature graphic $lang', (tester) async {
      tester.view.physicalSize = const Size(1024, 500);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: sagaxTheme,
          locale: Locale(lang),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: FeatureGraphic(lang: lang)),
        ),
      );
      // Let fonts and the logo image load for real before capturing.
      await tester.runAsync(() async {
        final element = tester.element(find.byType(FeatureGraphic));
        await precacheImage(
          const AssetImage('assets/images/sagax-games-logo.png'),
          element,
        );
        await Future<void>.delayed(const Duration(milliseconds: 500));
      });
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(FeatureGraphic),
        matchesGoldenFile('../../docs/google-play/feature-graphic-$lang.png'),
      );
    });
  }
}
