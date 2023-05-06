part of 'time.dart';

/// The time of the day with an offset from UTC/Greenwich, i.e. `10:15+08:00`. Time is stored to microsecond precision.
///
/// An [OffsetTime] is immutable and should be treated as a value-type.
class OffsetTime extends Time {

  /// The offset.
  final Offset offset;
  String? _string;


  /// Creates a [OffsetTime] with the offset and milliseconds since midnight which wraps around midnight.
  ///
  /// ```dart
  /// OffsetTime.fromDayMilliseconds(Offset(8), Offset43200000); // '12:00+08:00'
  ///
  /// OffsetTime.fromDayMilliseconds(Offset(8), Duration.millisecondsPerDay); // '00:00+08:00'
  /// ```
  OffsetTime.fromDayMilliseconds(this.offset, super.milliseconds): super.fromDayMilliseconds();

  /// Creates a [OffsetTime] with the offset and microseconds since midnight which wraps around midnight.
  ///
  /// ```dart
  /// OffsetTime.fromDayMicroseconds(Offset(8), 43200000000); // '12:00+08:00'
  ///
  /// OffsetTime.fromDayMicroseconds(Offset(8), Duration.microsecondsPerDay); // '00:00+08:00'
  /// ```
  OffsetTime.fromDayMicroseconds(this.offset, super.microseconds): super.fromDayMicroseconds();

  /// Creates a [OffsetTime] that represents the current time.
  OffsetTime.now(): this._now(DateTime.now());

  /// Creates a [OffsetTime].
  ///
  /// ```dart
  /// final time = OffsetTime(Offset(8), 12, 39, 59, 999, 999);
  /// print(time); // '12:39:59:999999+08:00'
  ///
  /// final overflow = OffsetTime(Offset(8), 25);
  /// print(overflow); // '01:00+08:00'
  ///
  /// final underflow = OffsetTime(Offset(8), -1);
  /// print(underflow); // '23:00+08:00'
  /// ```
  OffsetTime(this.offset, [super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]);

  OffsetTime._now(super.time): offset = Offset.fromMicroseconds(time.timeZoneOffset.inMicroseconds), super.fromNative();

  OffsetTime._(this.offset, super.time): super._();


  /// Returns a copy of this [OffsetTime] with the [duration] added, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).add(Duration(hours: -1, minutes: 1)); // '11:01+08:00'
  ///
  /// OffsetTime(Offset(8), 20).add(Duration(hours: 8)); // '04:00+08:00'
  /// ```
  @useResult OffsetTime add(Duration duration) => OffsetTime._(offset, _native.add(duration));

  /// Returns a copy of this [OffsetTime] with the [duration] subtracted, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).subtract(Duration(hours: -1, minutes: 1)); // '13:01+08:00'
  ///
  /// OffsetTime(Offset(8), 4).subtract(Duration(hours: 6)); // '22:00+08:00'
  /// ```
  @useResult OffsetTime subtract(Duration duration) => OffsetTime._(offset, _native.subtract(duration));

  /// Returns a copy of this [OffsetTime] with the time added, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).plus(hours: -1, minutes: 1); // '11:01+08:00'
  ///
  /// OffsetTime(Offset(8), 20).plus(hours: 8); // '04:00+08:00'
  /// ```
  ///
  /// See [add].
  @useResult OffsetTime plus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    OffsetTime._(offset, _native.plus(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this [OffsetTime] with the time subtracted, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).minus(hours: -1, minutes: 1); // '13:01+08:00'
  ///
  /// OffsetTime(Offset(8), 4).minus(hours: 6); // '22:00+08:00'
  /// ```
  ///
  /// See [subtract].
  @useResult OffsetTime minus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    OffsetTime._(offset, _native.minus(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this [OffsetTime] with the [Period] added.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 11, 30) + Period(hours: 1); // '12:30+08:00'
  /// ```
  @useResult OffsetTime operator + (Period period) => OffsetTime._(offset, _native + period);

  /// Returns a copy of this [OffsetTime] with the [Period] subtracted.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 11, 30) - Period(hours: 1); // '10:30+08:00'
  /// ```
  @useResult OffsetTime operator - (Period period) => OffsetTime._(offset, _native - period);


  /// Returns a copy of this [OffsetTime] truncated to the time unit.
  ///
  /// ```dart
  /// final time = OffsetTime(Offset(8), 12, 39, 59, 999);
  /// time.truncate(to: TimeUnit.minutes); // '12:39+08:00'
  /// ```
  @useResult OffsetTime truncate({required TimeUnit to}) => OffsetTime._(offset, _native.truncate(to: to));

  /// Returns a copy of this [OffsetTime] with the time unit rounded to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.round(5, TimeUnit.minutes); // '12:30:59+08:00'
  ///
  /// final bar =OffsetTime(Offset(8), 12, 34, 59);
  /// bar.round(5, TimeUnit.minutes); // '12:35:59+08:00'
  /// ```
  @useResult OffsetTime round(TimeUnit unit, int value) => OffsetTime._(offset, _native.round(unit, value));

  /// Returns a copy of this [OffsetTime] with the time unit ceil to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.ceil(5, TimeUnit.minutes); // '12:35:59+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 12, 34, 59);
  /// bar.ceil(5, TimeUnit.minutes); // '12:35:59+08:00'
  /// ```
  @useResult OffsetTime ceil(TimeUnit unit, int value) => OffsetTime._(offset, _native.ceil(unit, value));

  /// Returns a copy of this [OffsetTime] with the time unit floored to the nearest [value].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12, 31, 59);
  /// foo.floor(5, TimeUnit.minutes); // '12:30:59+08:00'
  ///
  /// final bar = OffsetTime(Offset(8), 12, 34, 59);
  /// bar.floor(5, TimeUnit.minutes); // '12:30:59+08:00'
  /// ```
  @useResult OffsetTime floor(TimeUnit unit, int value) => OffsetTime._(offset, _native.floor(unit, value));


  /// Returns a copy of this [OffsetTime] with the given updated parts.
  ///
  /// ```dart
  /// final original = OffsetTime(Offset(8), 12);
  /// original.copyWith(offset: Offset(12), minute: 30); // '12:30+12:00'
  /// ```
  @useResult OffsetTime copyWith({Offset? offset, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) => OffsetTime(
    offset ?? this.offset,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond  ?? this.microsecond,
  );


  /// Returns the difference between this [OffsetTime] and other.
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(-2), 22);
  /// foo.difference(OffsetTime(Offset(2), 12)); // 14 hours
  ///
  /// final bar = OffsetTime(Offset(3), 13);
  /// bar.difference(OffsetTime(Offset(-3), 23)); // -16 hours
  /// ```
  @useResult Duration difference(OffsetTime other) => Duration(microseconds: _instant - other._instant);


  /// Converts this [OffsetTime] to a [LocalTime].
  @useResult LocalTime toLocal() => LocalTime._(_native);
  

  /// Returns true if this [OffsetTime] is before [other].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12); // '12:00+08:00'
  /// final bar = OffsetTime(Offset(-8), 12); // '12:00-08:00'
  ///
  /// print(foo.isBefore(bar)); // true
  /// ```
  bool isBefore(OffsetTime other) => _instant < other._instant;

  /// Returns true if this [OffsetTime] occurs at the same moment as [other].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(4), 12); // '12:00+04:00'
  /// final bar = OffsetTime(Offset(0), 8); // '08:00Z'
  ///
  /// print(bar.isSameMomentAs(foo)); // true
  /// ```
  bool isSameMomentAs(OffsetTime other) => _instant == other._instant;

  /// Returns true if this [OffsetTime] is after [other].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12); // '12:00+08:00'
  /// final bar = OffsetTime(Offset(-8), 12); // '12:00-08:00'
  ///
  /// print(bar.isAfter(foo)); // true
  /// ```
  bool isAfter(OffsetTime other) => _instant > other._instant;


  @override
  @useResult bool operator ==(Object other) => identical(this, other) || other is OffsetTime && runtimeType == other.runtimeType &&
      offset == other.offset && _native.microsecondsSinceMidnight == other._native.microsecondsSinceMidnight;

  @override
  @useResult int get hashCode => runtimeType.hashCode ^ offset.hashCode ^ _native.microsecondsSinceMidnight;

  @override
  @useResult String toString() => _string ??= '${_native.toTimeString()}$offset';


  int get _instant => _native.microsecondsSinceMidnight - offset.inMicroseconds;

}
