import 'package:test/test.dart';
import 'package:sugar/sugar.dart';

void main() {
  test('separate', () => expect([1, 2, 3, 4, 5]..separate(8), [1, 8, 2, 8, 3, 8, 4, 8, 5]));
}