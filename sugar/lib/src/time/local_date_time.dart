part of 'date_time.dart';

/// A date-time without a timezone, i.e. `2023-04-10T09:30`.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// A [LocalDateTime] is immutable and should be treated as a value-type.
class LocalDateTime extends DateTimeBase with Orderable<LocalDateTime> {

  String? _string;

  /// Creates a [LocalDateTime] from the milliseconds since Unix epoch (January 1st 1970), treating [LocalDateTime]
  /// as being in UTC.
  ///
  /// ```dart
  /// LocalDateTime.fromEpochMilliseconds(946684800000); // '2000-01-01T00:00'
  /// ```
  LocalDateTime.fromEpochMilliseconds(super.milliseconds) : super.fromEpochMilliseconds();

  /// Creates a [LocalDateTime] from the milliseconds since Unix epoch (January 1st 1970), treating [LocalDateTime] as
  /// being in UTC.
  ///
  /// ```dart
  /// LocalDateTime.fromEpochMicroseconds(946684800000000); // '2000-01-01T00:00'
  /// ```
  LocalDateTime.fromEpochMicroseconds(super.microseconds) : super.fromEpochMicroseconds();

  /// Creates a [LocalDate] that represents the current date-time.
  LocalDateTime.now() : super.fromNative(DateTime.now());

  /// Creates a [LocalDateTime].
  LocalDateTime(super.year, [
    super.month = 1,
    super.day = 1,
    super.hour = 0,
    super.minute = 0,
    super.second = 0,
    super.millisecond = 0,
    super.microsecond = 0,
  ]);

  LocalDateTime._(super._native) : super._();


  /// Returns a copy of this [LocalDateTime] with the [duration] added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 1);
  /// date.add(Duration(days: 1, hours: 1)); // '2023-04-02T01:00'
  /// ```
  @useResult LocalDateTime add(Duration duration) => LocalDateTime._(_native.add(duration));

  /// Returns a copy of this [LocalDateTime] with the [duration] subtracted.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 1);
  /// date.minus(Duration(days: 1, hours: 1)); // '2023-03-31T23:00'
  /// ```
  @useResult LocalDateTime subtract(Duration duration) => LocalDateTime._(_native.subtract(duration));

  /// Returns a copy of this [LocalDateTime] with the given time added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date.plus(months: -1, hours: 1); // '2023-04-10T09:00'
  /// ```
  @useResult LocalDateTime plus({int years = 0, int months = 0, int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalDateTime._(_native.plus(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this [LocalDateTime] with the given time added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date.minus(months: -1, hours: 1); // '2023-05-10T07:00'
  /// ```
  @useResult LocalDateTime minus({int years = 0, int months = 0, int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalDateTime._(_native.minus(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this [LocalDate] with the [Period] added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date + Period(days: 1); // '2023-04-02T08:00'
  /// ```
  @useResult LocalDateTime operator + (Period period) => LocalDateTime._(_native + period);

  /// Returns a copy of this [LocalDate] with the [Period] subtracted.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date - Period(days: 1); // '2023-03-31T08:00'
  /// ```
  @useResult LocalDateTime operator - (Period period) => LocalDateTime._(_native - period);


  /// Returns a copy of this [LocalDateTime] truncated to the given temporal unit.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 15);
  /// date.truncate(to: DateUnit.months); // '2023-04-01'
  /// ```
  @useResult LocalDateTime truncate({required TemporalUnit to}) => LocalDateTime._(_native.truncate(to: to));

  /// Returns a copy of this [LocalDateTime] with only the given temporal unit rounded to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15).round(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDateTime(2023, 8, 15).round(6, DateUnit.months); // '2023-06-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime round(TemporalUnit unit, int value) => LocalDateTime._(_native.round(unit, value));

  /// Returns a copy of this [LocalDateTime] with only the given temporal unit ceil to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15).ceil(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDateTime(2023, 8, 15).ceil(6, DateUnit.months); // '2023-12-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime ceil(TemporalUnit unit, int value) => LocalDateTime._(_native.ceil(unit, value));

  /// Returns a copy of this [LocalDateTime] with only the given temporal unit floored to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15).floor(6, DateUnit.months); // '2023-01-15'
  ///
  /// LocalDateTime(2023, 8, 15).floor(6, DateUnit.months); // '2023-06-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime floor(TemporalUnit unit, int value) => LocalDateTime._(_native.floor(unit, value));


  /// Returns a copy of this [LocalDateTime] with the given updated parts.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 15).copyWith(day: 20); // '2023-04-20'
  /// ```
  @useResult LocalDateTime copyWith({int? year, int? month, int? day, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) =>
    LocalDateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );


  /// Returns the difference between this [LocalDateTime] and other.
  ///
  /// ```dart
  /// LocalDateTime(22).difference(LocalDateTime(12)); // 10 hours
  ///
  /// LocalDateTime(13).difference(LocalDateTime(23)); // -10 hours
  /// ```
  @useResult Duration difference(LocalDateTime other) => Duration(microseconds: epochMicroseconds - other.epochMicroseconds);


  //// Converts this [LocalDateTime] to a [ZonedDateTime].
  @useResult ZonedDateTime at(Timezone timezone) => ZonedDateTime._convert(timezone, _native);

  /// Returns a native [DateTime] in UTC that represents this [LocalDateTime].
  @useResult DateTime toNative() => _native;

  /// The date.
  @useResult LocalDate get date => LocalDate(year, month, day);

  /// The time.
  @useResult LocalTime get time => LocalTime(hour, minute, second, millisecond, microsecond);


  @override
  @useResult int compareTo(LocalDateTime other) => epochMicroseconds.compareTo(other.epochMicroseconds);

  @override
  @useResult int get hashValue => runtimeType.hashCode ^ epochMicroseconds;

  @override
  @useResult String toString() => _string ??= '${_native.toDateString()}T${_native.toTimeString()}';


  /// The day of the week. Following ISO-8601, a week starts on Monday which has a value of `1` and ends on Sunday which
  /// has a value of `7`.
  ///
  /// ```dart
  /// LocalDateTime(1969, 7, 20).weekday; // Sunday, 7
  /// ```
  @useResult int get weekday => _native.weekday;


  /// The ordinal week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 1).weekOfYear; // 13
  /// ```
  @useResult int get weekOfYear => _native.weekOfYear;

  /// The ordinal day of the year.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 1).dayOfYear; // 91
  /// ```
  @useResult int get dayOfYear => _native.dayOfYear;


  /// The first day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDateTime(2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // '2023-04-10'
  /// ```
  @useResult LocalDateTime get firstDayOfWeek => LocalDateTime._(_native.firstDayOfWeek);

  /// The last day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDateTime(2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // '2023-04-16'
  /// ```
  @useResult LocalDateTime get lastDayOfWeek => LocalDateTime._(_native.lastDayOfWeek);


  /// The first day of this month.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11).firstDayOfMonth; // '2023-04-01'
  /// ```
  @useResult LocalDateTime get firstDayOfMonth => LocalDateTime._(_native.firstDayOfMonth);

  /// The last day of this month.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11).lastDayOfMonth; // '2023-04-30'
  /// ```
  @useResult LocalDateTime get lastDayOfMonth => LocalDateTime._(_native.lastDayOfMonth);


  /// The number of days in the given month.
  ///
  /// ```dart
  /// LocalDateTime(2019, 2).daysInMonth; // 28
  /// LocalDateTime(2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => _native.daysInMonth;

  /// Whether this year is a leap year.
  ///
  /// ```dart
  /// LocalDateTime(2020).leapYear; // true
  /// LocalDateTime(2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => _native.leapYear;


  /// The milliseconds since Unix epoch (January 1st 1970), treating this date as being in UTC.
  @useResult EpochMilliseconds get epochMilliseconds => _native.millisecondsSinceEpoch;

  /// The microseconds since Unix epoch (January 1st 1970), treating this date as being in UTC.
  @useResult EpochMicroseconds get epochMicroseconds => _native.microsecondsSinceEpoch;

}
