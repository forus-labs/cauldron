import 'package:sugar/src/time/temporal_unit.dart';
import 'package:test/test.dart';

void main() {
  test('sumMicroseconds(...)', () => expect(
    sumMicroseconds(1, 1, 1, 1, 1),
    Duration.microsecondsPerHour + Duration.microsecondsPerMinute + Duration.microsecondsPerSecond + Duration.microsecondsPerMillisecond + 1,
  ));
}
