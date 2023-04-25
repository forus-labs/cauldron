import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/math.dart';
import 'package:sugar/time.dart';

part '../old/time/local_time.dart';
part '../old/time/offset_time.dart';

/// A temporal that contains units of time. All calculations should wrap around midnight.
@internal abstract class Time {

  /// Formats the given [time] to an ISO-8601 time string.
  static String format(DateTime time, Offset? offset) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    final seconds = time.second == 0 && time.millisecond == 0 && time.microsecond == 0 ? '' : ':${time.second.toString().padLeft(2, '0')}';
    final milliseconds = time.millisecond == 0 && time.microsecond == 0 ? '' : '.${time.millisecond.toString().padLeft(3, '0')}';
    final microseconds = time.microsecond == 0 ? '' :  time.microsecond.toString().padLeft(3, '0');
    final suffix = offset == null ? '' : offset.toString();

    return '$hours:$minutes$seconds$milliseconds$microseconds$suffix';
  }


  final DateTime _native;

  /// Creates a [Time] with the given seconds since midnight.
  Time.fromDaySeconds(DaySeconds seconds): _native = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true);

  /// Creates a [Time] with the given milliseconds since midnight.
  Time.fromDayMilliseconds(DayMilliseconds milliseconds): _native = DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);

  /// Creates a [Time] with the given microseconds since midnight.
  Time.fromDayMicroseconds(DayMicroseconds microseconds): _native = DateTime.fromMicrosecondsSinceEpoch(microseconds, isUtc: true);

  /// Creates a [Time] from the native [DateTime].
  Time.fromNativeDateTime(DateTime time): _native = DateTime.utc(1970, 1, 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);

  /// Creates a [Time].
  Time([int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
        _native = DateTime.utc(1970, 1, 1, hour, minute, second, millisecond, microsecond);

  Time._copy(this._native);

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
