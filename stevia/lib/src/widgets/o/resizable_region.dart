import 'package:flutter/widgets.dart';

class ResizableRegion extends StatefulWidget {
  final int index;
  final double height;
  final ValueNotifier<(int, Alignment, Offset)> resize;
  final Widget child;

  ResizableRegion(this.index, this.resize, this.child, this.height);

  @override
  State<ResizableRegion> createState() => ResizableRegionState(height);
}

class ResizableRegionState extends State<ResizableRegion> {

  double _height;

  ResizableRegionState(this._height);

  @override
  Widget build(BuildContext context) => SizedBox(
    height: _height,
    child: Stack(
      children: [
        ResizeGestureDetector(widget.index, Alignment.topCenter, widget.resize),
        ResizeGestureDetector(widget.index, Alignment.bottomCenter, widget.resize),
        widget.child,
      ],
    ),
  );

  double get height => _height;

  set height(double value) => setState(() {
    _height = value;
  });

}
