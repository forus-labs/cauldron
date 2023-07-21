import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:stevia/src/widgets/resizable/box/change_notifiers.dart';
import 'package:stevia/src/widgets/resizable/box/slider.dart';
import 'package:stevia/stevia.dart';

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
          region.builder(context, notifiers.index == index, notifier.percentage, region.child),
          _left,
          _right,
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
      child: GestureDetector(
        onTap: () {
          Haptic.selection();
          notifiers.index = index;
        },
        child: Stack(
          children: [
            region.builder(context, notifiers.index == index, notifier.percentage, region.child),
            _top,
            _bottom,
          ],
        ),
      ),
    ),
  );

}
