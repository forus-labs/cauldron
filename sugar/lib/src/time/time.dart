import 'package:meta/meta.dart';

import 'package:sugar/core.dart';
import 'package:sugar/core.dart' as math show round, ceil, floor;
import 'package:sugar/time.dart';

class Time with Relatable<Time> implements Comparable<Time> {

  static final noon = Time(12);
  static final midnight = Time(0);
  static final min = midnight;
  static final max = Time(23, 59, 59, 999, 999);

  final int hour;
  final int minute;
  final int second;
  final int millisecond;
  final int microsecond;
  int _inMicroseconds;


  Time(this.hour, [this.minute = 0, this.second = 0, this.millisecond = 0, this.microsecond = 0]):
        assert(hour >= 0 && hour < 24, 'Hour is "$hour", should be between 0 and 24'),
        assert(minute >= 0 && minute < 60, 'Minute is "$minute", should be between 0 and 60'),
        assert(second >= 0 && second < 60, 'Second is "$second", should be between 0 and 60'),
        assert(millisecond >= 0 && millisecond < 1000, 'Millisecond is "$millisecond", should be between 0 and 1000'),
        assert(microsecond >= 0 && microsecond < 1000, 'Microsecond is "$microsecond", should be between 0 and 1000');

  factory Time.fromMilliseconds(int milliseconds) => Time.fromMicroseconds(milliseconds * 1000);

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


  Time round(int value, TimeUnit unit) => _adjust(value, unit, math.round);

  Time ceil(int value, TimeUnit unit) => _adjust(value, unit, math.ceil);

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

  Duration difference(Time other) => Duration(microseconds: inMicroseconds - other.inMicroseconds);


  Time operator + (Duration duration) => this - -duration;

  Time operator - (Duration duration) {
    final other = duration.inMicroseconds;
    final microseconds = (inMicroseconds - other) % Day.microseconds;

    return Time.fromMicroseconds(microseconds.isNegative ? microseconds + Day.microseconds : microseconds);
  }


  int get inSeconds => inMicroseconds ~/ 1000000;

  int get inMilliseconds => inMicroseconds ~/ 1000;

  int get inMicroseconds => _inMicroseconds ??= Microsecond.from(hour, minute, second, millisecond, microsecond);


  @override
  int compareTo(Time other) => inMicroseconds.compareTo(other.inMicroseconds);

  @override
  @protected int get hash => inMicroseconds;

  @override
  String toString() => '${hour.padLeft(2)}:${minute.padLeft(2)}:${second.padLeft(2)}.${(millisecond * 1000 + microsecond).padLeft(6)}';

}