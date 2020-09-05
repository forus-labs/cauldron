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

class Day {
  static const hours = 24;
  static const minutes = 1440;
  static const seconds = 86400;
  static const milliseconds = 86400000;
  static const microseconds = 86400000000;
}

class Hour {
  static const minutes = 60;
  static const seconds = 3600;
  static const milliseconds = 3600000;
  static const microseconds = 3600000000;
}

class Minute {
  static const seconds = 60;
  static const milliseconds = 60000;
  static const microseconds = 60000000;
}

class Second {
  static const milliseconds = 1000;
  static const microseconds = 1000000;

  static int from(int hour, [int minute = 0, int second = 0]) =>
      hour * Hour.seconds + minute * Minute.seconds + second;
}

class Millisecond {
  static const microseconds = 1000;

  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0]) =>
      hour * Hour.milliseconds + minute * Minute.milliseconds +
          second * Second.milliseconds + millisecond;
}

class Microsecond {
  static int from(int hour, [int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) =>
      hour * Hour.microseconds + minute * Minute.microseconds + second * Second.microseconds +
          millisecond * Millisecond.microseconds + microsecond;
}
