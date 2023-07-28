import 'package:flutter/widgets.dart';
import 'package:sugar/sugar.dart';

import 'package:stevia/stevia.dart';
import 'package:stevia/src/widgets/resizable/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/resizable_box_region.dart';
import 'package:stevia/src/widgets/resizable/resizable_region.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';

/// A box which children can all be resized either horizontally or vertically.
///
/// Each child must be selected by tapping on it before it can be resized.
///
/// ## Contract
/// Each child has a minimum size determined by its slider size multiplied by 2. Setting an initial size smaller 
/// than the required minimum size will result in undefined behaviour.
///
/// A [ResizableBox] should contain at least two children. Passing it less than 2 children will result in undefined behaviour.
///
///
/// ## Example
/// To create a vertically resizable box:
/// ```dart
/// void main() => runApp(HomeWidget());
///
/// class HomeWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) => MaterialApp(
///     home: Scaffold(
///       body: Center(
///         child: ResizableBox(
///           height: 600,
///           width: 300,
///           initialIndex: 1,
///           children: [
///             ResizableRegion(
///               initialSize: 200,
///               sliderSize: 60,
///               builder: (context, snapshot, child) => Stack(
///                 children: [
///                   child!,
///                   if (snapshot.selected)
///                     Align(
///                       alignment: Alignment.bottomCenter,
///                       child: ResizableIcon.horizontal(),
///                     ),
///                 ],
///               ),
///               child: Container(
///                 decoration: const BoxDecoration(
///                   color: Color(0xFFF2C9D8),
///                   borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
///                 ),
///               ),
///             ),
///             ResizableRegion(
///               initialSize: 250,
///               sliderSize: 60,
///               builder: (context, snapshot, child) => Stack(
///                 children: [
///                   child!,
///                   if (snapshot.selected)
///                     Container(
///                       alignment: Alignment.topCenter,
///                       child: ResizableIcon.horizontal(),
///                     ),
///                   if (snapshot.selected)
///                     Align(
///                       alignment: Alignment.bottomCenter,
///                       child: ResizableIcon.horizontal(),
///                     ),
///                 ],
///               ),
///               child: Container(color: const Color(0xFFF2DAAC)),
///             ),
///             ResizableRegion(
///                 initialSize: 150,
///                 sliderSize: 60,
///                 builder: (context, snapshot, child) => Stack(
///                   children: [
///                     child!,
///                     if (snapshot.selected)
///                       Align(
///                         alignment: Alignment.topCenter,
///                         child: ResizableIcon.horizontal(),
///                       ),
///                   ],
///                 ),
///                 child: Container(
///                   decoration: const BoxDecoration(
///                     color: Color(0xFF8C5845),
///                     borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
///                   ),
///                 )
///             ),
///           ],
///         ),
///       ),
///     ),
///   );
/// }
/// ```
///
/// ![Resizable box](https://i.imgur.com/h6dSgV7.gif)
sealed class ResizableBox extends StatefulWidget {

  /// The height.
  final double height;
  /// The width.
  final double width;
  /// The initially selected region.
  final int initialIndex;
  /// The children which may be resized.
  final List<ResizableRegion> children;
  /// A function that is called when a region is selected.
  final void Function(int index)? onTap;
  /// A function that is called when a selected region and its neighbour have finished resizing.
  final void Function(RegionSnapshot selected, RegionSnapshot neighbour)? onResizeEnd;

  /// Creates a [ResizableBox].
  ///
  /// ## Contract
  /// Throws an [AssertionError] if:
  /// * either [height] or [width] is not positive.
  /// * [initialIndex] is not in the range `0 <= initialIndex < children.size`.
  /// * less than two [ResizableRegion]s are given.
  /// * the size of all [ResizableRegion]s are not equal to the height, if this box is vertically resizable, or width,
  ///   if this box is horizontally resizable.
  factory ResizableBox({
    required double height,
    required double width,
    required List<ResizableRegion> children,
    int initialIndex = 0,
    bool horizontal = false,
    void Function(int index)? onTap,
    void Function(RegionSnapshot selected, RegionSnapshot neighbour)? onResizeEnd,
    Key? key,
  }) => horizontal ?
      _HorizontalResizableBox(height, width, initialIndex, children, onTap, onResizeEnd, key: key) :
      _VerticalResizableBox(height, width, initialIndex, children, onTap, onResizeEnd, key: key);


  const ResizableBox._(this.height, this.width, this.initialIndex, this.children, this.onTap, this.onResizeEnd, {super.key});
    // TODO: redo assertions with fuzzy equality.
    // assert(0 < height, 'The height should be positive, but it is $height'),
    // assert(0 < width, 'The width should be positive, but it is $width'),
    // assert(2 <= children.length, 'A ResizableBox should have at least 2 ResizableRegions.'),
    // assert(0 <= initialIndex && initialIndex < children.length, 'The initial index should be in 0 < initialIndex < ${children.length}, but it is $initialIndex.');

}

sealed class _ResizableBoxState<T extends ResizableBox> extends State<T> {

  late ResizableBoxModel model;

  @override
  void initState() {
    super.initState();
    _update(widget.initialIndex);
  }

  @override
  void didUpdateWidget(T old) {
    super.didUpdateWidget(old);
    if (widget.height != old.height || widget.width != old.width) {
      _update(model.selected);
    }
  }

  void _update(int selected) {
    final notifiers = <ResizableRegionChangeNotifier>[];
    var min = 0.0;
    for (final (index, region) in widget.children.indexed) {
      notifiers.add(ResizableRegionChangeNotifier(
        region,
        RegionSnapshot(
          index: index,
          selected: selected == index,
          constraints: (min: region.sliderSize * 2, max: _size),
          min: min,
          max: min += region.initialSize,
        )
      ));
    }

    model = ResizableBoxModel(notifiers, _size, selected, widget.onTap, widget.onResizeEnd);
  }

  double get _size;

}


class _HorizontalResizableBox extends ResizableBox {

   _HorizontalResizableBox(
     super.height,
     super.width,
     super.initialIndex,
     super.children,
     super.onTap,
     super.onResizeEnd,
     {super.key}
   ): assert(children.sum((e) => e.initialSize) == width, 'The sum of the initial sizes of all children, ${children.sum((e) => e.initialSize)}, is not equal to the width of the RegionBox, $width.'),
      super._();


  @override
  State<StatefulWidget> createState() => _HorizontalResizableBoxState();

}

class _HorizontalResizableBoxState extends _ResizableBoxState<_HorizontalResizableBox> {

  @override
  Widget build(BuildContext context) => SizedBox(
    height: widget.height,
    width: widget.width,
    child: Row(
      children: [
        for (final notifier in model.notifiers)
          HorizontalResizableBoxRegion(
            model: model,
            notifier: notifier,
          ),
      ],
    ),
  );

  @override
  double get _size => widget.width;

}


class _VerticalResizableBox extends ResizableBox {

  _VerticalResizableBox(
    super.height,
    super.width,
    super.initialIndex,
    super.children,
    super.onTap,
    super.onResizeEnd,
    {super.key}
  ): assert(children.sum((e) => e.initialSize) == height, 'The sum of the initial sizes of all children, ${children.sum((e) => e.initialSize)}, is not equal to the height of the RegionBox, $height.'),
      super._();


  @override
  State<StatefulWidget> createState() => _VerticalResizableBoxState();

}

class _VerticalResizableBoxState extends _ResizableBoxState<_VerticalResizableBox> {

  @override
  Widget build(BuildContext context) => SizedBox(
    height: widget.height,
    width: widget.width,
    child: Column(
      children: [
        for (final notifier in model.notifiers)
          VerticalResizableBoxRegion(
            model: model,
            notifier: notifier,
          ),
      ],
    ),
  );

  @override
  double get _size => widget.height;
  
}
