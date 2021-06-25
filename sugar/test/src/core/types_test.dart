import 'package:test/test.dart';
import 'package:sugar/sugar.dart';

class A {}
class B extends A {}

void main() {
  group('Types', () {
    test('isSubtype', () {
      expect(Types.isSubtype(B(), A()), true);
      expect(Types.isSubtype(A(), A()), true);
      expect(Types.isSubtype(A(), B()), false);
    });
  });
}