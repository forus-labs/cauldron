import 'package:flutter_test/flutter_test.dart';

import 'package:stevia/src/widgets/foundation/color_filters.dart';

void main() {

  late List<double> matrix;

  setUp(() {
    matrix = <double>[
      9,  10, 18, 2,  25,
      25, 17, 15, 13, 8,
      22, 2,  17, 8,  10,
      13, 8,  4,  24, 25,
      6,  16, 18, 20, 6,
    ];
  });

  group('ColorFilters', () {
    test('matrix(...)', () => expect(
      () => ColorFilters.matrix(hue: 0.5, contrast: 0.6, brightness: 0.7, saturation: 0.8),
      returnsNormally,
    ));
  });

  // We only perform sanity tests. Some form of golden tests need to be performed to evaluate the filtered child.
  // It is complicated and isn't feasible at this moment (27th August 2023).
  group('Matrix5', () {
    group('hue(...)', () {
      test('normal', () {
        matrix.hue(0.1);
        expect(matrix.length, 25);
      });

      for (final (i, value) in [
        -1.1, 1.1, double.nan, double.infinity, double.negativeInfinity,
      ].indexed) {
        test('[$i] invalid value', () {
          expect(() => matrix.hue(value), throwsAssertionError);
        });
      }
    });

    group('contrast(...)', () {
      test('normal', () {
        matrix.contrast(0.1);
        expect(matrix.length, 25);
      });

      for (final (i, value) in [
        -1.1, 1.1, double.nan, double.infinity, double.negativeInfinity,
      ].indexed) {
        test('[$i] invalid value', () {
          expect(() => matrix.contrast(value), throwsAssertionError);
        });
      }
    });

    group('brightness(...)', () {
      test('normal', () {
        matrix.brightness(0.1);
        expect(matrix.length, 25);
      });

      for (final (i, value) in [
        -1.1, 1.1, double.nan, double.infinity, double.negativeInfinity,
      ].indexed) {
        test('[$i] invalid value', () {
          expect(() => matrix.brightness(value), throwsAssertionError);
        });
      }
    });

    group('saturation(...)', () {
      test('normal', () {
        matrix.saturation(0.1);
        expect(matrix.length, 25);
      });

      for (final (i, value) in [
        -1.1, 1.1, double.nan, double.infinity, double.negativeInfinity,
      ].indexed) {
        test('[$i] invalid value', () {
          expect(() => matrix.saturation(value), throwsAssertionError);
        });
      }
    });

    
    test('dotProduct(...)', () {
      final matrix = <double>[
        9,  10, 18, 2,  25,
        25, 17, 15, 13, 8,
        22, 2,  17, 8,  10,
        13, 8,  4,  24, 25,
        6,  16, 18, 20, 6,
      ]..dotProduct([
        14, 8,  1,  4,  17,
        8,  20, 16, 14, 9,
        5,  13, 9,  22, 4,
        25, 10, 3,  22, 13,
        1,  2,  4,  13, 2,
      ]);

      expect(
        matrix,
        [
          371, 576, 437, 941, 391,
          894, 881, 503, 1058, 823,
          619, 537, 271, 796, 584,
          891, 606, 349, 1105, 671,
          808, 814, 508, 1162, 590,
        ],
      );
    });
  });

}
