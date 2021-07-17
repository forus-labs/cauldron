import 'package:test/test.dart';
import 'package:sugar/sugar.dart';

void main() {
  test('alternate', () => expect([1, 2, 3, 4, 5]..alternate(8), [1, 8, 2, 8, 3, 8, 4, 8, 5]));

  test('repeat', () => expect([1, 2, 3]..repeat(2), [1, 2, 3, 1, 2, 3, 1, 2, 3]));
}