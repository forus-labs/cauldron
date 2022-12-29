import 'package:sugar/core.dart';
import 'package:test/test.dart';

void main() {

  test('Min.open(...)', () {
    expect(const Min.open(1).open, true);
    expect(const Min.open(1).closed, false);
  });

  test('Min.closed(...)', () {
    expect(const Min.closed(1).open, false);
    expect(const Min.closed(1).closed, true);
  });

  group('contains(...)', () {
    test('contains', () => expect(const Min.closed(1).contains(3), true));

    test('does not contain', () => expect(const Min.closed(1).contains(-1), false));

    test('closed', () => expect(const Min.closed(1).contains(1), true));

    test('open', () => expect(const Min.open(1).contains(1), false));
  });

  group('iterate(...)', () {
    test('closed', () => expect(const Min.closed(1).iterate(by: (e) => e + 1).take(5), [1, 2, 3, 4, 5]));

    test('open', () => expect(const Min.open(1).iterate(by: (e) => e + 1).take(5), [2, 3, 4, 5, 6]));

    test('out of range', () => expect(const Min.open(1).iterate(by: (e) => e - 1).take(5), []));
  });

  group('besides(...)', () {
    test('besides max', () => expect(const Min.open(1).besides(const Max.closed(1)), true));

    test('not besides max', () => expect(const Min.open(1).besides(const Max.open(1)), false));

    test('besides interval', () => expect(const Min.open(1).besides(Interval.closed(-1, 1)), true));

    test('not besides interval', () => expect(const Min.open(1).besides(Interval.open(-1, 1)), false));

    test('not besides min', () => expect(const Min.open(1).besides(const Min.open(1)), false));
  });

  group('encloses(...)', () {
    test('encloses min', () => expect(const Min.open(0).encloses(const Min.open(3)), true));

    test('min, both closed', () => expect(const Min.closed(0).encloses(const Min.closed(0)), true));

    test('min, both open', () => expect(const Min.open(0).encloses(const Min.open(0)), true));

    test('min, min closed, min open', () => expect(const Min.closed(0).encloses(const Min.open(0)), true));

    test('min, min open, min closed', () => expect(const Min.open(0).encloses(const Min.closed(0)), false));

    test('not encloses min', () => expect(const Min.open(0).encloses(const Min.closed(-5)), false));


    test('encloses interval', () => expect(const Min.open(0).encloses(Interval.open(1, 3)), true));

    test('partially encloses interval', () => expect(const Min.open(5).encloses(Interval.open(1, 7)), false));

    test('interval, both closed', () => expect(const Min.closed(1).encloses(Interval.closed(1, 3)), true));

    test('interval, both open', () => expect(const Min.open(1).encloses(Interval.open(1, 3)), true));

    test('interval, min closed, interval open', () => expect(const Min.closed(1).encloses(Interval.open(1, 3)), true));

    test('interval, min open, interval closed', () => expect(const Min.open(1).encloses(Interval.closed(1, 3)), false));

    test('not encloses interval', () => expect(const Min.open(5).encloses(Interval.open(1, 3)), false));


    test('not encloses max', () => expect(const Min.open(1).encloses(const Max.open(3)), false));
  });

  group('intersects(...)', () {
    test('intersects max', () => expect(const Min.open(0).intersects(const Max.closed(2)), true));

    test('not intersects max', () => expect(const Min.open(5).intersects(const Max.open(1)), false));

    test('intersects interval', () => expect(const Min.open(0).intersects(Interval.closed(-1, 1)), true));

    test('not intersects interval', () => expect(const Min.open(1).intersects(Interval.open(-1, 1)), false));

    test('min', () => expect(const Min.open(3).intersects(const Min.open(0)), true));
  });

  test('empty', () => expect(const Min.open(1).empty, false));

  for (final entry in {
    const Min.open(1): true,
    const Min.open(2): false,
    const Min.closed(1): false,
    const Max.open(1): false,
  }.entries) {
    test('equality - ${const Min.open(1)} and ${entry.key}', () {
      expect(const Min.open(1) == entry.key, entry.value);
      expect(const Min.open(1).hashCode == entry.key.hashCode, entry.value);
    });
  }
  
  group('toString()', () {
    test('open', () => expect(const Min.open(-1).toString(), '(-1..+∞)'));

    test('open', () => expect(const Min.closed(-1).toString(), '[-1..+∞)'));
  });

}
