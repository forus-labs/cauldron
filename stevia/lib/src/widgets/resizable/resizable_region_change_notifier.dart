import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:stevia/src/widgets/resizable/direction.dart';
import 'package:stevia/stevia.dart';

/// A resizable region's change notifier.
@internal class ResizableRegionChangeNotifier extends ChangeNotifier {

  /// The resizable region.
  final ResizableRegion region;
  RegionSnapshot _snapshot;

  /// Creates a [ResizableRegionChangeNotifier].
  ResizableRegionChangeNotifier(this.region, this._snapshot);

  /// Updates the current height or width and returns an offset with any overlap caused by shrinking beyond the minimum
  /// size removed.
  Offset update(Direction direction, Offset delta) {
    final (:min, :max) = _snapshot.position;
    final Offset(:dx, :dy) = delta;
    final (x, y) = switch (direction) {
      Direction.left => (_resize(direction, min + dx, max), 0.0),
      Direction.right => (-_resize(direction, min, max + dx), 0.0),
      Direction.top => (0.0, _resize(direction, min + dy, max)),
      Direction.bottom => (0.0, -_resize(direction, min, max + dy)),
    };

    return delta.translate(x, y);
  }

  double _resize(Direction direction, double min, double max) {
    final snapshot = _snapshot;
    final constraints = snapshot.constraints;
    final size = max - min;
    assert(size <= constraints.max, '$size should be less than ${constraints.max}.');

    if (constraints.min <= size) {
      _snapshot = snapshot.copyWith(min: min, max: max);
      notifyListeners();
      return 0;
    }

    if (direction == Direction.left || direction == Direction.top) {
      final min = max - constraints.min;
      if (snapshot.position.min != min) {
        _snapshot = snapshot.copyWith(min: min);
        notifyListeners();
      }

    } else {
      final max = min + constraints.min;
      if (snapshot.position.max != max) {
        _snapshot = snapshot.copyWith(max: max);
        notifyListeners();
      }
    }

    return size - constraints.min;
  }

  /// Whether the region is selected.
  bool get selected => _snapshot.selected;

  /// Notifies this [ResizableRegionChangeNotifier]'s listeners.
  set selected(bool value) {
    _snapshot = _snapshot.copyWith(selected: value);
    notifyListeners();
  }


  /// The current snapshot of the region.
  RegionSnapshot get snapshot => _snapshot;

}
