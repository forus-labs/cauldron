import 'package:meta/meta.dart';
import 'package:sugar/src/time/temporal_unit.dart';

import 'package:sugar/sugar.dart';

/// Provides functions for working with Dart's [DateTime]s. These functions should only be used when it is not feasible
/// to use this library's provided date & time types.
extension DateTimes on DateTime {

  /// Returns a copy of this [DateTime] with the given time added.
  ///
  /// ```dart
  /// DateTime(2023, 4, 10, 8).plus(months: -1, hours: 1); // '2023-04-10T09:00'
  /// ```
  ///
  /// See [add].
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

  /// Returns a copy of this [DateTime] with the given time subtracted.
  ///
  /// ```dart
  /// DateTime(2023, 4, 10, 8).minus(months: -1, hours: 1); // '2023-05-10T07:00'
  /// ```
  ///
  /// See [subtract].
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


  /// Returns a copy of this [DateTime] truncated to the given temporal unit.
  ///
  /// ```dart
  /// DateTime(2023, 4, 1).truncate(to: TemporalUnit.years); // 2023-01-01
  /// ```
  @useResult DateTime truncate({required TemporalUnit to}) {
    switch (to) {
      case DateUnit.years:
        return copyWith(month: 1, day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case DateUnit.months:
        return copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case DateUnit.days:
        return copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case TimeUnit.hours:
        return copyWith(minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case TimeUnit.minutes:
        return copyWith(second: 0, millisecond: 0, microsecond: 0);
      case TimeUnit.seconds:
        return copyWith(millisecond: 0, microsecond: 0);
      case TimeUnit.milliseconds:
        return copyWith(microsecond: 0);
      case TimeUnit.microseconds:
        return this;
      default:
        throw UnsupportedError('$to is not supported.'); // TODO: remove once sealed types are available.
    }
  }

  /// Returns a copy of this [DateTime] with the given temporal unit rounded to the nearest value. Throws a [RangeError]
  /// if [to] is not positive.
  ///
  /// ```dart
  /// DateTime(2023, 4, 15).round(6, DateUnit.months); // '2023-06-15'
  ///
  /// DateTime(2023, 8, 15)).round(6, DateUnit.months); // '2023-06-15'
  /// ```
  @Possible({RangeError})
  @useResult DateTime round(int to, DateUnit unit) => _adjust(to, unit, (date, to) => date.roundTo(to));

  /// Returns a copy of this [DateTime] with the given temporal unit ceiled to the nearest value. Throws a [RangeError]
  /// if [to] is not positive.
  ///
  /// ```dart
  /// DateTime(2023, 4, 15).ceil(6, DateUnit.months); // '2023-06-15'
  ///
  /// DateTime(2023, 8, 15)).ceil(6, DateUnit.months); // '2023-12-15'
  /// ```
  @Possible({RangeError})
  @useResult DateTime ceil(int to, TemporalUnit unit) => _adjust(to, unit, (date, to) => date.ceilTo(to));

  /// Returns a copy of this [DateTime] with the given temporal unit floored to the nearest value. Throws a [RangeError]
  /// if [to] is not positive.
  ///
  /// ```dart
  ///
  /// DateTime(2023, 4, 15).floor(6, DateUnit.months); // '2023-01-15'
  ///
  ///
  /// DateTime(2023, 8, 15)).floor(6, DateUnit.months); // '2023-06-15'
  /// ```
  @Possible({RangeError})
  @useResult DateTime floor(int to, TemporalUnit unit) => _adjust(to, unit, (date, to) => date.floorTo(to));

  DateTime _adjust(int to, TemporalUnit unit, int Function(int time, int to) apply) {
    switch (unit) {
      case DateUnit.years:
        return copyWith(year: apply(year, to));
      case DateUnit.months:
        return copyWith(month: apply(month, to));
      case DateUnit.days:
        return copyWith(day: apply(day, to));
      case TimeUnit.hours:
        return copyWith(hour: apply(hour, to));
      case TimeUnit.minutes:
        return copyWith(minute: apply(minute, to));
      case TimeUnit.seconds:
        return copyWith(second: apply(second, to));
      case TimeUnit.milliseconds:
        return copyWith(millisecond: apply(millisecond, to));
      case TimeUnit.microseconds:
        return copyWith(microsecond: apply(microsecond, to));
      default:
        throw UnsupportedError('$to is not supported.'); // TODO: remove once sealed types are available.
    }
  }


  /// The ordinal week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
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


  /// The number of days in this month taking leap years into account.
  ///
  /// ```dart
  /// DateTime(2019, 2).daysInMonth; // 28
  /// DateTime(2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => Dates.daysInMonth(year, month);

  /// True if this is year is a leap year.
  ///
  /// ```dart
  /// DateTime(2020).leapYear; // true
  /// DateTime(2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => Dates.leapYear(year);


  /// The days since Unix epoch.
  int get daysSinceEpoch => millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;

  /// The seconds since Unix epoch.
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;


  /// The time as seconds since midnight.
  ///
  /// DateTime(2023, 4, 1, 12).secondsSinceMidnight; // 43200 ('12:00')
  int get secondsSinceMidnight =>
    hour * Duration.secondsPerHour +
    minute * Duration.secondsPerMinute +
    second;

  /// The time as milliseconds since midnight.
  ///
  /// DateTime(2023, 4, 1, 12).millisecondsSinceMidnight; // 43200000 ('12:00')
  int get millisecondsSinceMidnight =>
    hour * Duration.millisecondsPerHour +
    minute * Duration.millisecondsPerMinute +
    second * Duration.millisecondsPerSecond +
    millisecond;

  /// The time as microseconds since midnight.
  ///
  /// DateTime(2023, 4, 1, 12).microsecondsSinceMidnight; // 43200000000 ('12:00')
  int get microsecondsSinceMidnight => sumMicroseconds(hour, minute, second, millisecond, microsecond);

}
