import 'package:flutter/material.dart';

/// Represents an icon for a resizable region.
class ResizableIcon extends StatelessWidget {

  /// The padding.
  final EdgeInsetsGeometry padding;
  /// The icon's color, defaults to [Colors.white30].
  final Color color;
  /// The height, defaults to 4.7 if horizontal and 29 if vertical.
  final double height;
  /// The width, defaults to 29 if horizontal and 4.7 if vertical.
  final double width;
  /// The icon's border radius.
  final BorderRadius borderRadius;

  /// Creates a [ResizableIcon] that is horizontally aligned.
  const ResizableIcon.horizontal({
    super.key,
    this.padding = const EdgeInsets.all(7),
    this.color = Colors.white30,
    this.height = 4.7,
    this.width = 29,
    this.borderRadius = const BorderRadius.horizontal(
      left: Radius.circular(5),
      right: Radius.circular(5),
    ),
  });

  /// Creates a [ResizableIcon] that is vertically aligned.
  const ResizableIcon.vertical({
    super.key,
    this.padding = const EdgeInsets.all(7),
    this.color = Colors.white30,
    this.height = 29,
    this.width = 4.7,
    this.borderRadius = const BorderRadius.vertical(
      top: Radius.circular(5),
      bottom: Radius.circular(5),
    ),
  });


  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: SizedBox(
        height: height,
        width: width,
      ),
    ),
  );
}
