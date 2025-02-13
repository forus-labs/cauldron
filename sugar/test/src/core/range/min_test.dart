import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

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

    test('closed out of range', () => expect(const Min.closed(1).iterate(by: (e) => e - 1).take(5), [1]));

    test('open out of range', () => expect(const Min.open(1).iterate(by: (e) => e - 1).take(5), []));
  });

  group('gap(...)', () {
    test('max gap', () => expect(const Min.closed(3).gap(const Max.open(1)), Interval.closedOpen(1, 3)));

    test('max no gap', () => expect(const Min.closed(3).gap(const Max.closed(5)), null));

    test('interval gap', () => expect(const Min.closed(7).gap(Interval.open(1, 5)), Interval.closedOpen(5, 7)));

    test('interval no gap', () => expect(const Min.closed(5).gap(Interval.open(4, 6)), null));

    test('min no gap', () => expect(const Min.closed(3).gap(const Min.closed(5)), null));

    test('all no gap', () => expect(const Min.closed(3).gap(const Unbound()), null));
  });

  group('intersection(...)', () {
    group('min', () {
      test(
        'closed open lesser greater',
        () => expect(const Min.closed(3).intersection(const Min.open(4)), const Min.open(4)),
      );

      test(
        'open closed lesser greater',
        () => expect(const Min.open(3).intersection(const Min.closed(4)), const Min.closed(4)),
      );

      test(
        'both open lesser greater',
        () => expect(const Min.open(3).intersection(const Min.open(4)), const Min.open(4)),
      );

      test(
        'both closed lesser greater',
        () => expect(const Min.closed(3).intersection(const Min.closed(4)), const Min.closed(4)),
      );

      test(
        'closed open greater lesser',
        () => expect(const Min.closed(4).intersection(const Min.open(3)), const Min.closed(4)),
      );

      test(
        'open closed greater lesser',
        () => expect(const Min.open(4).intersection(const Min.closed(3)), const Min.open(4)),
      );

      test(
        'both open greater lesser',
        () => expect(const Min.open(4).intersection(const Min.open(3)), const Min.open(4)),
      );

      test(
        'both closed greater lesser',
        () => expect(const Min.closed(4).intersection(const Min.closed(3)), const Min.closed(4)),
      );

      test('closed open same', () => expect(const Min.closed(4).intersection(const Min.open(4)), const Min.open(4)));

      test('open closed same', () => expect(const Min.open(4).intersection(const Min.closed(4)), const Min.open(4)));

      test('both open same', () => expect(const Min.open(4).intersection(const Min.open(4)), const Min.open(4)));

      test(
        'both closed same',
        () => expect(const Min.closed(4).intersection(const Min.closed(4)), const Min.closed(4)),
      );
    });

    test(
      'interval intersection',
      () => expect(const Min.closed(5).intersection(Interval.open(4, 6)), Interval.closedOpen(5, 6)),
    );

    test('interval no intersection', () => expect(const Min.closed(5).intersection(Interval.open(1, 3)), null));

    test(
      'max intersection',
      () => expect(const Min.closed(3).intersection(const Max.open(4)), Interval.closedOpen(3, 4)),
    );

    test('max no intersection', () => expect(const Min.closed(3).intersection(const Max.closed(1)), null));

    test('all intersection', () => expect(const Min.closed(3).intersection(const Unbound()), const Min.closed(3)));
  });

  group('besides(...)', () {
    test('besides max', () => expect(const Min.open(1).besides(const Max.closed(1)), true));

    test('not besides max', () => expect(const Min.open(1).besides(const Max.open(1)), false));

    test('besides interval', () => expect(const Min.open(1).besides(Interval.closed(-1, 1)), true));

    test('not besides interval', () => expect(const Min.open(1).besides(Interval.open(-1, 1)), false));

    test('not besides min', () => expect(const Min.open(1).besides(const Min.open(1)), false));

    test('not besides all', () => expect(const Min.open(1).besides(const Unbound()), false));
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

    test('not enclose interval', () => expect(const Min.open(5).encloses(Interval.open(1, 3)), false));

    test('not enclose max', () => expect(const Min.open(1).encloses(const Max.open(3)), false));

    test('not enclose all', () => expect(const Min.open(1).encloses(const Unbound()), false));
  });

  group('intersects(...)', () {
    test('intersects max', () => expect(const Min.open(0).intersects(const Max.closed(2)), true));

    test('not intersects max', () => expect(const Min.open(5).intersects(const Max.open(1)), false));

    test('intersects interval', () => expect(const Min.open(0).intersects(Interval.closed(-1, 1)), true));

    test('not intersects interval', () => expect(const Min.open(1).intersects(Interval.open(-1, 1)), false));

    test('intersects min', () => expect(const Min.open(3).intersects(const Min.open(0)), true));

    test('intersects all', () => expect(const Min.open(1).intersects(const Unbound()), true));
  });

  test('empty', () => expect(const Min.open(1).empty, false));

  for (final (range, expected) in [
    (const Min.open(1), true),
    (const Min.open(2), false),
    (const Min.closed(1), false),
    (const Max.open(1), false),
  ]) {
    test('equality - ${const Min.open(1)} and $range', () {
      expect(const Min.open(1) == range, expected);
      expect(const Min.open(1).hashCode == range.hashCode, expected);
    });
  }

  group('toString()', () {
    test('open', () => expect(const Min.open(-1).toString(), '(-1..+∞)'));

    test('closed', () => expect(const Min.closed(-1).toString(), '[-1..+∞)'));
  });
}
