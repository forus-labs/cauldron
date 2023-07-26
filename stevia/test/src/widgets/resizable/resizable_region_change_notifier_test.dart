import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/resizable/direction.dart';
import 'package:stevia/src/widgets/resizable/resizable_region_change_notifier.dart';
import 'package:stevia/stevia.dart';

void main() {
  for (final (index, (direction, delta, translated, min, max)) in [
    (Direction.left, const Offset(-10, 0), const Offset(-10, 0), -10.0, 30.0),
    (Direction.left, const Offset(10, 0), const Offset(10, 0), 10.0, 30.0),
    (Direction.left, const Offset(50, 0), const Offset(20, 0), 20.0, 30.0),

    (Direction.right, const Offset(10, 0), const Offset(10, 0), 0.0, 40.0),
    (Direction.right, const Offset(-10, 0), const Offset(-10, 0), 0.0, 20.0),
    (Direction.right, const Offset(-50, 0), const Offset(-20, 0), 0.0, 10.0),

    (Direction.top, const Offset(0, -10), const Offset(0, -10), -10.0, 30.0),
    (Direction.top, const Offset(0, 10), const Offset(0, 10), 10.0, 30.0),
    (Direction.top, const Offset(0, 50), const Offset(0, 20), 20.0, 30.0),

    (Direction.bottom, const Offset(0, 10), const Offset(0, 10), 0.0, 40.0),
    (Direction.bottom, const Offset(0, -10), const Offset(0, -10), 0.0, 20.0),
    (Direction.bottom, const Offset(0, -50), const Offset(0, -20), 0.0, 10.0),
  ].indexed) {
    test('[$index] update(...) notifies listener', () {
      late RegionSnapshot snapshot;
      var count = 0;

      final notifier = ResizableRegionChangeNotifier(
        ResizableRegion(initialSize: 20, sliderSize: 5, builder: (_, __, child) => child!, onResize: (s) => snapshot = s),
        RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 100), min: 0, max: 30),
      )..addListener(() => count++);

      expect(notifier.update(direction, delta), translated);

      expect(notifier.snapshot.min, min);
      expect(notifier.snapshot.max, max);
      expect(snapshot, RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 100), min: min, max: max));
      expect(count, 1);
    });
  }

  for (final (index, (direction, delta, min, max)) in [
    (Direction.left, const Offset(10, 0), 10.0, 20.0),
    (Direction.left, const Offset(50, 0), 10.0, 20.0),

    (Direction.right, const Offset(-10, 0), 10.0, 20.0),
    (Direction.right, const Offset(-50, 0), 10.0, 20.0),

    (Direction.top, const Offset(0, 10), 10.0, 20.0),
    (Direction.top, const Offset(0, 50), 10.0, 20.0),

    (Direction.bottom, const Offset(0, -10), 10.0, 20.0),
    (Direction.bottom, const Offset(0, -50), 10.0, 20.0),
  ].indexed) {
    test('[$index] update(...) does not notify listener', () {
      var notified = false;
      final notifier = ResizableRegionChangeNotifier(
        ResizableRegion(initialSize: 20, sliderSize: 5, builder: (_, __, child) => child!, onResize: (_) => notified = true),
        RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 100), min: min, max: max),
      )..addListener(() => notified = true);

      expect(notifier.update(direction, delta), Offset.zero);

      expect(notifier.snapshot.min, min);
      expect(notifier.snapshot.max, max);
      expect(notified, false);
    });
  }

  test('update(...) beyond total', () => expect(
    () =>
      ResizableRegionChangeNotifier(
        ResizableRegion(initialSize: 20, sliderSize: 5, builder: (_, __, child) => child!),
        RegionSnapshot(index: 0, selected: true, constraints: (min: 1, max: 5), min: 0, max: 2),
      ).update(Direction.right, const Offset(4, 0)),
    throwsAssertionError,
  ));

  test('selected', () {
    var notified = false;
    final notifier = ResizableRegionChangeNotifier(
      ResizableRegion(initialSize: 20, sliderSize: 5, builder: (_, __, child) => child!, onResize: (_) => throw AssertionError()),
      RegionSnapshot(index: 0, selected: false, constraints: (min: 10, max: 100), min: 0, max: 10),
    )..addListener(() => notified = true);

    expect(notifier.selected, false);
    expect(notifier.snapshot.selected, false);

    notifier.selected = true;

    expect(notifier.selected, true);
    expect(notifier.snapshot.selected, true);
    expect(notified, true);
  });

  test('unselected', () {
    var notified = false;
    final notifier = ResizableRegionChangeNotifier(
      ResizableRegion(initialSize: 20, sliderSize: 5, builder: (_, __, child) => child!, onResize: (_) => throw AssertionError()),
      RegionSnapshot(index: 0, selected: true, constraints: (min: 10, max: 100), min: 0, max: 10),
    )..addListener(() => notified = true);

    expect(notifier.selected, true);
    expect(notifier.snapshot.selected, true);

    notifier.selected = false;

    expect(notifier.selected, false);
    expect(notifier.snapshot.selected, false);
    expect(notified, true);
  });

}
