import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:foldable/foldable.dart';

// ============================================================
// Sudoku Sagax — iPhone Duo layout helpers
// ============================================================
//
// The fold posture and reserved regions come from the foldable package
// (FoldableProvider in main.dart). On every other device these helpers
// return null or false and the screens keep their usual layouts.

/// The side strip of the safe area where iPhone Duo keeps the status bar and
/// the camera, and where the system places toolbars ("vertical controls").
class SideRail {
  const SideRail({
    required this.onRight,
    required this.width,
    required this.top,
  });

  final bool onRight;
  final double width;

  /// Where the rail's own content can start: below the status bar and the
  /// camera on that side.
  final double top;
}

/// The [SideRail] of an iPhone Duo display whose safe area has a side strip
/// (the outer display, and the inner one in landscape); null elsewhere.
SideRail? sideRailOf(BuildContext context) {
  final duo = DuoMediaQuery.of(context);
  if (!duo.isFoldable) return null;
  final padding = MediaQuery.viewPaddingOf(context);
  final onRight = padding.right >= padding.left;
  final width = max(padding.left, padding.right);
  if (width < 60) return null;
  final screen = MediaQuery.sizeOf(context).width;
  var top = padding.top;
  for (final region in duo.regions) {
    if (region.kind != ReservedRegionKind.occlusion || !region.isActive) {
      continue;
    }
    final onSide = onRight
        ? region.bounds.right > screen - width
        : region.bounds.left < width;
    if (onSide) top = max(top, region.bounds.bottom);
  }
  return SideRail(onRight: onRight, width: width, top: top + 8);
}

/// The fold of a partly folded iPhone Duo, when it crosses an area of
/// [size] (local coordinates, as [FoldAwareBuilder] reports them).
Rect? foldAcross(FoldInfo fold, Size size) {
  // The posture decides, not the region alone: a region can stay marked as
  // active for a moment after the device is laid flat.
  if (!fold.isPartiallyOpen) return null;
  final rect = fold.divisionRect;
  if (rect == null) return null;
  final vertical = rect.height >= rect.width;
  final inside = vertical
      ? rect.left > 0 && rect.right < size.width
      : rect.top > 0 && rect.bottom < size.height;
  return inside ? rect : null;
}

/// Whether an iPhone Duo is partly folded with its fold running across the
/// screen, like a laptop: one half above the fold and the other below it.
bool isLaptopPose(BuildContext context) {
  final duo = DuoMediaQuery.of(context);
  if (!duo.isPartiallyOpen) return false;
  return duo.activeDivisions.any(
    (region) => region.bounds.width > region.bounds.height,
  );
}

/// [first] and [second] on either side of [fold]: left and right of a
/// vertical fold, above and below a horizontal one. Nothing is drawn on the
/// fold itself.
class FoldPanes extends StatelessWidget {
  const FoldPanes({
    super.key,
    required this.fold,
    required this.first,
    required this.second,
  });

  final Rect fold;
  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    if (fold.height >= fold.width) {
      return Row(
        children: [
          SizedBox(width: fold.left, child: first),
          SizedBox(width: fold.width),
          Expanded(child: second),
        ],
      );
    }
    return Column(
      children: [
        SizedBox(height: fold.top, child: first),
        SizedBox(height: fold.height),
        Expanded(child: second),
      ],
    );
  }
}

/// The app's own controls in the [SideRail] strip, below the camera, in
/// place of a top app bar. Must be placed in a [Stack] that fills the
/// screen.
class RailBar extends StatelessWidget {
  const RailBar({super.key, required this.rail, required this.children});

  final SideRail rail;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: rail.top,
      bottom: MediaQuery.viewPaddingOf(context).bottom,
      left: rail.onRight ? null : 0,
      right: rail.onRight ? 0 : null,
      width: rail.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (final child in children)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: child,
              ),
          ],
        ),
      ),
    );
  }
}
