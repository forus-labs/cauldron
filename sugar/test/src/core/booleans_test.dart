import 'package:test/test.dart';

import 'package:sugar/core.dart';

void main() {
  group('Booleans', () {
    group('toInt()', () {
      test('returns 1', () => expect(true.toInt(), 1));

      test('returns 0', () => expect(false.toInt(), 0));
    });
  });
}
