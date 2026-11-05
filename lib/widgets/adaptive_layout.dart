import 'package:flutter/material.dart';
import 'package:foldable/foldable.dart';

import 'duo_layout.dart';

// ============================================================
// Sudoku Sagax — Large screen layout helpers
// ============================================================
//
// Every size here comes from the window, not the device, so iPad Split View
// and Stage Manager get the layout that suits the space they really have.

/// How much text, icons and controls grow in this window: 1 on phones and
/// iPhone Duo (held as close as a phone), up to 1.3 on the largest tablets.
double uiScaleOf(BuildContext context) {
  final shortestSide = MediaQuery.sizeOf(context).shortestSide;
  return (shortestSide / 700).clamp(1.0, 1.3);
}

/// Whether a screen gets little height for its content: iPhone Duo's outer
/// display, either half of a Duo folded like a laptop, phones held sideways.
bool isCompactHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height < 720 || isLaptopPose(context);
}

/// Grows all the text below it by [uiScaleOf], on top of the text size the
/// player chose in the system settings. Widgets whose text must fit a shape
/// (board, number pad, level chips) opt out with
/// `MediaQuery.withNoTextScaling` and size their text from that shape.
class LargeScreenText extends StatelessWidget {
  const LargeScreenText({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scale = uiScaleOf(context);
    if (scale == 1) return child;
    final systemScale = MediaQuery.textScalerOf(context).scale(100) / 100;
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(systemScale * scale)),
      child: child,
    );
  }
}

/// [first] and [second] on either side of the fold of a partly folded iPhone
/// Duo, or side by side in a wide window; [single] in any other window.
class TwoPaneLayout extends StatelessWidget {
  const TwoPaneLayout({
    super.key,
    required this.first,
    required this.second,
    required this.single,
    this.splitWhenWide = true,
    this.firstFlex = 1,
    this.secondFlex = 1,
  });

  final Widget first;
  final Widget second;
  final Widget single;

  /// False to keep [single] in wide windows and split only around a fold.
  final bool splitWhenWide;

  /// How the width is shared in a wide window. A fold always decides the
  /// split by itself.
  final int firstFlex;
  final int secondFlex;

  @override
  Widget build(BuildContext context) {
    return FoldAwareBuilder(
      builder: (context, constraints, fold) {
        final foldRect = foldAcross(fold, constraints.biggest);
        if (foldRect != null) {
          return FoldPanes(fold: foldRect, first: first, second: second);
        }
        final wide =
            constraints.maxWidth >= 600 &&
            constraints.maxWidth > constraints.maxHeight * 1.1;
        if (splitWhenWide && wide) {
          return Row(
            children: [
              Expanded(flex: firstFlex, child: first),
              Expanded(flex: secondFlex, child: second),
            ],
          );
        }
        return single;
      },
    );
  }
}

/// [child], at most [maxWidth] wide, placed by [alignment] in the space it
/// gets. It scrolls only when it doesn't fit, and the drag works anywhere in
/// that space, the empty margins of a large screen included.
class CenteredPane extends StatelessWidget {
  const CenteredPane({
    super.key,
    required this.maxWidth,
    required this.child,
    this.padding = 24,
    this.alignment = Alignment.center,
  });

  final double maxWidth;
  final Widget child;
  final double padding;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: constraints.maxWidth - padding * 2,
            minHeight: constraints.maxHeight - padding * 2,
          ),
          child: Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Cards in rows of two, each row as tall as its taller card; in a single
/// column when the width is under [minWidthForTwo].
class TwoColumnCards extends StatelessWidget {
  const TwoColumnCards({
    super.key,
    required this.children,
    this.minWidthForTwo = 640,
    this.gap = 16,
  });

  final List<Widget> children;
  final double minWidthForTwo;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < minWidthForTwo) {
          return Column(children: children);
        }
        return Column(
          children: [
            for (int i = 0; i < children.length; i += 2)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: children[i]),
                    SizedBox(width: gap),
                    Expanded(
                      child: i + 1 < children.length
                          ? children[i + 1]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
