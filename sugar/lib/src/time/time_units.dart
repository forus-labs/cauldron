// ignore_for_file: public_member_api_docs

/// A temporal unit.
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

/// Constants that represent a day in other time units.
class Day {
  static const hours = 24;
  static const minutes = 1440;
  static const seconds = 86400;
  static const milliseconds = 86400000;
  static const microseconds = 86400000000;
}

/// Constants that represent an hour in other time units.
class Hour {
  static const minutes = 60;
  static const seconds = 3600;
  static const milliseconds = 3600000;
  static const microseconds = 3600000000;
}

/// Constants that represent a minute in other time units.
class Minute {
  static const seconds = 60;
  static const milliseconds = 60000;
  static const microseconds = 60000000;
}

/// Constants that represent a second in other time units.
class Second {
  static const milliseconds = 1000;
  static const microseconds = 1000000;

  /// Converts the given duration into seconds.
  static int from(int hour, [int minute = 0, int second = 0]) =>
      hour * Hour.seconds + minute * Minute.seconds + second;
}

/// Constants that represent a millisecond in other time units.
class Millisecond {
  static const microseconds = 1000;

  /// Converts the given duration into milliseconds.
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0]) =>
      hour * Hour.milliseconds + minute * Minute.milliseconds +
          second * Second.milliseconds + millisecond;
}

/// Constants that represent a microsecond in other time units.
class Microsecond {

  /// Converts the given duration into microseconds.
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) =>
      hour * Hour.microseconds + minute * Minute.microseconds + second * Second.microseconds +
          millisecond * Millisecond.microseconds + microsecond;
}
