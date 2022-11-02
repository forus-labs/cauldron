import 'package:sugar/collection.dart';
import 'package:test/test.dart';

void main() {
  group('swap(...)', () {
    test('same index', () => expect([1]..swap(0, 0), [1]));

    test('first < second', () => expect(['a', 'b']..swap(0, 1), ['b', 'a']));

    test('first > second', () => expect(['a', 'b']..swap(1, 0), ['b', 'a']));

    test('same value', () => expect(['a', 'a']..swap(0, 1), ['a', 'a']));

    test('invalid first index', () => expect(() => [1].swap(-1, 0), throwsRangeError));

    test('invalid second index', () => expect(() => [1].swap(0, 1), throwsRangeError));
  });

  group('containsAll(...)', () {
    test('contains exact', () => expect([1, 2, 3].containsAll([1, 2, 3]), true));

    test('contains subset', () => expect([1, 2, 3].containsAll([1, 2]), true));

    test('does not contain superset', () => expect([1, 2].containsAll([1, 2, 3]), false));

    test('does not contain intersecting', () => expect([1, 2, 3].containsAll([1, 2, 4]), false));


    test('duplicates contains subset', () => expect([1, 2, 3, 1].containsAll([1, 2]), true));

    test('contains duplicate subset', () => expect([1, 2, 3].containsAll([1, 2, 1]), true));

    test('duplicates contains duplicate subset', () => expect([1, 2, 3, 1].containsAll([1, 2, 1]), true));


    test('contains empty set', () => expect([1].containsAll([]), true));

    test('empty contains empty', () => expect([].containsAll([]), true));

    test('empty does not contain set', () => expect([].containsAll([1]), false));
  });

  group('replaceAll(...)', () {
    test('single replacement', () => expect([1, 3, 5]..replaceAll((replace, element) => replace(element + 1)), [2, 4, 6]));

    test('zero replacement', () => expect([1, 2, 3]..replaceAll((replace, element) {
      if (element.isOdd) {
        replace(element + 2);
      }
    }), [3, 5]));

    test('several replacement', () => expect([1, 2, 3]..replaceAll((replace, element) {
      if (element.isOdd) {
        replace(element + 2);
        replace(element + 4);
      }
    }), [3, 5, 5, 7]));

    test('function modifies underlying list', () {
      final list = [1, 2, 3, 4, 5];
      expect(() => list.replaceAll((replace, element) => list.remove(element)), throwsConcurrentModificationError);
    });
  });

  group('retainAll(...)', () {
    test('exact', () => expect([1, 2, 3]..retainAll([1, 2, 3]), [1, 2, 3]));

    test('subset', () => expect([1, 2, 3]..retainAll([1, 2]), [1, 2]));

    test('overlapping', () => expect([1, 2, 3]..retainAll([1, 2, 4]), [1, 2]));

    test('superset', () => expect([1, 2, 3]..retainAll([1, 2, 3, 4]), [1, 2, 3]));


    test('duplicates retain non-duplicates', () => expect([1, 2, 3, 1]..retainAll([1, 2]), [1, 2, 1]));

    test('non-duplicates retain duplicates', () => expect([1, 2, 3]..retainAll([1, 2, 1]), [1, 2]));

    test('duplicates retain duplicates', () => expect([1, 2, 3, 1]..retainAll([1, 2, 1]), [1, 2, 1]));


    test('empty retain non-empty', () => expect([]..retainAll([1, 2, 3]), []));

    test('non-empty retain empty', () => expect([1, 2, 3]..retainAll([]), []));

    test('empty retain empty', () => expect([]..retainAll([]), []));
  });

  group('removeAll(...)', () {
    test('exact', () => expect([1, 2, 3]..removeAll([1, 2, 3]), []));

    test('subset', () => expect([1, 2, 3]..removeAll([1, 2]), [3]));

    test('overlapping', () => expect([1, 2, 3]..removeAll([1, 2, 4]), [3]));

    test('superset', () => expect([1, 2, 3]..removeAll([1, 2, 3, 4]), []));


    test('duplicates remove non-duplicates', () => expect([1, 2, 3, 1]..removeAll([1, 2]), [3]));

    test('non-duplicates remove duplicates', () => expect([1, 2, 3]..removeAll([1, 2, 1]), [3]));

    test('duplicates remove duplicates', () => expect([1, 2, 3, 1]..removeAll([1, 2, 1]), [3]));


    test('empty remove non-empty', () => expect([]..removeAll([1, 2, 3]), []));

    test('non-empty remove empty', () => expect([1, 2, 3]..removeAll([]), [1, 2, 3]));

    test('empty remove empty', () => expect([]..removeAll([]), []));
  });

  group('*', () {
    test('zero', () => expect([1, 2, 3] * 2, [1, 2, 3, 1, 2, 3]));

    test('zero', () => expect([1] * 0, []));

    test('negative number', () => expect(() => [1] * - 1, throwsRangeError));
  });
}
