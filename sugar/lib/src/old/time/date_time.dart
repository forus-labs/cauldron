import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/math.dart';
import 'package:sugar/src/old/time/date.dart';
import 'package:sugar/src/time/time.dart';
import 'package:sugar/time.dart';

part '../../time/local_date_time.dart';
part 'zoned_date_time.dart';

/// Represents a temporal with date and time units.
@internal class DateTimeBase implements Date, Time {

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
