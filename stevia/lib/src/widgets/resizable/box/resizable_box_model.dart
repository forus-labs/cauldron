import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:stevia/stevia.dart';
import 'package:stevia/src/widgets/resizable/box/direction.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_region_change_notifier.dart';

/// A resizable box's model.
///
/// It contains a [ResizableRegionChangeNotifier] for each [ResizableRegion]. All updates are routed to this model
/// which then notifies only the changed [ResizableRegionChangeNotifier]s. This avoids rebuilding all regions.
@internal class ResizableBoxModel {

  /// The [ResizableRegionChangeNotifier] for all regions in this [ResizableBox].
  final List<ResizableRegionChangeNotifier> notifiers;
  int _selected;

  /// Creates a [ResizableBoxModel].
  ResizableBoxModel(this.notifiers, this._selected):
    assert(0 <= _selected && _selected < notifiers.length, 'The selected index should be in 0 <= selected < number of regions, but it is $_selected.');

  /// Updates the [ResizableRegionChangeNotifier] and its neighbours' sizes at the given index.
  void update(int index, Direction direction, Offset offset) {
    final selected = notifiers[index];
    final neighbour = switch (direction) {
      Direction.left || Direction.top when index != 0 => notifiers[index - 1],
      Direction.right || Direction.bottom when index != notifiers.length - 1 => notifiers[index + 1],
      _ => throw StateError('This is not possible.'),
    };

    // We always want to resize the shrunken region first. This allows us to remove any overlaps caused by shrinking a region
    // beyond the minimum size.
    final Offset(:dx, :dy) = offset;
    switch (direction) {
      case Direction.left when 0 < dx:
      case Direction.top when 0 < dy:
      case Direction.right when dx < 0:
      case Direction.bottom when dy < 0:
        neighbour.update(direction.flip(), selected.update(direction, offset));

      default:
        selected.update(direction, neighbour.update(direction.flip(), offset));
    }

    neighbour.notify();
    selected.notify();
  }

  /// The currently selected region's index. It should be `0 <= selected < number of regions`.
  int get selected => _selected;

  set selected(int value) {
    if (_selected != value) {
      final old = _selected;
      _selected = value;

      notifiers[old].notify();
      notifiers[selected].notify();
    }
  }

}
