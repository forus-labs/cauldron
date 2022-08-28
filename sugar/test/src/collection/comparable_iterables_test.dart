import 'package:test/test.dart';

import 'package:sugar/collection.dart';

void main() {

  group('ComparableIterables', () {
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

  group('NumberIterables', () {
    group('ints', () {
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
      group('min', () {
        test('empty', () => expect(<double>[].min, null));

        test('single value', () => expect([1.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, duplicate values', () => expect([2.0, 1.0, 3.0, 1.0, 2.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min first', () => expect([1.0, 2.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min not first', () => expect([2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min not first', () => expect([2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, nan first', () => expect([double.nan, 2.0, 1.0, 3.0].min?.isNaN, true));

        test('multiple values, nan not first', () => expect([ 2.0, 1.0, 3.0, double.nan].min?.isNaN, true));

        test('multiple values, negative infinity', () => expect([double.negativeInfinity, 2.0, 1.0, 3.0].min, double.negativeInfinity));

        test('multiple values, infinity', () => expect([double.infinity, 2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));
      });

      group('max', () {
        test('empty', () => expect(<double>[].max, null));

        test('single value', () => expect([1.0].max, closeTo(1.0, 0.0000000001)));

        test('multiple values, duplicate values', () => expect([2.0, 3.0, 1.0, 3.0, 2.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, max first', () => expect([3.0, 2.0, 1.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, max not first', () => expect([2.0, 3.0, 1.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, nan first', () => expect([double.nan, 2.0, 1.0, 3.0].max?.isNaN, true));

        test('multiple values, nan not first', () => expect([ 2.0, 1.0, 3.0, double.nan].max?.isNaN, true));

        test('multiple values, negative infinity', () => expect([double.negativeInfinity, 2.0, 1.0, 3.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, infinity', () => expect([double.infinity, 2.0, 1.0, 3.0].max, double.infinity));
      });
    });

    group('nums', () {
      group('min', () {
        test('empty', () => expect(<num>[].min, null));

        test('single value', () => expect(<num>[1.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, duplicate values', () => expect(<num>[2.0, 1.0, 3.0, 1.0, 2.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min first', () => expect(<num>[1.0, 2.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min not first', () => expect(<num>[2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, min not first', () => expect(<num>[2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));

        test('multiple values, nan first', () => expect(<num>[double.nan, 2.0, 1.0, 3.0].min?.isNaN, true));

        test('multiple values, nan not first', () => expect(<num>[ 2.0, 1.0, 3.0, double.nan].min?.isNaN, true));

        test('multiple values, negative infinity', () => expect(<num>[double.negativeInfinity, 2.0, 1.0, 3.0].min, double.negativeInfinity));

        test('multiple values, infinity', () => expect(<num>[double.infinity, 2.0, 1.0, 3.0].min, closeTo(1.0, 0.0000000001)));
      });

      group('max', () {
        test('empty', () => expect(<num>[].max, null));

        test('single value', () => expect(<num>[1.0].max, closeTo(1.0, 0.0000000001)));

        test('multiple values, duplicate values', () => expect(<num>[2.0, 3.0, 1.0, 3.0, 2.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, max first', () => expect(<num>[3.0, 2.0, 1.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, max not first', () => expect(<num>[2.0, 3.0, 1.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, nan first', () => expect(<num>[double.nan, 2.0, 1.0, 3.0].max?.isNaN, true));

        test('multiple values, nan not first', () => expect(<num>[ 2.0, 1.0, 3.0, double.nan].max?.isNaN, true));

        test('multiple values, negative infinity', () => expect(<num>[double.negativeInfinity, 2.0, 1.0, 3.0].max, closeTo(3.0, 0.0000000001)));

        test('multiple values, infinity', () => expect(<num>[double.infinity, 2.0, 1.0, 3.0].max, double.infinity));
      });
    });
  });

}
