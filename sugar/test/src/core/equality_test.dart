import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

class EqualityStub with Equality {

  @override
  final List<dynamic> fields;

  EqualityStub([this.fields = const ['field', 1]]);
}

class SubclassStub extends EqualityStub {}

class OtherEqualityStub with Equality {
  @override
  List<dynamic> get fields => const ['field', 1];
}

void main() {

  final stub = EqualityStub();

  group('==', () {
    for (final arguments in [
      ['identical', stub, true],
      ['same fields', EqualityStub(), true],
      ['different types', OtherEqualityStub(), false],
    ].triples<String, Equality, bool>()) {
      test(arguments.left, () => expect(stub == arguments.middle, arguments.right));
    }

    test('symmetrical', () {
      expect(stub == SubclassStub(), isFalse);
      expect(SubclassStub() == stub, isFalse);
    });
  });

  group('hashCode', () {
    for (final arguments in [
      ['identical', stub, true],
      ['same fields', EqualityStub(), true],
      ['subclass', SubclassStub(), true],
      ['different fields', EqualityStub([1, 2, 3]), false]
    ].triples<String, Equality, bool>()) {
      test(arguments.left, () => expect(stub.hashCode == arguments.middle.hashCode, arguments.right));
    }
  });

  test('toString', () => expect(stub.toString(), 'EqualityStub(field, 1)'));

}