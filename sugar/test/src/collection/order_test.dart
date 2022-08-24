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

    test('multiple values', () => expect([Foo(1), Foo(3), Foo(2), Foo(3)].order(by: (foo) => foo.id).ascending, [Foo(1), Foo(2), Foo(3), Foo(3)]));

    test('multiple values', () => expect([Foo(1), Foo(3), Foo(2)].order(by: (foo) => foo.id).ascending, [Foo(1), Foo(2), Foo(3)]));
  });

}
