import 'package:test/test.dart';
import 'package:sugar/sugar.dart';

void main() {
  group('NullableObjects', () {
    group('as()', () {
      test('exact type', () {
        const num foo = 1;
        expect(foo.as<int>(), 1);
      });

      test('different type', () => expect('string'.as<int>(), null));

      test('null', () => expect(null.as<int>(), null));
    });
  });
}
