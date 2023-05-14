import 'package:test/test.dart';

import 'package:sugar/collection.dart';

void main() {
  group('Sets', () {
    group('replaceAll(...)', () {
      test('single replacement', () => expect({1, 3, 5}..replaceAll((replace, element) => replace(element + 1)), {2, 4, 6}));

      test('zero replacement', () => expect({1, 2, 3}..replaceAll((replace, element) {
        if (element.isOdd) {
          replace(element + 2);
        }
      }), {3, 5}));

      test('several replacement', () => expect({1, 2, 3}..replaceAll((replace, element) {
        if (element.isOdd) {
          replace(element + 2);
          replace(element + 4);
        }
      }), {3, 5, 7}));

      test('function modifies underlying list', () {
        final list = {1, 2, 3, 4, 5};
        expect(() => list.replaceAll((replace, element) => list.remove(element)), throwsConcurrentModificationError);
      });

      test("replace function's return value", () => expect({1, 2, 3}..replaceAll((replace, element) {
        expect(replace(1), element == 1);
      }), {1}));
    });
  });

  group('NonNullableSet', () {
    group('addIfNonNull(...)', () {
      test('not null, element not in set', () {
        final set = <int>{};

        expect(set.addIfNonNull(1), true);
        expect(set, {1});
      });

      test('not null, element in set', () {
        final set = {1};

        expect(set.addIfNonNull(1), false);
        expect(set, {1});
      });

      test('null', () {
        final set = <int>{};

        expect(set.addIfNonNull(null), false);
        expect(set, []);
      });
    });
  });
}
