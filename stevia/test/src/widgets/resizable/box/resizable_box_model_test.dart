import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/src/widgets/resizable/box/direction.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_box_model.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_region_change_notifier.dart';

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

    top = ResizableRegionChangeNotifier(10, 25, 60)..addListener(() => topCount++);
    middle = ResizableRegionChangeNotifier(10, 15, 60)..addListener(() => middleCount++);
    bottom = ResizableRegionChangeNotifier(10, 20, 60)..addListener(() => bottomCount++);

    model = ResizableBoxModel([top, middle, bottom], 0);
  });

  for (final (index, constructor) in [
    () => ResizableBoxModel([top, bottom], -1),
    () => ResizableBoxModel([top, bottom], 2),
    () => ResizableBoxModel([top], 0),
  ].indexed) {
    test('[$index] constructor throws error', () => expect(constructor, throwsAssertionError));
  }


  for (final (i, (index, direction, offset, topSize, middleSize)) in [
    (1, Direction.left, const Offset(-100, 0), 10, 30),
    (1, Direction.left, const Offset(100, 0), 30, 10),

    (0, Direction.right, const Offset(-100, 0), 10, 30),
    (0, Direction.right, const Offset(100, 0), 30, 10),

    (1, Direction.top, const Offset(0, -100), 10, 30),
    (1, Direction.top, const Offset(0, 100), 30, 10),

    (0, Direction.bottom, const Offset(0, -100), 10, 30),
    (0, Direction.bottom, const Offset(0, 100), 30, 10),
  ].indexed) {
    test('[$i] update(...) direction', () {
      model.update(index, direction, offset);

      expect(top.current, topSize);
      expect(middle.current, middleSize);
      expect(bottom.current, 20);

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

      expect(top.current, 25);
      expect(middle.current, 15);
      expect(bottom.current, 20);

      expect(topCount, 0);
      expect(middleCount, 0);
      expect(bottomCount, 0);
    });
  }


  test('selected bottom', () {
    expect(model.selected, 0);
    model.selected = 2;

    expect(model.selected, 2);

    expect(top.current, 25);
    expect(middle.current, 15);
    expect(bottom.current, 20);

    expect(topCount, 1);
    expect(middleCount, 0);
    expect(bottomCount, 1);
  });

}
