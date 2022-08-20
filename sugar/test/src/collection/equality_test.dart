
import 'package:sugar/collection.dart';
import 'package:test/test.dart';

void main() {

  group('DeepIterableEquality', () {

  });

  group('DeepMapEquality', () {

  });

  group('DeepEquality', () {
    group('equal(...)', () {
      test('identical', () {
        final value = [];
        expect(DeepEquality.equal(value, value), true);
      });

      group('sets', () {
        test('different length', () => expect(DeepEquality.equal({'a'}, {'a', 'b'}), false));

        test('same length', () => expect(DeepEquality.equal({'a'}, {'b'}), false));

        test('different order', () => expect(DeepEquality.equal({'b', 'a'}, {'a', 'b'}), true));

        test('same order', () => expect(DeepEquality.equal({'a', 'b'}, {'a', 'b'}), true));

        test('nested sets, different order', () => expect(DeepEquality.equal({{'a'}, 'b'}, {'b', {'a'}}), true));

        test('nested maps, different order', () => expect(DeepEquality.equal({{'a': 1}, 'b'}, {'b', {'a': 1}}), true));

        test('nested iterables, different order', () => expect(DeepEquality.equal({['a'], 'b'}, {'b', ['a']}), true));

        test('nested entries, different order', () => expect(DeepEquality.equal({const MapEntry('a', 1), 'b'}, {'b', const MapEntry('a', 1)}), true));
      });

      group('maps', () {
        test('different length', () => expect(DeepEquality.equal({'a': 1}, {'a': 1, 'b': 1}), false));

        test('same length', () => expect(DeepEquality.equal({'a': 1}, {'b': 1}), false));

        test('different order', () => expect(DeepEquality.equal({'b': 1, 'a': 1}, {'a': 1, 'b': 1}), true));

        test('same order', () => expect(DeepEquality.equal({'a': 1, 'b': 2}, {'a': 1, 'b': 2}), true));

        test('same keys different values',  () => expect(DeepEquality.equal({'a': 1, 'b': 2}, {'a': 2, 'b': 3}), false));

        test('nested sets, different order', () => expect(DeepEquality.equal({'a': {1}, 'b': 2}, {'b': 2, 'a': {1}}), true));

        test('nested maps, different order', () => expect(DeepEquality.equal({'a': {1: 2}, 'b': 2}, {'b': 2, 'a': {1: 2}}), true));

        test('nested iterables, different order', () => expect(DeepEquality.equal({'a': [1], 'b': 2}, {'b': 2, 'a': [1]}), true));

        test('nested entries, different order', () => expect(DeepEquality.equal({'a': const MapEntry('a', 1), 'b': 1}, {'b': 1, 'a': const MapEntry('a', 1)}), true));
      });

      group('iterables', () {
        test('different length', () => expect(DeepEquality.equal(['a', 'b'], ['b']), false));

        test('same length', () => expect(DeepEquality.equal(['a'], ['b']), false));

        test('different order', () => expect(DeepEquality.equal(['a', 'b'], ['b', 'a']), false));

        test('same order', () => expect(DeepEquality.equal(['a', 'b'], ['a', 'b']), true));

        test('nested sets, same order', () => expect(DeepEquality.equal([1, {2}], [1, {2}]), true));

        test('nested maps, same order', () => expect(DeepEquality.equal([1, {2: 3}], [1, {2: 3}]), true));

        test('nested iterables, same order', () => expect(DeepEquality.equal([1, [2]], [1, [2]]), true));

        test('nested entries, same order', () => expect(DeepEquality.equal([const MapEntry('a', 1), 1], [const MapEntry('a', 1), 1]), true));
      });

      group('map entries', () {
        test('same values', () => expect(DeepEquality.equal(const MapEntry('a', 1), const MapEntry('a', 1)), true));

        test('different values', () => expect(DeepEquality.equal(const MapEntry('a', 1), const MapEntry('b', 2)), false));

        test('same keys, different values',  () => expect(DeepEquality.equal(const MapEntry('a', 1), const MapEntry('a', 2)), false));

        test('different keys, same values',  () => expect(DeepEquality.equal(const MapEntry('a', 1), const MapEntry('b', 1)), false));

        test('nested sets, same order', () => expect(DeepEquality.equal(const MapEntry('a', {1}), const MapEntry('a', {1})), true));

        test('nested maps, same order', () => expect(DeepEquality.equal(const MapEntry('a', {1: 2}), const MapEntry('a', {1: 2})), true));

        test('nested iterables, same order', () => expect(DeepEquality.equal(const MapEntry('a', [1]), const MapEntry('a', [1])), true));

        test('nested entries, same order', () => expect(DeepEquality.equal(const MapEntry('a', MapEntry('a', 2)), const MapEntry('a', MapEntry('a', 2))), true));
      });

      group('others', () {
        test('same values', () => expect(DeepEquality.equal('a', 'a'), true));

        test('same values', () => expect(DeepEquality.equal('a', 'b'), false));
      });

    });

    group('hashValue(...)', () {

    });
  });

}
