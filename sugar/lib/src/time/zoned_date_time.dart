part of 'date_time.dart';

/// A date-time with a timezone such as `2023-04-13T10:15:30+08:00 Asia/Singapore`. This class stores fields to microsecond
/// precision. It can be used to represent a specific point in time.
///
/// A [ZonedDateTime] can represent date-times with:
/// * A fixed offset from UTC that uses the same offset for all points on the timeline.
/// * A timezone in the IANA TZ database. This includes geographical locations which offset may vary across points on the timeline.
///
/// Obtaining the offset for a local datetime is non-trivial. It is possible for a local datetime to be ambiguous or invalid
/// due to timezone transitions.
///
/// There are three cases:
/// * Normal, with one valid offset. For most of the year, this is the case.
///
/// * Gap, with zero offsets. This is when the clock jumps forward, typically when transitioning from "winter" to "summer"
///   time. If a local datetime falls in the middle of a gap, the offset after the gap, i.e. "summer" time, is returned.
///
/// * Overlap, with two valid offsets. This is when clocks are set back, typically when transitioning from "summer" to
///   "winter" time. If a local datetime falls in the middle of an overlap, the offset before the overlap, , i.e. "winter"
///   time, is returned.
///
/// ## Note
/// By default, Detecting and retrieving the current timezone, i.e. [ZonedDateTime.now] is only supported on Windows, MacOS,
/// Linux & Web platforms. See [Timezone.platformTimezoneProvider] for more information.
///
/// A [ZonedDateTime] is immutable and should be treated as a value-type.
class ZonedDateTime extends DateTimeBase {

  /// The timezone.
  final Timezone timezone;
  /// The span in which this datetime occurs.
  final TimezoneSpan span;
  /// The microseconds since Unix epoch.
  final EpochMicroseconds epochMicroseconds;
  String? _string;

  /// Creates a [ZonedDateTime] that represents the milliseconds since Unix epoch (January 1st 1970) in the given local
  /// timezone.
  ///
  /// ```dart
  /// final timezone = Timezone('Asia/Singapore');
  /// final milliseconds = 1682865000000; // 2023-04-30T14:30Z
  ///
  /// final date = ZonedDateTime.fromEpochMilliseconds(timezone, milliseconds));
  ///
  /// print(date); // 2023-4-30T22:30+08:00
  /// ```
  factory ZonedDateTime.fromEpochMilliseconds(Timezone timezone, EpochMilliseconds milliseconds) => ZonedDateTime._(
      timezone,
      DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true)
  );

  /// Creates a [ZonedDateTime] that represents the microseconds since Unix epoch (January 1st 1970) in the given local
  /// timezone.
  ///
  /// ```dart
  /// final timezone = Timezone('Asia/Singapore');
  /// final microseconds = 1682865000000000; // 2023-04-30T14:30Z
  ///
  /// final date = ZonedDateTime.fromEpochMicroseconds(timezone, microseconds));
  ///
  /// print(date); // 2023-4-30T22:30+08:00
  /// ```
  factory ZonedDateTime.fromEpochMicroseconds(Timezone timezone, EpochMicroseconds microseconds) => ZonedDateTime._(
    timezone,
      DateTime.fromMicrosecondsSinceEpoch(microseconds, isUtc: true)
  );

  /// Creates a [ZonedDateTime] that represents the current datetime in the given [timezone]. The platform's current timezone
  /// is used if [timezone] is not given.
  ///
  /// ## Note
  /// By default, detecting and retrieving the platform's current timezone is only supported on Windows, MacOS, Linux &
  /// Web platforms. See [Timezone.platformTimezoneProvider] for more information.
  factory ZonedDateTime.now([Timezone? timezone]) => ZonedDateTime._(
    timezone ?? Timezone.now(),
    DateTime.now().toUtc(), // TODO: Dart 3 replace with DateTime.timestamp()
  );

  /// Creates a [ZonedDateTime].
  factory ZonedDateTime.from(Timezone timezone, int year, [
    int month = 1, 
    int day = 1, 
    int hour = 0, 
    int minute = 0, 
    int second = 0, 
    int millisecond = 0, 
    int microsecond = 0,
  ]) => ZonedDateTime._(timezone, DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond));

  /// Creates a [ZonedDateTime]. This is a convenience constructor for [ZonedDateTime.from].
  factory ZonedDateTime(String timezone, int year, [
    int month = 1, 
    int day = 1, 
    int hour = 0, 
    int minute = 0, 
    int second = 0, 
    int millisecond = 0, 
    int microsecond = 0,
  ]) => ZonedDateTime.from(Timezone(timezone), year, month, day, hour, minute, second, millisecond, microsecond);

  factory ZonedDateTime._(Timezone timezone, DateTime date) {
    final tuple = timezone.convert(local: date.microsecondsSinceEpoch); // TODO: Dart 3 destructuring
    return ZonedDateTime._fromNative(timezone, tuple.value, tuple.key, date);
  }

  ZonedDateTime._fromNative(this.timezone, this.span, this.epochMicroseconds, super._native): super.fromNative();


  /// Returns a copy of this [ZonedDateTime] with the [duration] added. Unlike [+] which adds the conceptual units of time,
  /// this method adds an exact number of microseconds. Consequentially, the resulting [ZonedDateTime] may be affected by
  /// DST.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// datetime.add(Duration(days: 1)); // 2023-03-13T01:00-04:00
  ///
  /// datetime + Period(days: 1); // 2023-03-13T00:00-04:00
  /// ```
  @useResult ZonedDateTime add(Duration duration) => ZonedDateTime.fromEpochMicroseconds(
    timezone,
    epochMicroseconds + duration.inMicroseconds,
  );

  /// Returns a copy of this [ZonedDateTime] with the [duration] subtracted. Unlike [-] which subtracts the conceptual units
  /// of time, this method subtracts an exact number of microseconds. Consequentially, the resulting [ZonedDateTime] may be
  /// affected by DST.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// datetime.subtract(Duration(days: 1)); // 2023-03-11T23:00-04:00
  ///
  /// datetime - Period(days: 1); // 2023-03-12T00:00-04:00
  /// ```
  @useResult ZonedDateTime subtract(Duration duration) => ZonedDateTime.fromEpochMicroseconds(
    timezone,
    epochMicroseconds - duration.inMicroseconds,
  );

  /// Returns a copy of this [ZonedDateTime] with the given time added. This method behaves similarly to [+]. Unlike [add]
  /// which adds an exact number of microseconds, this method adds the conceptual units of time. Consequentially, the resulting
  /// [ZonedDateTime] may be affected by DST.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// datetime.plus(days: 1); // 2023-03-13T00:00-04:00
  ///
  /// datetime.add(Duration(days: 1)); // 2023-03-13T01:00-04:00
  /// ```
  @useResult ZonedDateTime plus({int years = 0, int months = 0, int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    ZonedDateTime._(timezone, _native.plus(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this [ZonedDateTime] with the given time subtracted. This method behaves similarly to [-]. Unlike
  /// [subtract] which subtracts an exact number of microseconds, this method subtracts the conceptual units of time.
  /// Consequentially, the resulting [ZonedDateTime] may be affected by DST.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// datetime.minus(days: 1); // 2023-03-12T00:00-04:00
  ///
  /// datetime.subtract(Duration(days: 1)); // 2023-03-11T23:00-04:00
  /// ```
  @useResult ZonedDateTime minus({int years = 0, int months = 0, int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
      ZonedDateTime._(timezone, _native.minus(
        years: years,
        months: months,
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
      ));

  /// Returns a copy of this [ZonedDateTime] with the given time added. This method behaves similarly to [plus]. Unlike
  /// [add] which adds an exact number of microseconds, this method adds the conceptual units of time. Consequentially,
  /// the resulting [ZonedDateTime] may be affected by DST.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// datetime + Period(days: 1); // 2023-03-13T00:00-04:00
  ///
  /// datetime.add(Duration(days: 1)); // 2023-03-13T01:00-04:00
  /// ```
  @useResult ZonedDateTime operator + (Period period) => ZonedDateTime._(timezone, _native + period);

  /// Returns a copy of this [ZonedDateTime] with the given time subtracted. This method behaves similarly to [minus].
  /// Unlike [subtract] which subtracts an exact number of microseconds, this method subtracts the conceptual units of time.
  /// Consequentially, the resulting [ZonedDateTime] may be affected by DST.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// datetime - Period(days: 1); // 2023-03-12T00:00-04:00
  ///
  /// datetime.subtract(Duration(days: 1)); // 2023-03-11T23:00-04:00
  /// ```
  @useResult ZonedDateTime operator - (Period period) => ZonedDateTime._(timezone, _native - period);


  /// Returns a copy of this [ZonedDateTime] truncated to the given temporal unit.
  ///
  /// ```dart
  /// final date = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// date.truncate(to: DateUnit.months); // '2023-04-01T00:00+08:00'
  /// ```
  @useResult ZonedDateTime truncate({required TemporalUnit to}) => ZonedDateTime._(timezone, _native.truncate(to: to));

  /// Returns a copy of this [ZonedDateTime] with only the given temporal unit rounded to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  /// ## Example
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// foo.round(6, DateUnit.months); // '2023-06-15T00:00+08:00'
  ///
  /// final bar = ZonedDateTime(2023, 8, 15);
  /// bar.round(6, DateUnit.months); // '2023-06-15T00:00+08:00'
  /// ```
  @Possible({RangeError})
  @useResult ZonedDateTime round(TemporalUnit unit, int value) => ZonedDateTime._(timezone, _native.round(unit, value));

  /// Returns a copy of this [ZonedDateTime] with only the given temporal unit ceil to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  /// ## Example
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// foo.ceil(6, DateUnit.months); // '2023-06-15T00:00+08:00'
  ///
  /// final bar = ZonedDateTime('Asia/Singapore', 2023, 8, 15);
  /// bar.ceil(6, DateUnit.months); // '2023-12-15T00:00+08:00'
  /// ```
  @Possible({RangeError})
  @useResult ZonedDateTime ceil(TemporalUnit unit, int value) => ZonedDateTime._(timezone, _native.ceil(unit, value));

  /// Returns a copy of this [ZonedDateTime] with only the given temporal unit floored to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  ///
  /// ## Example
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// foo.floor(6, DateUnit.months); // '2023-01-15T00:00+08:00'
  ///
  /// final bar = ZonedDateTime('Asia/Singapore', 2023, 8, 15);
  /// bar.floor(6, DateUnit.months); // '2023-06-15T00:00+08:00'
  /// ```
  @Possible({RangeError})
  @useResult ZonedDateTime floor(TemporalUnit unit, int value) => ZonedDateTime._(timezone, _native.floor(unit, value));


  /// Returns a copy of this [ZonedDateTime] with the given updated parts.
  ///
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// foo.copyWith(day: 20); // '2023-04-20T00:00+08:00'
  /// ```
  @useResult ZonedDateTime copyWith({Timezone? timezone, int? year, int? month, int? day, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) =>
    ZonedDateTime.from(
      timezone ?? this.timezone,
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );


  /// Returns the difference in exact microseconds between this [ZonedDateTime] and other. This method will be affected
  /// by DST if the two dates are across DST transitions. The difference may also be negative.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final winter = ZonedDateTime('America/Detroit', 2023, 3, 12);
  /// final summer = ZonedDateTime('America/Detroit', 2023, 3, 13);
  ///
  /// print(summer.difference(winter)); // 23:00:00.000000
  ///
  /// print(winter.difference(summer)); // -23:00:00.000000
  /// ```
  @useResult Duration difference(ZonedDateTime other) => Duration(microseconds: epochMicroseconds - other.epochMicroseconds);

  /// Returns the difference when subtracting the individual conceptual time units of [other] from this. This method will
  /// not be affected by DST even if the two dates are across DST transitions.
  ///
  /// The returned [Period] will be negative if [other] occurs after this.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final winter = ZonedDateTime('America/Detroit', 2023, 3, 12);
  /// final summer = ZonedDateTime('America/Detroit', 2023, 3, 13);
  ///
  /// print(summer.gap(winter)); // 1 days
  ///
  /// print(winter.gap(summer)); // -1 days
  /// ```
  @useResult Period gap(ZonedDateTime other) => Period(
    years: year - other.year,
    months: month - other.month,
    days: day - other.day,
    hours: hour - other.hour,
    minutes: minute - other.minute,
    seconds: second - other.second,
    milliseconds: millisecond - other.millisecond,
    microseconds: microsecond - other.microsecond,
  );


  /// Converts this [ZonedDateTime] to a [LocalDateTime].
  @useResult LocalDateTime toLocal() => LocalDateTime._(_native);


  /// Returns true if this [ZonedDateTime] is before [other].
  ///
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 20, 12); // '2023-04-20T12:00+08:00[Asia/Singapore]'
  /// final bar = ZonedDateTime('Europe/London', 2023, 4, 20, 12); // '2023-04-20T12:00+01:00[Europe/London]'
  ///
  /// print(foo.isBefore(bar)); // true
  /// ```
  bool isBefore(ZonedDateTime other) => epochMicroseconds < other.epochMicroseconds;

  /// Returns true if this [ZonedDateTime] occurs at the same moment as [other].
  ///
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 20, 12); // '2023-04-20T12:00+08:00[Asia/Singapore]'
  /// final bar = ZonedDateTime('Europe/London', 2023, 4, 20, 5); // '2023-04-20T05:00+01:00[Europe/London]'
  ///
  /// print(bar.isSameMomentAs(foo)); // true
  /// ```
  bool isSameMomentAs(ZonedDateTime other) => epochMicroseconds == other.epochMicroseconds;

  /// Returns true if this [ZonedDateTime] is after [other].
  ///
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 20, 12); // '2023-04-20T12:00+08:00[Asia/Singapore]'
  /// final bar = ZonedDateTime('Europe/London', 2023, 4, 20, 12); // '2023-04-20T12:00+01:00[Europe/London]'
  ///
  /// print(bar.isAfter(foo)); // true
  /// ```
  bool isAfter(ZonedDateTime other) => epochMicroseconds > other.epochMicroseconds;


  @override
  bool operator ==(Object other) => identical(this, other) || other is ZonedDateTime && runtimeType == other.runtimeType &&
    timezone == other.timezone &&
    span == other.span &&
    epochMicroseconds == other.epochMicroseconds;

  @override
  int get hashCode => timezone.hashCode ^ span.hashCode ^ epochMicroseconds.hashCode;

  /// Returns a ISO-8601 formatted string.
  ///
  /// ## Format
  /// The format is yyyy-MM-ddTHH:mm:ss.mmmuuuZ\[identifier\] for UTC time, and
  /// yyyy-MM-ddTHH:mm:ss.mmmuuu±hhmm\[identifier\]  for local/non-UTC time, where:
  ///
  /// * yyyy is a, possibly negative, four digit representation of the year,
  ///   if the year is in the range -9999 to 9999, otherwise it is a signed
  ///   six digit representation of the year.
  /// * MM is the month in the range 01 to 12,
  /// * dd is the day of the month in the range 01 to 31,
  /// * HH are hours in the range 00 to 23,
  /// * mm are minutes in the range 00 to 59,
  /// * ss are seconds in the range 00 to 59 (no leap seconds),
  /// * mmm are milliseconds in the range 000 to 999, and
  /// * uuu are microseconds in the range 001 to 999. If microsecond equals 0,
  ///   then this part is omitted.
  /// * identifier is a TZ database identifier.
  ///
  /// Trailing zero-value seconds, milliseconds and microseconds are omitted.
  ///
  /// ## Example
  /// ```dart
  /// // 2023-04-30T12:15+08:00[Asia/Singapore]
  /// print(ZonedDateTime('Asia/Singapore', 2023, 4, 30, 12, 15));
  /// ```
  @override
  String toString() => _string ??= '${_native.toDateString()}T${_native.toTimeString()}${span.offset}[${timezone.name}]';


  /// The day of the week. Following ISO-8601, a week starts on Monday which has a value of `1` and ends on Sunday which
  /// has a value of `7`.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 1969, 7, 20).weekday; // Sunday, 7
  /// ```
  @useResult int get weekday => _native.weekday;


  /// The ordinal week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2023, 4, 1).weekOfYear; // 13
  /// ```
  @useResult int get weekOfYear => _native.weekOfYear;

  /// The ordinal day of the year.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2023, 4, 1).dayOfYear; // 91
  /// ```
  @useResult int get dayOfYear => _native.dayOfYear;


  /// The first day of this week.
  ///
  /// ```dart
  /// final tuesday = ZonedDateTime('Asia/Singapore', 2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // '2023-04-10'
  /// ```
  @useResult ZonedDateTime get firstDayOfWeek => ZonedDateTime._(timezone, _native.firstDayOfWeek);

  /// The last day of this week.
  ///
  /// ```dart
  /// final tuesday = ZonedDateTime('Asia/Singapore', 2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // '2023-04-16'
  /// ```
  @useResult ZonedDateTime get lastDayOfWeek => ZonedDateTime._(timezone, _native.lastDayOfWeek);


  /// The first day of this month.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2023, 4, 11).firstDayOfMonth; // '2023-04-01'
  /// ```
  @useResult ZonedDateTime get firstDayOfMonth => ZonedDateTime._(timezone, _native.firstDayOfMonth);

  /// The last day of this month.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2023, 4, 11).lastDayOfMonth; // '2023-04-30'
  /// ```
  @useResult LocalDateTime get lastDayOfMonth => LocalDateTime._(_native.lastDayOfMonth);


  /// The number of days in the given month.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2019, 2).daysInMonth; // 28
  /// ZonedDateTime('Asia/Singapore', 2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => _native.daysInMonth;

  /// Whether this year is a leap year.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2020).leapYear; // true
  /// ZonedDateTime('Asia/Singapore', 2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => _native.leapYear;


  /// The milliseconds since Unix epoch.
  EpochMilliseconds get epochMilliseconds => epochMicroseconds ~/ 1000;

}
