import 'package:test/test.dart';

import 'package:sugar/core.dart';

void main() {
  Future<String?> func<T>(T value) async => 'value';

  const int? nonnull = 1; // ignore: unnecessary_nullable_for_final_variable_declarations
  const int? nullable = null;

  group('not null', () {
    test('where predicate successful', () => expect(nonnull.where((value) => value == 1), 1));

    test('where predicate not successful', () => expect(nonnull.where((value) => value == 2), null));

    test('map', () => expect(nonnull.map((value) => value.toString()), '1'));

    test('bind not null', () => expect(nonnull.bind((value) => value.toString()), '1'));

    test('bind null', () => expect(nonnull.bind((value) => null), null));

    test('bind async', () async => expect(await nonnull.bind(func), 'value'));
  });

  group('null', () {
    test('where predicate successful', () => expect(nullable.where((value) => true), null));

    test('where predicate not successful', () => expect(nullable.where((value) => false), null));

    test('bind', () => expect(nullable.bind((value) => value.toString()), null));

    test('map', () => expect(nullable.map((value) => value.toString()), null));

    test('bind async', () async => expect(await nullable.bind(func), null));
  });

  group('FutureMaybe', () {
    Future<int?> compute(int value) async => value + 1;

    test('pipe not null', () async => expect(await compute(0).pipe(compute).pipe(compute), 3));

    test('pipe null', () async => expect(await Future<int?>.value().pipe(compute).pipe(compute), null));
  });

}
