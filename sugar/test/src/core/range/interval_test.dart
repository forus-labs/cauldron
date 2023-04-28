import 'package:sugar/sugar.dart';
import 'package:sugar/src/core/range/interval.dart';
import 'package:test/test.dart';

void main() {

  group('Interval', () {
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

    group('empty(...)', () {
      const interval = Interval.empty(1);

      test('empty', () => expect(interval.contains(1), false));

      test('same as Interval.closedOpen(1, 1)', () => expect(interval, Interval.closedOpen(1, 1)));
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

    group('gap(...)', () {
      test('min gap', () => expect(Interval.closed(3, 5).gap(const Min.open(7)), Interval.openClosed(5, 7)));

      test('min no gap', () => expect(Interval.closed(3, 5).gap(const Min.closed(5)), null));

      test('interval gap', () => expect(Interval.closed(3, 5).gap(Interval.open(7, 9)), Interval.openClosed(5, 7)));

      test('interval no gap', () => expect(Interval.closed(3, 5).gap(Interval.open(4, 6)), null));

      test('max gap', () => expect(Interval.closed(3, 5).gap(const Max.open(1)), Interval.closedOpen(1, 3)));

      test('max no gap', () => expect(Interval.closed(3, 5).gap(const Max.closed(5)), null));
      
      test('all no gap', () => expect(Interval.closed(3, 5).gap(Range.all()), null));
    });

    group('intersection(...)', () {
      test('min intersection', () => expect(Interval.closed(3, 5).intersection(const Min.open(4)), Interval.openClosed(4, 5)));

      test('min no intersection', () => expect(Interval.closed(3, 5).intersection(const Min.closed(7)), null));

      test('interval intersection', () => expect(Interval.closed(3, 5).intersection(Interval.open(4, 6)), Interval.openClosed(4, 5)));

      test('interval no intersection', () => expect(Interval.closed(3, 5).intersection(Interval.open(7, 9)), null));

      test('max intersection', () => expect(Interval.closed(3, 5).intersection(const Max.open(4)), Interval.closedOpen(3, 4)));

      test('max no intersection', () => expect(Interval.closed(3, 5).intersection(const Max.closed(1)), null));

      test('all intersection', () => expect(Interval.closed(3, 5).intersection(Range.all()), Interval.closed(3, 5)));
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


      test('all not besides', () => expect(Interval.closed(1, 3).besides(Range.all()), false));
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


      test('not enclose all', () => expect(Interval.closed(1, 3).encloses(Range.all()), false));

    });

    group('intersects(...)', () {
      test('self', () => expect(Interval.closed(1, 3).intersects(Interval.closed(1, 3)), true));


      test('intersects min', () => expect(Interval.closed(1, 3).intersects(const Min.closed(2)), true));

      test('does not intersect min', () => expect(Interval.closed(1, 3).intersects(const Min.open(3)), false));


      test('intersects max', () => expect(Interval.closed(1, 3).intersects(const Max.closed(2)), true));

      test('does not intersect max', () => expect(Interval.closed(1, 3).intersects(const Max.open(1)), false));


      test('does not intersect interval', () => expect(Interval.closed(1, 3).intersects(Interval.closed(5, 7)), false));

      test('intersects all', () => expect(Interval.closed(1, 3).intersects(Range.all()), true));

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
  });

  group('Gaps', () {
    group('minMax(...)', () {
      test('open closed gap', () => expect(Gaps.minMax(const Min.open(3), const Max.closed(1)), Interval.openClosed(1, 3)));

      test('closed open gap', () => expect(Gaps.minMax(const Min.closed(3), const Max.open(1)), Interval.closedOpen(1, 3)));

      test('invalid gap', () => expect(Gaps.minMax(const Min.closed(3), const Max.closed(3)), null));

      test('no gap', () => expect(Gaps.minMax(const Min.open(1), const Max.closed(3)), null));
    });

    group('minInterval(...)', () {
      test('open closed gap', () => expect(Gaps.minInterval(const Min.open(3),Interval.closed(-1, 1)), Interval.openClosed(1, 3)));

      test('closed open gap', () => expect(Gaps.minInterval(const Min.closed(3),Interval.open(-1, 1)), Interval.closedOpen(1, 3)));

      test('invalid gap', () => expect(Gaps.minInterval(const Min.closed(3),Interval.closed(-1, 3)), null));

      test('no gap', () => expect(Gaps.minInterval(const Min.closed(3),Interval.closed(-1, 6)), null));
    });

    group('maxInterval(...)', () {
      test('open closed gap', () => expect(Gaps.maxInterval(const Max.closed(1),Interval.open(3, 5)), Interval.openClosed(1, 3)));

      test('closed open gap', () => expect(Gaps.maxInterval(const Max.open(1),Interval.closed(3, 5)), Interval.closedOpen(1, 3)));

      test('invalid gap', () => expect(Gaps.maxInterval(const Max.closed(3),Interval.closed(3, 5)), null));

      test('no gap', () => expect(Gaps.maxInterval(const Max.closed(4),Interval.closed(3, 5)), null));
    });

    group('intervalInterval(...)', () {
      group('lower greater', () {
        test('open closed', () => expect(Gaps.intervalInterval(Interval.closed(1, 3), Interval.open(5, 7)), Interval.openClosed(3, 5)));

        test('closed open', () => expect(Gaps.intervalInterval(Interval.open(1, 3), Interval.closed(5, 7)), Interval.closedOpen(3, 5)));

        test('no gap', () => expect(Gaps.intervalInterval(Interval.open(1, 6), Interval.closed(5, 7)), null));

        test('touching, both closed', () => expect(Gaps.intervalInterval(Interval.closed(1, 3), Interval.closed(3, 5)), null));

        test('touching, both open', () => expect(Gaps.intervalInterval(Interval.open(1, 3), Interval.open(3, 5)), Interval.closed(3, 3)));

        test('touching, open closed', () => expect(Gaps.intervalInterval(Interval.open(1, 3), Interval.closed(3, 5)), Interval.closedOpen(3, 3)));

        test('touching, closed open', () => expect(Gaps.intervalInterval(Interval.closed(1, 3), Interval.open(3, 5)), Interval.openClosed(3, 3)));
      });

      group('greater lower', () {
        test('open closed gap', () => expect(Gaps.intervalInterval(Interval.open(5, 7), Interval.closed(1, 3)), Interval.openClosed(3, 5)));

        test('closed open gap', () => expect(Gaps.intervalInterval(Interval.closed(5, 7), Interval.open(1, 3)), Interval.closedOpen(3, 5)));

        test('no gap', () => expect(Gaps.intervalInterval(Interval.open(5, 7), Interval.closed(1, 6)), null));

        test('touching, both closed', () => expect(Gaps.intervalInterval(Interval.closed(3, 5), Interval.closed(1, 3)), null));

        test('touching, both open', () => expect(Gaps.intervalInterval(Interval.open(3, 5), Interval.open(1, 3)), Interval.closed(3, 3)));

        test('touching, open closed', () => expect(Gaps.intervalInterval(Interval.open(3, 5), Interval.closed(1, 3)), Interval.openClosed(3, 3)));

        test('touching, closed open', () => expect(Gaps.intervalInterval(Interval.closed(3, 5), Interval.open(1, 3)), Interval.closedOpen(3, 3)));
      });
    });
  });

  group('Intersections', () {
    group('minMax(...)', () {
      test('open closed intersection', () => expect(Intersections.minMax(const Min.open(1), const Max.closed(3)), Interval.openClosed(1, 3)));

      test('closed open intersection', () => expect(Intersections.minMax(const Min.closed(1), const Max.open(3)), Interval.closedOpen(1, 3)));

      test('no intersection', () => expect(Intersections.minMax(const Min.open(1), const Max.closed(1)), null));
    });

    group('minInterval(...)', () {
      test('open closed intersection', () => expect(Intersections.minInterval(const Min.open(1), Interval.closed(-1, 3)), Interval.openClosed(1, 3)));

      test('closed open intersection', () => expect(Intersections.minInterval(const Min.closed(1), Interval.open(-1, 3)), Interval.closedOpen(1, 3)));

      test('no gap', () => expect(Intersections.minInterval(const Min.open(1), Interval.closed(-1, 1)), null));
    });

    group('maxInterval(...)', () {
      test('open closed intersection', () => expect(Intersections.maxInterval(const Max.closed(3), Interval.open(1, 5)), Interval.openClosed(1, 3)));

      test('closed open intersection', () => expect(Intersections.maxInterval(const Max.open(3), Interval.closed(1, 5)), Interval.closedOpen(1, 3)));

      test('no intersection', () => expect(Intersections.maxInterval(const Max.open(3), Interval.closed(3, 5)), null));
    });

    group('intervalInterval(...)', () {
      group('lower greater', () {
        test('open closed', () => expect(Intersections.intervalInterval(Interval.closed(1, 5), Interval.open(3, 7)), Interval.openClosed(3, 5)));

        test('closed open', () => expect(Intersections.intervalInterval(Interval.open(1, 5), Interval.closed(3, 7)), Interval.closedOpen(3, 5)));

        test('no gap', () => expect(Intersections.intervalInterval(Interval.open(1, 6), Interval.closed(6, 7)), null));

        test('touching, both closed', () => expect(Intersections.intervalInterval(Interval.closed(1, 3), Interval.closed(3, 5)), Interval.closed(3, 3)));

        test('touching, both open', () => expect(Intersections.intervalInterval(Interval.open(1, 3), Interval.open(3, 5)), null));

        test('touching, open closed', () => expect(Intersections.intervalInterval(Interval.open(1, 3), Interval.closed(3, 5)), null));

        test('touching, closed open', () => expect(Intersections.intervalInterval(Interval.closed(1, 3), Interval.open(3, 5)), null));
      });

      group('greater lower', () {
        test('open closed gap', () => expect(Intersections.intervalInterval(Interval.open(3, 7), Interval.closed(1, 5)), Interval.openClosed(3, 5)));

        test('closed open gap', () => expect(Intersections.intervalInterval(Interval.closed(3, 7), Interval.open(1, 5)), Interval.closedOpen(3, 5)));

        test('no gap', () => expect(Intersections.intervalInterval(Interval.open(6, 7), Interval.closed(1, 6)), null));

        test('touching, both closed', () => expect(Intersections.intervalInterval(Interval.closed(3, 5), Interval.closed(1, 3)), Interval.closed(3, 3)));

        test('touching, both open', () => expect(Intersections.intervalInterval(Interval.open(3, 5), Interval.open(1, 3)), null));

        test('touching, open closed', () => expect(Intersections.intervalInterval(Interval.open(3, 5), Interval.closed(1, 3)), null));

        test('touching, closed open', () => expect(Intersections.intervalInterval(Interval.closed(3, 5), Interval.open(1, 3)), null));
      });
    });
  });

}
