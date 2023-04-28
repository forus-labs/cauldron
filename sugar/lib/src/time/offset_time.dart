part of 'time.dart';

class OffsetTime extends Time {

  /// The valid range of [OffsetTime]s in microseconds from `00:00+18:00` to `23:59:59.999999-18:00`, inclusive.
  static final Interval<int> range = Interval.closed(
    -18 * Duration.microsecondsPerHour,
    (Duration.millisecondsPerDay + 18 * Duration.microsecondsPerHour) - 1,
  );


  /// The offset.
  final Offset offset;
  String? _string;

  OffsetTime._(this.offset, super.time): super._();

}
