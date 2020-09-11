import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

class RelatableStub with Relatable<RelatableStub> {
  final int value;

  RelatableStub([this.value = 0]);

  @override
  int compareTo(RelatableStub other) => value.compareTo(other.value);

  @override
  int get hash => 12345;
}

class SubclassStub extends RelatableStub {}

void main() {
  final stub = RelatableStub();

  group('==', () {
    for(final arguments in [
      ['same value', RelatableStub(), true],
      ['higher value', RelatableStub(1), false],
      ['lower value', RelatableStub(-1), false],
      ['different type', SubclassStub(), false],
    ].triples<String, RelatableStub, bool>()) {
      test(arguments.left, () => expect(stub == arguments.middle, arguments.right));
    }
  });

  group('comparison', () {
    for (final arguments in [
      [RelatableStub(1), true, false],
      [RelatableStub(), false, true],
      [RelatableStub(-1), false, false],
    ].triples<RelatableStub, bool, bool>()) {
      test('other is ${arguments.left.value}', () {
        final less = arguments.middle;
        final equal = arguments.right;

        expect(stub < arguments.left, less && !equal);
        expect(stub > arguments.left, !less && !equal);
        expect(stub <= arguments.left, less || equal);
        expect(stub >= arguments.left, !less || equal);
      });
    }
  });

  test('hashCode', () => expect(stub.hashCode, 12345));
}