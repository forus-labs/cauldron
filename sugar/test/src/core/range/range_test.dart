import 'package:sugar/src/core/range/range.dart';

import 'package:test/test.dart';

void main() {

  group('Range', () {
    test('containsAll(...) contains all', () => expect(const Max.open(5).containsAll([1, 2]), true));

    test('containsAll(...) does not contain all', () => expect(const Max.open(5).containsAll([1, 2, 6]), false));
  });

  group('Besides', () {
    group('minMax(...)', () {
      test('besides, min closed max open', () => expect(Besides.minMax(const Min.closed(3), const Max.open(3)), true));

      test('besides, min open max closed', () => expect(Besides.minMax(const Min.open(3), const Max.closed(3)), true));

      test('both closed', () => expect(Besides.minMax(const Min.closed(3), const Max.closed(3)), false));

      test('both open', () => expect(Besides.minMax(const Min.open(3), const Max.open(3)), false));

      test('gap', () => expect(Besides.minMax(const Min.open(5), const Max.closed(3)), false));

      test('intersection', () => expect(Besides.minMax(const Min.open(1), const Max.closed(3)), false));

      test('discrete range', () => expect(Besides.minMax(const Min.closed(4), const Max.closed(3)), false));
    });

    group('minInterval(...)', () {
      test('besides, min closed interval open', () => expect(Besides.minInterval(const Min.closed(3), Interval.open(1, 3)), true));

      test('besides, min open interval closed', () => expect(Besides.minInterval(const Min.open(3), Interval.closed(1, 3)), true));

      test('both closed', () => expect(Besides.minInterval(const Min.closed(3), Interval.closed(1, 3)), false));

      test('both open', () => expect(Besides.minInterval(const Min.open(3), Interval.open(1, 3)), false));

      test('gap', () => expect(Besides.minInterval(const Min.open(5), Interval.open(1, 3)), false));

      test('intersection', () => expect(Besides.minInterval(const Min.open(3), Interval.open(1, 5)), false));

      test('discrete range', () => expect(Besides.minInterval(const Min.closed(4), Interval.closed(1, 3)), false));
    });

    group('maxInterval(...)', () {
      test('besides, max closed interval open', () => expect(Besides.maxInterval(const Max.closed(1), Interval.open(1, 3)), true));

      test('besides, max open interval closed', () => expect(Besides.maxInterval(const Max.open(1), Interval.closed(1, 3)), true));

      test('both closed', () => expect(Besides.maxInterval(const Max.closed(1), Interval.closed(1, 3)), false));

      test('both open', () => expect(Besides.maxInterval(const Max.open(1), Interval.open(1, 3)), false));

      test('gap', () => expect(Besides.maxInterval(const Max.closed(1), Interval.open(3, 5)), false));

      test('intersection', () => expect(Besides.maxInterval(const Max.open(3), Interval.open(1, 5)), false));

      test('discrete range', () => expect(Besides.maxInterval(const Max.closed(0), Interval.closed(1, 3)), false));
    });
  });
  
  group('Intersects', () {
    group('minMax(...)', () {
      test('intersection', () => expect(Intersects.minMax(const Min.open(5), const Max.open(8)), true));

      test('both closed', () => expect(Intersects.minMax(const Min.closed(5), const Max.closed(5)), true));

      test('both open', () => expect(Intersects.minMax(const Min.open(5), const Max.open(5)), false));

      test('min closed, max open', () => expect(Intersects.minMax(const Min.closed(5), const Max.open(5)), false));

      test('min open, max closed', () => expect(Intersects.minMax(const Min.open(5), const Max.closed(5)), false));

      test('no intersection', () => expect(Intersects.minMax(const Min.open(5), const Max.closed(1)), false));
    });

    group('minInterval(...)', () {
      test('partial intersection', () => expect(Intersects.minInterval(const Min.open(5), Interval.open(3, 7)), true));

      test('complete intersection', () => expect(Intersects.minInterval(const Min.open(5), Interval.open(6, 8)), true));

      test('both closed', () => expect(Intersects.minInterval(const Min.closed(5), Interval.closed(3, 5)), true));

      test('both open', () => expect(Intersects.minInterval(const Min.open(5), Interval.open(3, 5)), false));

      test('min closed, interval open', () => expect(Intersects.minInterval(const Min.closed(5), Interval.open(3, 5)), false));

      test('min open, interval closed', () => expect(Intersects.minInterval(const Min.open(5), Interval.closed(3, 5)), false));

      test('no intersection', () => expect(Intersects.minInterval(const Min.open(5), Interval.closed(1, 3)), false));
    });

    group('maxInterval(...)', () {
      test('partial intersection', () => expect(Intersects.maxInterval(const Max.open(5), Interval.open(3, 7)), true));

      test('complete intersection', () => expect(Intersects.maxInterval(const Max.open(5), Interval.open(1, 3)), true));

      test('both closed', () => expect(Intersects.maxInterval(const Max.closed(5), Interval.closed(5, 7)), true));

      test('both open', () => expect(Intersects.maxInterval(const Max.open(5), Interval.open(5, 7)), false));

      test('max closed, interval open', () => expect(Intersects.maxInterval(const Max.closed(5), Interval.open(5, 7)), false));

      test('max open, interval closed', () => expect(Intersects.maxInterval(const Max.open(5), Interval.closed(5, 7)), false));

      test('no intersection', () => expect(Intersects.maxInterval(const Max.open(-1), Interval.closed(1, 3)), false));
    });

    group('within(...)', () {
      test('middle', () => expect(Intersects.within(Interval.closed(1, 5), (value: 3, open: false)), true));

      test('less than', () => expect(Intersects.within(Interval.closed(1, 5), (value: 0, open: false)), false));

      test('more than', () => expect(Intersects.within(Interval.closed(1, 5), (value: 6, open: false)), false));


      test('min, both closed', () => expect(Intersects.within(Interval.closed(1, 5), (value: 1, open: false)), true));

      test('min, both open', () => expect(Intersects.within(Interval.open(1, 5), (value: 1, open: true)), false));

      test('min closed point open', () => expect(Intersects.within(Interval.closed(1, 5), (value: 1, open: true)), false));

      test('min open point closed', () => expect(Intersects.within(Interval.open(1, 5), (value: 1, open: false)), false));


      test('max, both closed', () => expect(Intersects.within(Interval.closed(1, 5), (value: 5, open: false)), true));

      test('max, both open', () => expect(Intersects.within(Interval.open(1, 5), (value: 5, open: true)), false));

      test('max closed point open', () => expect(Intersects.within(Interval.closed(1, 5), (value: 5, open: true)), false));

      test('max open point closed', () => expect(Intersects.within(Interval.open(1, 5), (value: 5, open: false)), false));
    });
  });

}
