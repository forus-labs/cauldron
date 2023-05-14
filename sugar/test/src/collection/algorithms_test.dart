import 'package:test/test.dart';

import 'package:sugar/collection.dart';

void main() {
  group('disjoint(...)', () {
    group('a is set', () {
      group('disjoint', () {
        test('disjoint', () => expect(disjoint({1}, [2]), true));

        test('different lengths', () => expect(disjoint({1}, [2, 3]), true));

        test('a is empty', () => expect(disjoint({}, [2]), true));

        test('b is empty', () => expect(disjoint({1}, []), true));

        test('both empty', () => expect(disjoint({}, []), true));

        test('multiple values', () => expect(disjoint({1, 2, 3}, [4, 5, 6, 7]), true));
      });

      group('intersection', () {
        test('single value', () => expect(disjoint({2}, [2]), false));

        test('different lengths', () => expect(disjoint({1, 2, 3}, [4, 2, 6, 7]), false));

        test('multiple values, single intersection', () => expect(disjoint({1, 2, 3}, [4, 2, 6]), false));

        test('multiple values, multiple intersection', () => expect(disjoint({1, 2, 3, 5}, [3, 2, 6, 5]), false));
      });
    });

    group('both not sets', () {
      group('disjoint', () {
        test('disjoint', () => expect(disjoint([1], [2]), true));

        test('a is empty', () => expect(disjoint([], [2]), true));

        test('b is empty', () => expect(disjoint([1], []), true));

        test('both empty', () => expect(disjoint([], []), true));

        test('a > b', () => expect(disjoint([1, 2], [3]), true));

        test('a < b', () => expect(disjoint([1], [2, 3]), true));

        test('multiple values', () => expect(disjoint([1, 2, 3], [4, 5, 6]), true));
      });

      group('intersection', () {
        test('single value', () => expect(disjoint([2], [2]), false));

        test('a > b', () => expect(disjoint([1, 2, 3], [4, 2]), false));

        test('a < b', () => expect(disjoint([4, 2], [1, 2, 3]), false));

        test('multiple values, single intersection', () => expect(disjoint([1, 2, 3], [4, 2, 6]), false));

        test('multiple values, multiple intersection', () => expect(disjoint([1, 2, 3, 5], [3, 2, 6, 5]), false));
      });
    });
  });

  group('separate(...)', () {
    test('empty list', () => expect(separate([], by: [1, 2, 3]), []));

    test('single element list', () => expect(separate([1], by: [2, 3, 4]), [1]));

    test('even number element list', () => expect(separate([1, 5], by: [2, 3, 4]), [1, 2, 3, 4, 5]));

    test('odd number element list', () => expect(separate([1, 5, 6], by: [2, 3, 4]), [1, 2, 3, 4, 5, 2, 3, 4, 6]));


    test('empty by', () => expect(separate([1, 2, 3], by: []), [1, 2, 3]));

    test('single by', () => expect(separate([1, 2, 3], by: [4]), [1, 4, 2, 4, 3]));

    test('multiple by', () => expect(separate([1, 2, 3], by: [4, 5]), [1, 4, 5, 2, 4, 5, 3]));
  });

  group('reverse(...)', () {
    test('invalid range', () => expect(() => reverse([], 1), throwsRangeError));

    test('empty list', () {
      final list = [];
      reverse(list);

      expect(list, []);
    });

    test('single element', () {
      final list = [1];
      reverse(list);

      expect(list, [1]);
    });

    test('even number of elements', () {
      final list = [1, 2];
      reverse(list);

      expect(list, [2, 1]);
    });

    test('odd number of elements', () {
      final list = [1, 2, 3];
      reverse(list);

      expect(list, [3, 2, 1]);
    });

    test('part of list, even number of elements', () {
      final list = [1, 2, 3, 4];
      reverse(list, 2, 4);

      expect(list, [1, 2, 4, 3]);
    });

    test('part of list, odd number of elements', () {
      final list = [1, 2, 3, 4];
      reverse(list, 1, 4);

      expect(list, [1, 4, 3, 2]);
    });
  });
}
