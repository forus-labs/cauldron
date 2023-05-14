import 'dart:math';

import 'package:test/test.dart';

import 'package:sugar/collection.dart';

void main() {

  group('Maps', () {
    group('merge(...)', () {
      test('empty', () => expect(Maps.merge({}, {}, resolve: (key, a, b) => a), {}));

      test('no conflicts', () => expect(
        Maps.merge({'a': 1}, {'b': 2}, resolve: (key, a, b) => min(a, b)),
        {'a': 1, 'b': 2},
      ));

      test('first wins', () => expect(
        Maps.merge({'a': 1}, {'a': 2, 'b': 2}, resolve: (key, a, b) => min(a, b)),
        {'a': 1, 'b': 2},
      ));

      test('second wins', () => expect(
        Maps.merge({'a': 2}, {'a': 1, 'b': 2}, resolve: (key, a, b) => min(a, b)),
        {'a': 1, 'b': 2},
      ));
    });

    group('putAll(...)', () {
      test('empty', () {
        final a = <String, int>{};
        expect(a..putAll({}, resolve: (k, a, b) => min(a, b)), <String, int>{});
      });

      test('no conflicts', () => expect(
        {'a': 1}..putAll({'b': 2}, resolve: (k, a, b) => min(a, b)),
        {'a': 1, 'b': 2},
      ));

      test('first wins', () => expect(
        {'a': 1}..putAll({'a': 2, 'b': 2}, resolve: (k, a, b) => min(a, b)),
        {'a': 1, 'b': 2},
      ));

      test('second wins', () => expect(
        {'a': 2}..putAll({'a': 1, 'b': 2}, resolve: (k, a, b) => min(a, b)),
        {'a': 1, 'b': 2},
      ));
    });

    group('retainWhere(...)', () {
      test('empty', () => expect(<int, int>{}..retainWhere((k, v) => true), <int, int>{}));

      test('retain all', () => expect({'a': 1, 'b': 2}..retainWhere((k, v) => true), {'a': 1, 'b': 2}));

      test('retain some', () => expect({'a': 1, 'b': 2, 'c': 3}..retainWhere((k, v) => k == 'b'), {'b': 2}));

      test('retain none', () => expect({'a': 1, 'b': 2}..retainWhere((k, v) => false), <String, int>{}));
    });

    group('inverse()', () {
      test('empty', () => expect(<String, int>{}.inverse(), <int, List<String>>{}));

      test('injective', () => expect({'a': 1, 'b': 2}.inverse(), <int, List<String>>{1: ['a'], 2: ['b']}));

      test('non-injective', () => expect({'a': 1, 'b': 1, 'c': 2}.inverse(), <int, List<String>>{1: ['a', 'b'], 2: ['c']}));
    });

    group('where(...)', () {
      test('empty', () => expect(<String, int>{}.where((k, v) => true), <String, int>{}));

      test('all', () => expect({'a': 1, 'b': 2}.where((k, v) => true), {'a': 1, 'b': 2}));

      test('some', () => expect({'a': 1, 'b': 2, 'c': 3}.where((k, v) => k == 'b'), {'b': 2}));

      test('none', () => expect({'a': 1, 'b': 2}.where((k, v) => false), <String, int>{}));
    });

    group('rekey(...)', () {
      test('empty', () => expect(<String, String>{}.rekey(int.parse), <int, String>{}));

      test('injective', () => expect({'1': 'a', '2': 'b'}.rekey(int.parse), {1: 'a', 2: 'b'}));

      test('override previous keys', () => expect({'1': 'a', '2': 'b', '1.0': 'c'}.rekey((k) => int.tryParse(k) ?? 1), {1: 'c', 2: 'b'}));
    });

    group('revalue', () {
      test('empty', () => expect(<String, String>{}.revalue(int.parse), <String, int>{}));

      test('revalues', () => expect({'a': '1', 'b': '2'}.revalue(int.parse), {'a': 1, 'b': 2}));
    });
  });

  group('NonNullableMap', () {
    group('putIfNotNull(...)', () {
      test('puts entry', () {
        final map = <String, int>{};
        expect(map.putIfNotNull('a', 1), true);
        expect(map, {'a': 1});
      });

      test('replaces entry', () {
        final map = <String, int>{'a': 0};
        expect(map.putIfNotNull('a', 1), true);
        expect(map, {'a': 1});
      });

      test('null key', () {
        final map = <String, int>{};
        expect(map.putIfNotNull(null, 1), false);
        expect(map, <String, int>{});
      });

      test('null value', () {
        final map = <String, int>{};
        expect(map.putIfNotNull('a', null), false);
        expect(map, <String, int>{});
      });
    });
  });

}
