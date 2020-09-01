import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

class Time with Relatable<Time> implements Comparable<Time> {

  static final noon = Time(12);
  static final midnight = Time(0);
  static final min = midnight;
  static final max = Time(23, 59, 59, 999, 999);
  static final _day = BigInt.from(Day.microseconds);

  final int hour;
  final int minute;
  final int second;
  final int millisecond;
  final int microsecond;
  int _inMicroseconds;


  Time(this.hour, [this.minute, this.second, this.millisecond, this.microsecond]):
        assert(hour >= 0 && hour < 24, 'Hour is "$hour", should be between 0 and 24'),
        assert(minute >= 0 && minute < 60, 'Minute is "$minute", should be between 0 and 60'),
        assert(second >= 0 && second < 60, 'Second is "$second", should be between 0 and 60'),
        assert(millisecond >= 0 && millisecond < 1000, 'Millisecond is "$millisecond", should be between 0 and 1000'),
        assert(microsecond >= 0 && microsecond < 1000, 'Microsecond is "$microsecond", should be between 0 and 1000');

  factory Time.fromMicroseconds(int value) {
    final microsecond = value % 1000;
    value ~/= 1000;

    final millisecond = value % 1000;
    value ~/= 1000;

    final second = value % 60;
    value ~/= 60;

    final minute = value % 60;
    value ~/= 60;

    final hour = value % 60;

    return Time(hour, minute, second, millisecond, microsecond).._inMicroseconds = value;
  }

  Time operator + (Duration duration) => this - -duration;

  Time operator - (Duration duration) {
    final other = duration.inMicroseconds;
    var microseconds = 0;
    if (inMicroseconds.subtractOverflows(other)) {
      microseconds = ((BigInt.from(inMicroseconds) - BigInt.from(other)) % _day).toInt();

    } else {
      microseconds = (inMicroseconds - other) % Day.microseconds;
    }

    return Time.fromMicroseconds(microseconds.isNegative ? microseconds + Day.microseconds : microseconds);
  }

  Duration difference(Time other) => Duration(microseconds: inMicroseconds - other.inMicroseconds);


  int get inSeconds => Second.from(hour, minute, second);

  int get inMilliseconds => Millisecond.from(hour, minute, second, millisecond);

  int get inMicroseconds => _inMicroseconds ??= Microsecond.from(hour, minute, second, millisecond, microsecond);


  @override
  int compareTo(Time other) => inMicroseconds.compareTo(inMicroseconds);

  @override
  int get hash => inMicroseconds;

  @override
  String toString() => '${hour.padLeft(2)}:${minute.padLeft(2)}:${second.padLeft(2)}.${(millisecond * 1000 + microsecond).padLeft(6)}';

}