import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:stevia/src/widgets/resizable/box/direction.dart';

/// A resizable box's change notifiers.
@internal class ResizableRegionChangeNotifiers {

  final List<ResizableRegionChangeNotifier> regions;
  int _selected;

  /// Creates a [ResizableRegionChangeNotifiers].
  ResizableRegionChangeNotifiers(this._selected, this.regions);

  /// Updates the [ResizableRegionChangeNotifier] and its neighbours' sizes at the given index.
  void update(int index, Direction direction, Offset offset) {
    final selected = regions[index];
    final neighbour = switch (direction) {
      Direction.left || Direction.top when index != 0 => regions[index - 1],
      Direction.right || Direction.bottom when index != regions.length - 1 => regions[index + 1],
      _ => throw StateError('This is not possible.'),
    };

    if ((direction == Direction.left && 0 < offset.dx) || (direction == Direction.top && 0 < offset.dy)) {
      final adjusted = selected.update(direction, offset);
      neighbour.update(direction.opposite, adjusted);

    } else {
      final adjusted = neighbour.update(direction.opposite, offset);
      selected.update(direction, adjusted);
    }

    neighbour.notify();
    selected.notify();
  }

  /// The currently selected region. It should be `0 <= selected < number of regions`.
  int get selected => _selected;

  set selected(int value) {
    if (_selected != value) {
      final old = _selected;
      _selected = value;

      regions[old].notify();
      regions[selected].notify();
    }
  }

}

/// A resizable box region's change notifier.
@internal class ResizableRegionChangeNotifier extends ChangeNotifier {

  /// The minimum size.
  final double min;
  /// The maximum size.
  final double max;
  double _current;
  double _percentage;

  /// Creates a [ResizableRegionChangeNotifier].
  ResizableRegionChangeNotifier(this.min, this.max, this._current, this._percentage);

  /// Notifies this [ResizableRegionChangeNotifier]'s listeners.
  void notify() => notifyListeners();

  /// Updates the current size and returns an offset that removes any overlap caused by shrinking beyond the minimum size.
  Offset update(Direction direction, Offset offset) {
    final Offset(:dx, :dy) = offset;
    return switch (direction) {
      Direction.left => Offset(dx + _update(_current - dx), dy),
      Direction.top => Offset(dx, dy + _update(_current - dy)),
      Direction.right => Offset(dx - _update(_current + dx), dy),
      Direction.bottom => Offset(dx, dy - _update(_current + dy)),
    };
  }

  double _update(double unbound) {
    if (min <= unbound) {
      _current = unbound;
      _percentage = _current / max;
      return 0;

    } else {
      _current = min;
      _percentage = _current / max;
      return unbound - min;
    }
  }


  /// The current size.
  double get current => _current;

  /// The current percentage.
  double get percentage => _percentage;

}
