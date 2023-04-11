import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/math.dart';
import 'package:sugar/time.dart';

part 'local_time.dart';
part 'offset_time.dart';

/// A temporal that contains units of time. All calculations should wrap around midnight.
@internal abstract class Time {

  /// Formats the given [time] to an ISO-8601 time string.
  static String format(DateTime time, Offset? offset) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    final seconds = time.second == 0 && time.millisecond == 0 && time.microsecond == 0 ? '' : ':${time.second.toString().padLeft(2, '0')}';
    final milliseconds = time.millisecond == 0 && time.microsecond == 0 ? '' : '.${time.millisecond.toString().padLeft(3, '0')}';
    final microseconds = time.microsecond == 0 ? '' :  time.microsecond.toString().padLeft(3, '0');
    final suffix = offset == null ? '' : offset.toString();

    return '$hours:$minutes$seconds$milliseconds$microseconds$suffix';
  }


  /// Returns a [DateTime] truncated to the given time unit. The date fields are not modified.
  static DateTime truncate(DateTime time, TimeUnit to) {
    switch (to) {
      case TimeUnit.hours:
        return time.copyWith(minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case TimeUnit.minutes:
        return time.copyWith(second: 0, millisecond: 0, microsecond: 0);
      case TimeUnit.seconds:
        return time.copyWith(millisecond: 0, microsecond: 0);
      case TimeUnit.milliseconds:
        return time.copyWith(microsecond: 0);
      case TimeUnit.microseconds:
        return time;
    }
  }

  /// Returns a [DateTime] with the given time unit rounded to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime round(DateTime time, int to, TimeUnit unit) => _adjust(time, to, unit, (time, to) => time.roundTo(to));

  /// Returns a [DateTime] with the given time unit ceiled to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime ceil(DateTime time, int to, TimeUnit unit) => _adjust(time, to, unit, (time, to) => time.ceilTo(to));

  /// Returns a [DateTime] with the given time unit floored to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime floor(DateTime time, int to, TimeUnit unit) => _adjust(time, to, unit, (time, to) => time.floorTo(to));

  static DateTime _adjust(DateTime time, int to, TimeUnit unit, int Function(int time, int to) apply) {
    switch (unit) {
      case TimeUnit.hours:
        return time.copyWith(hour: apply(time.hour, to));
      case TimeUnit.minutes:
        return time.copyWith(minute: apply(time.hour, to));
      case TimeUnit.seconds:
        return time.copyWith(second: apply(time.hour, to));
      case TimeUnit.milliseconds:
        return time.copyWith(millisecond: apply(time.hour, to));
      case TimeUnit.microseconds:
        return time.copyWith(microsecond: apply(time.hour, to));
    }
  }


  /// Returns a [DateTime] with the given time added. The calculation wraps around midnight.
  static DateTime plus(DateTime date, int hours, int minutes, int seconds, int milliseconds, int microseconds) => date.copyWith(
    hour: date.hour + hours,
    minute: date.minute + minutes,
    second: date.second + seconds,
    millisecond: date.millisecond + milliseconds,
    microsecond: date.microsecond + microseconds,
  );

  /// Returns a [DateTime] with the given time subtracted. The calculation wraps around midnight.
  static DateTime minus(DateTime date, int hours, int minutes, int seconds, int milliseconds, int microseconds) => date.copyWith(
    hour: date.hour - hours,
    minute: date.minute - minutes,
    second: date.second - seconds,
    millisecond: date.millisecond - milliseconds,
    microsecond: date.microsecond - microseconds,
  );


  final DateTime _native;

  /// Creates a [Time] with the given seconds since midnight.
  Time.fromDaySeconds(DaySeconds seconds): _native = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

  /// Creates a [Time] with the given milliseconds since midnight.
  Time.fromDayMilliseconds(DayMilliseconds milliseconds): _native = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [Time] with the given microseconds since midnight.
  Time.fromDayMicroseconds(DayMicroseconds microseconds): _native = DateTime.fromMicrosecondsSinceEpoch(microseconds, isUtc: true);

  /// Creates a [Time] from the native [DateTime].
  Time.fromNativeDateTime(DateTime time): _native = DateTime.utc(1970, 1, 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);

  /// Creates a [Time].
  Time([int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
        _native = DateTime.utc(1970, 1, 1, hour, minute, second, millisecond, microsecond);

  Time._copy(this._native);

  /// The hour.
  int get hour => _native.hour;

 /// The minute.
  int get minute => _native.minute;

  /// The second.
  int get second => _native.second;

  /// The millisecond.
  int get millisecond => _native.millisecond;

  /// The microsecond.
  int get microsecond => _native.microsecond;

}
