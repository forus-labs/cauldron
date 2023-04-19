import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/math.dart';
import 'package:sugar/src/old/time/date.dart';
import 'package:sugar/src/time/time.dart';
import 'package:sugar/time.dart';

part '../../time/local_date_time.dart';
part 'zoned_date_time.dart';

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

/// Represents a temporal with date and time units.
@internal class DateTimeBase implements Date, Time {

  /// Returns a [DateTime] with the given time added.
  static DateTime plus(DateTime date, int years, int months, int days, int hours, int minutes, int seconds, int milliseconds, int microseconds) => date.copyWith(
    year: date.year + years,
    month: date.month + months,
    day: date.day + days,
    hour: date.hour + hours,
    minute: date.minute + minutes,
    second: date.second + seconds,
    millisecond: date.millisecond + milliseconds,
    microsecond: date.microsecond + microseconds,
  );

  /// Returns a [DateTime] with the given time subtracted. The calculation wraps around midnight.
  static DateTime minus(DateTime date, int years, int months, int days, int hours, int minutes, int seconds, int milliseconds, int microseconds) => date.copyWith(
    year: date.year - years,
    month: date.month - months,
    day: date.day - days,
    hour: date.hour - hours,
    minute: date.minute - minutes,
    second: date.second - seconds,
    millisecond: date.millisecond - milliseconds,
    microsecond: date.microsecond - microseconds,
  );


  /// Returns a [DateTime] truncated to the given temporal unit.
  static DateTime truncate(DateTime date, TemporalUnit to) {
    switch (to) {
      case DateUnit.years:
        return date.copyWith(month: 1, day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case DateUnit.months:
        return date.copyWith(day: 1, hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case DateUnit.days:
        return date.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case TimeUnit.hours:
        return date.copyWith(minute: 0, second: 0, millisecond: 0, microsecond: 0);
      case TimeUnit.minutes:
        return date.copyWith(second: 0, millisecond: 0, microsecond: 0);
      case TimeUnit.seconds:
        return date.copyWith(millisecond: 0, microsecond: 0);
      case TimeUnit.milliseconds:
        return date.copyWith(microsecond: 0);
      case TimeUnit.microseconds:
        return date;
      default:
        throw UnsupportedError('$to is not supported.'); // TODO: remove once sealed types are available.
    }
  }

  /// Returns a [DateTime] with the given temporal unit rounded to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime round(DateTime date, int to, TemporalUnit unit) => _adjust(date, to, unit, (date, to) => date.roundTo(to));

  /// Returns a [DateTime] with the given temporal unit ceiled to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime ceil(DateTime date, int to, TemporalUnit unit) => _adjust(date, to, unit, (date, to) => date.ceilTo(to));

  /// Returns a [DateTime] with the given temporal unit floored to the nearest value. The date fields are not modified.
  ///
  /// ## Contract:
  /// [to] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  static DateTime floor(DateTime date, int to, TemporalUnit unit) => _adjust(date, to, unit, (date, to) => date.floorTo(to));

  static DateTime _adjust(DateTime time, int to, TemporalUnit unit, int Function(int time, int to) apply) {
    switch (unit) {
      case DateUnit.years:
        return time.copyWith(year: apply(time.year, to));
      case DateUnit.months:
        return time.copyWith(month: apply(time.month, to));
      case DateUnit.days:
        return time.copyWith(day: apply(time.day, to));
      case TimeUnit.hours:
        return time.copyWith(hour: apply(time.hour, to));
      case TimeUnit.minutes:
        return time.copyWith(minute: apply(time.hour, to));
      case TimeUnit.seconds:
        return time.copyWith(second: apply(time.hour, to));
      case TimeUnit.milliseconds:
        return time.copyWith(millisecond: apply(time.hour, to));
      case TimeUnit.microseconds:
        return time.copyWith(microsecond: apply(time.hour, to));
      default:
        throw UnsupportedError('$to is not supported.'); // TODO: remove once sealed types are available.
    }
  }


  final DateTime _native;

  /// Creates a [DateTimeBase] from the given milliseconds since Unix epoch.
  DateTimeBase.fromEpochMillisecondsAsUtc0(EpochMilliseconds milliseconds): _native = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [Date] from the given microseconds since Unix epoch, floored to the nearest day.
  DateTimeBase.fromEpochMicrosecondsAsUtc0(EpochMicroseconds microseconds): _native = DateTime.fromMillisecondsSinceEpoch(microseconds, isUtc: true);

  /// Creates a [DateTimeBase] from the native [DateTime].
  DateTimeBase.fromNativeDateTime(DateTime date): _native = DateTime.utc(date.year, date.month, date.day, date.hour, date.minute, date.second, date.millisecond, date.microsecond);

  /// Creates a [DateTimeBase].
  DateTimeBase(int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
    _native = DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond);

  DateTimeBase._(this._native);


  /// Returns the day of the week. Following ISO-8601, a week starts on Monday which has a value of `1` and ends on Sunday which
  /// has a value of `7`.
  ///
  /// For example, July 20th 1969 will return `7` (Sunday).
  @useResult int toWeekday() => Dates.weekday(year, month, day);

  /// Returns the ordinal week of the year. Following ISO-8601, a week is between `1` and `53`, inclusive.
  ///
  /// For example, April 1st 2023 will return `13`.
  @useResult int toWeekOfYear() => Dates.weekOfYear(year, month, day);

  /// Returns the ordinal day of the year.
  ///
  /// For example, April 1st 2023 will return `91`.
  @useResult int toDayOfYear() => Dates.dayOfYear(year, month, day);


  /// Returns the number of days in the given month.
  ///
  /// For example, February 15th 2023 will return `28` while February 15th 2024 will return `29`.
  @useResult int get daysInMonth => Dates.daysInMonth(year, month);

  /// Whether this [DateTime]'s year is a leap year.
  ///
  /// For example, February 15th 2023 will return `false` while February 15th 2024 will return `true`.
  @useResult bool get leapYear => Dates.leapYear(year);


  /// The year.
  @override
  int get year => _native.year;
  /// The month.
  @override
  int get month => _native.month;
  /// The day.
  @override
  int get day => _native.day;
  /// The hour.
  @override
  int get hour => _native.hour;
  /// The minute.
  @override
  int get minute => _native.minute;
  /// The second.
  @override
  int get second => _native.second;
  /// The millisecond.
  @override
  int get millisecond => _native.millisecond;
  /// The microsecond.
  @override
  int get microsecond => _native.microsecond;

}
