import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('Minute', () {
    test('from(...)', () => expect(Minutes.from(1, 1), 61));
  });

  group('Second', () {
    test('from(...)', () => expect(Seconds.from(1, 1, 1), Duration.secondsPerHour + Duration.secondsPerMinute + 1));
  });

  group('Millisecond', () {
    test('from(...)', () => expect(
      Milliseconds.from(1, 1, 1, 1),
      Duration.millisecondsPerHour + Duration.millisecondsPerMinute + Duration.millisecondsPerSecond + 1,
    ));
  });

  group('Microsecond', () {
    test('from(...)', () => expect(
      Microseconds.from(1, 1, 1, 1, 1),
      Duration.microsecondsPerHour + Duration.microsecondsPerMinute + Duration.microsecondsPerSecond + Duration.microsecondsPerMillisecond + 1,
    ));
  });
}
