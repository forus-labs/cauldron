import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:stevia/src/widgets/resizable/box/direction.dart';

/// A resizable region's change notifier.
@internal class ResizableRegionChangeNotifier extends ChangeNotifier {

  /// The total height or width of all resizable regions in a resizable box.
  final double total;
  /// The region's minimum height or width.
  final double min;
  double _current;

  /// Creates a [ResizableRegionChangeNotifier].
  ResizableRegionChangeNotifier(this.min, this._current, this.total):
    assert(0 < min, 'Min should be positive, but it is $min.'),
    assert(0 < total, 'Total should be positive, but it is $total.'),
    assert(
      min < total,
      '''
      Minimum region size, $min, is larger than the ResizableBox size, $total.
      To fix this:
        * increase the ResizableBox's size
        * decrease the ResizableRegion's slider size
      ''',
    ),
    assert(min <= _current && _current < total, 'Current should be in range: $min <= current < $total');


  /// Updates the current height or width and returns an offset with any overlap caused by shrinking beyond the minimum size removed.
  Offset update(Direction direction, Offset delta) {
    final Offset(:dx, :dy) = delta;
    final (x, y) = switch (direction) {
      Direction.left => (_resize(_current - dx), 0.0),
      Direction.right => (-_resize(_current + dx), 0.0),
      Direction.top => (0.0, _resize(_current - dy)),
      Direction.bottom => (0.0, -_resize(_current + dy)),
    };

    return delta.translate(x, y);
  }

  double _resize(double magnitude) {
    assert(magnitude <= total, '$magnitude should be less than $total.');

    if (min <= magnitude) {
      _current = magnitude;
      return 0;

    } else {
      _current = min;
      return magnitude - min;
    }
  }

  /// Notifies this [ResizableRegionChangeNotifier]'s listeners.
  void notify() => notifyListeners();


  /// The current size.
  double get current => _current;

}
