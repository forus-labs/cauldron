import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

/// Represents the time of the day as seen on a wall clock, i.e. `10:15:30`. It cannot be used to represent a specific
/// point in time without an additional offset or timezone.
class LocalTime with Orderable<LocalTime> {

  /// The valid range of [LocalTime]s, from `00:00` to `23:59:59.999999`, inclusive.
  static final Interval<LocalTime> range = Interval.closed(LocalTime(), LocalTime(23, 59, 59, 999, 999));
  /// The time of midnight, `00:00`.
  static final LocalTime midnight = LocalTime();
  /// The time of noon, `12:00`.
  static final LocalTime noon = LocalTime(12);

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

  int? _microseconds;
  String? _string;


  /// Creates a [LocalTime] with the given seconds since midnight. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final noon = LocalTime.fromDaySeconds(43200); // '12:00'
  ///
  /// final midnight = LocalTime.fromDaySeconds(Duration.secondsPerDay); // '00:00'
  /// ```
  factory LocalTime.fromDaySeconds(DaySeconds value) {
    value %= Duration.secondsPerDay;

    final second = value % 60;
    value ~/= 60;

    final minute = value % 60;
    value ~/= 60;

    final hour = value % 60;

    return LocalTime._(hour, minute, second, 0, 0);
  }

  /// Creates a [LocalTime] with the given milliseconds since midnight. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final noon = LocalTime.fromDayMilliseconds(43200000000); // '12:00'
  ///
  /// final midnight = LocalTime.fromDayMilliseconds(Duration.millisecondsPerDay); // '00:00'
  /// ```
  factory LocalTime.fromDayMilliseconds(DayMilliseconds value) {
    value %= Duration.millisecondsPerDay;

    final millisecond = value % 1000;
    value ~/= 1000;

    final second = value % 60;
    value ~/= 60;

    final minute = value % 60;
    value ~/= 60;

    final hour = value % 60;

    return LocalTime._(hour, minute, second, millisecond, 0);
  }

  /// Creates a [LocalTime] with the given microseconds since midnight. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final noon = LocalTime.fromDayMicroseconds(43200000); // '12:00'
  ///
  /// final midnight = LocalTime.fromDayMicroseconds(Duration.microsecondsPerDay); // '00:00'
  /// ```
  factory LocalTime.fromDayMicroseconds(DayMicroseconds value) {
    value %= Duration.microsecondsPerDay;

    final microsecond = value % 1000;
    value ~/= 1000;

    final millisecond = value % 1000;
    value ~/= 1000;

    final second = value % 60;
    value ~/= 60;

    final minute = value % 60;
    value ~/= 60;

    final hour = value % 60;

    return LocalTime._(hour, minute, second, millisecond, microsecond);
  }

  /// Creates a [LocalTime] that represents the current time.
  factory LocalTime.now() {
    final now = DateTime.now();
    return LocalTime._(now.hour, now.minute, now.second, now.millisecond, now.microsecond);
  }

  /// Creates a [LocalTime].
  ///
  /// ## Contract:
  /// The given arguments must be within the following ranges, otherwise a [RangeError] is thrown.
  /// * `0 <= hour < 24`
  /// * `0 <= minute < 60`
  /// * `0 <= second < 60`
  /// * `0 <= millisecond < 1000`
  /// * `0 <= microsecond < 1000`
  @Possible({RangeError})
  LocalTime([this.hour = 0, this.minute = 0, this.second = 0, this.millisecond = 0, this.microsecond = 0]) {
    RangeError.checkValueInInterval(hour, 0, 23, 'hour');
    RangeError.checkValueInInterval(minute, 0, 59, 'minute');
    RangeError.checkValueInInterval(second, 0, 59, 'second');
    RangeError.checkValueInInterval(millisecond, 0, 999, 'millisecond');
    RangeError.checkValueInInterval(microsecond, 0, 999, 'microsecond');
  }

  LocalTime._(this.hour, this.minute, this.second, this.millisecond, this.microsecond);


  /// Returns a copy of this [LocalTime] with the given time added. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = LocalTime(12).add(hours: -1, minutes: 1); // '11:01'
  ///
  /// final bar = LocalTime(20).add(hours: 8); // '04:00'
  /// ```
  LocalTime add({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) {
    final total = toDayMicroSeconds() + Microseconds.from(hours, minutes, seconds, milliseconds, microseconds);
    return LocalTime.fromDayMicroseconds(total);
  }

  /// Returns a copy of this [LocalTime] with the given time subtracted. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = LocalTime(12).subtract(hours: -1, minutes: 1); // '13:01'
  ///
  /// final bar = LocalTime(4).subtract(hours: 6); // '22:00'
  /// ```
  LocalTime subtract({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) {
    final total = toDayMicroSeconds() - Microseconds.from(hours, minutes, seconds, milliseconds, microseconds);
    return LocalTime.fromDayMicroseconds(total);
  }

  /// Returns a copy of this [LocalTime] with the given time added. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = LocalTime(12) + const Duration(hours: -1, minutes: 1); // '11:01'
  ///
  /// final bar = LocalTime(20) + const Duration(hours: 8); // '04:00'
  /// ```
  LocalTime operator + (Duration duration) => add(microseconds: duration.inMicroseconds);

  /// Returns a copy of this [LocalTime] with the given time subtracted. The calculation wraps around midnight.
  ///
  /// ```dart
  /// final foo = LocalTime(12) - const Duration(hours: -1, minutes: 1); // '13:01'
  ///
  /// final bar = LocalTime(4) - const Duration(hours: 6); // '22:00'
  /// ```
  LocalTime operator - (Duration duration) => subtract(microseconds: duration.inMicroseconds);


  LocalTime round(TimeUnit unit, [int value = 0]) => _adjust(value, unit, () => );

  LocalTime ceil(int value, TimeUnit unit) => _adjust(value, unit, math.ceil);

  LocalTime floor(int value, TimeUnit unit) => _adjust(value, unit, math.floor);


  LocalTime _adjust(int value, TimeUnit unit, int Function(int, int) function) {
    switch (unit) {
      case TimeUnit.hours:
        return LocalTime()

        return of(year, month, day, function(hour, value), minute, second, millisecond, microsecond);
      case TimeUnit.minutes:
        return of(year, month, day, hour, function(minute, value), second, millisecond, microsecond);
      case TimeUnit._seconds:
        return of(year, month, day, hour, minute, function(second, value), millisecond, microsecond);
      case TimeUnit.milliseconds:
        return of(year, month, day, hour, minute, second, function(millisecond, value), microsecond);
      case TimeUnit.microseconds:
        return of(year, month, day, hour, minute, second, millisecond, function(microsecond, value));
    }
  }


  /// Returns the difference between this[LocalTime] and other.
  ///
  /// ```dart
  /// LocalTime(22).difference(LocalTime(12)); // 10 hours
  ///
  /// LocalTime(13).difference(LocalTime(23)); // -10 hours
  /// ```
  Duration difference(LocalTime other) => Duration(microseconds: toDayMicroSeconds() - other.toDayMicroSeconds());


  /// Returns a copy of this [LocalTime] with the given updated parts.
  ///
  /// ```dart
  /// final noon = LocalTime(12);
  ///
  /// final halfPastNoon = noon.copyWith(minute: 30); // '12:30'
  /// ```
  ///
  /// ## Contract:
  /// The given arguments must be within the following ranges, otherwise a [RangeError] is thrown.
  /// * `0 <= hour < 24`
  /// * `0 <= minute < 60`
  /// * `0 <= second < 60`
  /// * `0 <= millisecond < 1000`
  /// * `0 <= microsecond < 1000`
  LocalTime copyWith({int? hour, int? minute, int? second, int? millisecond, int? microsecond}) => LocalTime(
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond  ?? this.microsecond,
  );

  /// Returns this [LocalTime] as seconds since midnight. The milliseconds and microseconds are truncated.
  ///
  /// ```dart
  /// final time = LocalTime(12, 0, 0, 999, 999);
  /// final seconds = time.toDaySeconds(); // 43200 ('12:00')
  /// ```
  DaySeconds toDaySeconds() => Seconds.from(hour, minute, second);

  /// Returns this [LocalTime] as milliseconds since midnight. The milliseconds are truncated.
  ///
  /// ```dart
  /// final time = LocalTime(12, 0, 0, 0, 999);
  /// final seconds = time.toDayMilliseconds(); // 43200000 ('12:00')
  /// ```
  DayMilliseconds toDayMilliseconds() => Milliseconds.from(hour, minute, second, millisecond);

  /// Returns this [LocalTime] as microseconds since midnight.
  ///
  /// ```dart
  /// final time = LocalTime(12);
  /// final seconds = time.toDayMicroseconds(); // 43200000000 ('12:00')
  /// ```
  DayMicroseconds toDayMicroSeconds() => _microseconds ??= Microseconds.from(hour, minute, second, millisecond, microsecond);


  @override
  int compareTo(LocalTime other) => toDayMicroSeconds().compareTo(other.toDayMicroSeconds());

  @override
  int get hashValue => hour.hashCode ^ minute.hashCode ^ second.hashCode ^ millisecond.hashCode ^ microsecond.hashCode;

  @override
  String toString() => _string ??= _format();

  String _format() {
    final hours = hour.toString().padLeft(2, '0');
    final minutes = minute.toString().padLeft(2, '0');
    final seconds = second.toString().padLeft(2, '0');
    final microseconds = ((millisecond * 1000) + microsecond).toString().padLeft(6, '0');
    return '$hours:$minutes:$seconds.$microseconds';
  }

}

void main() {
  LocalTime.now().round(TimeUnit.minutes, 5);
  LocalTime.now().round.minutes(5);
}


