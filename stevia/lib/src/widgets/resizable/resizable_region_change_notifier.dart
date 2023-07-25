import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:stevia/src/widgets/resizable/direction.dart';

/// A resizable region's change notifier.
@internal class ResizableRegionChangeNotifier extends ChangeNotifier {

  /// The region's minimum height or width, and the total size of the containing box.
  final ({double min, double max}) constraints;
  double _min;
  double _max;

  /// Creates a [ResizableRegionChangeNotifier].
  ResizableRegionChangeNotifier(this.constraints, this._min, this._max):
    assert(0 < constraints.min, 'Minimum size should be positive, but is ${constraints.min}'),
    assert(0 < constraints.max, 'Maximum size should be positive, but is ${constraints.max}'),
    assert(constraints.min < constraints.max, 'Minimum size should be less than the maximum size, but minimum is ${constraints.min} and maximum is ${constraints.max}'),
    assert(_min < _max, 'Min offset should be less than the maximum offset, but min is $_min and max is $_max'),
    assert(constraints.min <= _max - _min && _max - _min < constraints.max, '');


  /// Updates the current height or width and returns an offset with any overlap caused by shrinking beyond the minimum
  /// size removed.
  Offset update(Direction direction, Offset delta) {
    final Offset(:dx, :dy) = delta;
    final (x, y) = switch (direction) {
      Direction.left => (_resize(direction, _min + dx, _max), 0.0),
      Direction.right => (-_resize(direction, _min, _max + dx), 0.0),
      Direction.top => (0.0, _resize(direction, _min + dy, _max)),
      Direction.bottom => (0.0, -_resize(direction, _min, _max + dy)),
    };

    return delta.translate(x, y);
  }

  double _resize(Direction direction, double min, double max) {
    final size = max - min;
    assert(size <= constraints.max, '$size should be less than ${constraints.max}.');

    if (constraints.min <= size) {
      _min = min;
      _max = max;
      return 0;
    }

    if (direction == Direction.left || direction == Direction.top) {
      _min = max - constraints.min;
    } else {
      _max = min + constraints.min;
    }

    return size - constraints.min;
  }

  /// Notifies this [ResizableRegionChangeNotifier]'s listeners.
  void notify() => notifyListeners();


  /// The current size.
  double get size  => _max - _min;

  /// The minimum coordinate point.
  double get min  => _min;

  /// The maximum coordinate point.
  double get max  => _max;

}
