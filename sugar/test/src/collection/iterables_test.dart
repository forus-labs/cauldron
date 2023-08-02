import 'dart:collection';

import 'package:test/test.dart';

import 'package:sugar/collection.dart';
import 'package:sugar/core.dart';

void main() {
  group('Iterables', () {
    group('distinct(...)', () {
      test('empty', () => expect(<(String, int)>[].distinct(by: (e) => e.$1), []));

      test('single', () => expect([('a', 1)].distinct(by: (e) => e.$1), [('a', 1)]));

      test('multiple unique values', () => expect([('a', 1), ('b', 1), ('c', 1)].distinct(by: (e) => e.$1), [('a', 1), ('b', 1), ('c', 1)]));

      test('multiple deeply equal values', () => expect([[1], [2], [3], [1]].distinct(by: (element) => element), [[1], [2], [3], [1]]));

      test('multiple duplicate values, well-ordered', () => expect([('a', 1), ('b', 1), ('c', 1), ('a', 2)].distinct(by: (e) => e.$1).toList(), [('a', 1), ('b', 1), ('c', 1)]));

      test('multiple duplicate values, unordered', () {
        final set = HashSet<(String, int)>()..addAll({('a', 1), ('b', 1), ('c', 1), ('a', 2)});
        final distinct = set.distinct(by: (e) => e.$1).toSet();

        expect(distinct.containsAll(<(String, int)>{('a', 1), ('b', 1), ('c', 1)}) || distinct.containsAll(<(String, int)>{('a', 2), ('b', 1), ('c', 1)}), true);
      });
    });

    group('associate(...)', () {
      test('empty', () => expect([].associate(by: (e) => e), <dynamic, dynamic>{}));

      test('single value', () => expect([('a',)].associate(by: (e) => e.$1), {'a': ('a', )}));

      test('multiple unique values', () => expect([('a',), ('b',), ('c',)].associate(by: (e) => e.$1), {'a': ('a',), 'b': ('b',), 'c': ('c',)}));

      test('multiple duplicate values', () => expect([('a',), ('a',), ('b',), ('c',)].associate(by: (e) => e.$1), {'a': ('a',), 'b': ('b',), 'c': ('c',)}));
    });

    group('toMap(...)', () {
      test('empty', () => expect([].toMap((e) => (e, e)), {}));

      test('single value', () => expect([('a',)].toMap((e) => (e.$1, e.toString())), {'a': '(a)'}));

      test('multiple unique values', () => expect([('a',), ('b',), ('c',)].toMap((e) => (e.$1, e.toString())), {
        'a': '(a)',
        'b': '(b)',
        'c': '(c)',
      }));

      test('multiple duplicate values', () => expect([('a',), ('a',), ('b',), ('c',)].toMap((e) => (e.$1, e.toString())), {
        'a': '(a)',
        'b': '(b)',
        'c': '(c)',
      }));
    });


    test('toUnmodifiableList()', () {
      final original = [1, 2, 3];
      final unmodifiable = original.toUnmodifiableList();

      expect(unmodifiable, original);
      expect(() => unmodifiable[0] = 2, throwsUnsupportedError);
    });

    test('toUnmodifiableSet()', () {
      final original = {1, 2, 3};
      final unmodifiable = original.toUnmodifiableSet();

      expect(unmodifiable, original);
      expect(() => unmodifiable.remove(1), throwsUnsupportedError);
    });

    test('toUnmodifiableMap()', () {
      final original = {1, 2, 3};
      final unmodifiable = original.toUnmodifiableMap((e) => (e, e.toString()));

      expect(unmodifiable, {1: '1', 2: '2', 3: '3'});
      expect(() => unmodifiable.remove(1), throwsUnsupportedError);
    });
  });

  group('IterableIterable', () {
    group('flatten(...)', () {
      test('empty', () => expect([[]].flatten().toList(), []));

      test('single value', () => expect([[1]].flatten().toList(), [1]));

      test('multiple values', () => expect([[1, 2], [3, 4], [5]].flatten().toList(), [1, 2, 3, 4, 5]));
    });
  });

}
