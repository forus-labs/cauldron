import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/math.dart';
import 'package:sugar/time.dart';

/// A function that creates a [T] using the given arguments.
@internal typedef Create<T extends Time> = T Function(int hour, int minute, int second, int millisecond, int microsecond);

/// Represents a temporal that contains units of time.
@internal mixin Time {

  /// Formats the given [Time] to an ISO-8601 time string.
  static String format(Time time, Offset? offset) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    final seconds = time.second == 0 && time.millisecond == 0 && time.microsecond == 0 ? '' : ':${time.second.toString().padLeft(2, '0')}';
    final milliseconds = time.millisecond == 0 && time.microsecond == 0 ? '' : '.${time.millisecond.toString().padLeft(3, '0')}';
    final microseconds = time.microsecond == 0 ? '' :  time.microsecond.toString().padLeft(3, '0');
    final suffix = offset == null ? '' : offset.toString();

    return '$hours:$minutes$seconds$milliseconds$microseconds$suffix';
  }


  /// Returns a [T] with the given time unit rounded to the nearest value.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static T round<T extends Time>(T time, Create<T> create, int to, TimeUnit unit) => _adjust(time, create, to, unit, (time, to) => time.roundTo(to));

  /// Returns a [T] with the given time unit ceiled to the nearest value.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static T ceil<T extends Time>(T time, Create<T> create, int to, TimeUnit unit) => _adjust(time, create, to, unit, (time, to) => time.ceilTo(to));

  /// Returns a [T] with the given time unit floored to the nearest value.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static T floor<T extends Time>(T time, Create<T> create, int to, TimeUnit unit) => _adjust(time, create, to, unit, (time, to) => time.floorTo(to));

  static T _adjust<T extends Time>(T time, Create<T> create, int to, TimeUnit unit, int Function(int time, int to) apply) {
    switch (unit) {
      case TimeUnit.hours:
        return create(apply(time.hour, to), time.minute, time.second, time.millisecond, time.microsecond);
      case TimeUnit.minutes:
        return create(time.hour, apply(time.minute, to), time.second, time.millisecond, time.microsecond);
      case TimeUnit.seconds:
        return create(time.hour, time.minute, apply(time.second, to), time.millisecond, time.microsecond);
      case TimeUnit.milliseconds:
        return create(time.hour, time.minute, time.second, apply(time.millisecond, to), time.microsecond);
      case TimeUnit.microseconds:
        return create(time.hour, time.minute, time.second, time.millisecond, apply(time.microsecond, to));
    }
  }


  /// Returns a [T] truncated to the given time unit.
  static T truncate<T extends Time>(T time, Create<T> create, TimeUnit to) {
    switch (to) {
      case TimeUnit.hours:
        return create(time.hour, 0, 0, 0, 0);
      case TimeUnit.minutes:
        return create(time.hour, time.minute, 0, 0, 0);
      case TimeUnit.seconds:
        return create(time.hour, time.minute, time.second, 0, 0);
      case TimeUnit.milliseconds:
        return create(time.hour, time.minute, time.second, time.millisecond, 0);
      case TimeUnit.microseconds:
        return create(time.hour, time.minute, time.second, time.millisecond, time.microsecond);
    }
  }


  /// The hour.
  int get hour;
  /// The minute.
  int get minute;
  /// The second.
  int get second;
  /// The millisecond.
  int get millisecond;
  /// The microsecond.
  int get microsecond;

}

/// Represents a base temporal implementation that contains units of time.
@internal abstract class TimeBase with Time {

  /// The hour.
  @override final int hour;
  /// The minute.
  @override final int minute;
  /// The second.
  @override final int second;
  /// The millisecond.
  @override final int millisecond;
  /// The microsecond.
  @override final int microsecond;

  /// Creates a [TimeBase], checking the validity of the given time units.
  /// 
  /// ## Contract:
  /// The given arguments must be within the following ranges, otherwise a [RangeError] is thrown.
  /// * `0 <= hour < 24`
  /// * `0 <= minute < 60`
  /// * `0 <= second < 60`
  /// * `0 <= millisecond < 1000`
  /// * `0 <= microsecond < 1000`
  @Possible({RangeError})
  TimeBase.check([this.hour = 0, this.minute = 0, this.second = 0, this.millisecond = 0, this.microsecond = 0]) {
    RangeError.checkValueInInterval(hour, 0, 23, 'hour');
    RangeError.checkValueInInterval(minute, 0, 59, 'minute');
    RangeError.checkValueInInterval(second, 0, 59, 'second');
    RangeError.checkValueInInterval(millisecond, 0, 999, 'millisecond');
    RangeError.checkValueInInterval(microsecond, 0, 999, 'microsecond');
  }

  /// Creates a [Time] without checking the validity of the given time units.
  TimeBase([this.hour = 0, this.minute = 0, this.second = 0, this.millisecond = 0, this.microsecond = 0]);

}
