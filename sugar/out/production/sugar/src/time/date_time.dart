import 'package:sugar/time.dart';

class LocalDateTime extends DateTime with MultiPart, Temporal<LocalDateTime> {

  LocalDateTime(int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
      super(year, month, day, hour, minute, second, millisecond, microsecond);

  LocalDateTime.fromMilliseconds(int milliseconds): super.fromMillisecondsSinceEpoch(milliseconds);

  LocalDateTime.fromMicroseconds(int microseconds): super.fromMicrosecondsSinceEpoch(microseconds);

  LocalDateTime.now(): super.now();

  @override
  LocalDateTime operator + (Duration duration) => LocalDateTime.fromMicroseconds(microsecondsSinceEpoch + duration.inMicroseconds);

}

class UtcDateTime extends DateTime with MultiPart, Temporal<UtcDateTime> {

  UtcDateTime(int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
      super.utc(year, month, day, hour, minute, second, millisecond, microsecond);

  UtcDateTime.fromMilliseconds(int milliseconds): super.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  UtcDateTime.fromMicroseconds(int microseconds): super.fromMicrosecondsSinceEpoch(microseconds);

  factory UtcDateTime.now() {
    final date = DateTime.now().toUtc();
    return UtcDateTime(date.year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
  }

  @override
  UtcDateTime operator + (Duration duration) => UtcDateTime.fromMicroseconds(microsecondsSinceEpoch + duration.inMicroseconds);

}