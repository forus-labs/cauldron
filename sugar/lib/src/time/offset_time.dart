part of 'time.dart';

/// Represents the time of the day with an offset from UTC/Greenwich, i.e. `10:15:30+08:00`. Time is stored to microsecond precision.
///
/// To compare two [OffsetTime], they should be first converted to microseconds using [toOffsettedMicroseconds].
/// ```dart
/// final foo = OffsetTime(Offset(8), 12); // '12:00+08:00'
/// final bar = OffsetTime(Offset(-8), 12); // '12:00-08:00'
///
/// print(foo.toOffsettedMicroseconds() < bar.toOffsettedMicroseconds()); // true
/// ```
///
/// An [OffsetTime] is immutable and should be treated as a value-type.
///
/// See [range] for more information on the valid range of [OffsetTime]s.
class OffsetTime extends Time {

  /// The valid range of [OffsetTime]s in microseconds from `00:00+18:00` to `23:59:59.999999-18:00`, inclusive.
  static final Interval<int> range = Interval.closed(-18 * Duration.microsecondsPerHour, (Duration.millisecondsPerDay + 18 * Duration.microsecondsPerHour) - 1);

  /// The offset.
  final Offset offset;
  int? _microseconds;
  String? _string;

  /// Creates a [OffsetTime] that represents the current time.
  OffsetTime.now(): this._now(DateTime.now());

  /// Creates a [OffsetTime].
  ///
  /// ```dart
  /// final time = OffsetTime(Offset(8), 12, 39, 59, 999, 999) // '12:39:59:999999+08:00'
  ///
  /// final overflow = OffsetTime(Offset(8), 25) // '01:00+08:00'
  ///
  /// final underflow = OffsetTime(Offset(8), -1) // '23:00+08:00'
  /// ```
  OffsetTime(this.offset, [super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]);

  OffsetTime._now(super.time): offset = Offset.fromDuration(time.timeZoneOffset), super.fromNativeDateTime();

  OffsetTime._copy(this.offset, super.time): super._copy();


  /// Returns a copy of this [OffsetTime] with the given time added. The calculation wraps around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).plus(hours: -1, minutes: 1); // '11:01+08:00'
  ///
  /// OffsetTime(Offset(8), 20).plus(hours: 8); // '04:00+08:00'
  /// ```
  ///
  /// See [add].
  @useResult OffsetTime plus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
      OffsetTime._copy(offset, Time.plus(_native, hours, minutes, seconds, milliseconds, microseconds));

  /// Returns a copy of this [OffsetTime] with the given time subtracted. The calculation wraps around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).minus(hours: -1, minutes: 1); // '13:01+08:00'
  ///
  /// OffsetTime(Offset(8), 4).minus(hours: 6); // '22:00+08:00'
  /// ```
  ///
  /// See [subtract].
  @useResult OffsetTime minus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
      OffsetTime._copy(offset, Time.minus(_native, hours, minutes, seconds, milliseconds, microseconds));


  /// Returns a copy of this [OffsetTime] with the given [duration] added. The calculation wraps around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).add(Duration(hours: -1, minutes: 1)); // '11:01+08:00'
  ///
  /// OffsetTime(Offset(8), 20).add(Duration(hours: 8)); // '04:00+08:00'
  /// ```
  @useResult OffsetTime add(Duration duration) => OffsetTime._copy(offset, _native.add(duration));

  /// Returns a copy of this [OffsetTime] with the given [duration] subtracted. The calculation wraps around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).subtract(Duration(hours: -1, minutes: 1)); // '13:01+08:00'
  ///
  /// OffsetTime(Offset(8), 4).subtract(Duration(hours: 6)); // '22:00+08:00'
  /// ```
  @useResult OffsetTime subtract(Duration duration) => OffsetTime._copy(offset, _native.subtract(duration));


  /// Returns a copy of this [OffsetTime] truncated to the given time unit.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12, 39, 59, 999, 999).truncate(to: TimeUnit.minutes); // '12:39+08:00'
  /// ```
  @useResult OffsetTime truncate({required TimeUnit to}) => OffsetTime._copy(offset, Time.truncate(_native, to));

  /// Returns a copy of this [OffsetTime] with the given time unit rounded to the nearest [value].
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12, 31, 59).round(5, TimeUnit.minutes); // '12:30:59+08:00'
  ///
  /// OffsetTime(Offset(8), 12, 34, 59).round(5, TimeUnit.minutes); // '12:35:59+08:00'
  /// ```
  @useResult OffsetTime round(int value, TimeUnit unit) => OffsetTime._copy(offset, Time.round(_native, value, unit));

  /// Returns a copy of this [OffsetTime] with the given time unit ceil to the nearest [value].
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12, 31, 59).round(5, TimeUnit.minutes); // '12:35:59+08:00'
  ///
  /// OffsetTime(Offset(8), 12, 34, 59).round(5, TimeUnit.minutes); // '12:35:59+08:00'
  /// ```
  @useResult OffsetTime ceil(int value, TimeUnit unit) => OffsetTime._copy(offset, Time.ceil(_native, value, unit));

  /// Returns a copy of this [OffsetTime] with the given time unit floored to the nearest [value].
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12, 31, 59).round(5, TimeUnit.minutes); // '12:30:59+08:00'
  ///
  /// OffsetTime(Offset(8), 12, 34, 59).round(5, TimeUnit.minutes); // '12:30:59+08:00'
  /// ```
  @useResult OffsetTime floor(int value, TimeUnit unit) => OffsetTime._copy(offset, Time.floor(_native, value, unit));


  /// Returns the difference between this [OffsetTime] and other.
  ///
  /// ```dart
  /// OffsetTime(Offset(-2), 22).difference(OffsetTime(Offset(2), 12)); // 14 hours
  ///
  /// OffsetTime(Offset(3), 13).difference(OffsetTime(Offset(-3), 23)); // -16 hours
  /// ```
  @useResult Duration difference(OffsetTime other) => Duration(microseconds: toOffsettedMicroseconds() - other.toOffsettedMicroseconds());


  /// Returns this [OffsetTime] without an offset.
  @useResult LocalTime toLocalTime() => LocalTime._copy(_native);

  /// Returns this [OffsetTime] in microseconds, adjusted using its offset. The returned microseconds may be negative.
  ///
  /// To compare two [OffsetTime], they should be first converted to microseconds using this function.
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12); // '12:00+08:00'
  /// final bar = OffsetTime(Offset(-8), 12); // '12:00-08:00'
  ///
  /// print(foo.toOffsettedMicroseconds() < bar.toOffsettedMicroseconds()); // true
  /// ```
  @useResult int toOffsettedMicroseconds() => _microseconds ??= Microseconds.from(hour, minute, second, millisecond, microsecond) - offset.seconds * Duration.microsecondsPerSecond;


  /// Returns a copy of this [OffsetTime] with the given updated parts.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).copyWith(offset: Offset(12), minute: 30); // '12:30+12:00'
  /// ```
  @useResult OffsetTime copyWith({Offset? offset, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) => OffsetTime(
    offset ?? this.offset,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond  ?? this.microsecond,
  );


  @override
  @useResult bool operator ==(Object other) => identical(this, other) || other is OffsetTime && runtimeType == other.runtimeType &&
      offset == other.offset && toOffsettedMicroseconds() == other.toOffsettedMicroseconds();

  @override
  @useResult int get hashCode => runtimeType.hashCode ^ offset.hashCode ^ toOffsettedMicroseconds();

  @override
  @useResult String toString() => _string ??= Time.format(_native, offset);

}
