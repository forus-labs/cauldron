import 'package:meta/meta.dart';

import 'package:sugar/core.dart';
import 'package:sugar/core.dart' as math show round, ceil, floor;
import 'package:sugar/time.dart';

/// Represents an immutable time that is independent of timezones.
class Time with Relatable<Time> implements Comparable<Time> {

  /// The time of noon in the middle of the day.
  static final noon = Time(12);
  /// The time of midnight at the start of the day.
  static final midnight = Time(0);
  /// The minimum supported time.
  static final min = midnight;
  /// The maximum supported time.
  static final max = Time(23, 59, 59, 999, 999);

  /// The hour.
  final int hour;
  /// The minute.
  final int minute;
  /// The second.
  final int second;
  /// The millisecond.
  final int millisecond;
  /// The microsecond.
  final int microsecond;
  int _inMicroseconds;


  /// Creates a [Time] with the given time units.
  Time(this.hour, [this.minute = 0, this.second = 0, this.millisecond = 0, this.microsecond = 0]):
        assert(hour >= 0 && hour < 24, 'Hour is "$hour", should be between 0 and 24'),
        assert(minute >= 0 && minute < 60, 'Minute is "$minute", should be between 0 and 60'),
        assert(second >= 0 && second < 60, 'Second is "$second", should be between 0 and 60'),
        assert(millisecond >= 0 && millisecond < 1000, 'Millisecond is "$millisecond", should be between 0 and 1000'),
        assert(microsecond >= 0 && microsecond < 1000, 'Microsecond is "$microsecond", should be between 0 and 1000');

  /// Creates a [Time] from the given milliseconds. Behaviour is undefined if [milliseconds]
  /// exceeds the total milliseconds in a day.
  factory Time.fromMilliseconds(int milliseconds) => Time.fromMicroseconds(milliseconds * 1000);

  /// Creates a [Time] from the given milliseconds. Behaviour is undefined if [microseconds]
  /// exceeds the total microseconds in a day.
  factory Time.fromMicroseconds(int microseconds) {
    final total = microseconds;
    final microsecond = microseconds % 1000;
    microseconds ~/= 1000;

    final millisecond = microseconds % 1000;
    microseconds ~/= 1000;

    final second = microseconds % 60;
    microseconds ~/= 60;

    final minute = microseconds % 60;
    microseconds ~/= 60;

    final hour = microseconds % 60;

    return Time(hour, minute, second, millisecond, microsecond).._inMicroseconds = total;
  }


  /// Rounds this [Time] to the nearest [value].
  Time round(int value, TimeUnit unit) => _adjust(value, unit, math.round);

  /// Ceils this [Time] to the nearest [value].
  Time ceil(int value, TimeUnit unit) => _adjust(value, unit, math.ceil);

  /// Floors this [Time] to the nearest [value].
  Time floor(int value, TimeUnit unit) => _adjust(value, unit, math.floor);


  Time _adjust(int value, TimeUnit unit, int Function(int, int) function) {
    switch (unit) {
      case TimeUnit.hour:
        return Time(function(hour, value), minute, second, millisecond, microsecond);
      case TimeUnit.minute:
        return Time(hour, function(minute, value), second, millisecond, microsecond);
      case TimeUnit.second:
        return Time(hour, minute, function(second, value), millisecond, microsecond);
      case TimeUnit.millisecond:
        return Time(hour, minute, second, function(millisecond, value), microsecond);
      case TimeUnit.microsecond:
        return Time(hour, minute, second, millisecond, function(microsecond, value));
      default:
        assert(false, 'Time unit is "$unit", should be hour, minute, second, millisecond or microsecond');
        return this;
    }
  }

  /// Returns the length between this [Time] and [other].
  Duration difference(Time other) => Duration(microseconds: inMicroseconds - other.inMicroseconds);


  /// Returns a [Time] that represents this [Time] with the given duration added.
  Time operator + (Duration duration) => this - -duration;

  /// Returns a [Time] that represents this [Time] with the given duration subtracted.
  Time operator - (Duration duration) {
    final other = duration.inMicroseconds;
    final microseconds = (inMicroseconds - other) % Day.microseconds;

    return Time.fromMicroseconds(microseconds.isNegative ? microseconds + Day.microseconds : microseconds);
  }


  // Represents this [Time] as seconds.
  int get inSeconds => inMicroseconds ~/ 1000000;

  // Represents this [Time] as milliseconds.
  int get inMilliseconds => inMicroseconds ~/ 1000;

  // Represents this [Time] as microseconds.
  int get inMicroseconds => _inMicroseconds ??= Microsecond.from(hour, minute, second, millisecond, microsecond);


  @override
  int compareTo(Time other) => inMicroseconds.compareTo(other.inMicroseconds);

  @override
  @protected int get hash => inMicroseconds;

  @override
  String toString() => '${hour.padLeft(2)}:${minute.padLeft(2)}:${second.padLeft(2)}.${(millisecond * 1000 + microsecond).padLeft(6)}';

}