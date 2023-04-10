import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/src/time/time.dart';
import 'package:sugar/time.dart';

/// Creates an [OffsetTime] that does not check the ranges of arguments.
///
/// This exists because Dart is fucking stupid and doesn't have any visibility modifiers.
@internal OffsetTime offsetTime(Offset offset, int hour, int minute, int second, int millisecond, int microsecond) => OffsetTime._(offset, hour, minute, second, millisecond, microsecond);


/// Represents the time of the day with an offset from UTC/Greenwich, i.e. `10:15:30+08:00`. Time is stored to microsecond precision.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// To compare two [OffsetTime], they should be first converted to microseconds using [toOffsettedMicroseconds].
/// ```dart
/// final foo = OffsetTime(Offset(8), 12); // '12:00+08:00'
/// final bar = OffsetTime(Offset(-8), 12); // '12:00-08:00'
///
/// print(foo.toOffsettedMicroseconds() < bar.toOffsettedMicroseconds()); // true
/// ```
class OffsetTime extends TimeBase {

  /// The valid range of [OffsetTime]s in microseconds from `00:00+18:00` to `23:59:59.999999-18:00`, inclusive.
  static final Interval<int> range = Interval.closed(-18 * Duration.microsecondsPerHour, (Duration.millisecondsPerDay + 18 * Duration.microsecondsPerHour) - 1);

  /// The offset.
  final Offset offset;

  int? _microseconds;
  String? _string;


  /// Creates a [OffsetTime] that represents the current time with the given precision.
  ///
  /// ```dart
  /// // Assuming that it's '12:39:59:999999+08:00'
  ///
  /// final now = OffsetTime.now(); // '12:39:59:999999+08:00'
  ///
  /// final truncated = LocalTime.now(TimeUnit.seconds); // '12:39:59+08:00'
  /// ```
  factory OffsetTime.now([TimeUnit precision = TimeUnit.microseconds]) {
    final now = DateTime.now();
    final offset = Offset.fromDuration(now.timeZoneOffset);
    switch (precision) {
      case TimeUnit.hours:
        return OffsetTime._(offset, now.hour);
      case TimeUnit.minutes:
        return OffsetTime._(offset, now.hour, now.minute);
      case TimeUnit.seconds:
        return OffsetTime._(offset, now.hour, now.minute, now.second);
      case TimeUnit.milliseconds:
        return OffsetTime._(offset, now.hour, now.minute, now.second, now.millisecond);
      case TimeUnit.microseconds:
        return OffsetTime._(offset, now.hour, now.minute, now.second, now.millisecond, now.microsecond);
    }
  }

  factory OffsetTime._fromDayMicroseconds(Offset offset, DayMicroseconds value) {
    value %= Duration.microsecondsPerDay;

    final microsecond = value % 1000;
    value ~/= 1000;

    final millisecond = value % 1000;
    value ~/= 1000;

    final second = value % 60;
    value ~/= 60;

    final minute = value % 60;
    value ~/= 60;

    final hour = value % 60;

    return OffsetTime._(offset, hour, minute, second, millisecond, microsecond);
  }

  /// Creates a [OffsetTime].
  ///
  /// ## Contract:
  /// The given arguments must be within the following ranges, otherwise a [RangeError] is thrown.
  /// * `0 <= hour < 24`
  /// * `0 <= minute < 60`
  /// * `0 <= second < 60`
  /// * `0 <= millisecond < 1000`
  /// * `0 <= microsecond < 1000`
  @Possible({RangeError})
  OffsetTime(this.offset, [super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]): super.check();

  OffsetTime._(this.offset, [super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]);


  /// Returns a copy of this [OffsetTime] truncated to the given time unit.
  ///
  /// ```dart
  /// final time = OffsetTime(Offset(8), 12, 39, 59, 999, 999);
  /// final truncated = time.truncate(to: TimeUnit.minutes); // '12:39+08:00'
  /// ```
  OffsetTime truncate({required TimeUnit to}) => Time.truncate(this, _toOffsetTime, to);

  /// Returns a copy of this [OffsetTime] with the given time unit rounded to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.round(5, TimeUnit.minutes); // '12:30:59+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 12, 34, 59);
  /// bar.round(5, TimeUnit.minutes); // '12:35:59+08:00'
  /// ```
  OffsetTime round(int value, TimeUnit unit) => Time.round(this, _toOffsetTime, value, unit);

  /// Returns a copy of this [OffsetTime] with the given time unit ceil to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.round(5, TimeUnit.minutes); // '12:35:59+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 12, 34, 59);
  /// bar.round(5, TimeUnit.minutes); // '12:35:59+08:00'
  /// ```
  OffsetTime ceil(int value, TimeUnit unit) => Time.ceil(this, _toOffsetTime, value, unit);

  /// Returns a copy of this [OffsetTime] with the given time unit floored to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.round(5, TimeUnit.minutes); // '12:30:59+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 12, 34, 59);
  /// bar.round(5, TimeUnit.minutes); // '12:30:59+08:00'
  /// ```
  OffsetTime floor(int value, TimeUnit unit) => Time.floor(this, _toOffsetTime, value, unit);


  /// Returns a copy of this [OffsetTime] with the given time added. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12).add(hours: -1, minutes: 1); // '11:01+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 20).add(hours: 8); // '04:00+08:00'
  /// ```
  OffsetTime add({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) {
    final total = _toMicroseconds() + Microseconds.from(hours, minutes, seconds, milliseconds, microseconds);
    return OffsetTime._fromDayMicroseconds(offset, total);
  }

  /// Returns a copy of this [OffsetTime] with the given time subtracted. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12).subtract(hours: -1, minutes: 1); // '13:01+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 4).subtract(hours: 6); // '22:00+08:00'
  /// ```
  OffsetTime subtract({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) {
    final total = _toMicroseconds() - Microseconds.from(hours, minutes, seconds, milliseconds, microseconds);
    return OffsetTime._fromDayMicroseconds(offset, total);
  }

  /// Returns a copy of this [OffsetTime] with the given time added. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12) + const Duration(hours: -1, minutes: 1); // '11:01+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 20) + const Duration(hours: 8); // '04:00+08:00'
  /// ```
  OffsetTime operator + (Duration duration) => add(microseconds: duration.inMicroseconds);

  /// Returns a copy of this [OffsetTime] with the given time subtracted. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12) - const Duration(hours: -1, minutes: 1); // '13:01+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 4) - const Duration(hours: 6); // '22:00+08:00'
  /// ```
  OffsetTime operator - (Duration duration) => subtract(microseconds: duration.inMicroseconds);


  /// Returns the difference between this [OffsetTime] and other.
  ///
  /// ```dart
  /// OffsetTime(Offset(-2), 22).difference(OffsetTime(Offset(2), 12)); // 14 hours
  ///
  /// OffsetTime(Offset(3), 13).difference(OffsetTime(Offset(-3), 23)); // -16 hours
  /// ```
  Duration difference(OffsetTime other) => Duration(microseconds: toOffsettedMicroseconds() - other.toOffsettedMicroseconds());


  /// Returns this [OffsetTime] without an offset.
  LocalTime toLocalTime() => localTime(hour, minute, second, millisecond, microsecond);

  /// Returns this [OffsetTime] in microseconds, adjusted using its offset. The returned microseconds may be negative.
  ///
  /// To compare two [OffsetTime], they should be first converted to microseconds using this function.
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12); // '12:00+08:00'
  /// final bar = OffsetTime(Offset(-8), 12); // '12:00-08:00'
  ///
  /// print(foo.toOffsettedMicroseconds() < bar.toOffsettedMicroseconds()); // true
  /// ```
  int toOffsettedMicroseconds() => _toMicroseconds() - offset.seconds * 1000000;


  OffsetTime _toOffsetTime(int hour, int minute, int second, int millisecond, int microsecond) => OffsetTime._(offset, hour, minute, second, millisecond, microsecond);

  DayMicroseconds _toMicroseconds() => _microseconds ??= Microseconds.from(hour, minute, second, millisecond, microsecond);


  /// Returns a copy of this [OffsetTime] with the given updated parts.
  ///
  /// ```dart
  /// final noon = OffsetTime(Offset(8), 12);
  ///
  /// final halfPastNoon = noon.copyWith(offset: Offset(12), minute: 30); // '12:30+12:00'
  /// ```
  ///
  /// ## Contract:
  /// The given arguments must be within the following ranges, otherwise a [RangeError] is thrown.
  /// * `0 <= hour < 24`
  /// * `0 <= minute < 60`
  /// * `0 <= second < 60`
  /// * `0 <= millisecond < 1000`
  /// * `0 <= microsecond < 1000`
  OffsetTime copyWith({Offset? offset, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) => OffsetTime(
    offset ?? this.offset,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond  ?? this.microsecond,
  );


  @override
  bool operator ==(Object other) => identical(this, other) || other is OffsetTime && runtimeType == other.runtimeType &&
    offset == other.offset && _toMicroseconds() == other._toMicroseconds();

  @override
  int get hashCode => offset.hashCode ^ _toMicroseconds();

  @override
  String toString() => _string ??= Time.format(this, offset);

}
