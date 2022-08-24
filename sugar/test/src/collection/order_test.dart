import 'package:sugar/src/collection/order.dart';
import 'package:test/test.dart';

class Foo {

  final int id;

  Foo(this.id);

  @override
  bool operator ==(Object other) => identical(this, other) || other is Foo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

}

void main() {

  group('ascending', () {
    test('empty', () => expect(<int>[].order(by: (e) => e).ascending, []));

    test('single value', () => expect([Foo(1)].order(by: (foo) => foo.id).ascending, [Foo(1)]));

    test('multiple values', () => expect([Foo(1), Foo(3), Foo(2)].order(by: (foo) => foo.id).ascending, [Foo(1), Foo(2), Foo(3)]));

    test('multiple same values', () => expect([Foo(1), Foo(3), Foo(2), Foo(3)].order(by: (foo) => foo.id).ascending, [Foo(1), Foo(2), Foo(3), Foo(3)]));
  });

  group('descending', () {
    test('empty', () => expect(<int>[].order(by: (e) => e).descending, []));

    test('single value', () => expect([Foo(1)].order(by: (foo) => foo.id).descending, [Foo(1)]));

    test('multiple values', () => expect([Foo(1), Foo(3), Foo(2)].order(by: (foo) => foo.id).descending, [Foo(3), Foo(2), Foo(1)]));

    test('multiple same values', () => expect([Foo(1), Foo(3), Foo(2), Foo(3)].order(by: (foo) => foo.id).descending, [Foo(3), Foo(3), Foo(2), Foo(1)]));
  });

  group('min', () {
    test('empty', () => expect(<int>[].order(by: (e) => e).min, null));

    test('single value', () => expect([Foo(1)].order(by: (foo) => foo.id).min, Foo(1)));

    test('multiple values, min first', () => expect([Foo(1), Foo(3), Foo(2)].order(by: (foo) => foo.id).min, Foo(1)));

    test('multiple values, min not first', () => expect([Foo(3), Foo(1), Foo(2)].order(by: (foo) => foo.id).min, Foo(1)));

    test('multiple same values', () => expect([Foo(1), Foo(3), Foo(2), Foo(1)].order(by: (foo) => foo.id).min, Foo(1)));
  });

  group('max', () {
    test('empty', () => expect(<int>[].order(by: (e) => e).max, null));

    test('single value', () => expect([Foo(1)].order(by: (foo) => foo.id).max, Foo(1)));

    test('multiple values, max first', () => expect([Foo(3), Foo(1), Foo(2)].order(by: (foo) => foo.id).max, Foo(3)));

    test('multiple values, max not first', () => expect([Foo(1), Foo(3), Foo(2)].order(by: (foo) => foo.id).max, Foo(3)));

    test('multiple same values', () => expect([Foo(3), Foo(1), Foo(2), Foo(3)].order(by: (foo) => foo.id).max, Foo(3)));
  });

}
