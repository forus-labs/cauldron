import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  test('Max.open(...)', () {
    expect(const Max.open(1).open, true);
    expect(const Max.open(1).closed, false);
  });

  test('Max.closed(...)', () {
    expect(const Max.closed(1).open, false);
    expect(const Max.closed(1).closed, true);
  });

  group('contains(...)', () {
    test('contains', () => expect(const Max.closed(3).contains(1), true));

    test('does not contain', () => expect(const Max.closed(1).contains(3), false));

    test('closed', () => expect(const Max.closed(1).contains(1), true));

    test('open', () => expect(const Max.open(1).contains(1), false));
  });

  group('iterate(...)', () {
    test('closed', () => expect(const Max.closed(5).iterate(by: (e) => e - 1).take(5), [5, 4, 3, 2, 1]));

    test('open', () => expect(const Max.open(5).iterate(by: (e) => e - 1).take(5), [4, 3, 2, 1, 0]));

    test('closed out of range', () => expect(const Max.closed(5).iterate(by: (e) => e + 1).take(5), [5]));

    test('open out of range', () => expect(const Max.open(5).iterate(by: (e) => e + 1).take(5), []));
  });

  group('gap(...)', () {
    test('min gap', () => expect(const Max.open(1).gap(const Min.closed(3)), Interval.closedOpen(1, 3)));

    test('min no gap', () => expect(const Max.closed(5).gap(const Min.closed(3)), null));

    test('interval gap', () => expect(const Max.closed(5).gap(Interval.open(7, 9)), Interval.openClosed(5, 7)));

    test('interval no gap', () => expect(const Max.closed(5).gap(Interval.open(4, 6)), null));

    test('max no gap', () => expect(const Max.closed(3).gap(const Max.closed(5)), null));

    test('all no gap', () => expect(const Max.closed(3).gap(const Unbound()), null));
  });

  group('intersection(...)', () {
    group('max', () {
      test(
        'closed open lesser greater',
        () => expect(const Max.closed(3).intersection(const Max.open(4)), const Max.closed(3)),
      );

      test(
        'open closed lesser greater',
        () => expect(const Max.open(3).intersection(const Max.closed(4)), const Max.open(3)),
      );

      test(
        'both open lesser greater',
        () => expect(const Max.open(3).intersection(const Max.open(4)), const Max.open(3)),
      );

      test(
        'both closed lesser greater',
        () => expect(const Max.closed(3).intersection(const Max.closed(4)), const Max.closed(3)),
      );

      test(
        'closed open greater lesser',
        () => expect(const Max.closed(4).intersection(const Max.open(3)), const Max.open(3)),
      );

      test(
        'open closed greater lesser',
        () => expect(const Max.open(4).intersection(const Max.closed(3)), const Max.closed(3)),
      );

      test(
        'both open greater lesser',
        () => expect(const Max.open(4).intersection(const Max.open(3)), const Max.open(3)),
      );

      test(
        'both closed greater lesser',
        () => expect(const Max.closed(4).intersection(const Max.closed(3)), const Max.closed(3)),
      );

      test('closed open same', () => expect(const Max.closed(4).intersection(const Max.open(4)), const Max.open(4)));

      test('open closed same', () => expect(const Max.open(4).intersection(const Max.closed(4)), const Max.open(4)));

      test('both open same', () => expect(const Max.open(4).intersection(const Max.open(4)), const Max.open(4)));

      test(
        'both closed same',
        () => expect(const Max.closed(4).intersection(const Max.closed(4)), const Max.closed(4)),
      );
    });

    test(
      'interval intersection',
      () => expect(const Max.closed(5).intersection(Interval.open(4, 6)), Interval.openClosed(4, 5)),
    );

    test('interval no intersection', () => expect(const Max.closed(0).intersection(Interval.open(1, 3)), null));

    test(
      'min intersection',
      () => expect(const Max.closed(4).intersection(const Min.open(3)), Interval.openClosed(3, 4)),
    );

    test('min no intersection', () => expect(const Max.closed(3).intersection(const Min.closed(4)), null));

    test('all intersection', () => expect(const Max.closed(4).intersection(const Unbound()), const Max.closed(4)));
  });

  group('besides(...)', () {
    test('besides min', () => expect(const Max.open(1).besides(const Min.closed(1)), true));

    test('not besides min', () => expect(const Max.open(1).besides(const Min.open(1)), false));

    test('besides interval', () => expect(const Max.open(-1).besides(Interval.closed(-1, 1)), true));

    test('not besides interval', () => expect(const Max.open(-1).besides(Interval.open(-1, 1)), false));

    test('not besides max', () => expect(const Max.open(1).besides(const Max.open(1)), false));

    test('not besides all', () => expect(const Max.open(1).besides(const Unbound()), false));
  });

  group('encloses(...)', () {
    test('encloses max', () => expect(const Max.open(3).encloses(const Max.open(0)), true));

    test('max, both closed', () => expect(const Max.closed(0).encloses(const Max.closed(0)), true));

    test('max, both open', () => expect(const Max.open(0).encloses(const Max.open(0)), true));

    test('max, max closed, max open', () => expect(const Max.closed(0).encloses(const Max.open(0)), true));

    test('max, max open, max closed', () => expect(const Max.open(0).encloses(const Max.closed(0)), false));

    test('not encloses min', () => expect(const Max.open(0).encloses(const Max.closed(5)), false));

    test('encloses interval', () => expect(const Max.open(5).encloses(Interval.open(1, 3)), true));

    test('partially encloses interval', () => expect(const Max.open(5).encloses(Interval.open(1, 7)), false));

    test('interval, both closed', () => expect(const Max.closed(3).encloses(Interval.closed(1, 3)), true));

    test('interval, both open', () => expect(const Max.open(3).encloses(Interval.open(1, 3)), true));

    test('interval, max closed, interval open', () => expect(const Max.closed(3).encloses(Interval.open(1, 3)), true));

    test('interval, max open, interval closed', () => expect(const Max.open(3).encloses(Interval.closed(1, 3)), false));

    test('not encloses interval', () => expect(const Max.open(0).encloses(Interval.open(1, 3)), false));

    test('not enclose min', () => expect(const Max.open(3).encloses(const Min.open(1)), false));

    test('not enclose all', () => expect(const Max.open(3).encloses(const Unbound()), false));
  });

  group('intersects(...)', () {
    test('intersects min', () => expect(const Max.open(2).intersects(const Min.closed(0)), true));

    test('not intersects min', () => expect(const Max.open(1).intersects(const Min.open(5)), false));

    test('intersects interval', () => expect(const Max.open(0).intersects(Interval.closed(-1, 1)), true));

    test('not intersects interval', () => expect(const Max.open(-1).intersects(Interval.open(-1, 1)), false));

    test('intersects max', () => expect(const Max.open(0).intersects(const Max.open(3)), true));

    test('intersects all', () => expect(const Max.open(0).intersects(const Unbound()), true));
  });

  test('empty', () => expect(const Max.open(1).empty, false));

  for (final (range, expected) in [
    (const Max.open(1), true),
    (const Max.open(2), false),
    (const Max.closed(1), false),
    (const Min.open(1), false),
  ]) {
    test('equality - ${const Max.open(1)} and $range', () {
      expect(const Max.open(1) == range, expected);
      expect(const Max.open(1).hashCode == range.hashCode, expected);
    });
  }

  group('toString()', () {
    test('open', () => expect(const Max.open(-1).toString(), '(-∞..-1)'));

    test('closed', () => expect(const Max.closed(-1).toString(), '(-∞..-1]'));
  });
}
