import 'package:meta/meta.dart';
import 'package:sugar/time.dart';

/// Provides functions for working with Dart's [DateTime]s.
extension DateTimes on DateTime {

  /// Returns the day of the week. Following ISO-8601, a week starts on Monday which has a value of `1` and ends on Sunday which
  /// has a value of `7`.
  ///
  /// ```dart
  /// DateTime(1969, 7, 20).toWeekday(); // Sunday, 7
  /// ```
  @useResult int toWeekday() => Dates.weekday(year, month, day);

  /// Returns the ordinal week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// ```dart
  /// DateTime(2023, 4, 1).toWeekOfYear(); // 13
  /// ```
  @useResult int toWeekOfYear() => Dates.weekOfYear(year, month, day);

  /// Returns the ordinal day of the year.
  ///
  /// ```dart
  /// DateTime(2023, 4, 1).toDayOfYear(); // 91
  /// ```
  @useResult int toDayOfYear() => Dates.dayOfYear(year, month, day);


  /// The first day of this week.
  ///
  /// ```dart
  /// final tuesday = DateTime(2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // '2023-04-10'
  /// ```
  @useResult DateTime get firstDayOfWeek => copyWith(day: day - weekday - 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  /// The last day of this week.
  ///
  /// ```dart
  /// final tuesday = DateTime(2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // '2023-04-16'
  /// ```
  @useResult DateTime get lastDayOfWeek => copyWith(day: day + 8 - weekday, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);


  /// The first day of this month.
  ///
  /// ```dart
  /// DateTime(2023, 4, 11).firstDayOfMonth; // '2023-04-01'
  /// ```
  @useResult DateTime get firstDayOfMonth => copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

  /// The last day of this month.
  ///
  /// ```dart
  /// DateTime(2023, 4, 11).lastDayOfMonth; // '2023-04-30'
  /// ```
  @useResult DateTime get lastDayOfMonth => copyWith(day: daysInMonth, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);


  /// Returns the number of days in the given month.
  ///
  /// ```dart
  /// DateTime(2019, 2).daysInMonth; // 28
  /// DateTime(2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => Dates.daysInMonth(year, month);


  /// Whether this [DateTime]'s year is a leap year.
  ///
  /// ```dart
  /// DateTime(2020).leapYear; // true
  /// DateTime(2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => Dates.leapYear(year);

}
