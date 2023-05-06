part of 'date.dart';

/// A local date as seen in a calendar such as `2023-4-11`.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// A [LocalDate] is immutable and should be treated as a value-type.
class LocalDate extends Date with Orderable<LocalDate> {

  String? _string;

  /// Creates a [LocalDate] with the given days since Unix epoch (January 1st 1970). Treats the [LocalDate] as being in
  /// UTC.
  ///
  /// ```dart
  /// LocalDate.fromEpochDays(10957); // '2000-01-01'
  /// ```
  LocalDate.fromEpochDays(super.days): super.fromEpochDays();

  /// Creates a [LocalDate] with the given milliseconds since Unix epoch (January 1st 1970), floored to the nearest day.
  /// Treats the [LocalDate] as being in UTC.
  ///
  /// ```dart
  /// LocalDate.fromEpochMilliseconds(946684800000); // '2000-01-01'
  /// ```
  LocalDate.fromEpochMilliseconds(super.milliseconds): super.fromEpochMilliseconds();

  /// Creates a [LocalDate] with the given microseconds since Unix epoch (January 1st 1970), floored to the nearest day.
  /// Treats the [LocalDate] as being in UTC.
  ///
  /// ```dart
  /// LocalDate.fromEpochMicroseconds(946684800000000); // '2000-01-01'
  /// ```
  LocalDate.fromEpochMicroseconds(super.microseconds): super.fromEpochMicroseconds();

  /// Creates a [LocalDate] that represents the current date.
  @NotTested(because: 'current time is non-deterministic which leads to flaky and unreliable tests')
  factory LocalDate.now() {
    final date = DateTime.now();
    return LocalDate(date.year, date.month, date.day);
  }

  /// Creates a [LocalDate].
  ///
  /// ```dart
  /// final time = LocalTime(2023, 4, 11) // '2023-04-11'
  ///
  /// final overflow = LocalTime(2023, 13, 2) // '2024-01-02'
  ///
  /// final underflow = LocalTime(2023, -1, 2) // '2022-12-02'
  /// ```
  LocalDate(super.year, [super.month = 1, super.day = 1]): super();

  LocalDate._(super.native): super._();


  /// Returns a copy of this [LocalDate] with the [duration] added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).add(Duration(days: 1)); // '2023-04-02'
  /// ```
  @useResult LocalDate add(Duration duration) => LocalDate._(_native.plus(days: duration.inDays));

  /// Returns a copy of this [LocalDate] with the [duration] subtracted.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).subtract(Duration(days: 1)); // '2023-03-31'
  /// ```
  @useResult LocalDate subtract(Duration duration) => LocalDate._(_native.minus(days: duration.inDays));

  /// Returns a copy of this [LocalDate] with the units of date added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).plus(months: -1, days: 1); // '2023-03-02'
  /// ```
  @useResult LocalDate plus({int years = 0, int months = 0, int days = 0}) => LocalDate._(_native.plus(
    years: years,
    months: months,
    days: days,
  ));

  /// Returns a copy of this [LocalDate] with the units of date subtracted.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).minus(months: -1, days: 1); // '2023-05-01'
  /// ```
  @useResult LocalDate minus({int years = 0, int months = 0, int days = 0}) => LocalDate._(_native.minus(
    years: years,
    months: months,
    days: days,
  ));

  /// Returns a copy of this [LocalDate] with the [Period] added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1) + Period(days: 1); // '2023-04-02'
  /// ```
  @useResult LocalDate operator + (Period period) => LocalDate._(_native.plus(
    years: period.years,
    months: period.months,
    days: period.days,
  ));

  /// Returns a copy of this [LocalDate] with the [Period] subtracted.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1) - Period(days: 1); // '2023-03-31'
  /// ```
  @useResult LocalDate operator - (Period period) => LocalDate._(_native.minus(
    years: period.years,
    months: period.months,
    days: period.days,
  ));


  /// Returns a copy of this [LocalDate] truncated to the given date unit.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 15).truncate(to: DateUnit.months); // '2023-04-01'
  /// ```
  @useResult LocalDate truncate({required DateUnit to}) => LocalDate._(_native.truncate(to: to));

  /// Returns a copy of this [LocalDate] with only the given date unit rounded to the nearest [value].
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. Throws a [RangeError] otherwise.
  ///
  /// ## Example:
  /// ```dart
  /// LocalDate(2023, 4, 15).round(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDate(2023, 8, 15)).round(6, DateUnit.months); // '2023-06-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDate round(DateUnit unit, int value) => LocalDate._(_native.round(unit, value));

  /// Returns a copy of this [LocalDate] with only the given date unit ceil to the nearest [value].
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. Throws a [RangeError] otherwise.
  ///
  /// ## Example:
  /// ```dart
  /// LocalDate(2023, 4, 15).ceil(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDate(2023, 8, 15)).ceil(6, DateUnit.months); // '2023-12-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDate ceil(DateUnit unit, int value) => LocalDate._(_native.ceil(unit, value));

  /// Returns a copy of this [LocalDate] with only the given date unit floored to the nearest [value].
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. Throws a [RangeError] otherwise.
  ///
  /// ## Example:
  /// ```dart
  /// LocalDate(2023, 4, 15).floor(6, DateUnit.months); // '2023-01-15'
  ///
  /// LocalDate(2023, 8, 15)).floor(6, DateUnit.months); // '2023-06-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDate floor(DateUnit unit, int value) => LocalDate._(_native.floor(unit, value));


  /// Returns a copy of this [LocalDate] with the given updated parts.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 15).copyWith(day: 20); // '2023-04-20'
  /// ```
  @useResult LocalDate copyWith({int? year, int? month, int? day}) => LocalDate(
    year ?? this.year,
    month ?? this.month,
    day ?? this.day,
  );


  /// Returns the difference between this [LocalDate] and other.
  ///
  /// ```dart
  /// final foo = LocalDate(2023, 4, 12);
  /// final bar = LocalDate(2023, 4, 1);
  ///
  /// foo.difference(bar); // 11 days
  ///
  /// foo.difference(LocalDate(2023, 4, 12)); // -11 days
  /// ```
  @useResult Duration difference(LocalDate other) => Duration(microseconds: epochMicroseconds - other.epochMicroseconds);


  /// Returns a [LocalDateTime] on this date at the given time.
  @useResult LocalDateTime at(LocalTime time) => LocalDateTime(year, month, day, time.hour, time.minute, time.second, time.millisecond, time.microsecond);

  /// Returns a native [DateTime] in UTC that represents this [LocalDate].
  @useResult DateTime toNative() => _native;


  @override
  @useResult int compareTo(LocalDate other) => epochMicroseconds.compareTo(other.epochMicroseconds);

  @override
  @useResult int get hashValue => runtimeType.hashCode ^ epochMicroseconds;

  @override
  @useResult String toString() => _string ??= _native.toDateString();


  /// The day of the week. Following ISO-8601, a week starts on Monday which has a value of `1` and ends on Sunday which
  /// has a value of `7`.
  ///
  /// ```dart
  /// LocalDate(1969, 7, 20).weekday; // Sunday, 7
  /// ```
  @useResult int get weekday => _native.weekday;


  /// The ordinal week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).weekOfYear; // 13
  /// ```
  @useResult int get weekOfYear => _native.weekOfYear;

  /// The ordinal day of the year.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).dayOfYear; // 91
  /// ```
  @useResult int get dayOfYear => _native.dayOfYear;


  /// The first day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDate(2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // '2023-04-10'
  /// ```
  @useResult LocalDate get firstDayOfWeek => LocalDate._(_native.firstDayOfWeek);

  /// The last day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDate(2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // '2023-04-16'
  /// ```
  @useResult LocalDate get lastDayOfWeek => LocalDate._(_native.lastDayOfWeek);


  /// The first day of this month.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).firstDayOfMonth; // '2023-04-01'
  /// ```
  @useResult LocalDate get firstDayOfMonth => LocalDate._(_native.firstDayOfMonth);

  /// The last day of this month.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).lastDayOfMonth; // '2023-04-30'
  /// ```
  @useResult LocalDate get lastDayOfMonth => LocalDate._(_native.lastDayOfMonth);


  /// The number of days in the given month.
  ///
  /// ```dart
  /// LocalDate(2019, 2).daysInMonth; // 28
  /// LocalDate(2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => _native.daysInMonth;

  /// Whether this year is a leap year.
  ///
  /// ```dart
  /// LocalDate(2020).leapYear; // true
  /// LocalDate(2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => _native.leapYear;


  ///The days since Unix epoch. Treats this date as being in UTC.
  @useResult int get epochDays => _native.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;

  ///The milliseconds since Unix epoch. Treats this date as being in UTC.
  @useResult int get epochMilliseconds => _native.millisecondsSinceEpoch;

  ///The microseconds since Unix epoch. Treats this date as being in UTC.
  @useResult int get epochMicroseconds => _native.microsecondsSinceEpoch;

}
