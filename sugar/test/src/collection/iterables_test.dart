import 'package:sugar/collection.dart';
import 'package:test/test.dart';

class Foo {

  final String id;

  Foo(this.id);

  @override
  bool operator ==(Object other) => identical(this, other) || other is Foo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Foo{id: $id}';
}

void main() {
  
  group('Iterables', () {
    group('preimage(...)', () {
      test('empty', () => expect([].preimage((e) => e), <dynamic, dynamic>{}));

      test('single value', () => expect([Foo('a')].preimage((foo) => foo.id), {'a': Foo('a')}));

      test('multiple unique values', () => expect([Foo('a'), Foo('b'), Foo('c')].preimage((foo) => foo.id), {'a': Foo('a'), 'b': Foo('b'), 'c': Foo('c')}));

      test('multiple duplicate values', () => expect([Foo('a'), Foo('a'), Foo('b'), Foo('c')].preimage((foo) => foo.id), {'a': Foo('a'), 'b': Foo('b'), 'c': Foo('c')}));
    });

    group('toMap(...)', () {
      test('empty', () => expect([].toMap((e) => e, (e) => e), {}));

      test('single value', () => expect([Foo('a')].toMap((e) => e.id, (e) => e.toString()), {'a': 'Foo{id: a}'}));

      test('multiple unique values', () => expect([Foo('a'), Foo('b'), Foo('c')].toMap((e) => e.id, (e) => e.toString()), {
        'a': 'Foo{id: a}',
        'b': 'Foo{id: b}',
        'c': 'Foo{id: c}',
      }));

      test('multiple duplicate values', () => expect([Foo('a'), Foo('a'), Foo('b'), Foo('c')].toMap((e) => e.id, (e) => e.toString()), {
        'a': 'Foo{id: a}',
        'b': 'Foo{id: b}',
        'c': 'Foo{id: c}',
      }));
    });

    group('firstOrNull', () {
      test('empty', () => expect([].firstOrNull, null));

      test('single value', () => expect([1].firstOrNull, 1));

      test('multiple values', () => expect([1, 2, 3].firstOrNull, 1));
    });

    group('lastOrNull', () {
      test('empty', () => expect([].lastOrNull, null));

      test('single value', () => expect([1].lastOrNull, 1));

      test('multiple values', () => expect([1, 2, 3].lastOrNull, 3));
    });

    group('singleOrNull', () {
      test('empty', () => expect([].singleOrNull, null));

      test('single value', () => expect([1].singleOrNull, 1));

      test('multiple values', () => expect([1, 2, 3].singleOrNull, null));
    });
  });

  group('ComparableIterables', () {
    group('min', () {
      test('empty', () => expect(<int>[].min, null));

      test('single value', () => expect([1].min, 1));

      test('multiple values, duplicate values', () => expect([2, 1, 3, 1, 2].min, 1));

      test('multiple values, min first', () => expect([1, 2, 3].min, 1));

      test('multiple values, min not first', () => expect([2, 1, 3].min, 1));
    });

    group('max', () {
      test('empty', () => expect(<int>[].max, null));

      test('single value', () => expect([1].max, 1));

      test('multiple values, duplicate values', () => expect([2, 3, 1, 3, 2].max, 3));

      test('multiple values, max first', () => expect([3, 2, 1].max, 3));

      test('multiple values, max not first', () => expect([2, 3, 1].max, 3));
    });
  });

  group('IterableIterables', () {
    group('flat(...)', () {
      test('empty', () => expect([[]].flat(map: (e) => e).toList(), []));

      test('single value', () => expect([[1]].flat(map: (e) => e).toList(), [1]));

      test('multiple values', () => expect([[1, 2], [3, 4], [5]].flat(map: (e) => e.toString()).toList(), ['1', '2', '3', '4', '5']));
    });
  });

}
