import 'package:flutter/widgets.dart';
import 'package:stevia/stevia.dart';

/// The signature of a method for building a [ResizableRegion]'s child.
typedef ResizableRegionBuilder = Widget Function(BuildContext context, bool enabled, double dimension, Widget? child); // ignore: avoid_positional_boolean_parameters

/// A [ResizableRegion] is a region in a [ResizableBox].
///
/// Each region has a minimum size determined by `2 * [sliderSize]`.
final class ResizableRegion {

  /// The initial height or width of this region.
  ///
  /// ## Contract
  /// Throws a [ArgumentError]:
  /// * if [initialSize] is non-positive.
  /// * if the sum of all [ResizableRegion]s' [initialSize]s do not add up to [ResizableRegion] height or width.
  final double initialSize;
  /// The sliders' height or width, defaults to `50`.
  ///
  /// A [ResizableRegion] always has 2 sliders. The minimum size of a region is determined by the sum of the sliders' size.
  /// A larger [sliderSize] will increase the minimum region size.
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


  /// Creates a [ResizableRegion].
  ResizableRegion({required this.initialSize, required this.builder, this.sliderSize = 50, this.child}):
    assert (0 < initialSize, 'The initial size should be positive, but it is $initialSize.'),
    assert (2 * sliderSize <= initialSize, 'The initial size, $initialSize is less than the required minimum size, ${2 * sliderSize}.'),
    assert (0 < sliderSize, 'The slider size should be positive, but it is $sliderSize.');

}
