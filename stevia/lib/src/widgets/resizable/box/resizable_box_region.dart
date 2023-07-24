import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:stevia/stevia.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_region_change_notifier.dart';
import 'package:stevia/src/widgets/resizable/box/slider.dart';

/// A resizable region in a horizontal [ResizableBox].
@internal class HorizontalResizableBoxRegion extends StatelessWidget {

  /// The index.
  final int index;
  /// The containing resizable box's model.
  final ResizableBoxModel model;
  /// The notifier.
  final ResizableRegionChangeNotifier notifier;
  /// The region.
  final ResizableRegion region;
  /// The left slider.
  final HorizontalSlider left;
  /// The right slider.
  final HorizontalSlider right;

  /// Creates a [HorizontalResizableBoxRegion].
  HorizontalResizableBoxRegion({required this.index, required this.model, required this.notifier, required this.region}):
    left = HorizontalSlider.left(model: model, index: index, size: region.sliderSize),
    right = HorizontalSlider.right(model: model, index: index, size: region.sliderSize);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: notifier,
    builder: (context, _) => SizedBox(
      width: notifier.current,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Haptic.selection();
          model.selected = index;
        },
        child: Stack(
          children: [
            region.builder(context, model.selected == index, notifier.current, region.child),
            left,
            right,
          ],
        ),
      ),
    ),
  );

}

/// A resizable region in a vertical [ResizableBox].
@internal class VerticalResizableBoxRegion extends StatelessWidget {

  /// The index.
  final int index;
  /// The containing resizable box's model.
  final ResizableBoxModel model;
  /// The notifier.
  final ResizableRegionChangeNotifier notifier;
  /// The region.
  final ResizableRegion region;
  /// The top slider.
  final VerticalSlider top;
  /// The bottom slider.
  final VerticalSlider bottom;

  /// Creates a [VerticalResizableBoxRegion].
  VerticalResizableBoxRegion({required this.index, required this.model, required this.notifier, required this.region}):
    top = VerticalSlider.top(model: model, index: index, size: region.sliderSize),
    bottom = VerticalSlider.bottom(model: model, index: index, size: region.sliderSize);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: notifier,
    builder: (context, _) => SizedBox(
      height: notifier.current,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Haptic.selection();
          model.selected = index;
        },
        child: Stack(
          children: [
            region.builder(context, model.selected == index, notifier.current, region.child),
            top,
            bottom,
          ],
        ),
      ),
    ),
  );

}
