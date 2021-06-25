import 'package:meta/meta.dart';
import 'package:sugar/time.dart';

/// An immutable date without a timezone.
class Date extends DateTime with RoundableDateTime<Date>, Temporal<Date> {

  LocalDateTime? _local;
  UtcDateTime? _utc;


  /// Creates a [Date] with the given parameters.
  Date(int year, [int month = 1, int day = 1]): super(year, month, day, 0, 0, 0, 0, 0);

  /// Creates a [Date] from the given milliseconds since epoch. If [milliseconds]
  /// represents a date-time, the time is truncated.
  factory Date.fromMilliseconds(int milliseconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return Date(date.year, date.month, date.day);
  }

  /// Creates a [Date] from the given microseconds since epoch. If [microseconds]
  /// represents a date-time, the time is truncated.
  factory Date.fromMicroseconds(int microseconds) {
    final date = DateTime.fromMicrosecondsSinceEpoch(microseconds);
    return Date(date.year, date.month, date.day);
  }

  /// Creates a [Date] that represents the current date.
  factory Date.today() {
    final date = DateTime.now();
    return Date(date.year, date.month, date.day);
  }


  @override
  Date operator + (Duration duration) => Date.fromMicroseconds(microsecondsSinceEpoch + duration.inMicroseconds);


  @override
  // ignore: invalid_use_of_protected_member
  LocalDateTime toLocal() => _local ??= LocalDateTime(year, month, day)..datePart = this;

  @override
  // ignore: invalid_use_of_protected_member
  UtcDateTime toUtc() => _utc ??= UtcDateTime(year, month, day)..datePart = this;

  @override
  @protected Date of(int year, int month, int day, int hour, int minute, int second, int millisecond, int microsecond) =>
      Date(year, month, day);

}