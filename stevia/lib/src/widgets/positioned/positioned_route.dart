import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class PositionedRoute extends PopupRoute<void> {

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
    this.barrierLabel,
    this.barrierColor,
    this.barrierDismissible = true,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    throw UnimplementedError();
  }

}
