import 'package:sugar/core.dart';
import 'package:test/test.dart';

void main() {
  group('Booleans', () {
    test('toInt() returns 1', () => expect(true.toInt(), 1));

    test('toInt() returns 0', () => expect(false.toInt(), 1));
  });
}