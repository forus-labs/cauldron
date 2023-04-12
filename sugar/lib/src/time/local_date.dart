part of 'date.dart';

/// Represents a local date as seen in a calendar, i.e. `2023-04-11`.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// A [LocalDate] is immutable and should be treated as a value-type.
class LocalDate extends Date with Orderable<LocalDate> {

  int? _milliseconds;
  String? _string;

  /// Creates a [LocalDate] with the given days since Unix epoch (January 1st 1970).
  ///
  /// ```dart
  /// LocalDate.fromEpochDays(10957); // '2000-01-01'
  /// ```
  LocalDate.fromEpochDays(super.days): super.fromEpochDays();

  /// Creates a [LocalDate] with the given seconds since Unix epoch (January 1st 1970), floored to the nearest day.
  ///
  /// ```dart
  /// LocalDate.fromEpochSeconds(946684800); // '2000-01-01'
  /// ```
  LocalDate.fromEpochSeconds(super.seconds): super.fromEpochSeconds();

  /// Creates a [LocalDate] with the given milliseconds since Unix epoch (January 1st 1970), floored to the nearest day.
  ///
  /// ```dart
  /// LocalDate.fromEpochMilliseconds(946684800000); // '2000-01-01'
  /// ```
  LocalDate.fromEpochMilliseconds(super.milliseconds): super.fromEpochMilliseconds();

  /// Creates a [LocalDate] that represents the current date.
  ///
  /// ```dart
  /// // Assuming that it's '2023-04-11'
  ///
  /// final now = LocalTime.now(); // '2023-04-11'
  /// ```
  LocalDate.now(): super.fromNativeDateTime(DateTime.now());

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

  LocalDate._copy(super.native): super._copy();


  /// Returns a copy of this [LocalDate] with the given time added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).plus(months: -1, days: 1); // '2023-03-02'
  /// ```
  ///
  /// See [add].
  @useResult LocalDate plus({int years = 0, int months = 0, int days = 0}) => LocalDate._copy(Date.plus(_native, years, months, days));

  /// Returns a copy of this [LocalDate] with the given time added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).subtract(months: -1, days: 1); // '2023-05-01'
  /// ```
  ///
  /// See [subtract].
  @useResult LocalDate minus({int years = 0, int months = 0, int days = 0}) => LocalDate._copy(Date.minus(_native, years, months, days));


  /// Returns a copy of this [LocalDate] with the given [duration] added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).add(Duration(days: 1)); // '2023-04-02'
  /// ```
  ///
  /// See [plus].
  @useResult LocalDate add(Duration duration) => LocalDate._copy(_native.add(duration));

  /// Returns a copy of this [LocalTime] with the given [duration] subtracted.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).subtract(Duration(days: 1)); // '2023-03-31'
  /// ```
  ///
  /// See [minus].
  @useResult LocalDate subtract(Duration duration) => LocalDate._copy(_native.subtract(duration));


  /// Returns a copy of this [LocalDate] truncated to the given time unit.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 15).truncate(to: DateUnit.months); // '2023-04-01'
  /// ```
  @useResult LocalDate truncate({required DateUnit to}) => LocalDate._copy(Date.truncate(_native, to));

  /// Returns a copy of this [LocalDate] with only the given date unit rounded to the nearest [value].
  ///
  /// ```dart
  /// LocalDate(2023, 4, 15).round(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDate(2023, 8, 15)).round(6, DateUnit.months); // '2023-06-15'
  /// ```
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult LocalDate round(int value, DateUnit unit) => LocalDate._copy(Date.round(_native, value, unit));

  /// Returns a copy of this [LocalDate] with only the given date unit ceil to the nearest [value].
  ///
  /// ```dart
  /// LocalDate(2023, 4, 15).ceil(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDate(2023, 8, 15)).ceil(6, DateUnit.months); // '2023-12-15'
  /// ```
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult LocalDate ceil(int value, DateUnit unit) => LocalDate._copy(Date.ceil(_native, value, unit));

  /// Returns a copy of this [LocalTime] with only the given time unit floored to the nearest [value].
  ///
  /// ```dart
  /// LocalDate(2023, 4, 15).floor(6, DateUnit.months); // '2023-01-15'
  ///
  /// LocalDate(2023, 8, 15)).floor(6, DateUnit.months); // '2023-06-15'
  /// ```
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult LocalDate floor(int value, DateUnit unit) => LocalDate._copy(Date.floor(_native, value, unit));


  /// Returns a copy of this [LocalTime] with the given updated parts.
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
  /// LocalDate(2023, 4, 12).difference(LocalDate(2023, 4, 1)); // 11 days
  ///
  /// LocalDate(2023, 4, 1).difference(LocalDate(2023, 4, 12)); // -11 days
  /// ```
  @useResult Duration difference(LocalDate other) => Duration(milliseconds: toEpochMilliseconds() - other.toEpochMilliseconds());


  /// Returns the day of the week. Following ISO-8601, a week starts on Monday which has a value of `1` and ends on Sunday which
  /// has a value of `7`.
  ///
  /// ```dart
  /// LocalDate(1969, 7, 20).toWeekday(); // Sunday, 7
  /// ```
  @useResult int toWeekday() => _native.toWeekday();

  /// Returns the ordinal week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).toWeekOfYear(); // 13
  /// ```
  @useResult int toWeekOfYear() => _native.toWeekOfYear();

  /// Returns the ordinal day of the year.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).toDayOfYear(); // 91
  /// ```
  @useResult int toDayOfYear() => _native.toDayOfYear();

  /// Returns this [LocalDate] as days since Unix epoch (January 1st 1970).
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).toEpochDays(); // 19458
  /// ```
  @useResult EpochDays toEpochDays() => toEpochMilliseconds() ~/ Duration.millisecondsPerDay;

  /// Returns this [LocalDate] as seconds since Unix epoch (January 1st 1970).
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).toEpochSeconds(); // 1681171200
  /// ```
  @useResult EpochSeconds toEpochSeconds() => toEpochMilliseconds() ~/ 1000;

  /// Returns this [LocalDate] as milliseconds since Unix epoch (January 1st 1970).
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).toEpochMilliseconds(); // 1681171200000
  /// ```
  @useResult EpochMilliseconds toEpochMilliseconds() => _milliseconds ??= _native.millisecondsSinceEpoch.floorTo(Duration.millisecondsPerDay);


  /// The first day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDate(2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // '2023-04-10'
  /// ```
  @useResult LocalDate get firstDayOfWeek => LocalDate._copy(_native.firstDayOfWeek);

  /// The last day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDate(2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // '2023-04-16'
  /// ```
  @useResult LocalDate get lastDayOfWeek => LocalDate._copy(_native.lastDayOfWeek);


  /// The first day of this month.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).firstDayOfMonth; // '2023-04-01'
  /// ```
  @useResult LocalDate get firstDayOfMonth => LocalDate._copy(_native.firstDayOfMonth);

  /// The last day of this month.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).lastDayOfMonth; // '2023-04-30'
  /// ```
  @useResult LocalDate get lastDayOfMonth => LocalDate._copy(_native.lastDayOfMonth);


  /// Returns the number of days in the given month.
  ///
  /// ```dart
  /// LocalDate(2019, 2).daysInMonth; // 28
  /// LocalDate(2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => _native.daysInMonth;


  /// Whether this [DateTime]'s year is a leap year.
  ///
  /// ```dart
  /// LocalDate(2020).leapYear; // true
  /// LocalDate(2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => _native.leapYear;


  @override
  @useResult int compareTo(LocalDate other) => toEpochMilliseconds().compareTo(other.toEpochMilliseconds());

  @override
  @useResult int get hashValue => runtimeType.hashCode ^ toEpochMilliseconds();

  @override
  @useResult String toString() => _string ??= Date.format(_native);

}
