import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  group('Second', () {
    test('from', () => expect(Second.from(1, 1, 1), 3661));
  });

  group('Millisecond', () {
    test('from', () => expect(Millisecond.from(1, 1, 1, 1), Hour.milliseconds + Minute.milliseconds + Second.milliseconds + 1));
  });

  group('Microsecond', () {
    test('from', () => expect(Microsecond.from(1, 1, 1, 1, 1), Hour.microseconds + Minute.microseconds + Second.microseconds + Millisecond.microseconds + 1));
  });
}