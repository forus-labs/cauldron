import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:stevia/src/widgets/resizable/box/change_notifiers.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_box_region.dart';
import 'package:stevia/src/widgets/resizable/box/slider.dart';

/// A resizable region in a horizontal [ResizableBox].
@internal class HorizontalResizableRegion extends StatelessWidget {

  /// The index.
  final int index;
  /// The notifiers.
  final ResizableRegionChangeNotifiers notifiers;
  /// The notifier.
  final ResizableRegionChangeNotifier notifier;
  /// The region.
  final ResizableBoxRegion region;
  final HorizontalSlider _left;
  final HorizontalSlider _right;

  /// Creates a [HorizontalResizableRegion].
  HorizontalResizableRegion({required this.index, required this.notifiers, required this.notifier, required this.region}):
    _left = HorizontalSlider.left(notifiers: notifiers, index: index, size: region.sliderSize),
    _right = HorizontalSlider.right(notifiers: notifiers, index: index, size: region.sliderSize);

  @override
  Widget build(BuildContext context) => ListenableBuilder (
    listenable: notifier,
    builder: (context, _) => SizedBox(
      width: notifier.current,
      child: Stack(
        children: [
          _left,
          _right,
          region.builder(context, notifiers.selected == index, notifier.percentage, region.child),
        ],
      ),
    ),
  );

}

/// A resizable region in a vertical [ResizableBox].
@internal class VerticalResizableRegion extends StatelessWidget {

  /// The index.
  final int index;
  /// The notifiers.
  final ResizableRegionChangeNotifiers notifiers;
  /// The notifier.
  final ResizableRegionChangeNotifier notifier;
  /// The region.
  final ResizableBoxRegion region;
  final VerticalSlider _top;
  final VerticalSlider _bottom;

  /// Creates a [VerticalResizableRegion].
  VerticalResizableRegion({required this.index, required this.notifiers, required this.notifier, required this.region}):
    _top = VerticalSlider.top(notifiers: notifiers, index: index, size: region.sliderSize),
    _bottom = VerticalSlider.bottom(notifiers: notifiers, index: index, size: region.sliderSize);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: notifier,
    builder: (context, _) => SizedBox(
      height: notifier.current,
      child: Stack(
        children: [
          _top,
          _bottom,
          region.builder(context, notifiers.selected == index, notifier.percentage, region.child),
        ],
      ),
    ),
  );

}
