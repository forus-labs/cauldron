import 'package:meta/meta.dart';

import 'package:sugar/src/core/constants.dart';
import 'package:sugar/src/time/date.dart';
import 'package:sugar/src/time/time.dart';
import 'package:sugar/sugar.dart';

part 'local_date_time.dart';
part 'zoned_date_time.dart';

/// A datetime.
@internal
class DateTimeBase implements Date, Time {
  final DateTime _native;

  /// Creates a [DateTimeBase] from the given milliseconds since Unix epoch.
  DateTimeBase.fromEpochMilliseconds(EpochMilliseconds milliseconds)
    : _native = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [DateTimeBase] from the given microseconds since Unix epoch.
  DateTimeBase.fromEpochMicroseconds(EpochMicroseconds microseconds)
    : _native = DateTime.fromMicrosecondsSinceEpoch(microseconds, isUtc: true);

  /// Creates a [DateTimeBase] from the native [DateTime].
  DateTimeBase.fromNative(DateTime date)
    : _native = DateTime.utc(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );

  /// Creates a [DateTimeBase].
  DateTimeBase(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : _native = DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond);

  DateTimeBase._(this._native) : assert(_native.isUtc, '$_native is in local timezone. Should be UTC. $issueTracker');

  @override
  int get year => _native.year;
  @override
  int get month => _native.month;
  @override
  int get day => _native.day;
  @override
  int get hour => _native.hour;
  @override
  int get minute => _native.minute;
  @override
  int get second => _native.second;
  @override
  int get millisecond => _native.millisecond;
  @override
  int get microsecond => _native.microsecond;
}
