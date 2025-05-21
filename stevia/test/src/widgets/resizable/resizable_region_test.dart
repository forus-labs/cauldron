import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stevia/stevia.dart';

Widget stub(BuildContext context, RegionSnapshot snapshot, Widget? child) => child!;

void main() {
  group('RegionSnapshot', () {
    for (final (index, function) in [
      () => RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: -2), min: 1, max: 2),
      () => RegionSnapshot(index: 1, selected: false, constraints: (min: -1, max: 2), min: 1, max: 2),

      () => RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 1), min: 1, max: 2),
      () => RegionSnapshot(index: 1, selected: false, constraints: (min: 2, max: 1), min: 1, max: 2),

      () => RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 5), min: 1, max: 1),
      () => RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 5), min: 2, max: 1),

      () => RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 5), min: 1, max: 1),
      () => RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 5), min: 1, max: 10),

      () => RegionSnapshot(index: -1, selected: false, constraints: (min: 1, max: 5), min: 1, max: 3),
    ].indexed) {
      test('[$index] constructor throws error', () => expect(function, throwsAssertionError));
    }

    for (final (expected, selected, min, max) in [
      (RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 10), min: 3, max: 6), null, 3.0, 6.0),
      (RegionSnapshot(index: 1, selected: true, constraints: (min: 1, max: 10), min: 0, max: 6), true, null, 6.0),
      (RegionSnapshot(index: 1, selected: true, constraints: (min: 1, max: 10), min: 3, max: 5), true, 3.0, null),
    ]) {
      test('copyWith(...)', () => expect(
        RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 10), min: 0, max: 5).copyWith(selected: selected, min: min, max: max),
        expected,
      ));
    }

    test('percentage', () => expect(
      RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 10), min: 0, max: 5).percentage,
      (min: 0, max: 0.5),
    ));

    test('size', () => expect(
      RegionSnapshot(index: 1, selected: false, constraints: (min: 1, max: 10), min: 0, max: 5).size,
      5,
    ));
  });

  group('ResizableRegion', () {
    for (final (index, constructor) in [
      () => ResizableRegion(initialSize: 0, sliderSize: 10, builder: stub),
      () => ResizableRegion(initialSize: 10, sliderSize: 0, builder: stub),
      () => ResizableRegion(initialSize: 10, sliderSize: 10, builder: stub),
    ].indexed) {
      test('[$index] constructor throws error', () => expect(constructor, throwsAssertionError));
    }
  });

}
