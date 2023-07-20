import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:stevia/src/widgets/resizable/box/change_notifiers.dart';
import 'package:stevia/src/widgets/resizable/box/direction.dart';

/// A slider to used resize the containing resizable region in a single direction.
@internal sealed class Slider extends StatelessWidget {

  /// The notifiers.
  final ResizableRegionChangeNotifiers notifiers;
  /// The direction of this slider in the containing resizeable region. For example, a slider at the top of a vertical
  /// resizable region will have an alignment of [Direction.top].
  final Direction direction;
  /// The index of the containing resizable region.
  final int index;
  /// The slider's width or height if it is a vertical or horizontal slider respectively.
  final double size;


  /// Creates a [Slider].
  Slider({required this.notifiers, required this.direction, required this.index, required this.size}):
    assert(0 <= index, 'index is $index. It should be a non-negative integer.'),
    assert(!size.isNaN || size.isInfinite, 'size is Nan or infinite. It should not be NaN or infinite.');

}

/// A slider to used resize the containing resizable region in a horizontal direction.
@internal class HorizontalSlider extends Slider {

  /// Creates a [HorizontalSlider] in the left direction.
  HorizontalSlider.left({required super.notifiers, required super.index, required super.size}): super(direction: Direction.left);

  /// Creates a [HorizontalSlider] in the right direction.
  HorizontalSlider.right({required super.notifiers, required super.index, required super.size}): super(direction: Direction.right);


  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onHorizontalDragUpdate: (details) {
      if (notifiers.selected == index) {
        notifiers.update(index, direction, details.delta);
      }
    },
    child: Align(
      alignment: direction.alignment,
      child: SizedBox(width: size),
    ),
  );

}

/// A slider to used resize the containing resizable region in a vertical direction.
@internal class VerticalSlider extends Slider {

  /// Creates a [VerticalSlider] in the top direction.
  VerticalSlider.top({required super.notifiers, required super.index, required super.size}): super(direction: Direction.top);

  /// Creates a [VerticalSlider] in the bottom direction.
  VerticalSlider.bottom({required super.notifiers, required super.index, required super.size}): super(direction: Direction.bottom);


  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onVerticalDragUpdate: (details) {
      if (notifiers.selected == index) {
        notifiers.update(index, direction, details.delta);
      }
    },
    child: Align(
      alignment: direction.alignment,
      child: SizedBox(height: size),
    ),
  );

}