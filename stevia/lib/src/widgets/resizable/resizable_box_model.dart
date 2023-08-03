import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:stevia/stevia.dart';
import 'package:stevia/src/widgets/resizable/direction.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';

/// A resizable box's model.
///
/// It contains a [ResizableRegionChangeNotifier] for each [ResizableRegion]. All updates are routed to this model
/// which then notifies only the changed [ResizableRegionChangeNotifier]s. This avoids rebuilding all regions.
@internal class ResizableBoxModel {

  /// The [ResizableRegionChangeNotifier] for all regions in this [ResizableBox].
  final List<ResizableRegionChangeNotifier> notifiers;
  /// The total size of the [ResizableBox].
  final double size;
  final void Function(int)? _onTap;
  final void Function(RegionSnapshot selected, RegionSnapshot neighbour)? _onResizeEnd;
  int _selected;

  /// Creates a [ResizableBoxModel].
  ResizableBoxModel(this.notifiers, this.size, this._selected, this._onTap, this._onResizeEnd):
    assert(2 <= notifiers.length, 'A ResizableBox should have at least 2 ResizableRegions.'),
    assert(0 < size, "A ResizableBox's size should be positive."),
    assert(0 <= _selected && _selected < notifiers.length, 'The selected index should be in 0 <= selected < number of regions, but it is $_selected.');

  /// Updates the [ResizableRegionChangeNotifier] and its neighbours' sizes at the given index.
  void update(int index, Direction direction, Offset delta) {
    final (selected, neighbour) = _find(index, direction);
    if (neighbour == null) {
      return;
    }

    // We always want to resize the shrunken region first. This allows us to remove any overlaps caused by shrinking a region
    // beyond the minimum size.
    final Offset(:dx, :dy) = delta;
    final opposite = direction.flip();
    final (shrink, shrinkDirection, expand, expandDirection) = switch (direction) {
      Direction.left when 0 < dx => (selected, direction, neighbour, opposite),
      Direction.top when 0 < dy => (selected, direction, neighbour, opposite),
      Direction.right when dx < 0 => (selected, direction, neighbour, opposite),
      Direction.bottom when dy < 0 => (selected, direction, neighbour, opposite),
      _ => (neighbour, opposite, selected, direction),
    };

    final previous = (shrink.snapshot.min, shrink.snapshot.max);
    final adjusted = shrink.update(shrinkDirection, delta);
    if (previous != (shrink.snapshot.min, shrink.snapshot.max)) {
      expand.update(expandDirection, adjusted);
    }
  }

  /// Notifies the region at the [index] and its neighbour that it has been resized.
  void end(int index, Direction direction) {
    final (selected, neighbour) = _find(index, direction);
    if (neighbour == null) {
      return;
    }

    _onResizeEnd?.call(selected.snapshot, neighbour.snapshot);
  }

  (ResizableRegionChangeNotifier selected, ResizableRegionChangeNotifier? neighbour) _find(int index, Direction direction) {
    final selected = notifiers[index];
    final neighbour = switch (direction) {
      Direction.left || Direction.top when index != 0 => notifiers[index - 1],
      Direction.right || Direction.bottom when index != notifiers.length - 1 => notifiers[index + 1],
      _ => null,
    };

    return (selected, neighbour);
  }


  /// The currently selected region's index. It should be `0 <= selected < number of regions`.
  int get selected => _selected;

  set selected(int value) {
    if (_selected != value) {
      final old = _selected;
      _selected = value;

      _onTap?.call(value);
      notifiers[old].selected = false;
      notifiers[selected].selected = true;
    }
  }

}
