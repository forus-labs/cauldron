import 'package:test/test.dart';
import 'package:sugar/sugar.dart';

void main() {
  group('NullableNumbers', () {
    test('operator +', () {
      num? foo(num? a, num? b) => a + b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 3);
    });

    test('operator -', () {
      num? foo(num? a, num? b) => a - b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), -1);
    });

    test('operator *', () {
      num? foo(num? a, num? b) => a * b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 2);
    });

    test('operator %', () {
      num? foo(num? a, num? b) => a % b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 1);
    });

    test('operator /', () {
      num? foo(num? a, num? b) => a / b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 0.5);
    });

    test('operator ~/', () {
      num? foo(num? a, num? b) => a ~/ b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 0);
    });

    test('operator -', () {
      num? foo(num? a) => -a;

      expect(foo(null), null);
      expect(foo(1), -1);
    });

    test('operator <', () {
      bool? foo(num? a, num? b) => a < b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), true);
      expect(foo(2, 1), false);
      expect(foo(1, 1), false);
    });

    test('operator <=', () {
      bool? foo(num? a, num? b) => a <= b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), true);
      expect(foo(2, 1), false);
      expect(foo(1, 1), true);
    });

    test('operator >', () {
      bool? foo(num? a, num? b) => a > b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), false);
      expect(foo(2, 1), true);
    });

    test('operator >=', () {
      bool? foo(num? a, num? b) => a >= b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), false);
      expect(foo(2, 1), true);
      expect(foo(1, 1), true);
    });
  });

  group('NullableIntegers', () {
    test('operator &', () {
      int? foo(int? a, int? b) => a & b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 0);
    });

    test('operator |', () {
      int? foo(int? a, int? b) => a | b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 3);
    });

    test('operator ^', () {
      int? foo(int? a, int? b) => a ^ b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(3, 5), 6);
    });

    test('operator ~', () {
      int? foo(int? a) => ~a;

      expect(foo(null), null);
      expect(foo(1), -2);
    });

    test('operator <<', () {
      int? foo(int? a, int? b) => a << b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 4);
    });

    test('operator >>', () {
      int? foo(int? a, int? b) => a >> b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(4, 2), 1);
    });

    test('operator >>>', () {
      int? foo(int? a, int? b) => a >>> b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(9, 2), 2);
    });

    test('operator +', () {
      int? foo(int? a, int? b) => a + b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 3);
    });

    test('operator -', () {
      int? foo(int? a, int? b) => a - b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), -1);
    });

    test('operator *', () {
      int? foo(int? a, int? b) => a * b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 2);
    });

    test('operator %', () {
      int? foo(int? a, int? b) => a % b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 1);
    });

    test('operator -', () {
      int? foo(int? a) => -a;

      expect(foo(null), null);
      expect(foo(1), -1);
    });
  });

  group('NullableDoubles', () {
    test('operator +', () {
      double? foo(double? a, double? b) => a + b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 3);
    });

    test('operator -', () {
      double? foo(double? a, double? b) => a - b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), -1);
    });

    test('operator *', () {
      double? foo(double? a, double? b) => a * b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 2);
    });

    test('operator %', () {
      double? foo(double? a, double? b) => a % b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 1);
    });

    test('operator /', () {
      double? foo(double? a, double? b) => a / b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 0.5);
    });

    test('operator ~/', () {
      int? foo(double? a, double? b) => a ~/ b;

      expect(foo(1, null), null);
      expect(foo(null, 1), null);
      expect(foo(1, 2), 0);
    });

    test('operator -()', () {
      double? foo(double? a) => -a;

      expect(foo(null), null);
      expect(foo(1), -1);
    });
  });
}
