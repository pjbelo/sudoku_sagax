import 'package:flutter/widgets.dart';

/// The fade transition every Sagax game uses between screens.
PageRouteBuilder<T> fadeRoute<T>(Widget page, {int milliseconds = 300}) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, _, _) => page,
    transitionsBuilder: (_, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: Duration(milliseconds: milliseconds),
  );
}
