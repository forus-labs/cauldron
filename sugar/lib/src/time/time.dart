import 'package:meta/meta.dart';
import 'package:sugar/src/core/constants.dart';
import 'package:sugar/sugar.dart';

part 'local_time.dart';
part 'offset_time.dart';

/// A time of the day. All calculations wrap around midnight.
@internal abstract class Time {

  final DateTime _native;

  /// Creates a [Time] with the milliseconds since midnight.
  Time.fromDayMilliseconds(DayMilliseconds milliseconds): _native = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [Time] with the microseconds since midnight.
  Time.fromDayMicroseconds(DayMicroseconds microseconds): _native = DateTime.fromMicrosecondsSinceEpoch(microseconds, isUtc: true);

  /// Creates a [Time] from the native [DateTime].
  Time.fromNative(DateTime time): _native = DateTime.utc(1970, 1, 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);

  /// Creates a [Time].
  Time([int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
        _native = DateTime.utc(1970, 1, 1, hour, minute, second, millisecond, microsecond);

  Time._(this._native): assert(_native.isUtc, '$_native is in local timezone. Should be UTC. $issueTracker');

  /// The hour.
  int get hour => _native.hour;
  /// The minute.
  int get minute => _native.minute;
  /// The second.
  int get second => _native.second;
  /// The millisecond.
  int get millisecond => _native.millisecond;
  /// The microsecond.
  int get microsecond => _native.microsecond;

}
