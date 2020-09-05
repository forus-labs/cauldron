import 'package:meta/meta.dart';

// TODO: https://github.com/dart-lang/sdk/issues/43339
import 'package:sugar/src/time/date.dart';
import 'package:sugar/src/time/time.dart';

mixin Temporal<T extends Temporal<T>> implements DateTime {

  T _tomorrow;
  T _yesterday;

  T operator + (Duration duration);

  T operator - (Duration duration) => this + -duration;

  T get tomorrow => _tomorrow ??= this + const Duration(days: 1);

  T get yesterday => _yesterday ??= this - const Duration(days: 1);

}

extension DefaultTemporal on DateTime {

  DateTime operator + (Duration duration) => DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch + duration.inMicroseconds, isUtc: isUtc);

  DateTime operator - (Duration duration) => this + -duration;

  DateTime get tomorrow => this + const Duration(days: 1);

  DateTime get yesterday => this - const Duration(days: 1);

}

extension Chronological on DateTime {

  bool get isFuture => DateTime.now() < this;

  bool get isPast => DateTime.now() > this;

  bool operator < (DateTime other) => compareTo(other) < 0;

  bool operator > (DateTime other) => other < this;

  bool operator <= (DateTime other) => !(this > other);

  bool operator >= (DateTime other) => !(this < other);

}

mixin MultiPart implements DateTime {

  @protected Date datePart;
  @protected Time timePart;

  Date get date => datePart ??= Date(year, month, day);

  Time get time => timePart ??= Time(hour, minute, second, millisecond, microsecond);

}

