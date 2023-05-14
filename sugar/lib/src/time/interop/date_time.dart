import 'package:meta/meta.dart';

import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/sugar.dart';

/// Provides functions for working with in-built [DateTime]s.
///
/// These functions should only be used when it is not feasible to use `sugar.time`.
extension DateTimes on DateTime {

  /// Returns a copy of this with the units of time added.
  ///
  /// This function adds the conceptual units of time like [+].
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// // Assume the current timezone is `America/Detroit`.
  /// final datetime = DateTime(2023, 3, 12);
  ///
  /// datetime.plus(days: 1);          // 2023-03-13 00:00
  /// datetime.add(Duration(days: 1)); // 2023-03-13 01:00
  /// ```
  @useResult DateTime plus({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) => copyWith(
    year: year + years,
    month: month + months,
    day: day + days,
    hour: hour + hours,
    minute: minute + minutes,
    second: second + seconds,
    millisecond: millisecond + milliseconds,
    microsecond: microsecond + microseconds,
  );

  /// Returns a copy of this with the units of time subtracted.
  ///
  /// This function subtracts the conceptual units of time like [-].
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// // Assume the current timezone is `America/Detroit`.
  /// final datetime = DateTime(2023, 3, 13);
  ///
  /// datetime.minus(days: 1);              // 2023-03-12 00:00
  /// datetime.subtract(Duration(days: 1)); // 2023-03-11 23:00
  /// ```
  @useResult DateTime minus({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) => copyWith(
    year: year - years,
    month: month - months,
    day: day - days,
    hour: hour - hours,
    minute: minute - minutes,
    second: second - seconds,
    millisecond: millisecond - milliseconds,
    microsecond: microsecond - microseconds,
  );

  /// Returns a copy of this with the [period] added.
  ///
  /// This function adds the conceptual units of time unlike [add].
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// // Assume the current timezone is `America/Detroit`.
  /// final foo = DateTime(2023, 3, 12);
  ///
  /// foo + Period(days: 1);      // 2023-03-13 00:00
  /// foo.add(Duration(days: 1)); // 2023-03-13 01:00
  /// ```
  @useResult DateTime operator + (Period period) => copyWith(
    year: year + period.years,
    month: month + period.months,
    day: day + period.days,
    hour: hour + period.hours,
    minute: minute + period.minutes,
    second: second + period.seconds,
    millisecond: millisecond + period.milliseconds,
    microsecond: microsecond + period.microseconds,
  );

  /// Returns a copy of this with the [period] subtracted.
  ///
  /// This function adds the conceptual units of time unlike [subtract].
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// // Assume the current timezone is `America/Detroit`.
  /// final foo = DateTime(2023, 3, 12);
  ///
  /// foo - Period(days: 1);           // 2023-03-12 00:00-04:00
  /// foo.subtract(Duration(days: 1)); // 2023-03-11 23:00-04:00
  /// ```
  @useResult DateTime operator - (Period period) => copyWith(
    year: year - period.years,
    month: month - period.months,
    day: day - period.days,
    hour: hour - period.hours,
    minute: minute - period.minutes,
    second: second - period.seconds,
    millisecond: millisecond - period.milliseconds,
    microsecond: microsecond - period.microseconds,
  );


  /// Returns a copy of this truncated to the [TemporalUnit].
  ///
  /// ```dart
  /// DateTime(2023, 4, 15).truncate(to: DateUnit.months); // 2023-04-01 00:00
  /// ```
  @useResult DateTime truncate({required TemporalUnit to}) => _adjust(to, (time) => time);

  /// Returns a copy of this rounded to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// DateTime(2023, 4, 15).round(DateUnit.months, 6); // 2023-06-01 00:00
  /// DateTime(2023, 8, 15).round(DateUnit.months, 6); // 2023-06-01 00:00
  /// ```
  @Possible({RangeError})
  @useResult DateTime round(TemporalUnit unit, int value) => _adjust(unit, (date) => date.roundTo(value));

  /// Returns a copy of this ceiled to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// DateTime(2023, 4, 15).ceil(DateUnit.months, 6); // 2023-06-01 00:00
  /// DateTime(2023, 8, 15).ceil(DateUnit.months, 6); // 2023-12-01 00:00
  /// ```
  @Possible({RangeError})
  @useResult DateTime ceil(TemporalUnit unit, int value) => _adjust(unit, (date) => date.ceilTo(value));

  /// Returns a copy of this floored to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  ///
  /// ## Example
  /// ```dart
  /// DateTime(2023, 4, 15).floor(DateUnit.months, 6); // 2023-01-01 00:00
  /// DateTime(2023, 8, 15).floor(DateUnit.months, 6); // 2023-06-01 00:00
  /// ```
  @Possible({RangeError})
  @useResult DateTime floor(TemporalUnit unit, int value) => _adjust(unit, (date) => date.floorTo(value));

  DateTime _adjust(TemporalUnit unit, int Function(int time) apply) => switch (unit) {
    DateUnit.years => copyWith(year: apply(year), month: 1, day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
    DateUnit.months => copyWith(month: apply(month), day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
    DateUnit.days => copyWith(day: apply(day), hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0),
    TimeUnit.hours => copyWith(hour: apply(hour), minute: 0, second: 0, millisecond: 0, microsecond: 0),
    TimeUnit.minutes => copyWith(minute: apply(minute), second: 0, millisecond: 0, microsecond: 0),
    TimeUnit.seconds => copyWith(second: apply(second), millisecond: 0, microsecond: 0),
    TimeUnit.milliseconds => copyWith(millisecond: apply(millisecond), microsecond: 0),
    TimeUnit.microseconds => copyWith(microsecond: apply(microsecond)),
  };


  /// Formats this [DateTime]'s date as a ISO-8601 date, ignoring the time.
  ///
  /// ```dart
  /// DateTime(2023, 4, 1, 10, 30).toDateString(); // 2023-04-01
  /// ```
  String toDateString() => Dates.format(year, month, day);

  /// Formats this [DateTime]'s time as a ISO-8601 time, ignoring the date.
  ///
  /// ```dart
  /// DateTime(1, 1, 1, 20, 30, 40, 5, 6).toTimeString(); // 20:30:40.005006
  /// ```
  String toTimeString() => Times.format(hour, minute, second, millisecond, microsecond);


  /// The offset.
  @useResult Offset get offset => Offset.fromMicroseconds(timeZoneOffset.inMicroseconds);


  /// The ordinal week of the year.
  ///
  /// A week is between `1` and `53`, inclusive.
  ///
  /// See [weeks per year](https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year).
  ///
  /// ```dart
  /// DateTime(2023, 4, 1).weekOfYear; // 13
  /// ```
  @useResult int get weekOfYear => Dates.weekOfYear(year, month, day);

  /// The ordinal day of the year.
  ///
  /// ```dart
  /// DateTime(2023, 4, 1).toDayOfYear(); // 91
  /// ```
  @useResult int get dayOfYear => Dates.dayOfYear(year, month, day);


  /// The first day of the week.
  ///
  /// ```dart
  /// final tuesday = DateTime(2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // 2023-04-10
  /// ```
  @useResult DateTime get firstDayOfWeek => copyWith(day: day - weekday + 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  /// The last day of the week.
  ///
  /// ```dart
  /// final tuesday = DateTime(2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // 2023-04-16
  /// ```
  @useResult DateTime get lastDayOfWeek => copyWith(day: day + 7 - weekday, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);


  /// The first day of the month.
  ///
  /// ```dart
  /// DateTime(2023, 4, 11).firstDayOfMonth; // 2023-04-01
  /// ```
  @useResult DateTime get firstDayOfMonth => copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  /// The last day of the month.
  ///
  /// ```dart
  /// DateTime(2023, 4, 11).lastDayOfMonth; // 2023-04-30
  /// ```
  @useResult DateTime get lastDayOfMonth => copyWith(day: daysInMonth, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);


  /// The number of days in the month, taking leap years into account.
  ///
  /// ```dart
  /// DateTime(2019, 2).daysInMonth; // 28
  /// DateTime(2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => Dates.daysInMonth(year, month);

  /// Whether the is year is a leap year.
  ///
  /// ```dart
  /// DateTime(2020).leapYear; // true
  /// DateTime(2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => Dates.leapYear(year);


  /// The days since Unix epoch.
  int get daysSinceEpoch => millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;


  /// The time as milliseconds since midnight.
  ///
  /// ```dart
  /// DateTime(2023, 4, 1, 12).millisecondsSinceMidnight; // 43200000 ('12:00')
  /// ```
  int get millisecondsSinceMidnight =>
    hour * Duration.millisecondsPerHour +
    minute * Duration.millisecondsPerMinute +
    second * Duration.millisecondsPerSecond +
    millisecond;

  /// The time as microseconds since midnight.
  ///
  /// ```dart
  /// DateTime(2023, 4, 1, 12).microsecondsSinceMidnight; // 43200000000 ('12:00')
  /// ```
  int get microsecondsSinceMidnight => sumMicroseconds(hour, minute, second, millisecond, microsecond);

}
