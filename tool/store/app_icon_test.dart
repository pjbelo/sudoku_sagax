// Renders the app icon layers (1024×1024) into assets/icons/:
//   icon.png                 full icon: background + mark (iOS, legacy Android)
//   adaptive_background.png  Android adaptive icon background
//   adaptive_foreground.png  mark only, inside the adaptive-icon safe zone
//   adaptive_monochrome.png  white mark for Android 13+ themed icons
//
//   tool/store/app_icon.sh
//
// (runs this file with --update-goldens, then flutter_launcher_icons).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudoku_sagax/sagax_theme.dart';

const _violet = Color(0xFFA855F7);
const _canvas = 1024.0;

/// Digits in the 3×3 box (0 = empty), same as the in-app logo.
const _digits = [5, 0, 3, 0, 9, 0, 7, 0, 1];

/// Dark navy with a soft glow and a faint grid.
class IconBackground extends StatelessWidget {
  const IconBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.2, -0.3),
          radius: 1.0,
          colors: [Color(0xFF1C2B4F), Color(0xFF0B1020)],
        ),
      ),
      child: CustomPaint(painter: _GridPainter(), size: Size.infinite),
    );
  }
}

/// The sudoku box: neon frame, inner lines, digits, glowing centre cell.
class IconMark extends StatelessWidget {
  const IconMark({super.key, required this.size, this.monochrome = false});

  final double size;

  /// Plain white shapes, for Android themed icons.
  final bool monochrome;

  @override
  Widget build(BuildContext context) {
    final cell = size / 3;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _MarkPainter(monochrome: monochrome)),
          ),
          for (int i = 0; i < 9; i++)
            if (_digits[i] != 0)
              Positioned(
                left: (i % 3) * cell,
                top: (i ~/ 3) * cell,
                width: cell,
                height: cell,
                child: Center(child: _digit(_digits[i], cell, i == 4)),
              ),
        ],
      ),
    );
  }

  Widget _digit(int digit, double cell, bool center) {
    final Color color;
    if (monochrome) {
      color = Colors.white;
    } else if (center) {
      color = AppColors.midnightNavy;
    } else {
      color = AppColors.snowWhite;
    }
    return Text(
      '$digit',
      style: GoogleFonts.exo2(
        fontSize: cell * 0.56,
        height: 1,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: monochrome || center
            ? null
            : [
                Shadow(
                  color: AppColors.electricCyan.withValues(alpha: 0.6),
                  blurRadius: cell * 0.12,
                ),
              ],
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter({required this.monochrome});

  final bool monochrome;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final cell = s / 3;
    final frameWidth = s * 0.028;
    final frame = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(frameWidth / 2),
      Radius.circular(s * 0.13),
    );
    final gradient = monochrome
        ? null
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.electricCyan, _violet],
          ).createShader(Offset.zero & size);

    Paint stroke(double width, {double alpha = 1, double blur = 0}) {
      final p = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..color = Colors.white.withValues(alpha: alpha);
      if (gradient != null) p.shader = gradient;
      if (blur > 0) p.maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
      return p;
    }

    // Centre cell: a glowing filled tile (an outline in monochrome).
    final centre = RRect.fromRectAndRadius(
      Rect.fromLTWH(cell, cell, cell, cell).deflate(s * 0.035),
      Radius.circular(s * 0.05),
    );
    if (monochrome) {
      canvas.drawRRect(centre, stroke(s * 0.018));
    } else {
      canvas.drawRRect(
        centre,
        Paint()
          ..color = AppColors.electricCyan.withValues(alpha: 0.75)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.045),
      );
      canvas.drawRRect(centre, Paint()..color = AppColors.electricCyan);
    }

    // Inner lines between cells (kept off the frame).
    final inner = stroke(s * 0.012, alpha: monochrome ? 1 : 0.55);
    final inset = s * 0.07;
    for (int k = 1; k < 3; k++) {
      final d = k * cell;
      canvas.drawLine(Offset(d, inset), Offset(d, s - inset), inner);
      canvas.drawLine(Offset(inset, d), Offset(s - inset, d), inner);
    }

    // Neon frame: blurred glow underneath, crisp stroke on top.
    if (!monochrome) {
      canvas.drawRRect(frame, stroke(frameWidth * 1.6, blur: s * 0.035));
    }
    canvas.drawRRect(frame, stroke(frameWidth));
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.electricCyan.withValues(alpha: 0.05)
      ..strokeWidth = 2;
    for (double x = 0; x <= size.width; x += size.width / 16) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += size.height / 16) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> _render(WidgetTester tester, String name, Widget content) async {
  tester.view.physicalSize = const Size(_canvas, _canvas);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: RepaintBoundary(
        child: SizedBox(width: _canvas, height: _canvas, child: content),
      ),
    ),
  );
  // Let the bundled fonts load for real before capturing.
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 500)),
  );
  await tester.pumpAndSettle();
  await expectLater(
    find.byType(RepaintBoundary).first,
    matchesGoldenFile('../../assets/icons/$name.png'),
  );
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('icon', (tester) async {
    await _render(
      tester,
      'icon',
      const Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: IconBackground()),
          IconMark(size: _canvas * 0.64),
        ],
      ),
    );
  });

  testWidgets('adaptive background', (tester) async {
    await _render(tester, 'adaptive_background', const IconBackground());
  });

  // Adaptive icons are masked to as little as a 66/108 circle, so the mark
  // stays within ~42% of the canvas to keep its corners (and glow) inside.
  testWidgets('adaptive foreground', (tester) async {
    await _render(
      tester,
      'adaptive_foreground',
      const Center(child: IconMark(size: _canvas * 0.42)),
    );
  });

  testWidgets('adaptive monochrome', (tester) async {
    await _render(
      tester,
      'adaptive_monochrome',
      const Center(child: IconMark(size: _canvas * 0.42, monochrome: true)),
    );
  });
}
