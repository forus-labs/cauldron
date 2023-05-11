import 'package:meta/meta.dart';

/// Provides low-level functions for working with dates.
///
/// These functions should only be used when it is not feasible to use `sugar.time`, such as when working with 3rd-party
/// date-time types.
extension Dates on Never {

  static const _cumulative = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
  static const _months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  /// Formats the date as a ISO-8601 date.
  ///
  /// ```dart
  /// print(Dates.format(2023, 4, 1)); // '2023-04-01'
  /// ```
  @useResult static String format(int year, [int month = 1, int day = 1]) {
    final sign = year < 0 ? '-' : '';
    final yyyy = year.abs().toString().padLeft(4, '0');
    final mm = month.toString().padLeft(2, '0');
    final dd = day.toString().padLeft(2, '0');

    return '$sign$yyyy-$mm-$dd';
  }


  /// Computes the ordinal day of the week.
  ///
  /// A week starts on Monday (1) and ends Sunday (7).
  ///
  /// ## Example
  /// ```dart
  /// Dates.weekday(1969, 7, 20); // 7 (Sunday)
  /// ```
  ///
  /// ## Implementation details
  /// This function uses a modified version of of Tomohiko Sakamoto's algorithm where Monday = 1 and Sunday = 7.
  ///
  /// See [Sakamoto's methods](https://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week#Sakamoto's_methods).
  @useResult static int weekday(int year, int month, int day) {
    const table = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4];
    final adjustedYear = month < 3 ? year - 1 : year;
    final weekday = (adjustedYear + adjustedYear ~/4 - adjustedYear ~/100 + adjustedYear ~/400 + table[month - 1] + day) % 7;
    return weekday == 0 ? 7 : weekday;
  }

  /// Computes the ordinal week of the year.
  ///
  /// A week is between `1` and `53`, inclusive.
  ///
  /// See [weeks per year]( https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year).
  ///
  /// ```dart
  /// Dates.weekOfYear(2023, 4, 1); // 13
  /// ```
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

  /// Computes the ordinal day of the year.
  ///
  /// ```dart
  /// Dates.dayOfYear(2023, 4, 1); // 91
  /// ```
  @useResult static int dayOfYear(int year, int month, int day) => _cumulative[month - 1] + day + (leapYear(year) && month > 2 ? 1 : 0);


  /// Computes the number of days in the given month taking leap years into account.
  ///
  /// ```dart
  /// Dates.daysInMonth(2019, 2); // 28
  /// Dates.daysInMonth(2020, 2); // 29
  /// ```
  @useResult static int daysInMonth(int year, int month) => month == 2 ? (leapYear(year) ? 29 : 28) : _months[month - 1];

  /// Returns true if the [year] is a leap year.
  ///
  /// ```dart
  /// Dates.leapYear(2020); // true
  /// Dates.leapYear(2022); // false
  /// ```
  @useResult static bool leapYear(int year) => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

}
