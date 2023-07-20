import 'package:flutter/widgets.dart';

/// The signature of a method for building a [ResizableBoxRegion]'s child.
typedef RegionBuilder = Widget Function(BuildContext context, bool enabled, double percentage, Widget? child); // ignore: avoid_positional_boolean_parameters

/// A region in a [ResizableBox].
final class ResizableBoxRegion {

  /// A callback that returns the initial percentage of the resizable box that this region should occupy.
  ///
  /// The given minimum percentage is always between 0, inclusive, and 1, exclusive.
  ///
  /// ## Contract
  /// Throws a [ArgumentError]:
  /// * if `percentage < [min] || 1 <= percentage`.
  /// * if the sum of all [ResizableBoxRegion]s' [initialPercentage]s do not add up to 1.
  final double Function(double min) initialPercentage;
  /// The sliders' size, defaults to `50`. A [ResizableBoxRegion] has either 1 or 2 sliders. They are used to determine
  /// the minimum percentage when calculating the [initialPercentage]. A larger [sliderSize] will increase the minimum
  /// percentage.
  ///
  /// ## Contract
  /// Providing a negative value will result in undefined behaviour.
  final double sliderSize;
  /// The builder used to create a child to display in this region.
  final RegionBuilder builder;
  /// A size-independent widget which is passed back to the [builder].
  ///
  /// This argument is optional and can be null if the entire widget subtree the [builder] builds depends on the value
  /// of the future. For example, in the case where the future is a [String] and the [builder] returns a [Text] widget
  /// with the current [String] value, there would be no useful [child].
  final Widget? child;


  /// Creates a [ResizableBoxRegion].
  const ResizableBoxRegion({required this.initialPercentage, required this.builder, this.sliderSize = 50, this.child});

}
