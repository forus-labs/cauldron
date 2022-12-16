import 'package:sugar/collection_aggregate.dart';

import 'package:test/test.dart';

void main() {
  group('by(...)', () {
    test('exactly', () => expect([1, 2, 3, 4, 5, 6, 7, 8, 9].split.by(size: 3), [[1, 2, 3], [4, 5, 6], [7, 8, 9]]));

    test('partial', () => expect([1, 2, 3, 4, 5, 6, 7, 8].split.by(size: 3), [[1, 2, 3], [4, 5, 6], [7, 8]]));
  });

  group('before(...)', () {
    test('empty', () => expect([].split.before((element) => true).toList(), []));

    test('every element', () => expect([2, 2, 2, 2, 2].split.before((element) => element == 2).toList(), [[2], [2], [2], [2], [2]]));

    test('no elements', () => expect([1, 2, 3, 4, 5, 6, 7, 8].split.before((element) => element == 9).toList(), [[1, 2, 3, 4, 5, 6, 7, 8]]));

    test('end exactly on split', () => expect([1, 1, 2, 1, 1, 2].split.before((element) => element == 2).toList(), [[1, 1], [2, 1, 1], [2]]));

    test('different sizes', () => expect([1, 1, 2, 1, 1, 1, 2, 1, 2].split.before((element) => element == 2).toList(), [[1, 1], [2, 1, 1, 1], [2, 1], [2]]));
  });

  group('after(...)', () {
    test('empty', () => expect([].split.after((element) => true), []));

    test('every element', () => expect([2, 2, 2, 2, 2].split.after((element) => element == 2).toList(), [[2], [2], [2], [2], [2]]));

    test('no elements', () => expect([1, 2, 3, 4, 5, 6, 7, 8].split.after((element) => element == 9).toList(), [[1, 2, 3, 4, 5, 6, 7, 8]]));

    test('end exactly on split', () => expect([1, 1, 2, 1, 1, 2].split.after((element) => element == 2).toList(), [[1, 1, 2], [1, 1, 2]]));

    test('different sizes', () => expect([1, 1, 2, 1, 1, 1, 2, 1, 2].split.after((element) => element == 2).toList(), [[1, 1, 2], [1, 1, 1, 2], [1, 2]]));
  });

  group('window(...)', () {
    for (final length in [-1, 0]) {
      test('invalid length', () => expect(() => [1].split.window(length: length), throwsRangeError));
    }

    for (final by in [-1, 0]) {
      test('invalid by', () => expect(() => [1].split.window(length: 1, by: by), throwsRangeError));
    }

    group('partial', () {
      test('overlapping windows, partial ending', () => expect([1, 2, 3, 4].split.window(length: 3, by: 2, partial: true).toList(), [[1, 2, 3], [3, 4]]));

      test('overlapping windows, no partial ending', () => expect([1, 2, 3, 4, 5].split.window(length: 3, by: 2, partial: true).toList(), [[1, 2, 3], [3, 4, 5]]));


      test('exact windows, partial ending', () => expect([1, 2, 3, 4, 5].split.window(length: 2, by: 2, partial: true).toList(), [[1, 2], [3, 4], [5]]));

      test('exact windows, no partial ending', () => expect([1, 2, 3, 4].split.window(length: 2, by: 2, partial: true).toList(), [[1, 2], [3, 4]]));


      test('non-overlapping windows, partial ending', () => expect([1, 2, 3, 4, 5, 6, 7].split.window(length: 2, by: 3, partial: true).toList(), [[1, 2], [4, 5], [7]]));

      test('non-overlapping windows, no partial ending', () => expect([1, 2, 3, 4, 5].split.window(length: 2, by: 3, partial: true).toList(), [[1, 2], [4, 5]]));
    });

    group('not partial', () {
      test('overlapping windows, partial ending', () => expect([1, 2, 3, 4].split.window(length: 3, by: 2).toList(), [[1, 2, 3]]));

      test('overlapping windows, no partial ending', () => expect([1, 2, 3, 4, 5].split.window(length: 3, by: 2).toList(), [[1, 2, 3], [3, 4, 5]]));


      test('exact windows, partial ending', () => expect([1, 2, 3, 4, 5].split.window(length: 2, by: 2).toList(), [[1, 2], [3, 4]]));

      test('exact windows, no partial ending', () => expect([1, 2, 3, 4].split.window(length: 2, by: 2).toList(), [[1, 2], [3, 4]]));


      test('non-overlapping windows, partial ending', () => expect([1, 2, 3, 4, 5, 6, 7].split.window(length: 2, by: 3).toList(), [[1, 2], [4, 5]]));

      test('non-overlapping windows, no partial ending', () => expect([1, 2, 3, 4, 5].split.window(length: 2, by: 3).toList(), [[1, 2], [4, 5]]));
    });
  });
}
