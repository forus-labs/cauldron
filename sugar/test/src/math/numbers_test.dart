import 'package:sugar/math.dart';
import 'package:test/test.dart';

void main() {

  group('Booleans', () {
    test('toInt() returns 1', () => expect(true.toInt(), 1));

    test('toInt() returns 0', () => expect(false.toInt(), 1));
  });

  group('Integers', () {
    group('roundTo(...)', () {
      test('smaller than factor', () => expect(5.roundTo(10), 10));

      test('greater than mid', () => expect(27.roundTo(10), 30));

      test('less than mid', () => expect(22.roundTo(10), 20));

      test('greater than mid negative', () => expect((-6).roundTo(10), -10));

      test('less than mid negative', () => expect((-4).roundTo(10), 0));

      test('zero', () => expect(0.roundTo(3), 0));

      test('invalid factor', () => expect(() => 5.roundTo(-1), throwsRangeError));
    });

    group('ceilTo(...)', () {
      test('smaller than factor', () => expect(5.ceilTo(10), 10));

      test('greater than mid', () => expect(27.ceilTo(10), 30));

      test('less than mid', () => expect(22.ceilTo(10), 30));

      test('greater than mid negative', () => expect((-6).ceilTo(10), 0));

      test('less than mid negative', () => expect((-4).ceilTo(10), 0));

      test('zero', () => expect(0.ceilTo(3), 0));

      test('invalid factor', () => expect(() => 5.ceilTo(-1), throwsRangeError));
    });

    group('floorTo(...)', () {
      test('smaller than factor', () => expect(5.floorTo(10), 0));

      test('greater than mid', () => expect(27.floorTo(10), 20));

      test('less than mid', () => expect(22.floorTo(10), 20));

      test('greater than mid negative', () => expect((-4).floorTo(10), -10));

      test('less than mid negative', () => expect((-4).floorTo(10), -10));

      test('zero', () => expect(0.floorTo(3), 0));

      test('invalid factor', () => expect(() => 5.floorTo(-1), throwsRangeError));
    });

    for (final number in [-5, -1, 1, 5]) {
      test('$number.toBool() returns true', () => expect(number.toBool(), true));
    }

    test('toBool() returns false', () => expect(0.toBool(), false));
  });

  group('Doubles', () {
    test('approximately true', () => expect(1.0002.approximately(1.0, 0.01), true));

    test('approximately false', () => expect(1.2.approximately(1.0, 0.01), false));
  });

}
