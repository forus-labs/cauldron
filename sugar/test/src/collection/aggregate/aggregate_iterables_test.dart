import 'package:test/test.dart';

import 'package:sugar/collection_aggregate.dart';

void main() {
  group('AggregateIterable', () {
    group('nums', () {
      group('average(...)', () {
        test('empty', () => expect(<(num,)>[].average((e) => e.$1).isNaN, true));

        test('single', () => expect(<(num,)>[(1.0,)].average((e) => e.$1), closeTo(1.0, 0.0000000001)));

        test(
          'whole number',
          () => expect(<(num,)>[(1.0,), (2,), (3,)].average((e) => e.$1), closeTo(2.0, 0.0000000001)),
        );

        test(
          'fraction',
          () => expect(<(num,)>[(1.0,), (2,), (3.0,), (0.0,)].average((e) => e.$1), closeTo(1.5, 0.0000000001)),
        );

        test('NaN', () => expect(<(num,)>[(1.0,), (2,), (double.nan,)].average((e) => e.$1).isNaN, true));
      });

      group('sum(...)', () {
        test('empty', () => expect(<(num,)>[].sum((e) => e.$1), closeTo(0, 0.0000000001)));

        test('single int', () => expect(<(num,)>[(1,)].sum((e) => e.$1), 1));

        test('single double', () => expect(<(num,)>[(1.0,)].sum((e) => e.$1), closeTo(1.0, 0.0000000001)));

        test('multiple values', () => expect(<(num,)>[(1.0,), (-2,)].sum((e) => e.$1), closeTo(-1.0, 0.0000000001)));

        test('multiple values, NaN', () => expect(<(num,)>[(1.0,), (2,), (double.nan,)].sum((e) => e.$1).isNaN, true));
      });
    });

    group('ints', () {
      group('average(...)', () {
        test('empty', () => expect(<(int,)>[].average((e) => e.$1).isNaN, true));

        test('single', () => expect(<(int,)>[(1,)].average((e) => e.$1), closeTo(1, 0.0000000001)));

        test('whole number', () => expect(<(int,)>[(1,), (2,), (3,)].average((e) => e.$1), closeTo(2.0, 0.0000000001)));

        test(
          'fraction',
          () => expect(<(int,)>[(1,), (2,), (3,), (0,)].average((e) => e.$1), closeTo(1.5, 0.0000000001)),
        );
      });

      group('sum(...)', () {
        test('empty', () => expect(<(int,)>[].sum((e) => e.$1), 0));

        test('single', () => expect(<(int,)>[(1,)].sum((e) => e.$1), 1));

        test('multiple values', () => expect(<(int,)>[(1,), (-2,), (3,)].sum((e) => e.$1), 2));
      });
    });

    group('doubles', () {
      group('average(...)', () {
        test('empty', () => expect(<(double,)>[].average((e) => e.$1).isNaN, true));

        test('single', () => expect(<(double,)>[(1.0,)].average((e) => e.$1), closeTo(1.0, 0.0000000001)));

        test(
          'whole number',
          () => expect(<(double,)>[(1.0,), (2.0,), (3.0,)].average((e) => e.$1), closeTo(2.0, 0.0000000001)),
        );

        test(
          'fraction',
          () => expect(<(double,)>[(1.0,), (2.0,), (3.0,), (0.0,)].average((e) => e.$1), closeTo(1.5, 0.0000000001)),
        );

        test('NaN', () => expect(<(double,)>[(1.0,), (2.0,), (double.nan,)].average((e) => e.$1).isNaN, true));
      });

      group('sum(...)', () {
        test('empty', () => expect(<(double,)>[].sum((e) => e.$1), 0));

        test('single double', () => expect(<(double,)>[(1.0,)].sum((e) => e.$1), closeTo(1.0, 0.0000000001)));

        test(
          'multiple values',
          () => expect(<(double,)>[(1.0,), (-2.0,)].sum((e) => e.$1), closeTo(-1.0, 0.0000000001)),
        );

        test(
          'multiple values, NaN',
          () => expect(<(double,)>[(1.0,), (2.0,), (double.nan,)].sum((e) => e.$1).isNaN, true),
        );
      });
    });
  });

  group('AggregateComparableIterable', () {
    group('min', () {
      test('empty', () => expect(<String>[].min, null));

      test('single value', () => expect(['a'].min, 'a'));

      test('multiple values, duplicate values', () => expect(['2', '1', '3', '1', '2'].min, '1'));

      test('multiple values, min first', () => expect(['1', '2', '3'].min, '1'));

      test('multiple values, min not first', () => expect(['2', '1', '3'].min, '1'));
    });

    group('max', () {
      test('empty', () => expect(<String>[].max, null));

      test('single value', () => expect(['1'].max, '1'));

      test('multiple values, duplicate values', () => expect(['2', '3', '1', '3', '2'].max, '3'));

      test('multiple values, max first', () => expect(['3', '2', '1'].max, '3'));

      test('multiple values, max not first', () => expect(['2', '3', '1'].max, '3'));
    });
  });

  group('AggregateNumberIterable', () {
    group('nums', () {
      group('average', () {
        test('empty', () => expect(<num>[].average.isNaN, true));

        test('single', () => expect(<num>[1.0].average, closeTo(1.0, 0.0000000001)));

        test('whole number', () => expect(<num>[1.0, 2, 3].average, closeTo(2.0, 0.0000000001)));

        test('fraction', () => expect(<num>[1.0, 2.0, 3.0, 0.0].average, closeTo(1.5, 0.0000000001)));

        test('NaN', () => expect(<num>[1.0, 2, double.nan].average.isNaN, true));
      });

      group('sum', () {
        test('empty', () => expect(<num>[].sum, closeTo(0, 0.0000000001)));

        test('single int', () => expect(<num>[1].sum, 1));

        test('single double', () => expect(<num>[1.0].sum, closeTo(1.0, 0.0000000001)));

        test('multiple values', () => expect(<num>[1.0, -2].sum, closeTo(-1.0, 0.0000000001)));

        test('multiple values, NaN', () => expect(<num>[1.0, 2, double.nan].sum.isNaN, true));
      });
    });

    group('ints', () {
      group('average', () {
        test('empty', () => expect(<int>[].average.isNaN, true));

        test('single', () => expect(<int>[1].average, closeTo(1, 0.0000000001)));

        test('whole number', () => expect(<int>[1, 2, 3].average, closeTo(2.0, 0.0000000001)));

        test('fraction', () => expect(<int>[1, 2, 3, 0].average, closeTo(1.5, 0.0000000001)));
      });

      group('sum', () {
        test('empty', () => expect(<int>[].sum, 0));

        test('single', () => expect([1].sum, 1));

        test('multiple values', () => expect([1, -2, 3].sum, 2));
      });

      group('min', () {
        test('empty', () => expect(<int>[].min, null));

        test('single value', () => expect([1].min, 1));

        test('multiple values, duplicate values', () => expect([2, 1, 3, 1, 2].min, 1));

        test('multiple values, min first', () => expect([1, 2, 3].min, 1));

        test('multiple values, min not first', () => expect([2, 1, 3].min, 1));
      });

      group('max', () {
        test('empty', () => expect(<int>[].max, null));

        test('single value', () => expect([1].max, 1));

        test('multiple values, duplicate values', () => expect([2, 3, 1, 3, 2].max, 3));

        test('multiple values, max first', () => expect([3, 2, 1].max, 3));

        test('multiple values, max not first', () => expect([2, 3, 1].max, 3));
      });
    });

    group('doubles', () {
      group('average', () {
        test('empty', () => expect(<double>[].average.isNaN, true));

        test('single', () => expect(<double>[1.0].average, closeTo(1.0, 0.0000000001)));

        test('whole number', () => expect(<double>[1.0, 2.0, 3.0].average, closeTo(2.0, 0.0000000001)));

        test('fraction', () => expect(<double>[1.0, 2.0, 3.0, 0.0].average, closeTo(1.5, 0.0000000001)));

        test('NaN', () => expect(<double>[1.0, 2.0, double.nan].average.isNaN, true));
      });

      group('sum', () {
        test('empty', () => expect(<double>[].sum, 0));

        test('single double', () => expect(<double>[1.0].sum, closeTo(1.0, 0.0000000001)));

        test('multiple values', () => expect(<double>[1.0, -2].sum, closeTo(-1.0, 0.0000000001)));

        test('multiple values, NaN', () => expect(<double>[1.0, 2, double.nan].sum.isNaN, true));
      });

      group('min', () {
        test('empty', () => expect(<double>[].min, null));

        test('single value', () => expect([1.0].min, closeTo(1.0, 0.0000000001)));

        test(
          'multiple values, duplicate values',
          () => expect([2.0, 1.0, 3.0, 1.0, 2.0].min, closeTo(1.0, 0.0000000001)),
        );

        test('multiple values, min first', () => expect([1.0, 2.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min not first', () => expect([2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min not first', () => expect([2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, nan first', () => expect([double.nan, 2.0, 1.0, 3.0].min?.isNaN, true));

        test('multiple values, nan not first', () => expect([2.0, 1.0, 3.0, double.nan].min?.isNaN, true));

        test(
          'multiple values, negative infinity',
          () => expect([double.negativeInfinity, 2.0, 1.0, 3.0].min, double.negativeInfinity),
        );

        test(
          'multiple values, infinity',
          () => expect([double.infinity, 2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)),
        );
      });

      group('max', () {
        test('empty', () => expect(<double>[].max, null));

        test('single value', () => expect([1.0].max, closeTo(1.0, 0.0000000001)));

        test(
          'multiple values, duplicate values',
          () => expect([2.0, 3.0, 1.0, 3.0, 2.0].max, closeTo(3.0, 0.0000000001)),
        );

        test('multiple values, max first', () => expect([3.0, 2.0, 1.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, max not first', () => expect([2.0, 3.0, 1.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, nan first', () => expect([double.nan, 2.0, 1.0, 3.0].max?.isNaN, true));

        test('multiple values, nan not first', () => expect([2.0, 1.0, 3.0, double.nan].max?.isNaN, true));

        test(
          'multiple values, negative infinity',
          () => expect([double.negativeInfinity, 2.0, 1.0, 3.0].max, closeTo(3.0, 0.0000000001)),
        );

        test('multiple values, infinity', () => expect([double.infinity, 2.0, 1.0, 3.0].max, double.infinity));
      });
    });

    group('nums', () {
      group('min', () {
        test('empty', () => expect(<num>[].min, null));

        test('single value', () => expect(<num>[1.0].min, closeTo(1.0, 0.0000000001)));

        test(
          'multiple values, duplicate values',
          () => expect(<num>[2.0, 1.0, 3.0, 1.0, 2.0].min, closeTo(1.0, 0.0000000001)),
        );

        test('multiple values, min first', () => expect(<num>[1.0, 2.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min not first', () => expect(<num>[2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min not first', () => expect(<num>[2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, nan first', () => expect(<num>[double.nan, 2.0, 1.0, 3.0].min?.isNaN, true));

        test('multiple values, nan not first', () => expect(<num>[2.0, 1.0, 3.0, double.nan].min?.isNaN, true));

        test(
          'multiple values, negative infinity',
          () => expect(<num>[double.negativeInfinity, 2.0, 1.0, 3.0].min, double.negativeInfinity),
        );

        test(
          'multiple values, infinity',
          () => expect(<num>[double.infinity, 2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)),
        );
      });

      group('max', () {
        test('empty', () => expect(<num>[].max, null));

        test('single value', () => expect(<num>[1.0].max, closeTo(1.0, 0.0000000001)));

        test(
          'multiple values, duplicate values',
          () => expect(<num>[2.0, 3.0, 1.0, 3.0, 2.0].max, closeTo(3.0, 0.0000000001)),
        );

        test('multiple values, max first', () => expect(<num>[3.0, 2.0, 1.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, max not first', () => expect(<num>[2.0, 3.0, 1.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, nan first', () => expect(<num>[double.nan, 2.0, 1.0, 3.0].max?.isNaN, true));

        test('multiple values, nan not first', () => expect(<num>[2.0, 1.0, 3.0, double.nan].max?.isNaN, true));

        test(
          'multiple values, negative infinity',
          () => expect(<num>[double.negativeInfinity, 2.0, 1.0, 3.0].max, closeTo(3.0, 0.0000000001)),
        );

        test('multiple values, infinity', () => expect(<num>[double.infinity, 2.0, 1.0, 3.0].max, double.infinity));
      });
    });
  });
}
