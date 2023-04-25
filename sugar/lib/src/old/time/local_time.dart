part of '../../time/time.dart';

/// Represents the time of the day as seen on a wall clock, i.e. `10:15:30`. Time is stored to microsecond precision.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// A [LocalTime] is immutable and should be treated as a value-type.
///
/// See [range] for more information on the valid range of [LocalTime]s.
class LocalTime extends Time with Orderable<LocalTime> {

  /// The valid range of [LocalTime]s, from `00:00` to `23:59:59.999999`, inclusive.
  static final Interval<LocalTime> range = Interval.closed(LocalTime(), LocalTime(23, 59, 59, 999, 999));
  /// The time of midnight, `00:00`.
  static final LocalTime midnight = LocalTime();
  /// The time of noon, `12:00`.
  static final LocalTime noon = LocalTime(12);

  int? _microseconds;
  String? _string;

  /// Creates a [LocalTime] with the given seconds since midnight. The calculation wraps around midnight.
  ///
  /// ```dart
  /// LocalTime.fromDaySeconds(43200); // '12:00'
  ///
  /// LocalTime.fromDaySeconds(Duration.secondsPerDay); // '00:00'
  /// ```
  LocalTime.fromDaySeconds(super.seconds): super.fromDaySeconds();

  /// Creates a [LocalTime] with the given milliseconds since midnight. The calculation wraps around midnight.
  ///
  /// ```dart
  /// LocalTime.fromDayMilliseconds(43200000000); // '12:00'
  ///
  /// LocalTime.fromDayMilliseconds(Duration.millisecondsPerDay); // '00:00'
  /// ```
  LocalTime.fromDayMilliseconds(super.milliseconds): super.fromDayMilliseconds();

  /// Creates a [LocalTime] with the given microseconds since midnight. The calculation wraps around midnight.
  ///
  /// ```dart
  /// LocalTime.fromDayMicroseconds(43200000); // '12:00'
  ///
  /// LocalTime.fromDayMicroseconds(Duration.microsecondsPerDay); // '00:00'
  /// ```
  LocalTime.fromDayMicroseconds(super.microseconds): super.fromDayMicroseconds();

  /// Creates a [LocalTime] that represents the current time.
  LocalTime.now(): super.fromNativeDateTime(DateTime.now());

  /// Creates a [LocalTime].
  ///
  /// ```dart
  /// final time = LocalTime(12, 39, 59, 999, 999) // '12:39:59:999999'
  ///
  /// final overflow = LocalTime(25) // '01:00'
  ///
  /// final underflow = LocalTime(-1) // '23:00'
  /// ```
  LocalTime([super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]);

  LocalTime._copy(super.native): super._copy();


  /// Returns a copy of this [LocalTime] with the given time added. The calculation wraps around midnight.
  ///
  /// ```dart
  /// LocalTime(12).plus(hours: -1, minutes: 1); // '11:01'
  ///
  /// LocalTime(20).plus(hours: 8); // '04:00'
  /// ```
  ///
  /// See [add].
  @useResult LocalTime plus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalTime._copy(Time.plus(_native, hours, minutes, seconds, milliseconds, microseconds));

  /// Returns a copy of this [LocalTime] with the given time subtracted. The calculation wraps around midnight.
  ///
  /// ```dart
  /// LocalTime(12).minus(hours: -1, minutes: 1); // '13:01'
  ///
  /// LocalTime(4).minus(hours: 6); // '22:00'
  /// ```
  ///
  /// See [subtract].
  @useResult LocalTime minus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalTime._copy(Time.minus(_native, hours, minutes, seconds, milliseconds, microseconds));


  /// Returns a copy of this [LocalTime] with the given [duration] added. The calculation wraps around midnight.
  ///
  /// ```dart
  /// LocalTime(12).add(Duration(hours: -1, minutes: 1)); // '11:01'
  ///
  /// LocalTime(20).add(Duration(hours: 8)); // '04:00'
  /// ```
  ///
  /// See [plus].
  @useResult LocalTime add(Duration duration) => LocalTime._copy(_native.plus(duration));

  /// Returns a copy of this [LocalTime] with the given [duration] subtracted. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = LocalTime(12).minus(Duration(hours: -1, minutes: 1)); // '13:01'
  ///
  /// final bar = LocalTime(4).minus(Duration(hours: 6)); // '22:00'
  /// ```
  ///
  /// See [minus].
  @useResult LocalTime subtract(Duration duration) => LocalTime._copy(_native.minus(duration));


  /// Returns a copy of this [LocalTime] truncated to the given time unit.
  ///
  /// ```dart
  /// LocalTime(12, 39, 59, 999, 999).truncate(to: TimeUnit.minutes); // '12:39'
  /// ```
  @useResult LocalTime truncate({required TimeUnit to}) => LocalTime._copy(Time.truncate(_native, to));

  /// Returns a copy of this [LocalTime] with only the given time unit rounded to the nearest [value].
  ///
  /// ```dart
  /// LocalTime(12, 31, 59).round(5, TimeUnit.minutes); // '12:30:59'
  ///
  /// LocalTime(12, 34, 59).round(5, TimeUnit.minutes); // '12:35:59'
  /// ```
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult LocalTime round(int value, TimeUnit unit) => LocalTime._copy(Time.round(_native, value, unit));

  /// Returns a copy of this [LocalTime] with only the given time unit ceil to the nearest [value].
  ///
  /// ```dart
  /// LocalTime(12, 31, 59).round(5, TimeUnit.minutes); // '12:35:59'
  ///
  /// LocalTime(12, 34, 59).round(5, TimeUnit.minutes); // '12:35:59'
  /// ```
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult LocalTime ceil(int value, TimeUnit unit) => LocalTime._copy(Time.ceil(_native, value, unit));

  /// Returns a copy of this [LocalTime] with only the given time unit floored to the nearest [value].
  ///
  /// ```dart
  /// LocalTime(12, 31, 59).round(5, TimeUnit.minutes); // '12:30:59'
  ///
  /// LocalTime(12, 34, 59).round(5, TimeUnit.minutes); // '12:30:59'
  /// ```
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult LocalTime floor(int value, TimeUnit unit) => LocalTime._copy(Time.floor(_native, value, unit));


  /// Returns a copy of this [LocalTime] with the given updated parts.
  ///
  /// ```dart
  /// LocalTime(12).copyWith(minute: 30); // '12:30'
  /// ```
  @useResult LocalTime copyWith({int? hour, int? minute, int? second, int? millisecond, int? microsecond}) => LocalTime(
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond  ?? this.microsecond,
  );


  /// Returns the difference between this [LocalTime] and other.
  ///
  /// ```dart
  /// LocalTime(22).difference(LocalTime(12)); // 10 hours
  ///
  /// LocalTime(13).difference(LocalTime(23)); // -10 hours
  /// ```
  @useResult Duration difference(LocalTime other) => Duration(microseconds: toDayMicroSeconds() - other.toDayMicroSeconds());


  /// Combines this time with an offset to create an [OffsetTime].
  ///
  /// ```dart
  /// LocalTime(12).at(Offset(8)); // '12:00+08:00'
  /// ```
  @useResult OffsetTime at(Offset offset) => OffsetTime._copy(offset, _native);

  /// Returns a native [DateTime] that represents this [LocalTime]. The date is always set to January 1st 1970 (Unix epoch).
  @useResult DateTime toNativeDateTime() => DateTime.utc(1970, 1, 1, _native.hour, _native.minute, _native.second, _native.millisecond, _native.microsecond);

  /// Returns this [LocalTime] as seconds since midnight. The milliseconds and microseconds are truncated.
  ///
  /// ```dart
  /// LocalTime(12, 0, 0, 999, 999).toDaySeconds(); // 43200 ('12:00')
  /// ```
  @useResult DaySeconds toDaySeconds() => Seconds.from(hour, minute, second);

  /// Returns this [LocalTime] as milliseconds since midnight. The milliseconds are truncated.
  ///
  /// ```dart
  /// LocalTime(12, 0, 0, 0, 999).toDayMilliseconds(); // 43200000 ('12:00')
  /// ```
  @useResult DayMilliseconds toDayMilliseconds() => Milliseconds.from(hour, minute, second, millisecond);

  /// Returns this [LocalTime] as microseconds since midnight.
  ///
  /// ```dart
  /// LocalTime(12).toDayMicroseconds(); // 43200000000 ('12:00')
  /// ```
  @useResult DayMicroseconds toDayMicroSeconds() => _microseconds ??= Microseconds.from(hour, minute, second, millisecond, microsecond);


  @override
  int compareTo(LocalTime other) => toDayMicroSeconds().compareTo(other.toDayMicroSeconds());

  @override
  int get hashValue => runtimeType.hashCode ^ toDayMicroSeconds();

  @override
  String toString() => _string ??= Time.format(_native, null);

}
