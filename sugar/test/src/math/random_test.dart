import 'dart:math';

import 'package:test/test.dart';

import 'package:sugar/src/math/random.dart';

void main() {
  group('Randoms', () {
    group('nextBoundedInt(...)', () {
      test('negative', () => expect(FakeRandom(ints: [0]).nextBoundedInt(-5, 10), -5));

      test('min', () => expect(FakeRandom(ints: [0]).nextBoundedInt(5, 10), 5));

      test('middle', () => expect(FakeRandom(ints: [2]).nextBoundedInt(5, 10), 7));

      test('max', () => expect(FakeRandom(ints: [4]).nextBoundedInt(5, 10), 9));

      test('min = max', () => expect(() => FakeRandom(ints: [0]).nextBoundedInt(5, 5), throwsRangeError));
    });

    group('nextBoundedDouble(...)', () {
      test('negative', () => expect(FakeRandom(doubles: [0.0]).nextBoundedDouble(-5.0, 10.0), closeTo(-5.0, 0.00001)));

      test('min', () => expect(FakeRandom(doubles: [0.0]).nextBoundedDouble(5.0, 10.0), closeTo(5.0, 0.00001)));

      test('middle', () => expect(FakeRandom(doubles: [0.2]).nextBoundedDouble(5.0, 10.0), closeTo(6.0, 0.00001)));

      test('max', () => expect(FakeRandom(doubles: [0.9]).nextBoundedDouble(5.0, 10.0), closeTo(9.5, 0.00001)));


      test('NaN range', () => expect(() => FakeRandom(doubles: [0]).nextBoundedDouble(double.nan, 1.0), throwsRangeError));

      test('min = max', () => expect(() => FakeRandom(doubles: [0]).nextBoundedDouble(1.0, 1.0), throwsRangeError));

      test('infinite range', () => expect(() => FakeRandom(doubles: [0]).nextBoundedDouble(-double.maxFinite, double.maxFinite), throwsRangeError));

      test('min infinity', () => expect(() => FakeRandom(doubles: [0]).nextBoundedDouble(double.negativeInfinity, 1.0), throwsRangeError));

      test('max infinity', () => expect(() => FakeRandom(doubles: [0]).nextBoundedDouble(0.0, double.infinity), throwsRangeError));
    });
    
    group('nextWeightedBool(...)', () {
      test('negative', () => expect(() => Random().nextWeightedBool(-0.1), throwsRangeError));

      test('> 1', () => expect(() => Random().nextWeightedBool(1.1), throwsRangeError));

      test('positive infinity', () => expect(() => Random().nextWeightedBool(double.infinity), throwsRangeError));

      test('negative infinity', () => expect(() => Random().nextWeightedBool(double.negativeInfinity), throwsRangeError));

      test('true', () => expect(Random().nextWeightedBool(1), true));

      test('false', () => expect(Random().nextWeightedBool(0), false));
    });

    group('ints(...)', () {
      test('values', () async => expect(await FakeRandom(ints: [1, 2, 3, 4]).ints(length: 4, min: -2, max: 10).toList(), [-1, 0, 1, 2]));

      test('negative length', () => expect(() => FakeRandom(ints: [0]).ints(max: 2, length: -3), throwsRangeError));

      test('min = max', () => expect(() => FakeRandom(ints: [0]).ints(min: 1, max: 1), throwsRangeError));
    });

    group('doubles(...)', () {
      test('values', () async => expect(await FakeRandom(doubles: [0.1, 0.2, 0.3, 0.4]).doubles(length: 4, max: 10).toList(), [1.0, 2.0, 3.0, 4.0]));

      test('NaN range', () => expect(() => FakeRandom(doubles: [0]).doubles(min: double.nan, max: 2.0), throwsRangeError));

      test('min = max', () => expect(() => FakeRandom(doubles: [0]).doubles(min: 2.0, max: 2.0), throwsRangeError));

      test('infinite range', () => expect(() => FakeRandom(doubles: [0]).doubles(min: -double.maxFinite, max: double.maxFinite), throwsRangeError));

      test('min infinity', () => expect(() => FakeRandom(doubles: [0]).doubles(min: double.negativeInfinity, max: 2.0), throwsRangeError));

      test('max infinity', () => expect(() => FakeRandom(doubles: [0]).doubles(min: 1.0, max: double.infinity), throwsRangeError));
    });
  });

  group('FakeRandom', () {
    group('nextInt(...)', () {
      test('a', () {
        final a = ['a', 'b', 'd', 'e'];
        var i = a.length - 1;
        for (; i >= 0; i--) {
          if (a[i] == 'b') {
            break;
          }
        }

        a.insert(i + 1, 'c');
      });
      
      test('in sequence', () {
        final random = FakeRandom(ints: [1, 3]);
        expect(random.nextInt(5), 1);
        expect(random.nextInt(5), 3);
      });

      test('no more integers', () => expect(() => FakeRandom().nextInt(1), throwsStateError));

      test('max is zero', () => expect(() => FakeRandom(ints: [0]).nextInt(0), throwsRangeError));

      test('max is negative', () => expect(() => FakeRandom(ints: [0]).nextInt(-1), throwsRangeError));

      test('greater than or equal to max', () => expect(() => FakeRandom(ints: [2]).nextInt(2), throwsRangeError));

      test('less than 0', () => expect(() => FakeRandom(ints: [-1]).nextInt(2), throwsRangeError));
    });

    group('nextDoubles(...)', () {
      test('in sequence', () {
        final random = FakeRandom(doubles: [0.1, 0.2]);
        expect(random.nextDouble(), closeTo(0.1, 0.00001));
        expect(random.nextDouble(), closeTo(0.2, 0.00001));
      });

      test('no more doubles', () => expect(() => FakeRandom().nextDouble(), throwsStateError));

      test('greater than or equal to 1.0', () => expect(() => FakeRandom(doubles: [1.0]).nextDouble(), throwsRangeError));

      test('less than 0', () => expect(() => FakeRandom(doubles: [-0.1]).nextDouble(), throwsRangeError));
    });

    group('nextBool()', () {
      test('in sequence', () {
        final random = FakeRandom(bools: [false, true]);
        expect(random.nextBool(), false);
        expect(random.nextBool(), true);
      });

      test('no more booleans', () => expect(() => FakeRandom().nextBool(), throwsStateError));
    });
  });
}
