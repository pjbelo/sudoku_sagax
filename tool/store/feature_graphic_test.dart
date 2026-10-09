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
import 'package:sudoku_sagax/l10n/app_localizations.dart';
import 'package:sudoku_sagax/sagax_theme.dart';
import 'package:sudoku_sagax/widgets/sudoku_board.dart';
import 'package:sudoku_sagax/widgets/sudoku_logo.dart';

import 'store_art.dart';

/// Second line under the tagline (store copy only, not used in the app).
const _subline = {
  'en': '9 LEVELS · BEGINNER TO EXPERT',
  'pt': '9 NÍVEIS · DE INICIANTE A ESPECIALISTA',
  'es': '9 NIVELES · DE PRINCIPIANTE A EXPERTO',
  'fr': '9 NIVEAUX · DE DÉBUTANT À EXPERT',
  'de': '9 LEVEL · VOM ANFÄNGER ZUM EXPERTEN',
};

class FeatureGraphic extends StatelessWidget {
  const FeatureGraphic({super.key, required this.lang});

  final String lang;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final board = showcaseBoard();
    final comma = l10n.tagline.indexOf(',');
    final first = l10n.tagline.substring(0, comma + 1);
    final second = l10n.tagline.substring(comma + 1);

    return SizedBox(
      width: 1024,
      height: 500,
      child: Stack(
        children: [
          // Background: navy with a soft cyan/violet glow and a faint grid.
          const Positioned.fill(child: StoreBackdrop()),
          Positioned(
            right: -60,
            bottom: -200,
            child: storeGlow(storeViolet, 460, 0.2),
          ),
          Positioned(
            right: 40,
            top: 20,
            child: storeGlow(AppColors.electricCyan, 460, 0.16),
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
