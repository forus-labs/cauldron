import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// The direction.
@internal enum Direction {
  /// The left.
  left(Alignment.centerLeft),
  /// The top.
  top(Alignment.topCenter),
  /// The right.
  right(Alignment.centerRight),
  /// The bottom.
  bottom(Alignment.bottomCenter);

  /// The alignment.
  final Alignment alignment;

  /// Creates a [Direction].
  const Direction(this.alignment);

  /// The opposite.
  Direction get opposite => switch (this) {
    left => right,
    top => bottom,
    right => left,
    bottom => top,
  };
}
