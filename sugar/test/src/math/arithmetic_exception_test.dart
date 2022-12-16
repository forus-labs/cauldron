import 'package:sugar/math.dart';
import 'package:test/test.dart';

void main() {
  test('default message', () => expect(ArithmeticException().toString(), "ArithmeticException: ''"));

  test('custom message', () => expect(ArithmeticException('custom message').toString(), 'ArithmeticException: custom message'));
}
