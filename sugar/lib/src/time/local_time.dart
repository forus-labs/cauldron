part of 'time.dart';

/// The time of the day as seen on a wall clock, i.e. `10:15`. Time is stored to microsecond precision.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// A [LocalTime] is immutable and should be treated as a value-type. See [range] for more information on the valid range
/// of [LocalTime]s.
class LocalTime extends Time with Orderable<LocalTime> {

  /// The valid range of [LocalTime]s, from `00:00` to `23:59:59.999999`, inclusive.
  static final Interval<LocalTime> range = Interval.closed(LocalTime(), LocalTime(23, 59, 59, 999, 999));
  /// The time of midnight, `00:00`.
  static final LocalTime midnight = LocalTime();
  /// The time of noon, `12:00`.
  static final LocalTime noon = LocalTime(12);


  String? _string;

  /// Creates a [LocalTime] with the milliseconds since midnight which wraps around midnight.
  ///
  /// ```dart
  /// LocalTime.fromDayMilliseconds(43200000000); // '12:00'
  ///
  /// LocalTime.fromDayMilliseconds(Duration.millisecondsPerDay); // '00:00'
  /// ```
  LocalTime.fromDayMilliseconds(super.milliseconds): super.fromDayMilliseconds();

  /// Creates a [LocalTime] with the microseconds since midnight which wraps around midnight.
  ///
  /// ```dart
  /// LocalTime.fromDayMicroseconds(43200000); // '12:00'
  ///
  /// LocalTime.fromDayMicroseconds(Duration.microsecondsPerDay); // '00:00'
  /// ```
  LocalTime.fromDayMicroseconds(super.microseconds): super.fromDayMicroseconds();

  /// Creates a [LocalTime] that represents the current time.
  LocalTime.now(): super.fromNative(DateTime.now());

  /// Creates a [LocalTime].
  ///
  /// ```dart
  /// // '12:39:59:999999'
  /// final time = LocalTime(12, 39, 59, 999, 999) ;
  ///
  /// final overflow = LocalTime(25); // '01:00'
  ///
  /// final underflow = LocalTime(-1); // '23:00'
  /// ```
  LocalTime([super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]);

  LocalTime._(super.native): super._();


  /// Returns a copy of this [LocalTime] with the [duration] added, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime(12).add(Duration(hours: -1, minutes: 1)); // '11:01'
  ///
  /// LocalTime(20).add(Duration(hours: 8)); // '04:00'
  /// ```
  @useResult LocalTime add(Duration duration) => LocalTime._(_native.add(duration));

  /// Returns a copy of this [LocalTime] with the [duration] subtracted, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime(12).minus(Duration(hours: -1, minutes: 1)); // '13:01'
  ///
  /// LocalTime(4).minus(Duration(hours: 6)); // '22:00'
  /// ```
  @useResult LocalTime subtract(Duration duration) => LocalTime._(_native.subtract(duration));

  /// Returns a copy of this [LocalTime] with the time added, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime(12).plus(hours: -1, minutes: 1); // '11:01'
  ///
  /// LocalTime(20).plus(hours: 8); // '04:00'
  /// ```
  @useResult LocalTime plus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalTime._(_native.plus(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this [LocalTime] with the time subtracted, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime(12).minus(hours: -1, minutes: 1); // '13:01'
  ///
  /// LocalTime(4).minus(hours: 6); // '22:00'
  /// ```
  @useResult LocalTime minus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalTime._(_native.minus(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this [LocalTime] with the [Period] added.
  ///
  /// ```dart
  /// LocalTime(11, 30) + Period(hours: 1); // '12:30'
  /// ```
  @useResult LocalTime operator + (Period period) => LocalTime._(_native + period);

  /// Returns a copy of this [LocalTime] with the [Period] subtracted.
  ///
  /// ```dart
  /// LocalTime(11, 30) - Period(hours: 1); // '10:30'
  /// ```
  @useResult LocalTime operator - (Period period) => LocalTime._(_native - period);


  /// Returns a copy of this [LocalTime] truncated to the time unit.
  ///
  /// ```dart
  /// final foo = LocalTime(12, 39, 59);
  /// foo.truncate(to: TimeUnit.minutes); // '12:39'
  /// ```
  @useResult LocalTime truncate({required TimeUnit to}) => LocalTime._(_native.truncate(to: to));

  /// Returns a copy of this [LocalTime] with only the time unit rounded to the nearest [value].
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. Throws a [RangeError] otherwise.
  ///
  /// ## Example:
  /// ```dart
  /// LocalTime(12, 31, 59).round(5, TimeUnit.minutes); // '12:30:59'
  ///
  /// LocalTime(12, 34, 59).round(5, TimeUnit.minutes); // '12:35:59'
  /// ```
  @Possible({RangeError})
  @useResult LocalTime round(int value, TimeUnit unit) => LocalTime._(_native.round(value, unit));

  /// Returns a copy of this [LocalTime] with only the time unit ceil to the nearest [value].
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. Throws a [RangeError] otherwise.
  ///
  /// ## Example:
  /// ```dart
  /// LocalTime(12, 31, 59).round(5, TimeUnit.minutes); // '12:35:59'
  ///
  /// LocalTime(12, 34, 59).round(5, TimeUnit.minutes); // '12:35:59'
  /// ```
  @Possible({RangeError})
  @useResult LocalTime ceil(int value, TimeUnit unit) => LocalTime._(_native.ceil(value, unit));

  /// Returns a copy of this [LocalTime] with only the time unit floored to the nearest [value].
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. Throws a [RangeError] otherwise.
  ///
  /// ## Example:
  /// ```dart
  /// LocalTime(12, 31, 59).round(5, TimeUnit.minutes); // '12:30:59'
  ///
  /// LocalTime(12, 34, 59).round(5, TimeUnit.minutes); // '12:30:59'
  /// ```
  @Possible({RangeError})
  @useResult LocalTime floor(int value, TimeUnit unit) => LocalTime._(_native.floor(value, unit));


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
  @useResult Duration difference(LocalTime other) => Duration(microseconds: dayMicroseconds - other.dayMicroseconds);

  /// Returns the difference between this [LocalTime] and other.
  ///
  /// The returned [Period] will be negative if [other] occurs after this.
  ///
  /// ```dart
  /// LocalTime(22).gap(LocalTime(12)); // 10 hours
  ///
  /// LocalTime(13).gap(LocalTime(23)); // -10 hours
  /// ```
  @useResult Period gap(LocalTime other) => Period(
    hours: hour - other.hour,
    minutes: minute - other.minute,
    seconds: second - other.second,
    milliseconds: millisecond - other.millisecond,
    microseconds: microsecond - other.microsecond,
  );


  /// Returns a native [DateTime] in UTC that represents this [LocalTime].
  ///
  /// The date is always set to 1970 January 1st (Unix epoch).
  @useResult DateTime toNative() => DateTime.utc(1970, 1, 1, _native.hour, _native.minute, _native.second, _native.millisecond, _native.microsecond);


  @override
  int compareTo(LocalTime other) => dayMicroseconds.compareTo(other.dayMicroseconds);

  @override
  int get hashValue => runtimeType.hashCode ^ dayMicroseconds;

  @override
  String toString() => _string ??= _native.toTimeString();


  /// The milliseconds since midnight.
  ///
  /// ```dart
  /// final m = LocalTime(12).dayMicroseconds;
  /// print(m); // 43200000 ('12:00')
  /// ```
  @useResult DayMilliseconds get dayMilliseconds => _native.millisecondsSinceMidnight;

  /// The microseconds since midnight.
  ///
  /// ```dart
  /// final m = LocalTime(12).dayMicroseconds;
  /// print(m); // 43200000000 ('12:00')
  /// ```
  @useResult DayMicroseconds get dayMicroseconds => _native.microsecondsSinceMidnight;

}
