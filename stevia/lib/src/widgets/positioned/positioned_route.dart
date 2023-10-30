import 'package:flutter/cupertino.dart';

/// TODO
class PositionedRoute extends PopupRoute<void> {

  /// Used build the route's primary contents.
  ///
  /// See [ModalRoute.buildPage] for complete definition of the parameters.
  final RoutePageBuilder builder;
  @override
  final Color? barrierColor;
  @override
  final String? barrierLabel;
  @override
  final bool barrierDismissible;
  @override
  final Duration transitionDuration;

  /// Creates a [PositionedRoute].
  PositionedRoute({
    required this.builder,
    this.barrierLabel,
    this.barrierColor,
    this.barrierDismissible = true,
    this.transitionDuration = const Duration(milliseconds: 300),
  });


  // @override
  // Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  //   return
  // }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => builder(context, animation, secondaryAnimation);

  @override
  Animation<double> createAnimation() => CurvedAnimation(
    parent: super.createAnimation(),
    // A cubic animation curve that starts slowly and ends with an overshoot of its bounds before reaching its end.
    curve: const Cubic(0.075, 0.82, 0.4, 1.065),
    reverseCurve: Curves.easeIn,
  );

}
