import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  final small = DateTime.now();
  final large = small.add(const Duration(days: 1));

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

  group('comparison', () {
    for(final arguments in [
      ['a < b', small, large],
      ['a > b', large, small]
    ].triples<String, DateTime, DateTime>()) {
      test(arguments.left, () {
        expect(min(arguments.middle, arguments.right), small);
        expect(max(arguments.middle, arguments.right), large);
      });
    }
  });

  test('hash', () => expect(hash(['apple', 'banana']), 6458003090));
}