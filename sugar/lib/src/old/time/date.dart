import 'package:meta/meta.dart';

/// A function that creates a [T] using the given arguments.
@internal typedef CreateDate<T extends Date> = T Function(int year, int month, int day);

/// Provides primitive functions for working with dates.
extension Dates on Never {

  static const _days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  static const _cumulative = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];

  /// Returns the number of days in the given month.
  ///
  /// For example, if the given date is February 2020 (a leap year). `29` will be returned.
  static int daysInMonth(int year, int month) => month == 2 ? (leapYear(year) ? 29 : 28) : _days[month - 1];

  /// Returns the day of the week. Following ISO-8601, a week starts on monday which has a value of `1`.
  ///
  /// For example, if the given date is July 20th 1969, the returned weekday is 7, which is a Sunday.
  static int weekday(int year, int month, int day) {
    // Modified Tomohiko Sakamoto's algorithm where Monday = 1 and Sunday = 7.
    // See https://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week#Sakamoto's_methods
    const table = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4];
    final adjustedYear = month < 3 ? year - 1 : year;
    final weekday = (adjustedYear + adjustedYear ~/4 - adjustedYear ~/100 + adjustedYear ~/400 + table[month-1] + day) % 7;
    return weekday == 0 ? 7 : weekday;
  }

  /// Returns the week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// For example, if the given date is April 1st 2023, the returned week will be `13`.
  ///
  /// See https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int weekOfYear(int year, int month, int day) {
    // Calculates the week number from an ordinal date.
    // See https://en.wikipedia.org/wiki/ISO_week_date#Calculating_the_week_number_from_an_ordinal_date
    final ordinal = (dayOfYear(year, month, day) - weekday(year, month, day) + 10) ~/ 7;
    if (ordinal == 0) {
      return weekOfYear(year - 1, 12, 28);
    }

    if (ordinal == 53 && weekday(year, 1, 1) != 4 && weekday(year, 12, 31) != 4) {
      return 1;
    }

    return ordinal;
  }

  /// Returns the day of the year. For example, if the given date is April 1st 2023, the returned day is `91`.
  static int dayOfYear(int year, int month, int day) => _cumulative[month - 1] + day + (leapYear(year) && month > 2 ? 1 : 0);

  /// Returns `true` if the given [year] is a leap year.
  static bool leapYear(int year) => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

}

/// Represents a temporal that contains units of date.
@internal mixin Date {

  static T startOfMonth<T extends Date>(T date, CreateDate<T> create) => create(date.year, date.month, 1);

  static T endOfMonth<T extends Date>(T date, CreateDate<T> create) => create(date.year, date.month, date.daysInMonth);

  // static T startOfWeek<T extends Date>(T date, CreateDate<T> create) => create(date.)

  /// The year.
  int get year;
  /// The month.
  int get month;
  /// The day.
  int get day;

  /// The number of days in this month.
  ///
  /// For example, if the this date is February 3rd 2020 (a leap year). the [daysInMonth] will be `29`.
  int get daysInMonth => Dates.daysInMonth(year, month);

  /// The day of the week. Following ISO-8601, a week starts on monday which has a value of `1`.
  ///
  /// For example, if this date is July 20th 1969, the [weekday] will be 7, which is a Sunday.
  int get weekday => Dates.weekday(year, month, day);

  /// The week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// For example, if this date is April 1st 2023, the [weekOfYear] will be `13`.
  ///
  /// See https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  int get weekOfYear => Dates.weekOfYear(year, month, day);

  /// The day of the year.
  ///
  /// For example, if this date is April 1st 2023, the [dayOfYear] will be `91`.
  int get dayOfYear => Dates.dayOfYear(year, month, day);

  /// Whether this date is a leap year.
  bool get leapYear => Dates.leapYear(year);

}

void main() => print(DateTime(1990, 13, 1));
