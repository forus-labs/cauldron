import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  test('alternate', () => expect([1, 2, 3, 4, 5]..alternate(8), [1, 8, 2, 8, 3, 8, 4, 8, 5]));

  test('*', () => expect([1, 2, 3] * 2, [1, 2, 3, 1, 2, 3, 1, 2, 3]));
}
