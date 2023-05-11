part of 'time.dart';

/// The time of the day without a timezone, as seen on a wall clock, such as. `12:30`.
///
/// A [LocalTime] is immutable.  It cannot represent a specific point in time without an additional offset or timezone.
/// Time is stored to microsecond precision See [range] for the valid range of `LocalTime`s.
///
/// ## Working with `LocalTime`s
///
/// To create a `LocalTime`:
/// ```dart
/// final now = LocalTime.now();
/// final moonLanding = LocalTime(18, 4);
/// ```
/// You can add and subtract different types of time intervals, including:
/// * [Duration] - [add] and [subtract]
/// * [Period] - [+] and [-]
/// * Individual units of time - [plus] and [minus]
///
/// `LocalTime` behaves the same for all 3 types of time intervals. All calculations wrap around midnight.
///
/// ```dart
/// final later = now.add(const Duration(hours: 1);
/// final evenLater = now + const Period(hour: 2);
/// final latest = now.plus(hours: 3);
/// ```
///
/// `LocalTime`s can be compared using the comparison operators such as [<].
///
/// ```dart
/// print(now < later); // true
/// print(latest >= evenLater); // true
/// ```
///
/// You can also [truncate], [round], [ceil] and [floor] `LocalTime`.
///
/// ```dart
/// print(moonLanding.truncate(to: TimeUnit.hours); // 18:00
/// print(moonLanding.round(TimeUnit.minutes, 5);   // 18:05
/// print(moonLanding.ceil(TimeUnit.minutes, 5);    // 18:05
/// print(moonLanding.floor(TimeUnit.minutes, 5);   // 18:00
/// ```
///
/// ## Other resources
/// See [OffsetTime] to represent times with offsets.
class LocalTime extends Time with Orderable<LocalTime> {

  /// The valid range of [LocalTime]s, from `00:00` to `23:59:59.999999`, inclusive.
  static final Interval<LocalTime> range = Interval.closed(LocalTime(), LocalTime(23, 59, 59, 999, 999));
  /// Midnight, `00:00`.
  static final LocalTime midnight = LocalTime();
  /// Noon, `12:00`.
  static final LocalTime noon = LocalTime(12);


  String? _string;

  // TODO: https://github.com/dart-lang/linter/issues/3563
  // ignore: comment_references
  /// Creates a [LocalTime] from the [milliseconds] since midnight, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime.fromDayMilliseconds(43200000); // 12:00
  ///
  /// LocalTime.fromDayMilliseconds(Duration.millisecondsPerDay + 1); // 00:00:00.001
  /// ```
  LocalTime.fromDayMilliseconds(super.milliseconds): super.fromDayMilliseconds();

  // TODO: https://github.com/dart-lang/linter/issues/3563
  // ignore: comment_references
  /// Creates a [LocalTime] with the [microseconds] since midnight, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime.fromDayMicroseconds(43200000000); // 12:00
  ///
  /// LocalTime.fromDayMicroseconds(Duration.microsecondsPerDay + 1); // 00:00:00.000001
  /// ```
  LocalTime.fromDayMicroseconds(super.microseconds): super.fromDayMicroseconds();

  /// Creates a [LocalTime] that represents the current time.
  LocalTime.now(): super.fromNative(DateTime.now());

  /// Creates a [LocalTime].
  ///
  /// ```dart
  /// LocalTime(12, 39, 59, 999, 999); // 12:39:59:999999
  ///
  /// LocalTime(25); // 01:00
  ///
  /// LocalTime(-1); // 23:00
  /// ```
  LocalTime([super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]);

  LocalTime._(super.native): super._();


  /// Returns a copy of this with the [duration] added, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime(12).add(Duration(hours: -1, minutes: 1)); // 11:01
  ///
  /// LocalTime(20).add(Duration(hours: 8)); // 04:00
  /// ```
  @useResult LocalTime add(Duration duration) => LocalTime._(_native.add(duration));

  /// Returns a copy of this with the [duration] subtracted, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime(12).minus(Duration(hours: -1, minutes: 1)); // 13:01
  ///
  /// LocalTime(4).minus(Duration(hours: 6)); // 22:00
  /// ```
  @useResult LocalTime subtract(Duration duration) => LocalTime._(_native.subtract(duration));

  /// Returns a copy of this with the time units added, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime(12).plus(hours: -1, minutes: 1); // 11:01
  ///
  /// LocalTime(20).plus(hours: 8); // 04:00
  /// ```
  @useResult LocalTime plus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalTime._(_native.plus(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this with the time units subtracted, wrapping around midnight.
  ///
  /// ```dart
  /// LocalTime(12).minus(hours: -1, minutes: 1); // 13:01
  ///
  /// LocalTime(4).minus(hours: 6); // 22:00
  /// ```
  @useResult LocalTime minus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalTime._(_native.minus(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this with the [period] added.
  ///
  /// ```dart
  /// LocalTime(11, 30) + Period(hours: 1); // 12:30
  /// ```
  @useResult LocalTime operator + (Period period) => LocalTime._(_native + period);

  /// Returns a copy of this with the [period] subtracted.
  ///
  /// ```dart
  /// LocalTime(11, 30) - Period(hours: 1); // 10:30
  /// ```
  @useResult LocalTime operator - (Period period) => LocalTime._(_native - period);


  /// Returns a copy of this truncated to the [TimeUnit].
  ///
  /// ```dart
  /// LocalTime(12, 39, 59).truncate(to: TimeUnit.minutes); // 12:39
  /// ```
  @useResult LocalTime truncate({required TimeUnit to}) => LocalTime._(_native.truncate(to: to));

  /// Returns a copy of this rounded to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalTime(12, 31, 59).round(TimeUnit.minutes, 5); // 12:30
  ///
  /// LocalTime(12, 34, 59).round(TimeUnit.minutes, 5); // 12:35
  /// ```
  @Possible({RangeError})
  @useResult LocalTime round(TimeUnit unit, int value) => LocalTime._(_native.round(unit, value));

  /// Returns a copy of this ceiled to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalTime(12, 31, 59).round(TimeUnit.minutes, 5); // 12:35
  ///
  /// LocalTime(12, 34, 59).round(TimeUnit.minutes, 5); // 12:35
  /// ```
  @Possible({RangeError})
  @useResult LocalTime ceil(TimeUnit unit, int value) => LocalTime._(_native.ceil(unit, value));

  /// Returns a copy of this floored to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalTime(12, 31, 59).round(5, TimeUnit.minutes); // 12:30
  ///
  /// LocalTime(12, 34, 59).round(5, TimeUnit.minutes); // 12:30
  /// ```
  @Possible({RangeError})
  @useResult LocalTime floor(TimeUnit unit, int value) => LocalTime._(_native.floor(unit, value));


  /// Returns a copy of this with the updated units of time.
  ///
  /// ```dart
  /// LocalTime(12).copyWith(minute: 30); // 12:30
  /// ```
  @useResult LocalTime copyWith({int? hour, int? minute, int? second, int? millisecond, int? microsecond}) => LocalTime(
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond  ?? this.microsecond,
  );


  /// Returns the difference between this and [other].
  ///
  /// ```dart
  /// LocalTime(22).difference(LocalTime(12)); // 10 hours
  ///
  /// LocalTime(13).difference(LocalTime(23)); // -10 hours
  /// ```
  @useResult Duration difference(LocalTime other) => Duration(microseconds: dayMicroseconds - other.dayMicroseconds);


  /// Converts this to a [OffsetTime].
  ///
  /// ```dart
  /// LocalTime(12).at(Offset(8)); // 12:00+08:00
  /// ```
  @useResult OffsetTime at(Offset offset) => OffsetTime._(offset, _native);

  /// Converts this to a [DateTime] in UTC.
  ///
  /// The date is always set to Unix epoch (1970 January 1st).
  @useResult DateTime toNative() => DateTime.utc(1970, 1, 1, _native.hour, _native.minute, _native.second, _native.millisecond, _native.microsecond);


  @override
  int compareTo(LocalTime other) => dayMicroseconds.compareTo(other.dayMicroseconds);

  @override
  int get hashValue => runtimeType.hashCode ^ dayMicroseconds;

  /// Returns a ISO formatted string representation.
  ///
  /// When possible, trailing zero seconds, milliseconds and microseconds are truncated.
  ///
  /// ```dart
  /// LocalDateTime(12, 30, 1, 2, 3); // 12:30:01.002003
  ///
  /// LocalDateTime(12, 30); // 12:30
  /// ```
  @override
  String toString() => _string ??= _native.toTimeString();


  /// The milliseconds since midnight.
  ///
  /// ```dart
  /// LocalTime(12).dayMicroseconds; // 43200000 (12:00)
  /// ```
  @useResult DayMilliseconds get dayMilliseconds => _native.millisecondsSinceMidnight;

  /// The microseconds since midnight.
  ///
  /// ```dart
  /// LocalTime(12).dayMicroseconds; // 43200000000 (12:00)
  /// ```
  @useResult DayMicroseconds get dayMicroseconds => _native.microsecondsSinceMidnight;

}
