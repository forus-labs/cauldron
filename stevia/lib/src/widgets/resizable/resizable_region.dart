import 'package:flutter/widgets.dart';
import 'package:stevia/stevia.dart';

/// The signature of a method for building a [ResizableRegion]'s child.
typedef ResizableRegionBuilder = Widget Function(BuildContext context, RegionSnapshot, Widget? child); // ignore: avoid_positional_boolean_parameters

/// A snapshot of a region.
final class RegionSnapshot {
  /// This region's index.
  final int index;
  /// Whether the region is selected.
  final bool selected;
  /// The's minimum height or width, and the total size of the containing box.
  final ({double min, double max}) constraints;
  /// This region's minimum as a cartesian coordinate.
  final double min;
  /// This region's maximum as a cartesian coordinate.
  final double max;

  /// Creates a [RegionSnapshot].
  RegionSnapshot({required this.index, required this.selected, required this.constraints, required this.min, required this.max}):
    assert(0 <= index, 'Index should be non-negative, but is $index.'),
    assert(0 < constraints.min, 'Minimum size should be positive, but is ${constraints.min}'),
    assert(0 < constraints.max, 'Maximum size should be positive, but is ${constraints.max}'),
    assert(min < max, 'Min offset should be less than the maximum offset, but min is $min and max is $max'),
    assert(constraints.min < constraints.max, 'Minimum size should be less than the maximum size, but minimum is ${constraints.min} and maximum is ${constraints.max}'),
    assert(constraints.min <= max - min && max - min < constraints.max, 'Region size must be within $constraints. However, it is ${max - min}.');


  /// Creates a [RegionSnapshot].
  RegionSnapshot copyWith({bool? selected, double? min, double? max}) => RegionSnapshot(
    index: index,
    selected: selected ?? this.selected,
    constraints: constraints,
    min: min ?? this.min,
    max: max ?? this.max,
  );

  /// The [min] and [max] as percentages of the containing box's total size.
  (double, double) get percentage => (min / constraints.max, max / constraints.max);

  /// This region's size.
  double get size => max - min;


  @override
  bool operator ==(Object other) => identical(this, other) || other is RegionSnapshot && runtimeType == other.runtimeType &&
    index == other.index &&
    selected == other.selected &&
    constraints == other.constraints &&
    min == other.min &&
    max == other.max;

  @override
  int get hashCode => index.hashCode ^ selected.hashCode ^ constraints.hashCode ^ min.hashCode ^ max.hashCode;

  @override
  String toString() => 'RegionSnapshot[index: $index, selected: $selected, constraints: $constraints, min: $min, max: $max]';

}


/// A [ResizableRegion] is a region in a [ResizableBox].
///
/// Each region has a minimum size determined by `2 * [sliderLength]`.
class ResizableRegion {

  /// The initial height or width of this region.
  ///
  /// ## Contract
  /// Throws a [ArgumentError]:
  /// * if [initialSize] is non-positive.
  /// * if the sum of all [ResizableRegion]s' [initialSize]s do not add up to [ResizableRegion] height or width.
  final double initialSize;
  /// The sliders' height or width, defaults to `50`.
  ///
  /// A [ResizableRegion] always has 2 sliders. The minimum size of a region is determined by the sum of the sliders'
  /// size. A larger [sliderSize] will increase the minimum region size.
  ///
  /// ## Contract
  /// Providing a negative value will result in undefined behaviour.
  final double sliderSize;
  /// The builder used to create a child to display in this region.
  final ResizableRegionBuilder builder;
  /// A height or width-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the size of
  /// the region.
  final Widget? child;
  /// A function that is called when this region has finished resizing.
  final void Function(RegionSnapshot)? onResizeEnd;


  /// Creates a [ResizableRegion].
  ResizableRegion({required this.initialSize, required this.builder, this.sliderSize = 50, this.child, this.onResizeEnd}):
    assert (0 < initialSize, 'The initial size should be positive, but it is $initialSize.'),
    assert (0 < sliderSize, 'The slider size should be positive, but it is $sliderSize.'),
    assert (2 * sliderSize <= initialSize, 'The initial size, $initialSize is less than the required minimum size, ${2 * sliderSize}.');

}
