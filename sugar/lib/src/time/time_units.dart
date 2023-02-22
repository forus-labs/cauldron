/// Provides constants for converting between hours and other time units.
extension Hour on Never {
  /// The number of minutes in an hour.
  static const minutes = 60;
  /// The number of minutes in an hour.
  static const seconds = 3600;
  /// The number of milliseconds in an hour.
  static const milliseconds = 3600000;
  /// The number of microseconds in an hour.
  static const microseconds = 3600000000;
}

/// Provides constants and utilities for converting between minutes and other time units.
extension Minute on Never {
  /// The number of seconds in a minute.
  static const seconds = 60;
  /// The number of milliseconds in a minute.
  static const milliseconds = 60000;
  /// The number of microseconds in a minute.
  static const microseconds = 60000000;
}

/// Provides constants and utilities for converting between seconds and other time units.
extension Second on Never {
  /// The number of milliseconds in a second.
  static const milliseconds = 1000;
  /// The number of microseconds in a second.
  static const microseconds = 1000000;

  /// Converts the given time units into seconds.
  static int from(int hour, [int minute = 0, int second = 0]) =>
      hour * Hour.seconds +
      minute * Minute.seconds + second;
}

/// Provides constants and utilities for converting between milliseconds and other time units.
extension Millisecond on Never {
  /// The number of microseconds in a millisecond.
  static const microseconds = 1000;

  /// Converts the given time units into milliseconds.
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0]) =>
      hour * Hour.milliseconds +
      minute * Minute.milliseconds +
      second * Second.milliseconds +
      millisecond;
}

/// Provides utilities for converting between microseconds and other time units.
extension Microsecond on Never {
  /// Converts the given time units into microseconds.
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) =>
      hour * Hour.microseconds +
      minute * Minute.microseconds +
      second * Second.microseconds +
      millisecond * Millisecond.microseconds +
      microsecond;
}
