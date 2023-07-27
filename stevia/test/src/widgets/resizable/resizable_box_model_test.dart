import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/src/widgets/resizable/direction.dart';
import 'package:stevia/src/widgets/resizable/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/resizable_region.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';

void main() {
  late ResizableBoxModel model;
  late ResizableRegionChangeNotifier top;
  late ResizableRegionChangeNotifier middle;
  late ResizableRegionChangeNotifier bottom;
  late int topCount;
  late int middleCount;
  late int bottomCount;
  late int topEnd;
  late int middleEnd;
  late int bottomEnd;
  late int selectedIndex;

  setUp(() {
    topCount = 0;
    middleCount = 0;
    bottomCount = 0;
    topEnd = 0;
    middleEnd = 0;
    bottomEnd = 0;
    selectedIndex = 0;

    top = ResizableRegionChangeNotifier(
      ResizableRegion(initialSize: 25, sliderSize: 5, builder: (_, __, ___) => const SizedBox(), onResizeEnd: (_) => topEnd++),
      RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 60), min: 0, max: 25),
    )..addListener(() => topCount++);

    middle = ResizableRegionChangeNotifier(
      ResizableRegion(initialSize: 15, sliderSize: 5, builder: (_, __, ___) => const SizedBox(), onResizeEnd: (_) => middleEnd++),
      RegionSnapshot(index: 1, selected: true, constraints: (min: 10, max: 60), min: 25, max: 40),
    )..addListener(() => middleCount++);

    bottom = ResizableRegionChangeNotifier(
      ResizableRegion(initialSize: 20, sliderSize: 5, builder: (_, __, ___) => const SizedBox(), onResizeEnd: (_) => bottomEnd++),
      RegionSnapshot(index: 1, selected: true, constraints: (min: 10, max: 60), min: 40, max: 60),
    )..addListener(() => bottomCount++);

    model = ResizableBoxModel([top, middle, bottom], (index) => selectedIndex = index , 60, 0);
  });

  for (final (index, constructor) in [
    () => ResizableBoxModel([top, bottom], null, 60, -1),
    () => ResizableBoxModel([top, bottom], null, 60, 2),
    () => ResizableBoxModel([top], null, 60, 0),
  ].indexed) {
    test('[$index] constructor throws error', () => expect(constructor, throwsAssertionError));
  }


  for (final (i, (index, direction, offset, (topMin, topMax), (middleMin, middleMax))) in [
    (1, Direction.left, const Offset(-100, 0), (0, 10), (10, 40)),
    (1, Direction.left, const Offset(100, 0), (0, 30), (30, 40)),

    (0, Direction.right, const Offset(-100, 0), (0, 10), (10, 40)),
    (0, Direction.right, const Offset(100, 0), (0, 30), (30, 40)),

    (1, Direction.top, const Offset(0, -100), (0, 10), (10, 40)),
    (1, Direction.top, const Offset(0, 100), (0, 30), (30, 40)),

    (0, Direction.bottom, const Offset(0, -100), (0, 10), (10, 40)),
    (0, Direction.bottom, const Offset(0, 100), (0, 30), (30, 40)),
  ].indexed) {
    test('[$i] update(...) direction', () {
      model.update(index, direction, offset);

      expect(top.snapshot.min, topMin);
      expect(top.snapshot.max, topMax);
      expect(middle.snapshot.min, middleMin);
      expect(middle.snapshot.max, middleMax);
      expect(bottom.snapshot.min, 40);
      expect(bottom.snapshot.max, 60);

      expect(topCount, 1);
      expect(middleCount, 1);
      expect(bottomCount, 0);
    });
  }

  for (final (i, (index, direction, offset)) in [
    (0, Direction.left, const Offset(-100, 0)),
    (0, Direction.left, const Offset(100, 0)),

    (2, Direction.right, const Offset(-100, 0)),
    (2, Direction.right, const Offset(100, 0)),
    
    (0, Direction.top, const Offset(0, -100)),
    (0, Direction.top, const Offset(0, 100)),

    (2, Direction.bottom, const Offset(0, -100)),
    (2, Direction.bottom, const Offset(0, 100)),
  ].indexed) {
    test('[$i] update(...) edge does not cause update', () {
      model.update(index, direction, offset);

      expect(top.snapshot.min, 0);
      expect(top.snapshot.max, 25);
      expect(middle.snapshot.min, 25);
      expect(middle.snapshot.max, 40);
      expect(bottom.snapshot.min, 40);
      expect(bottom.snapshot.max, 60);

      expect(topCount, 0);
      expect(middleCount, 0);
      expect(bottomCount, 0);
    });
  }


  for (final (i, (index, direction)) in [
    (1, Direction.left),
    (1, Direction.left),

    (0, Direction.right),
    (0, Direction.right),

    (1, Direction.top),
    (1, Direction.top),

    (0, Direction.bottom),
    (0, Direction.bottom),
  ].indexed) {
    test('[$i] end calls callback', () {
      model.end(index, direction);

      expect(topEnd, 1);
      expect(middleEnd, 1);
      expect(bottomEnd, 0);
    });
  }


  test('selected bottom', () {
    expect(model.selected, 0);
    expect(selectedIndex, 0);

    model.selected = 2;

    expect(model.selected, 2);
    expect(selectedIndex, 2);

    expect(top.snapshot.min, 0);
    expect(top.snapshot.max, 25);
    expect(middle.snapshot.min, 25);
    expect(middle.snapshot.max, 40);
    expect(bottom.snapshot.min, 40);
    expect(bottom.snapshot.max, 60);

    expect(topCount, 1);
    expect(middleCount, 0);
    expect(bottomCount, 1);
  });

}
