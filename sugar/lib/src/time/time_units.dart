/// A unit of date-time.
enum TimeUnit {
  year,
  month,
  day,
  hour,
  minute,
  second,
  millisecond,
  microsecond,
}

/// Provides constants that represents a day in other time units.
class Day {
  static const hours = 24;
  static const minutes = 1440;
  static const seconds = 86400;
  static const milliseconds = 86400000;
  static const microseconds = 86400000000;
}

/// Provides constants that represents an hour in other time units.
class Hour {
  static const minutes = 60;
  static const seconds = 3600;
  static const milliseconds = 3600000;
  static const microseconds = 3600000000;
}

/// Provides constants that represents a minute in other time units.
class Minute {
  static const seconds = 60;
  static const milliseconds = 60000;
  static const microseconds = 60000000;
}

/// Provides constants that represents a second in other time units and functions
/// to convert between other time units and seconds.
class Second {
  static const milliseconds = 1000;
  static const microseconds = 1000000;

  /// Converts the given time units into seconds.
  static int from(int hour, [int minute = 0, int second = 0]) =>
      hour * Hour.seconds + minute * Minute.seconds + second;
}

/// Provides constants that represents a millisecond in other time units and functions
/// to convert between other time units and millisecond.
class Millisecond {
  static const microseconds = 1000;

  /// Converts the given time units into milliseconds.
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0]) =>
      hour * Hour.milliseconds + minute * Minute.milliseconds +
          second * Second.milliseconds + millisecond;
}

/// Provides constants that represents a microsecond in other time units and functions
/// to convert between other time units and microsecond.
class Microsecond {

  /// Converts the given time units into microseconds
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) =>
      hour * Hour.microseconds + minute * Minute.microseconds + second * Second.microseconds +
          millisecond * Millisecond.microseconds + microsecond;
}
