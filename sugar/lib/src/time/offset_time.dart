import 'package:sugar/core.dart';
import 'package:sugar/math.dart';
import 'package:sugar/time.dart';

/// Represents the time of the day with an offset from UTC/Greenwich, i.e. `10:15:30+08:00`. It cannot be used to represent a specific
/// point in time without an additional offset or timezone.
///
/// To compare two [OffsetTime], they should be first converted to microseconds using [toOffsettedMicroseconds].
/// ```dart
/// final foo = OffsetTime(Offset(8), 12); // '12:00+08:00'
/// final bar = OffsetTime(Offset(-8), 12); // '12:00-08:00'
///
/// print(foo.toOffsettedMicroseconds() < bar.toOffsettedMicroseconds()); // true
/// ```
class OffsetTime {

  /// The valid range of [OffsetTime]s in microseconds from `00:00+18:00` to `23:59:59.999999-18:00`, inclusive.
  static final Interval<int> range = Interval.closed(-18 * Duration.microsecondsPerHour, (Duration.millisecondsPerDay + 18 * Duration.microsecondsPerHour) - 1);

  /// The offset.
  final Offset offset;
  /// The hour.
  final int hour;
  /// The minute.
  final int minute;
  /// The second.
  final int second;
  /// The millisecond.
  final int millisecond;
  /// The microsecond.
  final int microsecond;

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


  /// Creates a [OffsetTime] using the given offset and time.
  OffsetTime.fromLocalTime(Offset offset, LocalTime time): this._(offset, time.hour, time.minute, time.second, time.millisecond, time.microsecond);

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
  OffsetTime(this.offset, [this.hour = 0, this.minute = 0, this.second = 0, this.millisecond = 0, this.microsecond = 0]) {
    RangeError.checkValueInInterval(hour, 0, 23, 'hour');
    RangeError.checkValueInInterval(minute, 0, 59, 'minute');
    RangeError.checkValueInInterval(second, 0, 59, 'second');
    RangeError.checkValueInInterval(millisecond, 0, 999, 'millisecond');
    RangeError.checkValueInInterval(microsecond, 0, 999, 'microsecond');
  }

  OffsetTime._(this.offset, [this.hour = 0, this.minute = 0, this.second = 0, this.millisecond = 0, this.microsecond= 0]);


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


  /// Returns a copy of this [OffsetTime] with the given time unit rounded to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.round(5, TimeUnit.minutes); // '12:30:59+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 12, 34, 59);
  /// bar.round(5, TimeUnit.minutes); // '12:35:59+08:00'
  /// ```
  OffsetTime round(int value, TimeUnit unit) => _adjust(value, unit, (time, to) => time.roundTo(to));

  /// Returns a copy of this [OffsetTime] with the given time unit ceil to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.round(5, TimeUnit.minutes); // '12:35:59+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 12, 34, 59);
  /// bar.round(5, TimeUnit.minutes); // '12:35:59+08:00'
  /// ```
  OffsetTime ceil(int value, TimeUnit unit) => _adjust(value, unit, (time, to) => time.ceilTo(to));

  /// Returns a copy of this [OffsetTime] with the given time unit floored to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.round(5, TimeUnit.minutes); // '12:30:59+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 12, 34, 59);
  /// bar.round(5, TimeUnit.minutes); // '12:30:59+08:00'
  /// ```
  OffsetTime floor(int value, TimeUnit unit) => _adjust(value, unit, (time, to) => time.floorTo(to));

  OffsetTime _adjust(int value, TimeUnit unit, int Function(int, int) function) {
    switch (unit) {
      case TimeUnit.hours:
        return OffsetTime._(offset, function(hour, value), minute, second, millisecond, microsecond);
      case TimeUnit.minutes:
        return OffsetTime._(offset, hour, function(minute, value), second, millisecond, microsecond);
      case TimeUnit.seconds:
        return OffsetTime._(offset ,hour, minute, function(second, value), millisecond, microsecond);
      case TimeUnit.milliseconds:
        return OffsetTime._(offset, hour, minute, second, function(millisecond, value), microsecond);
      case TimeUnit.microseconds:
        return OffsetTime._(offset, hour, minute, second, millisecond, function(microsecond, value));
    }
  }


  /// Returns a copy of this [OffsetTime] truncated to the given time unit.
  ///
  /// ```dart
  /// final time = OffsetTime(Offset(8), 12, 39, 59, 999, 999);
  /// final truncated = time.truncate(to: TimeUnit.minutes); // '12:39+08:00'
  /// ```
  OffsetTime truncate({required TimeUnit to}) {
    switch (to) {
      case TimeUnit.hours:
        return OffsetTime._(offset, hour);
      case TimeUnit.minutes:
        return OffsetTime._(offset, hour, minute);
      case TimeUnit.seconds:
        return OffsetTime._(offset, hour, minute, second);
      case TimeUnit.milliseconds:
        return OffsetTime._(offset, hour, minute, second, millisecond);
      case TimeUnit.microseconds:
        return OffsetTime._(offset, hour, minute, second, millisecond, microsecond);
    }
  }


  /// Returns the difference between this [OffsetTime] and other.
  ///
  /// ```dart
  /// OffsetTime(Offset(-2), 22).difference(OffsetTime(Offset(2), 12)); // 14 hours
  ///
  /// OffsetTime(Offset(3), 13).difference(OffsetTime(Offset(-3), 23)); // -16 hours
  /// ```
  Duration difference(OffsetTime other) => Duration(microseconds: toOffsettedMicroseconds() - other.toOffsettedMicroseconds());


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


  /// Returns this [OffsetTime] without an offset.
  LocalTime toLocalTime() => LocalTime(hour, minute, second, millisecond, microsecond);

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


  @override
  bool operator ==(Object other) => identical(this, other) || other is OffsetTime && runtimeType == other.runtimeType &&
    offset == other.offset && _toMicroseconds() == other._toMicroseconds();

  @override
  int get hashCode => offset.hashCode ^ _toMicroseconds();

  DayMicroseconds _toMicroseconds() => _microseconds ??= Microseconds.from(hour, minute, second, millisecond, microsecond);


  @override
  String toString() => _string ??= _format();

  String _format() {
    final hours = hour.toString().padLeft(2, '0');
    final minutes = minute.toString().padLeft(2, '0');

    final seconds = second == 0 && millisecond == 0 && microsecond == 0 ? '' : ':${second.toString().padLeft(2, '0')}';
    final milliseconds = millisecond == 0 && microsecond == 0 ? '' : '.${millisecond.toString().padLeft(3, '0')}';
    final microseconds = microsecond == 0 ? '' :  microsecond.toString().padLeft(3, '0');

    return '$hours:$minutes$seconds$milliseconds$microseconds$offset';
  }

}
