import 'package:flutter/widgets.dart';
import 'package:stevia/src/widgets/resizable/box/change_notifiers.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_box_region.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_region.dart';

/// A box which children can either be horizontally or vertically resized.
class ResizableBox extends StatelessWidget {

  final int initialIndex;
  final List<ResizableBoxRegion> children;
  final bool verticial;

  /// Creates a [ResizableBox].
  const ResizableBox({required this.initialIndex, required this.children, this.verticial = true, super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints),
  );

}

class _VerticalResizableBox extends StatefulWidget {

  final BoxConstraints constraints;
  final int initialIndex;
  final List<ResizableBoxRegion> children;

  const _VerticalResizableBox({required this.constraints, required this.initialIndex, required this.children});

  @override
  State<StatefulWidget> createState() => _VerticalResizableBoxState();

}

class _VerticalResizableBoxState extends State<_VerticalResizableBox> {

  late ResizableRegionChangeNotifiers notifiers;


  @override
  void initState() {
    super.initState();
    _update(widget.initialIndex);
  }

  @override
  void didUpdateWidget(_VerticalResizableBox old) {
    super.didUpdateWidget(old);
    if (widget.constraints != old.constraints) {
      _update(notifiers.selected);
    }
  }

  void _update(int selected) {
    final height = widget.constraints.maxHeight;

    final regions = <ResizableRegionChangeNotifier>[];
    for (final region in widget.children) {
      final min = region.sliderSize * 2;
      final percentage = region.initialPercentage(min);
      regions.add(ResizableRegionChangeNotifier(min, height, height * percentage, percentage));
    }

    notifiers = ResizableRegionChangeNotifiers(selected, regions);
  }


  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final (index, region) in widget.children.indexed)
        VerticalResizableRegion(
          index: index,
          notifiers: notifiers,
          notifier: notifiers.regions[index],
          region: region,
        ),
    ],
  );
  
}
