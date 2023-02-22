import 'package:sugar/core.dart';

abstract class _Time<T extends _Time<T>> {

  final int hour;
  final int minute;
  final int second;
  final int millisecond;
  final int microsecond;

  _Time(this.hour, this.minute, this.second, this.millisecond, this.microsecond);


  T add({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0});

  T subtract({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0});

  T operator + (Duration duration);

  T operator - (Duration duration);


  Duration difference(T other);


  T copyWith({int? hour, int? minute, int? second, int? millisecond, int? microsecond});

}

class LocalTime extends _Time<LocalTime> with Orderable<LocalTime> {

  static final Interval<LocalTime> range = Interval.closed(LocalTime(), LocalTime(23, 59, 59, 999, 999));
  static final midnight = LocalTime();
  static final noon = LocalTime(12);


  factory LocalTime.fromMilliseconds(int milliseconds) => LocalTime.fromMicroseconds(milliseconds * 1000);

  factory LocalTime.fromMicroseconds(int microseconds) {
    final total = microseconds;
    final microsecond = microseconds % 1000;
    microseconds ~/= 1000;

    final millisecond = microseconds % 1000;
    microseconds ~/= 1000;

    final second = microseconds % 60;
    microseconds ~/= 60;

    final minute = microseconds % 60;
    microseconds ~/= 60;

    final hour = microseconds % 60;

    return LocalTime(hour, minute, second, millisecond, microsecond);
  }

  factory LocalTime.now() {
    final now = DateTime.now();
    return LocalTime(now.hour, now.minute, now.second, now.millisecond, now.microsecond);
  }

  LocalTime([super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]) {
    RangeError.checkValueInInterval(minute, 0, 23, 'hour');
    RangeError.checkValueInInterval(minute, 0, 60, 'minute');
    RangeError.checkValueInInterval(minute, 0, 60, 'second');
    RangeError.checkValueInInterval(minute, 0, 1000, 'millisecond');
    RangeError.checkValueInInterval(minute, 0, 1000, 'microsecond');
  }


  @override
  LocalTime add({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) {

  }


  @override
  LocalTime copyWith({int? hour, int? minute, int? second, int? millisecond, int? microsecond}) => LocalTime(
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

}
