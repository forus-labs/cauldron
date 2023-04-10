import 'package:meta/meta.dart';

/// Represents a temporal that contains units of date.
@internal mixin Date {

  /// The year.
  int get year;
  /// The month.
  int get month;
  /// The day.
  int get day;


  /// The day of the week. Following ISO-8601, a week starts on monday which has a value of `1`.
  ///
  /// For example, if the date is July 20th 1969, the [weekday] will be 7, which is a Sunday.
  int get weekday => Dates.weekday(year, month, day);


  int get weekOfYear => Dates.weekOfYear(year, month, day);

  /// The day of the year.
  ///
  /// For example, if the date is April 1st 2023, the [dayOfYear] is `91`.
  int get dayOfYear => Dates.dayOfYear(year, month, day);

  /// Whether this date is a leap year.
  bool get leapYear => Dates.leapYear(year);

}

extension Dates on Never {

  static const _cumulative = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];


  static int weekday(int year, int month, int day) {
    // Modified Tomohiko Sakamoto's algorithm where Monday = 1 and Sunday = 7.
    // See https://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week#Sakamoto's_methods
    const table = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4];
    final adjustedYear = month < 3 ? year - 1 : year;
    final weekday = (adjustedYear + adjustedYear ~/4 - adjustedYear ~/100 + adjustedYear ~/400 + table[month-1] + day) % 7;
    return weekday == 0 ? 7 : weekday;
  }

  static int weekOfYear(int year, int month, int day) {
    final ordinal = (dayOfYear(year, month, day) - weekday(year, month, day) + 10) ~/ 7;
    if (ordinal == 0) {
      return weekOfYear(year - 1, 12, 28);
    }

    if (ordinal == 53 && weekday(year, 1, 1) != 4 && weekday(year, 12, 31) != 4) {
      return 1;
    }

    return ordinal;
  }

  static int dayOfYear(int year, int month, int day) => _cumulative[month - 1] + day + (leapYear(year) && month > 2 ? 1 : 0);

  static bool leapYear(int year) => year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);

}
