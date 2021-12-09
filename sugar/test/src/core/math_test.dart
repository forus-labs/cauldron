import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  final small = DateTime.now();
  final large = small.add(const Duration(days: 1));

  group('from', () {
    for (final arguments in [
      [true, 1],
      [false, 0],
    ].pairs<bool, int>()) {
      test(arguments.key, () => expect(Integers.from(arguments.key), arguments.value));
    }
  });


  test('rounding', () {
    expect(8.roundTo(5), 10);
    expect(round(8, 5), 10);
  });

  test('ceil', () {
    expect(6.ceilTo(5), 10);
    expect(ceil(6, 5), 10);
  });

  test('floor', () {
    expect(14.floorTo(5), 10);
    expect(floor(14, 5), 10);
  });

  group('toBool', () {
    for (final arguments in [
      [4, true],
      [1, true],
      [0, false],
      [-1, false],
    ].pairs<int, bool>()) {
      test(arguments.key, () => expect(arguments.key.toBool(), arguments.value));
    }
  });

  group('comparison', () {
    for (final arguments in [
      ['a < b', small, large],
      ['a > b', large, small]
    ].triples<String, DateTime, DateTime>()) {
      test(arguments.left, () {
        expect(min(arguments.middle, arguments.right), small);
        expect(max(arguments.middle, arguments.right), large);
      });
    }
  });
}
