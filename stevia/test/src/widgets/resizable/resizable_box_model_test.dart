import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/src/widgets/resizable/direction.dart';
import 'package:stevia/src/widgets/resizable/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';

void main() {
  late ResizableBoxModel model;
  late ResizableRegionChangeNotifier top;
  late ResizableRegionChangeNotifier middle;
  late ResizableRegionChangeNotifier bottom;
  late int topCount;
  late int middleCount;
  late int bottomCount;

  setUp(() {
    topCount = 0;
    middleCount = 0;
    bottomCount = 0;

    top = ResizableRegionChangeNotifier((min: 10, max: 60), 0, 25)..addListener(() => topCount++);
    middle = ResizableRegionChangeNotifier((min: 10, max: 60), 25, 40)..addListener(() => middleCount++);
    bottom = ResizableRegionChangeNotifier((min: 10, max: 60), 40, 60)..addListener(() => bottomCount++);

    model = ResizableBoxModel([top, middle, bottom], 60, 0);
  });

  for (final (index, constructor) in [
    () => ResizableBoxModel([top, bottom], 60, -1),
    () => ResizableBoxModel([top, bottom], 60, 2),
    () => ResizableBoxModel([top], 60, 0),
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

      expect(top.min, topMin);
      expect(top.max, topMax);
      expect(middle.min, middleMin);
      expect(middle.max, middleMax);
      expect(bottom.min, 40);
      expect(bottom.max, 60);

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

      expect(top.min, 0);
      expect(top.max, 25);
      expect(middle.min, 25);
      expect(middle.max, 40);
      expect(bottom.min, 40);
      expect(bottom.max, 60);

      expect(topCount, 0);
      expect(middleCount, 0);
      expect(bottomCount, 0);
    });
  }


  test('selected bottom', () {
    expect(model.selected, 0);
    model.selected = 2;

    expect(model.selected, 2);

    expect(top.min, 0);
    expect(top.max, 25);
    expect(middle.min, 25);
    expect(middle.max, 40);
    expect(bottom.min, 40);
    expect(bottom.max, 60);

    expect(topCount, 1);
    expect(middleCount, 0);
    expect(bottomCount, 1);
  });

}
