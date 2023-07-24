import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/resizable/box/direction.dart';
import 'package:stevia/src/widgets/resizable/box/resizable_region_change_notifier.dart';

void main() {
  for (final (index, function) in [
    () => ResizableRegionChangeNotifier(0, 1, 1),
    () => ResizableRegionChangeNotifier(-1, 1, 1),

    () => ResizableRegionChangeNotifier(1, 1, 0),
    () => ResizableRegionChangeNotifier(1, 1, -1),

    () => ResizableRegionChangeNotifier(2, 1, 2),

    () => ResizableRegionChangeNotifier(1, 2, 2),
    () => ResizableRegionChangeNotifier(1, -1, 2),
  ].indexed) {
    test('[$index] constructor throws error', () => expect(function, throwsAssertionError));
  }

  for (final (index, (direction, delta, translated, current)) in [
    (Direction.left, const Offset(-10, 0), const Offset(-10, 0), 40),
    (Direction.left, const Offset(10, 0), const Offset(10, 0), 20),
    (Direction.left, const Offset(50, 0), const Offset(20, 0), 10),

    (Direction.right, const Offset(10, 0), const Offset(10, 0), 40),
    (Direction.right, const Offset(-10, 0), const Offset(-10, 0), 20),
    (Direction.right, const Offset(-50, 0), const Offset(-20, 0), 10),

    (Direction.top, const Offset(0, -10), const Offset(0, -10), 40),
    (Direction.top, const Offset(0, 10), const Offset(0, 10), 20),
    (Direction.top, const Offset(0, 50), const Offset(0, 20), 10),

    (Direction.bottom, const Offset(0, 10), const Offset(0, 10), 40),
    (Direction.bottom, const Offset(0, -10), const Offset(0, -10), 20),
    (Direction.bottom, const Offset(0, -50), const Offset(0, -20), 10),
  ].indexed) {
    test('[$index] update(...)', () {
      final notifier = ResizableRegionChangeNotifier(10, 30, 100);
      expect(notifier.update(direction, delta), translated);
      expect(notifier.current, current);
    });
  }

  test('update(...) beyond total', () => expect(
    () => ResizableRegionChangeNotifier(1, 2, 5).update(Direction.right, const Offset(4, 0)),
    throwsAssertionError,
  ));

  test('notify()', () {
    var called = false;
    ResizableRegionChangeNotifier(10, 30, 100)..addListener(() => called = true)..notify();
    expect(called, true);
  });
}
