import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/math.dart';
import 'package:sugar/time.dart';

part 'local_date.dart';

/// Provides low-level functions for working with dates.
///
/// These functions should only be used when working with 3rd party date types or low-level code. Users should otherwise
/// prefer [DateTimes] or other similar classes.
extension Dates on DateTime {

  static const _cumulative = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  static const _months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  /// Returns the ordinal day of the week. Following ISO-8601, a week starts on Monday which has a value of `1` and ends on Sunday
  /// which has a value of `7`.
  ///
  /// ```dart
  /// Dates.weekday(1969, 7, 20); // Sunday, 7
  /// ```
  ///
  /// ## Implementation details:
  /// This function uses a modified version of Tomohiko Sakamoto's algorithm where Monday = 1 and Sunday = 7.
  /// See https://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week#Sakamoto's_methods
  @useResult static int weekday(int year, int month, int day) {
    const table = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4];
    final adjustedYear = month < 3 ? year - 1 : year;
    final weekday = (adjustedYear + adjustedYear ~/4 - adjustedYear ~/100 + adjustedYear ~/400 + table[month - 1] + day) % 7;
    return weekday == 0 ? 7 : weekday;
  }

  /// Returns the ordinal week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// ```dart
  /// Dates.weekOfYear(2023, 4, 1); // 13
  /// ```
  ///
  /// See https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  ///
  /// ## Implementation details:
  /// This function uses the algorithm from https://en.wikipedia.org/wiki/ISO_week_date#Calculating_the_week_number_from_an_ordinal_date.
  @useResult static int weekOfYear(int year, int month, int day) {
    final ordinal = (dayOfYear(year, month, day) - weekday(year, month, day) + 10) ~/ 7;
    if (ordinal == 0) {
      return weekOfYear(year - 1, 12, 28);
    }

    if (ordinal == 53 && weekday(year, 1, 1) != 4 && weekday(year, 12, 31) != 4) {
      return 1;
    }

    return ordinal;
  }

  /// Returns the given date's ordinal day of the year.
  ///
  /// ```dart
  /// Dates.dayOfYear(2023, 4, 1); // 91
  /// ```
  @useResult static int dayOfYear(int year, int month, int day) => _cumulative[month - 1] + day + (leapYear(year) && month > 2 ? 1 : 0);

  /// Returns the number of days in the given month.
  ///
  /// ```dart
  /// Dates.daysInMonth(2019, 2); // 28
  /// Dates.daysInMonth(2020, 2); // 29
  /// ```
  @useResult static int daysInMonth(int year, int month) => month == 2 ? (leapYear(year) ? 29 : 28) : _months[month - 1];

  /// Returns whether given [year] is a leap year.
  ///
  /// ```dart
  /// Dates.leapYear(2020); // true
  /// Dates.leapYear(2022); // false
  /// ```
  @useResult static bool leapYear(int year) => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

}

/// Represents a temporal that contains units of date.
@internal abstract class Date {

  /// Returns a [DateTime] with the given time added.
  static DateTime plus(DateTime date, int years, int months, int days) => date.copyWith(
    year: date.year + years,
    month: date.month + months,
    day: date.day + days,
  );

  /// Returns a [DateTime] with the given time subtracted. The calculation wraps around midnight.
  static DateTime minus(DateTime date, int years, int months, int days) => date.copyWith(
    year: date.year - years,
    month: date.month - months,
    day: date.day - days,
  );


  /// Returns a [DateTime] truncated to the given date unit. The time fields are not modified.
  static DateTime truncate(DateTime date, DateUnit to) {
    switch (to) {
      case DateUnit.years:
        return date.copyWith(month: 1, day: 1);
      case DateUnit.months:
        return date.copyWith(day: 1);
      case DateUnit.days:
        return date;
    }
  }

  /// Returns a [DateTime] with the given date unit rounded to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime round(DateTime date, int to, DateUnit unit) => _adjust(date, to, unit, (date, to) => date.roundTo(to));

  /// Returns a [DateTime] with the given date unit ceiled to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime ceil(DateTime date, int to, DateUnit unit) => _adjust(date, to, unit, (date, to) => date.ceilTo(to));

  /// Returns a [DateTime] with the given date unit floored to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime floor(DateTime date, int to, DateUnit unit) => _adjust(date, to, unit, (date, to) => date.floorTo(to));

  static DateTime _adjust(DateTime time, int to, DateUnit unit, int Function(int time, int to) apply) {
    switch (unit) {
      case DateUnit.years:
        return time.copyWith(year: apply(time.year, to));
      case DateUnit.months:
        return time.copyWith(month: apply(time.month, to));
      case DateUnit.days:
        return time.copyWith(day: apply(time.day, to));
    }
  }


  final DateTime _native;

  /// Creates a [Date] from the given days since Unix epoch.
  Date.fromEpochDays(EpochDays days): _native = DateTime.fromMillisecondsSinceEpoch(days * Duration.millisecondsPerDay, isUtc: true);

  /// Creates a [Date] from the given seconds since Unix epoch, floored to the nearest day.
  Date.fromEpochSeconds(EpochSeconds seconds): _native = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

  /// Creates a [Date] from the given milliseconds since Unix epoch, floored to the nearest day.
  Date.fromEpochMilliseconds(EpochMilliseconds milliseconds): _native = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [Date] from the native [DateTime].
  Date.fromNativeDateTime(DateTime date): _native = DateTime.utc(date.year, date.month, date.day);

  /// Creates a [Date].
  Date(int year, [int month = 1, int day = 1]): _native = DateTime.utc(year, month, day);

  Date._copy(this._native);

  /// The year.
  int get year => _native.year;
  /// The month.
  int get month => _native.month;
  /// The day.
  int get day => _native.day;

}
