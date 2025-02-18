part of 'date_time.dart';

/// A date-time with a timezone such as `2023-04-13 10:15:30+08:00 Asia/Singapore`.
///
/// A [ZonedDateTime] is immutable. It can represent a specific point in time. Time is stored to microsecond precision.
///
/// It can represent date-times with:
/// * A fixed offset from UTC across all points in time.
/// * A timezone in the IANA TZ database, including geographical locations with varying offsets across points in time.
///
/// ## Caveats
/// By default, [ZonedDateTime.now] without specifying a timezone only works on Windows, MacOS, Linux and web. The
/// `Factory` timezone will be returned on all other platforms. This is due to limitations with `dart:ffi`. See
/// [Timezone.platformTimezoneProvider].
///
/// If you're feeling adventurous, consider using [stevia](https://github.com/forus-labs/cauldron/tree/master/stevia),
/// an experimental add-on package for retrieving the timezone on other Android and iOS.
///
/// ## Timezones Transitions
///
/// Obtaining the offset for a local date-time is not trivial. Due to timezone transitions, it is possible for a local
/// date-time to be ambiguous or invalid. There are three cases.
///
/// Normal, with one valid offset. This is the case for most of the year.
/// <br>
///
///
/// Gap, with zero offsets. This is when the clock jumps forward, when transitioning from winter to summer time.
/// If a local date-time fails in the middle of a gap, the offset after the gap, i.e. summer time, is returned.
///
/// ![Clock jumping forward](https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Begin_CEST.svg/120px-Begin_CEST.svg.png)
///
/// ```dart
/// // EST to EDT transition occurs at 2023-03-12 02:00
/// // Offset from -05:00 to -04:00
/// //
/// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
///
/// final datetime = ZoneDateTime('America/Detroit', 2023, 3, 12, 2, 30);
/// print(datetime); // 2023-03-12 03:30-04:00 [America/Detroit]
/// ```
/// <br>
///
///
/// Overlap, with two valid offsets. This is when clocks are set back, typically when transitioning from summer to
/// winter time. If a local date-time falls in the middle of an overlap, the offset before the overlap, i.e. winter time,
/// is returned.
///
/// ![Clock moving backwards](https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/End_CEST.svg/120px-End_CEST.svg.png)
///
/// ```dart
/// // EDT to EST transition occurs at 2023-11-05 01:00
/// // Offset from -04:00 to -05:00
/// //
/// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
///
/// final datetime = ZoneDateTime('America/Detroit', 2023, 11, 5, 1, 30);
/// print(datetime); // 2023-11-05 01:30-05:00 [America/Detroit]
/// ```
/// <br>
///
/// ## Working with `ZonedDateTime`s
///
/// To create a `ZonedDateTime`:
/// ```dart
/// final now = ZonedDateTime.now();
/// final berlinWallFall = ZonedDateTime('Europe/Berlin'), 1989, 11, 9, 18, 53);
/// ```
///
///
/// You can add and subtract different types of time intervals, including:s
/// * [Duration] - [add] and [subtract]
/// * [Period] - [+] and [-]
/// * Individual units of time - [plus] and [minus]
///
/// [Duration] stores a fixed quantity of time in microseconds while [Period] and the individual units of time represent
/// the conceptual units of time. For example, a duration of 1 day is always 86,400,000,000 microseconds while a period
/// of 1 day is 1 "day". This leads to differences when adding/subtracting from a [ZonedDateTime] near a DST transition.
///
/// ```dart
/// // DST occurs at 2023-03-12 02:00
/// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
///
/// final datetime = ZoneDateTime('America/Detroit', 2023, 3, 12);
///
/// datetime.add(Duration(days: 1)); // 2023-03-13 01:00
/// datetime + Period(days: 1);      // 2023-03-13 00:00
/// ```
///
///
/// `ZonedDateTime` can be compared with [isBefore], [isSameMomentAs] and [isAfter]. Two `ZonedDateTime` may be in
/// different timezones but still represent the same moment. However, they are only considered equal, using [==], if
/// they represent the same moment in the same timezone.
///
/// ```dart
/// final singapore = ZonedDateTime('Asia/Singapore', 2023, 5, 11, 13, 11);
/// final tokyo = ZonedDateTime('Asia/Tokyo', 2023, 5, 11, 14, 11);
///
/// print(singapore.isSameMomentAs(tokyo); // true;
/// print(singapore == tokyo); // false
/// ```
///
/// You can also [truncate], [round], [ceil] and [floor] `ZonedDateTime`.
///
/// ```dart
/// print(berlinWallFall.truncate(to: DateTime.days); // 1989-11-09 00:00
/// print(berlinWallFall.round(TimeUnit.hours, 12);   // 1989-11-10 00:00
/// print(berlinWallFall.ceil(TimeUnit.hours, 5);     // 1989-11-10 00:00
/// print(berlinWallFall.floor(TimeUnit.hours, 5);    // 1989-11-09 12:00
/// ```
///
/// ## Testing
/// To test code that depend on the current timezone, stub [Timezone.platformTimezoneProvider].
///
/// ```dart
/// void main() {
///   setUp(() => Timezone.platformTimezoneProvider = () => 'Asia/Singapore');
///
///   test('some test', () => expect(
///     ZonedDateTime.from(Timezone.now(), 2023, 6, 13),
///     ZonedDateTime('Asia/Singapore', 2023, 6, 13),
///   ));
///
///   tearDown(() => Timezone.platformTimezoneProvider = defaultPlatformTimezoneProvider);
/// }
/// ```
final class ZonedDateTime extends DateTimeBase {
  /// The timezone.
  final Timezone timezone;

  /// The span in which this date-time occurs.
  final TimezoneSpan span;

  /// The microseconds since Unix epoch.
  final EpochMicroseconds epochMicroseconds;
  String? _string;

  /// Creates a [ZonedDateTime] that represents the [milliseconds] since Unix epoch (January 1st 1970) in the [timezone].
  ///
  /// ```dart
  /// final timezone = Timezone('Asia/Singapore');
  /// final milliseconds = 1682865000000; // 2023-04-30T14:30Z
  ///
  /// final date = ZonedDateTime.fromEpochMilliseconds(timezone, milliseconds));
  ///
  /// print(date); // 2023-04-30T22:30+08:00[Asia/Singapore]
  /// ```
  ZonedDateTime.fromEpochMilliseconds(Timezone timezone, EpochMilliseconds milliseconds)
    : this._(timezone, timezone.span(at: milliseconds * 1000), milliseconds * 1000);

  /// Creates a [ZonedDateTime] that represents the [microseconds] since Unix epoch (January 1st 1970) in the [timezone].
  ///
  /// ```dart
  /// final timezone = Timezone('Asia/Singapore');
  /// final microseconds = 1682865000000000; // 2023-04-30T14:30Z
  ///
  /// final date = ZonedDateTime.fromEpochMicroseconds(timezone, microseconds));
  ///
  /// print(date); // 2023-04-30T22:30+08:00[Asia/Singapore]
  /// ```
  ZonedDateTime.fromEpochMicroseconds(Timezone timezone, EpochMicroseconds microseconds)
    : this._(timezone, timezone.span(at: microseconds), microseconds);

  /// Creates a [ZonedDateTime] that represents the current date-time in the [timezone].
  ///
  /// The platform's current timezone is used if [timezone] is not given.
  ///
  /// **By default, retrieving the platform's timezone is only only supported on Windows, MacOS, Linux & web. The
  /// `Factory` timezone will be returned on all other platforms. See [Timezone.platformTimezoneProvider].**
  ///
  /// If you're feeling adventurous, consider using [stevia](https://github.com/forus-labs/cauldron/tree/master/stevia),
  /// an experimental add-on package for retrieving the timezone on other Android and iOS.
  factory ZonedDateTime.now([Timezone? timezone]) {
    timezone ??= Timezone.now();
    final now = DateTime.now().microsecondsSinceEpoch;
    return ZonedDateTime._(timezone, timezone.span(at: now), now);
  }

  /// Creates a [ZonedDateTime].
  ///
  /// ```dart
  /// final singapore = Timezone('Asia/Singapore');
  /// ZonedDateTime.from(singapore, 2023, 5, 11);
  /// ```
  factory ZonedDateTime.from(
    Timezone timezone,
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) =>
      ZonedDateTime._convert(timezone, DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond));

  /// Creates a [ZonedDateTime].
  factory ZonedDateTime(
    String timezone,
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) => ZonedDateTime._convertFromDateTimeParts(
    Timezone(timezone),
    year,
    month,
    day,
    hour,
    minute,
    second,
    millisecond,
    microsecond,
  );

  factory ZonedDateTime._convert(Timezone timezone, DateTime date) {
    final (microseconds, span) = timezone.convert(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
    return ZonedDateTime._(timezone, span, microseconds);
  }

  factory ZonedDateTime._convertFromDateTimeParts(
    Timezone timezone,
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond,
  ) {
    final (microseconds, span) = timezone.convert(year, month, day, hour, minute, second, millisecond, microsecond);
    return ZonedDateTime._(timezone, span, microseconds);
  }

  ZonedDateTime._(this.timezone, this.span, this.epochMicroseconds)
    : super._(DateTime.fromMicrosecondsSinceEpoch(epochMicroseconds + span.offset.inMicroseconds, isUtc: true));

  /// Returns a copy of this with the [duration] added.
  ///
  /// This function adds an exact number of microseconds unlike [+]. It may produce surprising results when added to a
  /// `ZonedDateTime` near a DST transition.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final foo = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// foo.add(Duration(days: 1)); // 2023-03-13T01:00-04:00[America/Detroit]
  /// foo + Period(days: 1);      // 2023-03-13T00:00-04:00[America/Detroit]
  /// ```
  @useResult
  ZonedDateTime add(Duration duration) =>
      ZonedDateTime.fromEpochMicroseconds(timezone, epochMicroseconds + duration.inMicroseconds);

  /// Returns a copy of this with the [duration] subtracted.
  ///
  /// This function adds an exact number of microseconds unlike [-]. It may produce surprising results when added to a
  /// `ZonedDateTime` near a DST transition.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final foo = ZonedDateTime('America/Detroit', 2023, 3, 13);
  ///
  /// foo.subtract(Duration(days: 1)); // 2023-03-11T23:00-04:00
  /// foo - Period(days: 1);           // 2023-03-12T00:00-04:00
  /// ```
  @useResult
  ZonedDateTime subtract(Duration duration) =>
      ZonedDateTime.fromEpochMicroseconds(timezone, epochMicroseconds - duration.inMicroseconds);

  /// Returns a copy of this with the units of time added.
  ///
  /// This function adds the conceptual units of time like [+].
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final foo = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// foo.plus(days: 1);          // 2023-03-13T00:00-04:00[America/Detroit]
  /// foo.add(Duration(days: 1)); // 2023-03-13T01:00-04:00[America/Detroit]
  /// ```
  @useResult
  ZonedDateTime plus({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) => ZonedDateTime._convert(
    timezone,
    _native.plus(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ),
  );

  /// Returns a copy of this with the units of time subtracted.
  ///
  /// This function adds the conceptual units of time like [-].
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// datetime.minus(days: 1);              // 2023-03-12T00:00-04:00[America/Detroit]
  /// datetime.subtract(Duration(days: 1)); // 2023-03-11T23:00-04:00[America/Detroit]
  /// ```
  @useResult
  ZonedDateTime minus({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) => ZonedDateTime._convert(
    timezone,
    _native.minus(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ),
  );

  /// Returns a copy of this with the [period] added.
  ///
  /// This function adds the conceptual units of time unlike [add].
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final foo = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// foo + Period(days: 1);      // 2023-03-13T00:00-04:00[America/Detroit]
  /// foo.add(Duration(days: 1)); // 2023-03-13T01:00-04:00[America/Detroit]
  /// ```
  @useResult
  ZonedDateTime operator +(Period period) => ZonedDateTime._convert(timezone, _native + period);

  /// Returns a copy of this with the [period] subtracted.
  ///
  /// This function adds the conceptual units of time unlike [subtract].
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final foo = ZonedDateTime('America/Detroit', 2023, 3, 12);
  ///
  /// foo - Period(days: 1);           // 2023-03-12T00:00-04:00[America/Detroit]
  /// foo.subtract(Duration(days: 1)); // 2023-03-11T23:00-04:00[America/Detroit]
  /// ```
  @useResult
  ZonedDateTime operator -(Period period) => ZonedDateTime._convert(timezone, _native - period);

  /// Returns a copy of this truncated to the [TemporalUnit].
  ///
  /// ```dart
  /// final date = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// date.truncate(to: DateUnit.months); // 2023-04-01T00:00+08:00[Asia/Singapore]
  /// ```
  @useResult
  ZonedDateTime truncate({required TemporalUnit to}) => ZonedDateTime._convert(timezone, _native.truncate(to: to));

  /// Returns a copy of this rounded to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// foo.round(DateUnit.months, 6); // 2023-06-01T00:00+08:00[Asia/Singapore]
  ///
  /// final bar = ZonedDateTime('Asia/Singapore', DateTime2023, 8, 15);
  /// bar.round(DateUnit.months, 6); // 2023-06-01T00:00+08:00[Asia/Singapore]
  /// ```
  @Possible({RangeError})
  @useResult
  ZonedDateTime round(TemporalUnit unit, int value) => ZonedDateTime._convert(timezone, _native.round(unit, value));

  /// Returns a copy of this ceiled to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// foo.ceil(DateUnit.months, 6); // 2023-06-01T00:00+08:00[Asia/Singapore]
  ///
  /// final bar = ZonedDateTime('Asia/Singapore', 2023, 8, 15);
  /// bar.ceil(DateUnit.months, 6); // 2023-12-01T00:00+08:00[Asia/Singapore]
  /// ```
  @Possible({RangeError})
  @useResult
  ZonedDateTime ceil(TemporalUnit unit, int value) => ZonedDateTime._convert(timezone, _native.ceil(unit, value));

  /// Returns a copy of this floored to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  ///
  /// ## Example
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// foo.floor(DateUnit.months, 6); // 2023-01-01T00:00+08:00[Asia/Singapore]
  ///
  /// final bar = ZonedDateTime('Asia/Singapore', 2023, 8, 15);
  /// bar.floor(DateUnit.months, 6); // 2023-06-01T00:00+08:00[Asia/Singapore]
  /// ```
  @Possible({RangeError})
  @useResult
  ZonedDateTime floor(TemporalUnit unit, int value) => ZonedDateTime._convert(timezone, _native.floor(unit, value));

  /// Returns a copy of this with the updated units of time.
  ///
  /// ```dart
  /// final foo = ZonedDateTime('Asia/Singapore', 2023, 4, 15);
  /// foo.copyWith(day: 20); // 2023-04-20T00:00+08:00[Asia/Singapore]
  /// ```
  @useResult
  ZonedDateTime copyWith({
    Timezone? timezone,
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) => ZonedDateTime.from(
    timezone ?? this.timezone,
    year ?? this.year,
    month ?? this.month,
    day ?? this.day,
    hour ?? this.hour,
    minute ?? this.minute,
    second ?? this.second,
    millisecond ?? this.millisecond,
    microsecond ?? this.microsecond,
  );

  /// Returns the difference in exact microseconds between this and [other].
  ///
  /// This function is affected by DST if this and [other] are across DST transitions.
  ///
  /// ```dart
  /// // DST occurs at 2023-03-12 02:00
  /// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
  ///
  /// final winter = ZonedDateTime('America/Detroit', 2023, 3, 12);
  /// final summer = ZonedDateTime('America/Detroit', 2023, 3, 13);
  ///
  /// print(summer.difference(winter)); // 23:00:00.000000
  /// print(winter.difference(summer)); // -23:00:00.000000
  /// ```
  @useResult
  Duration difference(ZonedDateTime other) => Duration(microseconds: epochMicroseconds - other.epochMicroseconds);

  // TODO: support retrieving earlier and later offsets during overlaps

  /// Converts this to a [LocalDateTime].
  @useResult
  LocalDateTime toLocal() => LocalDateTime._(_native);

  /// Returns true if this [ZonedDateTime] is before [other].
  ///
  /// ```dart
  /// // 2023-04-20T12:00+08:00[Asia/Singapore]
  /// final singapore = ZonedDateTime('Asia/Singapore', 2023, 4, 20, 12);
  ///
  /// // 2023-04-20T12:00+01:00[Europe/London]
  /// final london = ZonedDateTime('Europe/London', 2023, 4, 20, 12);
  ///
  /// print(singapore.isBefore(london)); // true
  /// ```
  bool isBefore(ZonedDateTime other) => epochMicroseconds < other.epochMicroseconds;

  /// Returns true if this occurs at the same moment as [other].
  ///
  /// ```dart
  /// final singapore = ZonedDateTime('Asia/Singapore', 2023, 5, 11, 13, 11);
  /// final tokyo = ZonedDateTime('Asia/Tokyo', 2023, 5, 11, 14, 11);
  ///
  /// print(singapore.isSameMomentAs(tokyo); // true;
  /// print(singapore == tokyo); // false
  /// ```
  bool isSameMomentAs(ZonedDateTime other) => epochMicroseconds == other.epochMicroseconds;

  /// Returns true if this is after [other].
  ///
  /// ```dart
  /// // 2023-04-20T12:00+08:00[Asia/Singapore]
  /// final singapore = ZonedDateTime('Asia/Singapore', 2023, 4, 20, 12);
  ///
  /// // 2023-04-20T12:00+01:00[Europe/London]
  /// final london = ZonedDateTime('Europe/London', 2023, 4, 20, 12);
  ///
  /// print(london.isAfter(singapore)); // true
  /// ```
  bool isAfter(ZonedDateTime other) => epochMicroseconds > other.epochMicroseconds;

  /// Returns true if other is a [ZonedDateTime] at the same moment and in the same timezone.
  ///
  /// ```dart
  /// final singapore = ZonedDateTime('Asia/Singapore', 2023, 5, 11, 13, 11);
  /// final tokyo = ZonedDateTime('Asia/Tokyo', 2023, 5, 11, 14, 11);
  ///
  /// print(singapore.isSameMomentAs(tokyo); // true;
  /// print(singapore == tokyo); // false
  /// ```
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZonedDateTime &&
          runtimeType == other.runtimeType &&
          timezone == other.timezone &&
          epochMicroseconds == other.epochMicroseconds;

  @override
  int get hashCode => timezone.hashCode ^ epochMicroseconds.hashCode;

  /// Returns a ISO-8601 formatted string.
  ///
  /// ## Format
  /// The format is yyyy-MM-ddTHH:mm:ss.mmmuuuZ\[identifier\] for UTC time, and
  /// yyyy-MM-ddTHH:mm:ss.mmmuuu±hhmm\[identifier\]  for local/non-UTC time, where:
  ///
  /// * yyyy is a, possibly negative, four digit representation of the year,
  ///   if the year is in the range -9999 to 9999, otherwise it is a signed
  ///   six digit representation of the year.
  /// * MM is the month in the range 01 to 12,
  /// * dd is the day of the month in the range 01 to 31,
  /// * HH are hours in the range 00 to 23,
  /// * mm are minutes in the range 00 to 59,
  /// * ss are seconds in the range 00 to 59 (no leap seconds),
  /// * mmm are milliseconds in the range 000 to 999, and
  /// * uuu are microseconds in the range 001 to 999. If microsecond equals 0,
  ///   then this part is omitted.
  /// * identifier is a TZ database identifier.
  ///
  /// Trailing zero-value seconds, milliseconds and microseconds are omitted.
  ///
  /// ## Example
  /// ```dart
  /// // 2023-04-30T12:15+08:00[Asia/Singapore]
  /// print(ZonedDateTime('Asia/Singapore', 2023, 4, 30, 12, 15));
  /// ```
  @override
  String toString() =>
      _string ??= '${_native.toDateString()}T${_native.toTimeString()}${span.offset}[${timezone.name}]';

  /// The day of the week.
  ///
  /// A week starts on Monday (1) and ends on Sunday (7).
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 1969, 7, 20).weekday; // Sunday, 7
  /// ```
  @useResult
  int get weekday => _native.weekday;

  /// The ordinal week of the year.
  ///
  /// A week is between `1` and `53`, inclusive.
  ///
  /// See [weeks per year](https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year).
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2023, 4, 1).weekOfYear; // 13
  /// ```
  @useResult
  int get weekOfYear => _native.weekOfYear;

  /// The ordinal day of the year.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2023, 4, 1).dayOfYear; // 91
  /// ```
  @useResult
  int get dayOfYear => _native.dayOfYear;

  /// The first day of the week.
  ///
  /// ```dart
  /// final tuesday = ZonedDateTime('Asia/Singapore', 2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // 2023-04-10T00:00+08:00[Asia/Singapore]
  /// ```
  @useResult
  ZonedDateTime get firstDayOfWeek => ZonedDateTime._convert(timezone, _native.firstDayOfWeek);

  /// The last day of the week.
  ///
  /// ```dart
  /// final tuesday = ZonedDateTime('Asia/Singapore', 2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // 2023-04-16T00:00+08:00[Asia/Singapore]
  /// ```
  @useResult
  ZonedDateTime get lastDayOfWeek => ZonedDateTime._convert(timezone, _native.lastDayOfWeek);

  /// The first day of the month.
  ///
  /// ```dart
  /// // 2023-04-01T00:00+08:00[Asia/Singapore]
  /// ZonedDateTime('Asia/Singapore', 2023, 4, 11).firstDayOfMonth;
  /// ```
  @useResult
  ZonedDateTime get firstDayOfMonth => ZonedDateTime._convert(timezone, _native.firstDayOfMonth);

  /// The last day of the month.
  ///
  /// ```dart
  /// // 2023-04-30T00:00+08:00[Asia/Singapore]
  /// ZonedDateTime('Asia/Singapore', 2023, 4, 11).lastDayOfMonth;
  /// ```
  @useResult
  ZonedDateTime get lastDayOfMonth => ZonedDateTime._convert(timezone, _native.lastDayOfMonth);

  /// The number of days in the month.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2019, 2).daysInMonth; // 28
  /// ZonedDateTime('Asia/Singapore', 2020, 2).daysInMonth; // 29
  /// ```
  @useResult
  int get daysInMonth => _native.daysInMonth;

  /// Whether this year is a leap year.
  ///
  /// ```dart
  /// ZonedDateTime('Asia/Singapore', 2020).leapYear; // true
  /// ZonedDateTime('Asia/Singapore', 2021).leapYear; // false
  /// ```
  @useResult
  bool get leapYear => _native.leapYear;

  /// The milliseconds since Unix epoch.
  EpochMilliseconds get epochMilliseconds => epochMicroseconds ~/ 1000;
}
