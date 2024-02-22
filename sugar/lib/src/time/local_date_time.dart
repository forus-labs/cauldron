part of 'date_time.dart';

/// A date-time without a timezone, such as `2023-04-10 09:30`.
///
/// A `LocalDateTime` is immutable. It cannot represent a specific point in time without an additional offset or timezone.
/// Time is stored to microsecond precision.
///
/// ## Working with `LocalDateTime`s
///
/// To create a `LocalDateTime`:
/// ```dart
/// final now = LocalDateTime.now();
/// final moonLanding = LocalDateTime(1969, 7, 20, 18, 4);
/// ```
///
/// You can add and subtract different types of time intervals, including:
/// * [Duration] - [add] and [subtract]
/// * [Period] - [+] and [-]
/// * Individual units of time - [plus] and [minus]
///
/// `LocalDateTime` behaves the same for all 3 types of time intervals.
///
/// ```dart
/// final tomorrow = now.add(const Duration(days: 1);
/// final dayAfterTomorrow = now + const Period(days: 2);
/// final threeDaysAfter = now.plus(days: 3);
/// ```
///
/// `LocalDateTime`s can be compared using the comparison operators such as [<].
///
/// ```dart
/// print(now < tomorrow); // true
/// print(dayAfterTomorrow >= now); // true
/// ```
///
/// You can also [truncate], [round], [ceil] and [floor] `LocalDateTime`.
///
/// ```dart
/// print(moonLanding.truncate(to: TimeUnit.hours); // 1969-07-20 18:00
/// print(moonLanding.round(DateUnit.days, 7);      // 1969-07-21 00:00
/// print(moonLanding.ceil(DateUnit.days, 7);       // 1969-07-21 00:00
/// print(moonLanding.floor(DateUnit.days, 7);      // 1969-07-14 00:00
/// ```
///
/// ## Testing
///
/// [LocalDateTime.now] can be stubbed by setting [System.currentDateTime]:
/// ```dart
/// void main() {
///   test('mock LocalDateTime.now()', () {
///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 23, 30);
///     expect(LocalDateTime.now(), LocalDateTime(2023, 7, 9, 23, 30));
///   });
/// }
/// ```
///
/// ## Other resources
/// See [ZonedDateTime] to represent date and times with timezones.
final class LocalDateTime extends DateTimeBase with Orderable<LocalDateTime> {

  String? _string;

  /// Creates a [LocalDateTime] from the [milliseconds] since Unix epoch (January 1st 1970).
  ///
  /// ```dart
  /// LocalDateTime.fromEpochMilliseconds(946684800001); // 2000-01-01 00:00:00.001
  /// ```
  LocalDateTime.fromEpochMilliseconds(super.milliseconds) : super.fromEpochMilliseconds();

  /// Creates a [LocalDateTime] from the [microseconds] since Unix epoch (January 1st 1970).
  ///
  /// ```dart
  /// LocalDateTime.fromEpochMicroseconds(946684800000001); // 2000-01-01 00:00:00.000001
  /// ```
  LocalDateTime.fromEpochMicroseconds(super.microseconds) : super.fromEpochMicroseconds();

  /// Creates a [LocalDateTime] that represents the current date-time.
  ///
  /// ## Precision
  /// The precision of [LocalDateTime.now] can be configured by giving a [TemporalUnit]:
  /// ```dart
  /// // Assuming it's 2023-07-09 10:30
  /// LocalDateTime.now(DateUnit.years); // 2023-01-01 00:00
  /// ```
  ///
  /// ## Testing
  /// [LocalDateTime.now] can be stubbed by setting [System.currentDateTime]:
  /// ```dart
  /// void main() {
  ///   test('mock LocalDateTime.now()', () {
  ///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 23, 30);
  ///     expect(LocalDateTime.now(), LocalDate(2023, 7, 9, 23, 30));
  ///   });
  /// }
  /// ```
  factory LocalDateTime.now([TemporalUnit precision = TimeUnit.microseconds]) {
    final DateTime(:year, :month, :day, :hour, :minute, :second, :millisecond, :microsecond) = System.currentDateTime();
    return switch (precision) {
      TimeUnit.microseconds => LocalDateTime(year, month, day, hour, minute, second, millisecond, microsecond),
      TimeUnit.milliseconds => LocalDateTime(year, month, day, hour, minute, second, millisecond),
      TimeUnit.seconds => LocalDateTime(year, month, day, hour, minute, second),
      TimeUnit.minutes => LocalDateTime(year, month, day, hour, minute),
      TimeUnit.hours => LocalDateTime(year, month, day, hour),
      DateUnit.days => LocalDateTime(year, month, day),
      DateUnit.months => LocalDateTime(year, month),
      DateUnit.years => LocalDateTime(year),
    };
  }

  /// Creates a [LocalDateTime].
  LocalDateTime(super.year, [
    super.month = 1,
    super.day = 1,
    super.hour = 0,
    super.minute = 0,
    super.second = 0,
    super.millisecond = 0,
    super.microsecond = 0,
  ]);

  LocalDateTime._(super._native) : super._();


  /// Returns a copy of this with the [duration] added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 1, 20, 3);
  /// date.add(Duration(days: 1, hours: 2)); // 2023-04-02 22:03
  /// ```
  @useResult LocalDateTime add(Duration duration) => LocalDateTime._(_native.add(duration));

  /// Returns a copy of this with the [duration] subtracted.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 1, 20, 3);
  /// date.minus(Duration(days: 1, hours: 2)); // 2023-03-31 18:03
  /// ```
  @useResult LocalDateTime subtract(Duration duration) => LocalDateTime._(_native.subtract(duration));

  /// Returns a copy of this with the units of time added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date.plus(months: -1, hours: 1); // 2023-04-10 09:00
  /// ```
  @useResult LocalDateTime plus({int years = 0, int months = 0, int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalDateTime._(_native.plus(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this with the units of time subtracted.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date.minus(months: -1, hours: 1); // 2023-05-10 07:00
  /// ```
  @useResult LocalDateTime minus({int years = 0, int months = 0, int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
    LocalDateTime._(_native.minus(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: microseconds,
    ));

  /// Returns a copy of this with the [period] added.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 10, 8) + Period(days: 1); // 2023-04-02 08:00
  /// ```
  @useResult LocalDateTime operator + (Period period) => LocalDateTime._(_native + period);

  /// Returns a copy of this with the [period] subtracted.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 10, 8) - Period(days: 1); // 2023-03-31 08:00
  /// ```
  @useResult LocalDateTime operator - (Period period) => LocalDateTime._(_native - period);


  /// Returns a copy of this truncated to the [TemporalUnit].
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 15, 3, 40);
  /// date.truncate(to: DateUnit.months); // 2023-04-01 00:00
  /// ```
  @useResult LocalDateTime truncate({required TemporalUnit to}) => LocalDateTime._(_native.truncate(to: to));

  /// Returns a copy of this rounded to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15, 12, 30).round(DateUnit.months, 6); // 2023-06-01 00:00
  ///
  /// LocalDateTime(2023, 8, 15, 12, 30).round(DateUnit.months, 6); // 2023-06-01 00:00
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime round(TemporalUnit unit, int value) => LocalDateTime._(_native.round(unit, value));

  /// Returns a copy of this ceiled to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15, 12, 30).ceil(DateUnit.months, 6); // 2023-06-01 00:00
  ///
  /// LocalDateTime(2023, 8, 15, 12, 30).ceil(DateUnit.months, 6); // 2023-12-01 00:00
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime ceil(TemporalUnit unit, int value) => LocalDateTime._(_native.ceil(unit, value));

  /// Returns a copy of this floored to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15, 12, 30).floor(DateUnit.months, 6); // 2023-01-01 00:00
  ///
  /// LocalDateTime(2023, 8, 15, 12, 30).floor(DateUnit.months, 6); // 2023-06-15 00:00
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime floor(TemporalUnit unit, int value) => LocalDateTime._(_native.floor(unit, value));


  /// Returns a copy of this with the updated units of time.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 15, 12, 30).copyWith(day: 20); // 2023-04-20 12:30
  /// ```
  @useResult LocalDateTime copyWith({int? year, int? month, int? day, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) =>
    LocalDateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );


  /// Returns the difference between this and [other].
  ///
  /// ```dart
  /// LocalDateTime(22).difference(LocalDateTime(12)); // 10 hours
  ///
  /// LocalDateTime(13).difference(LocalDateTime(23)); // -10 hours
  /// ```
  @useResult Duration difference(LocalDateTime other) => Duration(microseconds: epochMicroseconds - other.epochMicroseconds);


  /// Converts this to a [ZonedDateTime].
  @useResult ZonedDateTime at(Timezone timezone) => ZonedDateTime._convert(timezone, _native);

  /// Converts this to a [DateTime] in UTC.
  @useResult DateTime toNative() => _native;

  /// The date.
  @useResult LocalDate get date => LocalDate(year, month, day);

  /// The time.
  @useResult LocalTime get time => LocalTime(hour, minute, second, millisecond, microsecond);


  @override
  @useResult int compareTo(LocalDateTime other) => epochMicroseconds.compareTo(other.epochMicroseconds);

  @override
  @useResult int get hashValue => runtimeType.hashCode ^ epochMicroseconds;

  /// Returns a ISO formatted string representation.
  ///
  /// When possible, trailing zero seconds, milliseconds and microseconds are truncated.
  ///
  /// ```dart
  /// final foo = LocalDateTime(2023, 5, 10, 12, 30, 1, 2, 3).toString();
  /// print(foo); // '2023-05-10T12:30:01.002003'
  ///
  /// final bar = LocalDateTime(2023, 5, 10, 12, 30).toString();
  /// print(bar); // '2023-05-10T12:30'
  /// ```
  @override
  @useResult String toString() => _string ??= '${_native.toDateString()}T${_native.toTimeString()}';


  /// The day of the week.
  ///
  /// A week starts on Monday (1) and ends on Sunday (7).
  ///
  /// ```dart
  /// LocalDateTime(1969, 7, 20, 12, 30).weekday; // Sunday, 7
  /// ```
  @useResult int get weekday => _native.weekday;


  /// The ordinal week of the year.
  ///
  /// A week is between `1` and `53`, inclusive.
  ///
  /// See [weeks per year](https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year).
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 1, 12, 30).weekOfYear; // 13
  /// ```
  @useResult int get weekOfYear => _native.weekOfYear;

  /// The ordinal day of the year.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 1, 12, 30).dayOfYear; // 91
  /// ```
  @useResult int get dayOfYear => _native.dayOfYear;


  /// The first day of the week.
  ///
  /// ```dart
  /// final tuesday = LocalDateTime(2023, 4, 11, 12, 30);
  /// final monday = tuesday.firstDayOfWeek; // 2023-04-10 00:00
  /// ```
  @useResult LocalDateTime get firstDayOfWeek => LocalDateTime._(_native.firstDayOfWeek);

  /// The last day of the week.
  ///
  /// ```dart
  /// final tuesday = LocalDateTime(2023, 4, 11, 12, 30);
  /// final sunday = tuesday.lastDayOfWeek; // 2023-04-16 00:00
  /// ```
  @useResult LocalDateTime get lastDayOfWeek => LocalDateTime._(_native.lastDayOfWeek);


  /// The first day of the month.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11, 12, 30).firstDayOfMonth; // 2023-04-01 00:00
  /// ```
  @useResult LocalDateTime get firstDayOfMonth => LocalDateTime._(_native.firstDayOfMonth);

  /// The last day of the month.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11, 12, 30).lastDayOfMonth; // 2023-04-30 00:00
  /// ```
  @useResult LocalDateTime get lastDayOfMonth => LocalDateTime._(_native.lastDayOfMonth);


  /// The number of days in the month.
  ///
  /// ```dart
  /// LocalDateTime(2019, 2).daysInMonth; // 28
  /// LocalDateTime(2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => _native.daysInMonth;

  /// Whether this year is a leap year.
  ///
  /// ```dart
  /// LocalDateTime(2020).leapYear; // true
  /// LocalDateTime(2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => _native.leapYear;


  /// The milliseconds since Unix epoch, assuming this datetime is in UTC.
  @useResult EpochMilliseconds get epochMilliseconds => _native.millisecondsSinceEpoch;

  /// The microseconds since Unix epoch, assuming this datetime is in UTC.
  @useResult EpochMicroseconds get epochMicroseconds => _native.microsecondsSinceEpoch;

}
