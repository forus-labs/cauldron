import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/resizable/direction.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';

void main() {
  for (final (index, function) in [
    () => ResizableRegionChangeNotifier((min: 1, max: -2), 1, 2),
    () => ResizableRegionChangeNotifier((min: -1, max: 2), 1, 2),

    () => ResizableRegionChangeNotifier((min: 1, max: 1), 1, 2),
    () => ResizableRegionChangeNotifier((min: 2, max: 1), 1, 2),

    () => ResizableRegionChangeNotifier((min: 1, max: 5), 1, 1),
    () => ResizableRegionChangeNotifier((min: 1, max: 5), 2, 1),

    () => ResizableRegionChangeNotifier((min: 1, max: 5), 1, 1),
    () => ResizableRegionChangeNotifier((min: 1, max: 5), 1, 10),
  ].indexed) {
    test('[$index] constructor throws error', () => expect(function, throwsAssertionError));
  }

  for (final (index, (direction, delta, translated, min, max)) in [
    (Direction.left, const Offset(-10, 0), const Offset(-10, 0), -10, 30),
    (Direction.left, const Offset(10, 0), const Offset(10, 0), 10, 30),
    (Direction.left, const Offset(50, 0), const Offset(20, 0), 20, 30),

    (Direction.right, const Offset(10, 0), const Offset(10, 0), 0, 40),
    (Direction.right, const Offset(-10, 0), const Offset(-10, 0), 0, 20),
    (Direction.right, const Offset(-50, 0), const Offset(-20, 0), 0, 10),

    (Direction.top, const Offset(0, -10), const Offset(0, -10), -10, 30),
    (Direction.top, const Offset(0, 10), const Offset(0, 10), 10, 30),
    (Direction.top, const Offset(0, 50), const Offset(0, 20), 20, 30),

    (Direction.bottom, const Offset(0, 10), const Offset(0, 10), 0, 40),
    (Direction.bottom, const Offset(0, -10), const Offset(0, -10), 0, 20),
    (Direction.bottom, const Offset(0, -50), const Offset(0, -20), 0, 10),
  ].indexed) {
    test('[$index] update(...)', () {
      final notifier = ResizableRegionChangeNotifier((min: 10, max: 100), 0, 30);
      expect(notifier.update(direction, delta), translated);

      expect(notifier.min, min);
      expect(notifier.max, max);
      expect(notifier.size, max - min);
    });
  }

  test('update(...) beyond total', () => expect(
    () => ResizableRegionChangeNotifier((min: 1, max: 5), 0, 2).update(Direction.right, const Offset(4, 0)),
    throwsAssertionError,
  ));

  test('notify()', () {
    var called = false;
    ResizableRegionChangeNotifier((min: 1, max: 100), 0, 30)..addListener(() => called = true)..notify();
    expect(called, true);
  });
}
