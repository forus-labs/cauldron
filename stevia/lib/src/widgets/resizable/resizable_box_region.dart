import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import 'package:stevia/stevia.dart';
import 'package:stevia/src/widgets/resizable/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';
import 'package:stevia/src/widgets/resizable/slider.dart';

/// A resizable region in a horizontal [ResizableBox].
@internal class HorizontalResizableBoxRegion extends StatelessWidget {

  /// The containing resizable box's model.
  final ResizableBoxModel model;
  /// The notifier.
  final ResizableRegionChangeNotifier notifier;
  /// The left slider.
  final HorizontalSlider left;
  /// The right slider.
  final HorizontalSlider right;

  /// Creates a [HorizontalResizableBoxRegion].
  HorizontalResizableBoxRegion({required this.model, required this.notifier}):
    left = HorizontalSlider.left(model: model, index: notifier.snapshot.index, size: notifier.region.sliderSize),
    right = HorizontalSlider.right(model: model, index: notifier.snapshot.index, size: notifier.region.sliderSize);

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      Haptic.selection();
      model.selected = notifier.snapshot.index;
    },
    child: ListenableBuilder(
      listenable: notifier,
      builder: (context, _) => SizedBox(
        width: notifier.snapshot.size,
        child: Stack(
          children: [
            notifier.region.builder(
              context,
              notifier.snapshot,
              notifier.region.child,
            ),
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

  /// The containing resizable box's model.
  final ResizableBoxModel model;
  /// The notifier.
  final ResizableRegionChangeNotifier notifier;
  /// The top slider.
  final VerticalSlider top;
  /// The bottom slider.
  final VerticalSlider bottom;

  /// Creates a [VerticalResizableBoxRegion].
  VerticalResizableBoxRegion({required this.model, required this.notifier}):
    top = VerticalSlider.top(model: model, index: notifier.snapshot.index, size: notifier.region.sliderSize),
    bottom = VerticalSlider.bottom(model: model, index: notifier.snapshot.index, size: notifier.region.sliderSize);

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      Haptic.selection();
      model.selected = notifier.snapshot.index;
    },
    child: ListenableBuilder(
      listenable: notifier,
      builder: (context, _) => SizedBox(
        height: notifier.snapshot.size,
        child: Stack(
          children: [
            notifier.region.builder(
              context,
              notifier.snapshot,
              notifier.region.child,
            ),
            top,
            bottom,
          ],
        ),
      ),
    ),
  );

}
