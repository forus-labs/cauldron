import 'package:meta/meta.dart';

/// The days since Unix epoch, 1st January 1970.
typedef EpochDays = int;

/// The seconds since Unix epoch, 1st January 1970.
typedef EpochSeconds = int;

/// The milliseconds since Unix epoch, 1st January 1970.
typedef EpochMilliseconds = int;

/// The microseconds since Unix epoch, 1st January 1970.
typedef EpochMicroseconds = int;


/// The seconds in a day since midnight.
typedef DaySeconds = int;

/// The milliseconds in a day since midnight.
typedef DayMilliseconds = int;

/// The microseconds in a day since midnight.
typedef DayMicroseconds = int;


/// A unit of date-time, such as days or hours.
@sealed class TemporalUnit {}

/// A unit of date, such as months and days.
enum DateUnit implements TemporalUnit {
  /// The years.
  years,
  /// The months.
  months,
  /// The days.
  days,
}

/// A unit of time, such as hours and minutes.
enum TimeUnit implements TemporalUnit {
  /// The hours.
  hours,
  /// The minutes.
  minutes,
  /// The seconds.
  seconds,
  /// The milliseconds.
  milliseconds,
  /// The microseconds.
  microseconds,
}


/// Converts the sum of all individual parts to microseconds.
@internal
@useResult int sumMicroseconds(int hours, [int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0]) =>
  hours * Duration.microsecondsPerHour +
  minutes * Duration.microsecondsPerMinute +
  seconds * Duration.microsecondsPerSecond +
  milliseconds * Duration.microsecondsPerMillisecond +
  microseconds;
