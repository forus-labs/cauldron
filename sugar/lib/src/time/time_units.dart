import 'package:meta/meta.dart';

/// Provides utilities for converting between minutes and other time units.
extension Minutes on Never {
  /// Converts the given time units into minutes.
  @useResult
  static int from(int hour, [int minute = 0]) => hour * Duration.minutesPerHour + minute;
}

/// Provides utilities for converting between seconds and other time units.
extension Seconds on Never {
  /// Converts the given time units into seconds.
  @useResult
  static int from(int hour, [int minute = 0, int second = 0]) =>
      hour * Duration.secondsPerHour +
      minute * Duration.secondsPerMinute +
      second;
}

/// Provides utilities for converting between milliseconds and other time units.
extension Milliseconds on Never {
  /// Converts the given time units into milliseconds.
  @useResult
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0]) =>
      hour * Duration.millisecondsPerHour +
      minute * Duration.millisecondsPerMinute +
      second * Duration.millisecondsPerSecond +
      millisecond;
}

/// Provides utilities for converting between microseconds and other time units.
extension Microseconds on Never {
  /// Converts the given time units into microseconds.
  @useResult
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) =>
      hour * Duration.microsecondsPerHour +
      minute * Duration.millisecondsPerMinute +
      second * Duration.microsecondsPerSecond +
      millisecond * Duration.microsecondsPerMillisecond +
      microsecond;
}
