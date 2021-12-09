import 'package:meta/meta.dart';
import 'package:sugar/time.dart';

/// An immutable date-time without a timezone.
class LocalDateTime extends DateTime with MultiPart, RoundableDateTime<LocalDateTime>, Temporal<LocalDateTime> {

  /// Creates a [LocalDateTime] with the given parameters.
  LocalDateTime(int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
        super(year, month, day, hour, minute, second, millisecond, microsecond);

  /// Creates a [LocalDateTime] from the given milliseconds since epoch.
  LocalDateTime.fromMilliseconds(int milliseconds): super.fromMillisecondsSinceEpoch(milliseconds);

  /// Creates a [LocalDateTime] from the given microseconds since epoch.
  LocalDateTime.fromMicroseconds(int microseconds): super.fromMicrosecondsSinceEpoch(microseconds);

  /// Creates a [LocalDateTime] that represents the current date and time.
  LocalDateTime.now(): super.now();

  @override
  LocalDateTime operator + (Duration duration) => LocalDateTime.fromMicroseconds(microsecondsSinceEpoch + duration.inMicroseconds);

  @override
  @protected LocalDateTime of(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond) =>
      LocalDateTime(year, month, day, hour, minute, second, millisecond, microsecond);

}

/// An immutable date-time in the UTC±00:00 timezone.
class UtcDateTime extends DateTime with MultiPart, RoundableDateTime<UtcDateTime>, Temporal<UtcDateTime> {

  /// Creates a [UtcDateTime] with the given parameters.
  UtcDateTime(int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
        super.utc(year, month, day, hour, minute, second, millisecond, microsecond);

  /// Creates a [UtcDateTime] from the given milliseconds since epoch.
  UtcDateTime.fromMilliseconds(int milliseconds): super.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [UtcDateTime] from the given microseconds since epoch.
  UtcDateTime.fromMicroseconds(int microseconds): super.fromMicrosecondsSinceEpoch(microseconds, isUtc: true);

  /// Creates a [UtcDateTime] that represents the current date and time.
  factory UtcDateTime.now() {
    final date = DateTime.now().toUtc();
    return UtcDateTime(date.year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond, date.microsecond);
  }

  @override
  UtcDateTime operator + (Duration duration) => UtcDateTime.fromMicroseconds(microsecondsSinceEpoch + duration.inMicroseconds);

  @override
  @protected UtcDateTime of(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond) =>
      UtcDateTime(year, month, day, hour, minute, second, millisecond, microsecond);

}
