import 'package:test/test.dart';

import 'package:sugar/core.dart';

void main() {
  Future<String?> func<T>(T value) async => 'value';

  const int? nonnull = 1;
  const int? nullable = null;

  group('not null', () {
    test('where predicate successful', () => expect(nonnull.where((value) => value == 1), 1));

    test('where predicate not successful', () => expect(nonnull.where((value) => value == 2), null));

    test('map', () => expect(nonnull.map((value) => value.toString()), '1'));

    test('bind not null', () => expect(nonnull.bind((value) => value.toString()), '1'));

    test('bind null', () => expect(nonnull.bind((value) => null), null));

    test('pipe not null', () async => expect(await 1.pipe(func), 'value'));

    test('pipe not null', () async => expect(await 1.pipe(func), 'value'));
  });

  group('null', () {
    test('where predicate successful', () => expect(const None<String>().where((value) => true), const None()));

    test('where predicate not successful', () => expect(const None().where((value) => false), const None()));

    test('bind', () => expect(const None().bind((value) => Some(value.toString())), const None()));

    test('map', () => expect(const None().map((value) => value.toString()), const None()));

    test('pipe', () async => expect(await const None().pipe(func), const None()));
  });

}
