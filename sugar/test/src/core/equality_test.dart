import 'package:test/test.dart';

import 'package:sugar/core.dart';

void main() {
  group('DeepEqualityIterable', () {
    test('list equals other list', () => expect([1].equals([1]), true));

    test('list equal set', () => expect([1, 2].equals({2, 1}), true));

    test('list hash equals other hash', () => expect([1].hashValue, [1].hashValue));

    test('list hash not equals other hash', () => expect([1].hashValue, isNot([2].hashValue)));
  });

  group('DeepEqualityMap', () {
    test('map equals other map', () => expect({1: 2}.equals({1: 2}), true));

    test('map not equals other map', () => expect({1: 2}.equals({1: 3}), false));

    test('map hash equals other hash', () => expect({1: 2}.hashValue, {1: 2}.hashValue));

    test('map hash not equals other hash', () => expect({1: 2}.hashValue, isNot({1: 3}.hashValue)));
  });

  group('Equality', () {
    group('deep(...)', () {
      test('identical', () {
        final value = [];
        expect(Equality.deep(value, value), true);
      });

      group('sets', () {
        test('different length', () => expect(Equality.deep({'a'}, {'a', 'b'}), false));

        test('same length', () => expect(Equality.deep({'a'}, {'b'}), false));

        test('different order', () => expect(Equality.deep({'b', 'a'}, {'a', 'b'}), true));

        test('same order', () => expect(Equality.deep({'a', 'b'}, {'a', 'b'}), true));

        test('nested sets, different order', () => expect(Equality.deep({{'a'}, 'b'}, {'b', {'a'}}), true));

        test('nested maps, different order', () => expect(Equality.deep({{'a': 1}, 'b'}, {'b', {'a': 1}}), true));

        test('nested iterables, different order', () => expect(Equality.deep({['a'], 'b'}, {'b', ['a']}), true));

        test('nested entries, different order', () => expect(Equality.deep({const MapEntry('a', 1), 'b'}, {'b', const MapEntry('a', 1)}), true));
      });

      group('maps', () {
        test('different length', () => expect(Equality.deep({'a': 1}, {'a': 1, 'b': 1}), false));

        test('same length', () => expect(Equality.deep({'a': 1}, {'b': 1}), false));

        test('different order', () => expect(Equality.deep({'b': 1, 'a': 1}, {'a': 1, 'b': 1}), true));

        test('same order', () => expect(Equality.deep({'a': 1, 'b': 2}, {'a': 1, 'b': 2}), true));

        test('same keys different values',  () => expect(Equality.deep({'a': 1, 'b': 2}, {'a': 2, 'b': 3}), false));

        test('nested sets, different order', () => expect(Equality.deep({'a': {1}, 'b': 2}, {'b': 2, 'a': {1}}), true));

        test('nested maps, different order', () => expect(Equality.deep({'a': {1: 2}, 'b': 2}, {'b': 2, 'a': {1: 2}}), true));

        test('nested iterables, different order', () => expect(Equality.deep({'a': [1], 'b': 2}, {'b': 2, 'a': [1]}), true));

        test('nested entries, different order', () => expect(Equality.deep({'a': const MapEntry('a', 1), 'b': 1}, {'b': 1, 'a': const MapEntry('a', 1)}), true));
      });

      group('iterables', () {
        test('different length', () => expect(Equality.deep(['a', 'b'], ['b']), false));

        test('same length', () => expect(Equality.deep(['a'], ['b']), false));

        test('list and set', () => expect(Equality.deep(['a', 'b'], {'b', 'a'}), true));

        test('different order', () => expect(Equality.deep(['a', 'b'], ['b', 'a']), false));

        test('same order', () => expect(Equality.deep(['a', 'b'], ['a', 'b']), true));

        test('nested sets, same order', () => expect(Equality.deep([1, {2}], [1, {2}]), true));

        test('nested maps, same order', () => expect(Equality.deep([1, {2: 3}], [1, {2: 3}]), true));

        test('nested iterables, same order', () => expect(Equality.deep([1, [2]], [1, [2]]), true));

        test('nested entries, same order', () => expect(Equality.deep([const MapEntry('a', 1), 1], [const MapEntry('a', 1), 1]), true));
      });

      group('map entries', () {
        test('same values', () => expect(Equality.deep(const MapEntry('a', 1), const MapEntry('a', 1)), true));

        test('different values', () => expect(Equality.deep(const MapEntry('a', 1), const MapEntry('b', 2)), false));

        test('same keys, different values',  () => expect(Equality.deep(const MapEntry('a', 1), const MapEntry('a', 2)), false));

        test('different keys, same values',  () => expect(Equality.deep(const MapEntry('a', 1), const MapEntry('b', 1)), false));

        test('nested sets, same order', () => expect(Equality.deep(const MapEntry('a', {1}), const MapEntry('a', {1})), true));

        test('nested maps, same order', () => expect(Equality.deep(const MapEntry('a', {1: 2}), const MapEntry('a', {1: 2})), true));

        test('nested iterables, same order', () => expect(Equality.deep(const MapEntry('a', [1]), const MapEntry('a', [1])), true));

        test('nested entries, same order', () => expect(Equality.deep(const MapEntry('a', MapEntry('a', 2)), const MapEntry('a', MapEntry('a', 2))), true));
      });

      group('others', () {
        test('same values', () => expect(Equality.deep('a', 'a'), true));

        test('same values', () => expect(Equality.deep('a', 'b'), false));
      });

    });
  });

  group('HashCodes', () {
    group('deep(...)', () {
      test('different types', () => expect(HashCodes.deep({'a'}), isNot(HashCodes.deep(['a']))));

      group('sets', () {
        test('different values', () => expect(HashCodes.deep({'a'}), isNot(HashCodes.deep({'b'}))));

        test('different length', () => expect(HashCodes.deep({'a'}), isNot(HashCodes.deep({'a', 'b'}))));

        test('same order', () => expect(HashCodes.deep({'a', 'b'}), HashCodes.deep({'a', 'b'})));

        test('different order', () => expect(HashCodes.deep({'a', 'b'}), HashCodes.deep({'b', 'a'})));

        test('nested sets, different order', () => expect(HashCodes.deep({{'a'}, 'b'}), HashCodes.deep({'b', {'a'}})));

        test('nested maps, different order', () => expect(HashCodes.deep({{'a': 1}, 'b'}), HashCodes.deep({'b', {'a': 1}})));

        test('nested iterables, different order', () => expect(HashCodes.deep({['a'], 'b'}), HashCodes.deep({'b', ['a']})));

        test('nested entries, different order', () => expect(HashCodes.deep({const MapEntry('a', 1), 'b'}), HashCodes.deep({'b', const MapEntry('a', 1)})));
      });

      group('maps', () {
        test('different length', () => expect(HashCodes.deep({'a': 1}), isNot(HashCodes.deep({'a': 1, 'b': 1}))));

        test('same length', () => expect(HashCodes.deep({'a': 1}), isNot(HashCodes.deep({'b': 1}))));

        test('different order', () => expect(HashCodes.deep({'b': 1, 'a': 1}), HashCodes.deep({'a': 1, 'b': 1})));

        test('same order', () => expect(HashCodes.deep({'a': 1, 'b': 2}), HashCodes.deep({'a': 1, 'b': 2})));

        test('same keys different values',  () => expect(HashCodes.deep({'a': 1, 'b': 2}), isNot(HashCodes.deep({'a': 2, 'b': 3}))));

        test('nested sets, different order', () => expect(HashCodes.deep({'a': {1}, 'b': 2}), HashCodes.deep({'b': 2, 'a': {1}})));

        test('nested maps, different order', () => expect(HashCodes.deep({'a': {1: 2}, 'b': 2}), HashCodes.deep({'b': 2, 'a': {1: 2}})));

        test('nested iterables, different order', () => expect(HashCodes.deep({'a': [1], 'b': 2}), HashCodes.deep({'b': 2, 'a': [1]})));

        test('nested entries, different order', () => expect(HashCodes.deep({'a': const MapEntry('a', 1), 'b': 1}), HashCodes.deep({'b': 1, 'a': const MapEntry('a', 1)})));
      });

      group('iterables', () {
        test('different length', () => expect(HashCodes.deep(['a', 'b']), isNot(HashCodes.deep(['b']))));

        test('same length', () => expect(HashCodes.deep(['a']), isNot(HashCodes.deep(['b']))));

        test('different order', () => expect(HashCodes.deep(['a', 'b']), isNot(HashCodes.deep(['b', 'a']))));

        test('same order', () => expect(HashCodes.deep(['a', 'b']), HashCodes.deep(['a', 'b'])));

        test('nested sets, same order', () => expect(HashCodes.deep([1, {2}]), HashCodes.deep([1, {2}])));

        test('nested maps, same order', () => expect(HashCodes.deep([1, {2: 3}]), HashCodes.deep([1, {2: 3}])));

        test('nested iterables, same order', () => expect(HashCodes.deep([1, [2]]), HashCodes.deep([1, [2]])));

        test('nested entries, same order', () => expect(HashCodes.deep([const MapEntry('a', 1), 1]), HashCodes.deep([const MapEntry('a', 1), 1])));
      });

      group('map entries', () {
        test('same values', () => expect(HashCodes.deep(const MapEntry('a', 1)), HashCodes.deep(const MapEntry('a', 1))));

        test('different values', () => expect(HashCodes.deep(const MapEntry('a', 1)), isNot(HashCodes.deep(const MapEntry('b', 2)))));

        test('same keys, different values',  () => expect(HashCodes.deep(const MapEntry('a', 1)), isNot(HashCodes.deep(const MapEntry('a', 2)))));

        test('different keys, same values',  () => expect(HashCodes.deep(const MapEntry('a', 1)), isNot(HashCodes.deep(const MapEntry('b', 1)))));

        test('nested sets, same order', () => expect(HashCodes.deep(const MapEntry('a', {1})), HashCodes.deep(const MapEntry('a', {1}))));

        test('nested maps, same order', () => expect(HashCodes.deep(const MapEntry('a', {1: 2})), HashCodes.deep(const MapEntry('a', {1: 2}))));

        test('nested iterables, same order', () => expect(HashCodes.deep(const MapEntry('a', [1])), HashCodes.deep(const MapEntry('a', [1]))));

        test('nested entries, same order', () => expect(HashCodes.deep(const MapEntry('a', MapEntry('a', 2))), HashCodes.deep(const MapEntry('a', MapEntry('a', 2)))));
      });
    });
  });

}
