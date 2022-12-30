import 'package:sugar/core.dart';
import 'package:test/test.dart';

void main() {

  group('closedOpen(...)', () {
    test('non-empty range', () {
      final interval = Interval.closedOpen(1, 2);

      expect(interval.min, 1);
      expect(interval.minClosed, true);
      expect(interval.minOpen, false);

      expect(interval.max, 2);
      expect(interval.maxClosed, false);
      expect(interval.maxOpen, true);
    });

    test('empty range', () => expect(() => Interval.closedOpen(1, 1), returnsNormally));

    test('invalid range', () => expect(() => Interval.closedOpen(1, -1), throwsRangeError));
  });

  group('closed(...)', () {
    test('non-empty range', () {
      final interval = Interval.closed(1, 2);

      expect(interval.min, 1);
      expect(interval.minClosed, true);
      expect(interval.minOpen, false);

      expect(interval.max, 2);
      expect(interval.maxClosed, true);
      expect(interval.maxOpen, false);
    });

    test('empty range', () => expect(() => Interval.closed(1, 1), returnsNormally));

    test('invalid range', () => expect(() => Interval.closed(1, -1), throwsRangeError));
  });

  group('openClosed(...)', () {
    test('non-empty range', () {
      final interval = Interval.openClosed(1, 2);

      expect(interval.min, 1);
      expect(interval.minClosed, false);
      expect(interval.minOpen, true);

      expect(interval.max, 2);
      expect(interval.maxClosed, true);
      expect(interval.maxOpen, false);
    });

    test('empty range', () => expect(() => Interval.openClosed(1, 1), returnsNormally));

    test('invalid range', () => expect(() => Interval.openClosed(1, -1), throwsRangeError));
  });

  group('open(...)', () {
    test('non-empty range', () {
      final interval = Interval.open(1, 2);

      expect(interval.min, 1);
      expect(interval.minClosed, false);
      expect(interval.minOpen, true);

      expect(interval.max, 2);
      expect(interval.maxClosed, false);
      expect(interval.maxOpen, true);
    });

    test('empty range', () => expect(() => Interval.open(1, 1), throwsRangeError));

    test('invalid range', () => expect(() => Interval.open(1, -1), throwsRangeError));
  });

  group('contains(...)', () {
    test('contains', () => expect(Interval.open(1, 3).contains(2), true));

    test('less than', () => expect(Interval.open(1, 3).contains(0), false));

    test('more than', () => expect(Interval.open(1, 3).contains(4), false));


    test('min closed', () => expect(Interval.closed(1, 3).contains(1), true));

    test('min open', () => expect(Interval.open(1, 3).contains(1), false));

    test('max closed', () => expect(Interval.closed(1, 3).contains(3), true));

    test('max open', () => expect(Interval.open(1, 3).contains(3), false));
  });

  group('iterate(...)', () {
    test('closed-open ascending, increasing', () => expect(Interval.closedOpen(1, 5).iterate(by: (e) => e + 1), [1, 2, 3, 4]));

    test('closed-open ascending, decreasing', () => expect(Interval.closedOpen(1, 5).iterate(by: (e) => e - 1), [1]));

    test('closed-open descending, decreasing', () => expect(Interval.closedOpen(1, 5).iterate(by: (e) => e - 1, ascending: false), [4, 3, 2, 1]));

    test('closed-open descending, increasing', () => expect(Interval.closedOpen(1, 5).iterate(by: (e) => e + 1, ascending: false), []));


    test('closed ascending, increasing', () => expect(Interval.closed(1, 5).iterate(by: (e) => e + 1), [1, 2, 3, 4, 5]));

    test('closed ascending, decreasing', () => expect(Interval.closed(1, 5).iterate(by: (e) => e - 1), [1]));

    test('closed descending, decreasing', () => expect(Interval.closed(1, 5).iterate(by: (e) => e - 1, ascending: false), [5, 4, 3, 2, 1]));

    test('closed descending, increasing', () => expect(Interval.closed(1, 5).iterate(by: (e) => e + 1, ascending: false), [5]));


    test('open-closed ascending, increasing', () => expect(Interval.openClosed(1, 5).iterate(by: (e) => e + 1), [2, 3, 4, 5]));

    test('open-closed ascending, decreasing', () => expect(Interval.openClosed(1, 5).iterate(by: (e) => e - 1), []));

    test('open-closed descending, decreasing', () => expect(Interval.openClosed(1, 5).iterate(by: (e) => e - 1, ascending: false), [5, 4, 3, 2]));

    test('open-closed descending, increasing', () => expect(Interval.openClosed(1, 5).iterate(by: (e) => e + 1, ascending: false), [5]));


    test('open ascending, increasing', () => expect(Interval.open(1, 5).iterate(by: (e) => e + 1), [2, 3, 4]));

    test('open ascending, decreasing', () => expect(Interval.open(1, 5).iterate(by: (e) => e - 1), []));

    test('open descending, decreasing', () => expect(Interval.open(1, 5).iterate(by: (e) => e - 1, ascending: false), [4, 3, 2]));

    test('open descending, increasing', () => expect(Interval.open(1, 5).iterate(by: (e) => e + 1, ascending: false), []));
  });

  group('besides(...)', () {
    test('besides min', () => expect(Interval.open(1, 3).besides(const Min.closed(3)), true));

    test('not besides min', () => expect(Interval.open(1, 3).besides(const Min.closed(4)), false));


    test('besides max', () => expect(Interval.open(1, 3).besides(const Max.closed(1)), true));

    test('not besides max', () => expect(Interval.open(1, 3).besides(const Max.closed(0)), false));


    test('open besides greater closed interval', () => expect(Interval.open(1, 3).besides(Interval.closed(3, 5)), true));

    test('open not besides greater closed interval', () => expect(Interval.open(1, 3).besides(Interval.closed(5, 7)), false));

    test('open not besides greater open interval', () => expect(Interval.open(1, 3).besides(Interval.open(3, 7)), false));


    test('open besides lesser closed interval', () => expect(Interval.open(1, 3).besides(Interval.closed(0, 1)), true));

    test('open not besides lesser closed interval', () => expect(Interval.open(1, 3).besides(Interval.closed(-2, 0)), false));

    test('open not besides lesser open interval', () => expect(Interval.open(1, 3).besides(Interval.open(-2, 1)), false));


    test('closed besides greater open interval', () => expect(Interval.closed(1, 3).besides(Interval.open(3, 5)), true));

    test('closed not besides greater open interval', () => expect(Interval.closed(1, 3).besides(Interval.open(5, 7)), false));

    test('closed not besides greater closed interval', () => expect(Interval.closed(1, 3).besides(Interval.closed(3, 7)), false));


    test('closed besides lesser open interval', () => expect(Interval.closed(1, 3).besides(Interval.open(0, 1)), true));

    test('closed not besides lesser open interval', () => expect(Interval.closed(1, 3).besides(Interval.open(-2, 0)), false));

    test('closed not besides lesser closed interval', () => expect(Interval.closed(1, 3).besides(Interval.closed(-2, 1)), false));


    test('greater discrete range', () => expect(Interval.closed(1, 3).besides(Interval.closed(4, 5)), false));

    test('lesser discrete range', () => expect(Interval.closed(1, 3).besides(Interval.closed(0, 1)), false));
  });

  group('encloses(...)', () {
    test('self', () => expect(Interval.open(1, 5).encloses(Interval.open(1, 5)), true));

    test('enclose range', () => expect(Interval.closed(1, 5).encloses(Interval.closed(2, 3)), true));


    test('not enclose lesser range', () => expect(Interval.closed(1, 5).encloses(Interval.closed(-4, -1)), false));

    test('partially enclose lesser range', () => expect(Interval.closed(1, 5).encloses(Interval.closed(-4, 2)), false));

    test('not enclose greater range', () => expect(Interval.closed(1, 5).encloses(Interval.closed(7, 10)), false));

    test('partially enclose lesser range', () => expect(Interval.closed(1, 5).encloses(Interval.closed(3, 7)), false));


    test('closed min open', () => expect(Interval.closed(1, 5).encloses(Interval.open(1, 3)), true));

    test('closed min closed', () => expect(Interval.closed(1, 5).encloses(Interval.closed(1, 3)), true));

    test('open min closed', () => expect(Interval.open(1, 5).encloses(Interval.closed(1, 3)), false));

    test('open min open', () => expect(Interval.open(1, 5).encloses(Interval.open(1, 3)), true));


    test('closed max open', () => expect(Interval.closed(1, 5).encloses(Interval.open(3, 5)), true));

    test('closed max closed', () => expect(Interval.closed(1, 5).encloses(Interval.closed(3, 5)), true));

    test('open max closed', () => expect(Interval.open(1, 5).encloses(Interval.closed(3, 5)), false));

    test('open nax open', () => expect(Interval.open(1, 5).encloses(Interval.open(3, 5)), true));


    test('min', () => expect(Interval.open(1, 5).encloses(const Min.open(2)), false));

    test('max', () => expect(Interval.open(1, 5).encloses(const Max.open(3)), false));

    test('discrete range', () => expect(Interval.closed(2, 4).encloses(Interval.open(1, 5)), false));
  });

  group('intersects(...)', () {
    test('self', () => expect(Interval.closed(1, 3).intersects(Interval.closed(1, 3)), true));


    test('intersects min', () => expect(Interval.closed(1, 3).intersects(const Min.closed(2)), true));

    test('does not intersect min', () => expect(Interval.closed(1, 3).intersects(const Min.open(3)), false));


    test('intersects max', () => expect(Interval.closed(1, 3).intersects(const Max.closed(2)), true));

    test('does not intersect max', () => expect(Interval.closed(1, 3).intersects(const Max.open(1)), false));


    test('does not intersect interval', () => expect(Interval.closed(1, 3).intersects(Interval.closed(5, 7)), false));

    for (final other in [
      Interval.closed(3, 7),
      Interval.closed(-1, 3),
      Interval.closed(2, 3),
      Interval.closed(-1, 7),
    ]) {
      test('[1..5] intersects $other', () => expect(Interval.closed(1, 5).intersects(other), true));
    }
  });

  for (final interval in [
    Interval.closedOpen(1, 1),
    Interval.openClosed(1, 1),
  ]) {
    test('empty', () => expect(interval.empty, true));
  }

  for (final interval in [
    Interval.closedOpen(1, 3),
    Interval.open(1, 2),
    Interval.closed(1, 1),
  ]) {
    test('not empty', () => expect(interval.empty, false));
  }

  for (final entry in {
    Interval.open(1, 3): true,
    Interval.open(0, 4): false,
    Interval.closedOpen(1, 3): false,
    Interval.openClosed(1, 3): false,
    const Max.open(1): false,
  }.entries) {
    test('equality - ${Interval.open(1, 3)} and ${entry.key}', () {
      expect(Interval.open(1, 3) == entry.key, entry.value);
      expect(Interval.open(1, 3).hashCode == entry.key.hashCode, entry.value);
    });
  }

  group('toString()', () {
    test('closedOpen', () => expect(Interval.closedOpen(-1, 1).toString(), '[-1..1)'));

    test('closed', () => expect(Interval.closed(-1, 1).toString(), '[-1..1]'));

    test('openClosed', () => expect(Interval.openClosed(-1, 1).toString(), '(-1..1]'));

    test('open', () => expect(Interval.open(-1, 1).toString(), '(-1..1)'));
  });

}
