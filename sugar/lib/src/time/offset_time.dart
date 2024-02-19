part of 'time.dart';

/// The time of the day with an offset from UTC/Greenwich, such as `10:15+08:00`.
///
/// An [OffsetTime] is immutable. Time is stored to microsecond precision.
///
/// ## Working with `OffsetTime`s
///
/// To create an `OffsetTime`:
/// ```dart
/// final now = OffsetTime.now();
/// final moonLanding = OffsetTime(Offset(-6), 18, 4);
/// ```
///
/// You can add and subtract different types of time intervals, including:
/// * [Duration] - [add] and [subtract]
/// * [Period] - [+] and [-]
/// * Individual units of time - [plus] and [minus]
///
/// `OffsetTime` behaves the same for all 3 types of time intervals. All calculations wrap around midnight.
///
/// ```dart
/// final later = now.add(const Duration(hours: 1);
/// final evenLater = now + const Period(hour: 2);
/// final latest = now.plus(hours: 3);
/// ```
///
/// `OffsetTime` can be compared with [isBefore], [isSameMomentAs] and [isAfter]. Two `OffsetTime` may be in different
/// timezones but still represent the same moment. However, they are only considered equal, using [==], if they represent
/// the same moment in the same timezone.
///
/// ```dart
/// print(now.isBefore(later)); // true
/// print(latest.isAfter(evenLater)); // true
/// ```
///
/// You can also [truncate], [round], [ceil] and [floor] `OffsetTime`.
///
/// ```dart
/// print(moonLanding.truncate(to: TimeUnit.hours); // 18:00-06:00
/// print(moonLanding.round(TimeUnit.minutes, 5);   // 18:05-06:00
/// print(moonLanding.ceil(TimeUnit.minutes, 5);    // 18:05-06:00
/// print(moonLanding.floor(TimeUnit.minutes, 5);   // 18:00-06:00
/// ```
///
/// ## Testing
///
/// [OffsetTime.now] can be stubbed by setting [System.currentDateTime]:
/// ```dart
/// void main() {
///   test('mock OffsetTime.now()', () {
///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 23, 30);
///     expect(OffsetTime.now(), OffsetTime(Offset.utc, 23, 30));
///   });
/// }
/// ```
class OffsetTime extends Time {

  /// The offset.
  final Offset offset;
  String? _string;

  // TODO: https://github.com/dart-lang/linter/issues/3563
  // ignore: comment_references
  /// Creates a [OffsetTime] with the [offset] and [milliseconds] since midnight, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime.fromDayMilliseconds(Offset(8), 43200000); // 12:00+08:00
  ///
  /// OffsetTime.fromDayMilliseconds(Offset(8), 86400000); // 00:00+08:00
  /// ```
  OffsetTime.fromDayMilliseconds(this.offset, super.milliseconds): super.fromDayMilliseconds();

  // TODO: https://github.com/dart-lang/linter/issues/3563
  // ignore: comment_references
  /// Creates a [OffsetTime] with the [offset] and [microseconds] since midnight, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime.fromDayMicroseconds(Offset(8), 43200000000); // 12:00+08:00
  ///
  /// OffsetTime.fromDayMicroseconds(Offset(8), 86400000000); // 00:00+08:00
  /// ```
  OffsetTime.fromDayMicroseconds(this.offset, super.microseconds): super.fromDayMicroseconds();

  /// Creates a [OffsetTime] that represents the current time.
  ///
  /// ## Precision
  /// The precision of [OffsetTime.now] can be configured by giving a [TimeUnit]:
  /// ```dart
  /// // Assuming it's 2023-07-09 10:30:50+00:00
  /// OffsetTime.now(TimeUnit.hours); // 10:00+00:00
  /// ```
  ///
  /// ## Testing
  /// [OffsetTime.now] can be stubbed by setting [System.currentDateTime]:
  /// ```dart
  /// void main() {
  ///   test('mock OffsetTime.now()', () {
  ///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 23, 30);
  ///     expect(OffsetTime.now(), OffsetTime(Offset.utc, 23, 30));
  ///   });
  /// }
  /// ```
  factory OffsetTime.now([TimeUnit precision = TimeUnit.microseconds]) {
    final DateTime(:hour, :minute, :second, :millisecond, :microsecond, :timeZoneOffset) = System.currentDateTime();
    final offset = Offset.fromMicroseconds(timeZoneOffset.inMicroseconds);
    return switch (precision) {
      TimeUnit.microseconds => OffsetTime(offset, hour, minute, second, millisecond, microsecond),
      TimeUnit.milliseconds => OffsetTime(offset, hour, minute, second, millisecond),
      TimeUnit.seconds => OffsetTime(offset, hour, minute, second),
      TimeUnit.minutes => OffsetTime(offset, hour, minute),
      TimeUnit.hours => OffsetTime(offset, hour),
    };
  }

  /// Creates a [OffsetTime].
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12, 39, 59, 999, 999); // 12:39:59:999999+08:00
  ///
  /// OffsetTime(Offset(8), 25); // '01:00+08:00'
  ///
  /// OffsetTime(Offset(8), -1); // '23:00+08:00'
  /// ```
  OffsetTime(this.offset, [super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]);

  OffsetTime._(this.offset, super._native): super._();


  /// Returns a copy of this with the [duration] added, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).add(Duration(hours: -1)); // 11:00+08:00
  ///
  /// OffsetTime(Offset(8), 20).add(Duration(hours: 8)); // 04:00+08:00
  /// ```
  @useResult OffsetTime add(Duration duration) => OffsetTime._(offset, _native.add(duration));

  /// Returns a copy of this with the [duration] subtracted, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).subtract(Duration(hours: -1)); // 13:00+08:00
  ///
  /// OffsetTime(Offset(8), 4).subtract(Duration(hours: 6)); // 22:00+08:00
  /// ```
  @useResult OffsetTime subtract(Duration duration) => OffsetTime._(offset, _native.subtract(duration));

  /// Returns a copy of this with the units of time added, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).plus(hours: -1); // 11:00+08:00
  ///
  /// OffsetTime(Offset(8), 20).plus(hours: 8); // 04:00+08:00
  /// ```
  @useResult OffsetTime plus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    OffsetTime._(offset, _native.plus(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this with the units of time subtracted, wrapping around midnight.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).minus(hours: -1); // 13:00+08:00
  ///
  /// OffsetTime(Offset(8), 4).minus(hours: 6); // 22:00+08:00
  /// ```
  @useResult OffsetTime minus({int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    OffsetTime._(offset, _native.minus(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this with the [period] added.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 11, 30) + Period(hours: 1); // 12:30+08:00
  /// ```
  @useResult OffsetTime operator + (Period period) => OffsetTime._(offset, _native + period);

  /// Returns a copy of this with the [period] subtracted.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 11, 30) - Period(hours: 1); // 10:30+08:00
  /// ```
  @useResult OffsetTime operator - (Period period) => OffsetTime._(offset, _native - period);


  /// Returns a copy of this truncated to the [TimeUnit].
  ///
  /// ```dart
  /// final time = OffsetTime(Offset(8), 12, 39, 59, 999);
  /// time.truncate(to: TimeUnit.minutes); // 12:39+08:00
  /// ```
  @useResult OffsetTime truncate({required TimeUnit to}) => OffsetTime._(offset, _native.truncate(to: to));

  /// Returns a copy of this rounded to the nearest [unit] and [value].
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12, 31, 59).round(TimeUnit.minutes, 5); // 12:30+08:00
  ///
  /// OffsetTime(Offset(8), 12, 34, 59).round(TimeUnit.minutes, 5); // 12:35+08:00
  /// ```
  @useResult OffsetTime round(TimeUnit unit, int value) => OffsetTime._(offset, _native.round(unit, value));

  /// Returns a copy of this ceiled to the nearest [unit] and [value].
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12, 31, 59).ceil(TimeUnit.minutes, 5); // 12:35+08:00
  ///
  /// OffsetTime(Offset(8), 12, 34, 59).ceil(TimeUnit.minutes, 5); // 12:35+08:00
  /// ```
  @useResult OffsetTime ceil(TimeUnit unit, int value) => OffsetTime._(offset, _native.ceil(unit, value));

  /// Returns a copy of this floored to the nearest [unit] and [value].
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12, 31, 59).floor(TimeUnit.minutes, 5); // 12:30+08:00
  ///
  /// OffsetTime(Offset(8), 12, 34, 59).floor(TimeUnit.minutes, 5); // 12:30+08:00
  /// ```
  @useResult OffsetTime floor(TimeUnit unit, int value) => OffsetTime._(offset, _native.floor(unit, value));


  /// Returns a copy of this with the updated offset and units of time.
  ///
  /// ```dart
  /// OffsetTime(Offset(8), 12).copyWith(offset: Offset(12)); // 12:00+12:00
  /// ```
  @useResult OffsetTime copyWith({Offset? offset, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) => OffsetTime(
    offset ?? this.offset,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond  ?? this.microsecond,
  );


  /// Returns the difference between this and [other].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(-2), 22);
  /// final bar = OffsetTime(Offset(2), 12);
  ///
  /// foo.difference(bar); // 14 hours
  /// bar.difference(foo); // -14 hours
  /// ```
  @useResult Duration difference(OffsetTime other) => Duration(microseconds: _instant - other._instant);


  /// Converts this [OffsetTime] to a [LocalTime].
  @useResult LocalTime toLocal() => LocalTime._(_native);
  

  /// Returns true if this is before [other].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12); // 12:00+08:00
  /// final bar = OffsetTime(Offset(-8), 12); // 12:00-08:00
  ///
  /// print(foo.isBefore(bar)); // true
  /// ```
  bool isBefore(OffsetTime other) => _instant < other._instant;

  /// Returns true if this occurs at the same moment as [other].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(4), 12); // 12:00+04:00
  /// final bar = OffsetTime(Offset(0), 8);  // 08:00Z
  ///
  /// print(bar.isSameMomentAs(foo)); // true
  /// ```
  bool isSameMomentAs(OffsetTime other) => _instant == other._instant;

  /// Returns true if this is after [other].
  ///
  /// ```dart
  /// final foo = OffsetTime(Offset(8), 12); // 12:00+08:00
  /// final bar = OffsetTime(Offset(-8), 12); // 12:00-08:00
  ///
  /// print(bar.isAfter(foo)); // true
  /// ```
  bool isAfter(OffsetTime other) => _instant > other._instant;


  /// Returns true if other is a [OffsetTime] at the same moment and in the same timezone.
  ///
  /// ```
  /// final foo = OffsetTime(Offset(4), 12); // 12:00+04:00
  /// final bar = OffsetTime(Offset(0), 8);  // 08:00Z
  ///
  /// bar == foo; // false
  /// bar.isSameMomentAs(foo); // true
  /// ```
  @override
  @useResult bool operator ==(Object other) => identical(this, other) || other is OffsetTime && runtimeType == other.runtimeType &&
      offset == other.offset && _native.microsecondsSinceMidnight == other._native.microsecondsSinceMidnight;

  @override
  @useResult int get hashCode => runtimeType.hashCode ^ offset.hashCode ^ _native.microsecondsSinceMidnight;

  /// Returns a ISO formatted string representation.
  ///
  /// When possible, trailing zero seconds, milliseconds and microseconds are truncated.
  ///
  /// ```dart
  /// OffsetTime(Offset(-8), 12, 30, 1, 2, 3); // 12:30:01.002003-08:00
  ///
  /// LocalDateTime(Offset(4), 12, 30); // 12:30+04:00
  /// ```
  @override
  @useResult String toString() => _string ??= '${_native.toTimeString()}$offset';


  int get _instant => _native.microsecondsSinceMidnight - offset.inMicroseconds;

}
