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
  late int selectedIndex;
  (RegionSnapshot, RegionSnapshot)? resize;

  setUp(() {
    topCount = 0;
    middleCount = 0;
    bottomCount = 0;
    selectedIndex = 0;
    resize = null;

    top = ResizableRegionChangeNotifier(
      ResizableRegion(initialSize: 25, sliderSize: 5, builder: (_, __, ___) => const SizedBox()),
      RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 60), min: 0, max: 25),
    )..addListener(() => topCount++);

    middle = ResizableRegionChangeNotifier(
      ResizableRegion(initialSize: 15, sliderSize: 5, builder: (_, __, ___) => const SizedBox()),
      RegionSnapshot(index: 1, selected: true, constraints: (min: 10, max: 60), min: 25, max: 40),
    )..addListener(() => middleCount++);

    bottom = ResizableRegionChangeNotifier(
      ResizableRegion(initialSize: 20, sliderSize: 5, builder: (_, __, ___) => const SizedBox()),
      RegionSnapshot(index: 1, selected: true, constraints: (min: 10, max: 60), min: 40, max: 60),
    )..addListener(() => bottomCount++);

    model = ResizableBoxModel(
      [top, middle, bottom],
      60,
      0.0,
      0,
      (index) => selectedIndex = index,
      (selected, neighbour) => resize = (selected, neighbour),
    );
  });

  for (final (index, constructor) in [
    () => ResizableBoxModel([top, bottom], 60, 0.0, -1, null, null),
    () => ResizableBoxModel([top, bottom], 60, 0.0, 2, null, null),
    () => ResizableBoxModel([top], 60, 0.0, 0, null, null),
  ].indexed) {
    test('[$index] constructor throws error', () => expect(constructor, throwsAssertionError));
  }


  for (final (i, (index, direction, offset, (topMin, topMax), (middleMin, middleMax), maximized)) in [
    (1, Direction.left, const Offset(-100, 0), (0, 10), (10, 40), false),
    (1, Direction.left, const Offset(100, 0), (0, 30), (30, 40), false),

    (0, Direction.right, const Offset(-100, 0), (0, 10), (10, 40), false),
    (0, Direction.right, const Offset(100, 0), (0, 30), (30, 40), false),

    (1, Direction.top, const Offset(0, -100), (0, 10), (10, 40), false),
    (1, Direction.top, const Offset(0, 100), (0, 30), (30, 40), false),

    (0, Direction.bottom, const Offset(0, -100), (0, 10), (10, 40), false),
    (0, Direction.bottom, const Offset(0, 100), (0, 30), (30, 40), false),
  ].indexed) {
    test('[$i] update(...) direction', () {
      expect(model.update(index, direction, offset), maximized);

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

  for (final (i, (selected, neighbour, direction)) in [
    (1, 0, Direction.left),
    (1, 0, Direction.left),

    (0, 1, Direction.right),
    (0, 1, Direction.right),

    (1, 0, Direction.top),
    (1, 0, Direction.top),

    (0, 1, Direction.bottom),
    (0, 1, Direction.bottom),
  ].indexed) {
    test('[$i] end calls callback', () {
      model.end(selected, direction);

      expect(resize?.$1.index, selected);
      expect(resize?.$2.index, neighbour);
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
