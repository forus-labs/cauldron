part of 'date.dart';

/// A date without a timezone, as seen in a calendar, such as `2023-04-11`.
///
/// A `LocalDate` is immutable. It cannot represent a specific point in time without an additional offset or timezone.
///
/// ## Working with `LocalDate`s
///
/// To create a `LocalDate`:
/// ```dart
/// final today = LocalDate.now();
/// final moonLanding = LocalDate(1969, 7, 20);
/// ```
///
/// You can add and subtract different types of time intervals, including:
/// * [Duration] - [add] and [subtract]
/// * [Period] - [+] and [-]
/// * Individual units of time - [plus] and [minus]
///
/// `LocalDate` behaves the same for all 3 types of time intervals.
///
/// ```dart
/// final tomorrow = today.add(const Duration(days: 1);
/// final dayAfterTomorrow = today + const Period(days: 2);
/// final threeDaysAfter = today.plus(days: 3);
/// ```
///
/// `LocalDate`s can be compared using the comparison operators such as [<].
///
/// ```dart
/// print(today < tomorrow); // true
/// print(dayAfterTomorrow >= today); // true
/// ```
///
/// You can also [truncate], [round], [ceil] and [floor] `LocalDate`.
///
/// ```dart
/// print(moonLanding.truncate(to: DateUnit.months); // 1969-07-01
/// print(moonLanding.round(DateUnit.days, 7);       // 1969-07-21
/// print(moonLanding.ceil(DateUnit.days, 7);        // 1969-07-21
/// print(moonLanding.floor(DateUnit.days, 7);       // 1969-07-14
/// ```
///
/// ## Testing
///
/// [LocalDate.now] can be stubbed by setting [System.currentDateTime]:
/// ```dart
/// void main() {
///   test('mock LocalDate.now()', () {
///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 23, 30);
///     expect(LocalDate.now(), LocalDate(2023, 7, 9));
///   });
/// }
/// ```
///
/// ## Other resources
/// See:
/// * [LocalDateTime] to represent date -times without timezones.
/// * [ZonedDateTime] to represent date -times with timezones.
class LocalDate extends Date with Orderable<LocalDate> {

  String? _string;

  // TODO: https://github.com/dart-lang/linter/issues/3563
  // ignore: comment_references
  /// Creates a [LocalDate] with the [days] since Unix epoch (January 1st 1970).
  ///
  /// ```dart
  /// LocalDate.fromEpochDays(10957); // '2000-01-01'
  /// ```
  LocalDate.fromEpochDays(super.days): super.fromEpochDays();

  // TODO: https://github.com/dart-lang/linter/issues/3563
  // ignore: comment_references
  /// Creates a [LocalDate] with the [milliseconds] since Unix epoch (January 1st 1970), floored to the nearest day.
  ///
  /// ```dart
  /// LocalDate.fromEpochMilliseconds(946684800000); // 2000-01-01
  /// ```
  LocalDate.fromEpochMilliseconds(super.milliseconds): super.fromEpochMilliseconds();

  // TODO: https://github.com/dart-lang/linter/issues/3563
  // ignore: comment_references
  /// Creates a [LocalDate] with the [microseconds] since Unix epoch (January 1st 1970), floored to the nearest day.
  ///
  /// ```dart
  /// LocalDate.fromEpochMicroseconds(946684800000000); // 2000-01-01
  /// ```
  LocalDate.fromEpochMicroseconds(super.microseconds): super.fromEpochMicroseconds();

  /// Creates a [LocalDate] that represents the current date.
  ///
  /// ## Precision
  /// The precision of [LocalDate.now] can be configured by giving a [DateUnit]:
  /// ```dart
  /// // Assuming it's 2023-07-09
  /// LocalDate.now(DateUnit.years); // 2023-01-01
  /// ```
  ///
  /// ## Testing
  /// [LocalDate.now] can be stubbed by setting [System.currentDateTime]:
  /// ```dart
  /// void main() {
  ///   test('mock LocalDate.now()', () {
  ///     System.currentDateTime = () => DateTime.utc(2023, 7, 9, 23, 30);
  ///     expect(LocalDate.now(), LocalDate(2023, 7, 9));
  ///   });
  /// }
  /// ```
  factory LocalDate.now([DateUnit precision = DateUnit.days]) {
    final date = System.currentDateTime();
    return switch (precision) {
      DateUnit.days => LocalDate(date.year, date.month, date.day),
      DateUnit.months => LocalDate(date.year, date.month),
      DateUnit.years => LocalDate(date.year),
    };
  }

  /// Creates a [LocalDate].
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11); // 2023-04-11
  ///
  /// LocalDate(2023, 13, 2); // 2024-01-02
  ///
  /// LocalDate(2023, -1, 2); // 2022-12-02
  /// ```
  LocalDate(super.year, [super.month = 1, super.day = 1]): super();

  LocalDate._(super.native): super._();


  /// Returns a copy of this with the [duration] added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).add(Duration(days: 1)); // 2023-04-02
  /// ```
  @useResult LocalDate add(Duration duration) => LocalDate._(_native.plus(days: duration.inDays));

  /// Returns a copy of this with the [duration] subtracted.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).subtract(Duration(days: 1)); // 2023-03-31
  /// ```
  @useResult LocalDate subtract(Duration duration) => LocalDate._(_native.minus(days: duration.inDays));

  /// Returns a copy of this with the units of time added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).plus(months: -1, days: 1); // 2023-03-02
  /// ```
  @useResult LocalDate plus({int years = 0, int months = 0, int days = 0}) => LocalDate._(_native.plus(
    years: years,
    months: months,
    days: days,
  ));

  /// Returns a copy of this with the units of time subtracted.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).minus(months: -1, days: 1); // 2023-05-01
  /// ```
  @useResult LocalDate minus({int years = 0, int months = 0, int days = 0}) => LocalDate._(_native.minus(
    years: years,
    months: months,
    days: days,
  ));

  /// Returns a copy of this with the [period] added.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1) + Period(days: 1); // 2023-04-02
  /// ```
  @useResult LocalDate operator + (Period period) => LocalDate._(_native.plus(
    years: period.years,
    months: period.months,
    days: period.days,
  ));

  /// Returns a copy of this with the [period] subtracted.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1) - Period(days: 1); // 2023-03-31
  /// ```
  @useResult LocalDate operator - (Period period) => LocalDate._(_native.minus(
    years: period.years,
    months: period.months,
    days: period.days,
  ));


  /// Returns a copy of this truncated to the given [DateUnit].
  ///
  /// ```dart
  /// LocalDate(2023, 4, 15).truncate(to: DateUnit.months); // 2023-04-01
  /// ```
  @useResult LocalDate truncate({required DateUnit to}) => LocalDate._(_native.truncate(to: to));

  /// Returns a copy of this rounded to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalDate(2023, 4, 15).round(DateUnit.months, 6); // 2023-06-01
  ///
  /// LocalDate(2023, 8, 15).round(DateUnit.months, 6); // 2023-06-01
  /// ```
  @Possible({RangeError})
  @useResult LocalDate round(DateUnit unit, int value) => LocalDate._(_native.round(unit, value));

  /// Returns a copy of this ceiled to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalDate(2023, 4, 15).ceil(DateUnit.months, 6); // 2023-06-01
  ///
  /// LocalDate(2023, 8, 15).ceil(DateUnit.months, 6); // 2023-12-01
  /// ```
  @Possible({RangeError})
  @useResult LocalDate ceil(DateUnit unit, int value) => LocalDate._(_native.ceil(unit, value));

  /// Returns a copy of this floored to the nearest [unit] and [value].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `value <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// LocalDate(2023, 4, 15).floor(DateUnit.months, 6); // 2023-01-01
  ///
  /// LocalDate(2023, 8, 15).floor(DateUnit.months, 6); // 2023-06-01
  /// ```
  @Possible({RangeError})
  @useResult LocalDate floor(DateUnit unit, int value) => LocalDate._(_native.floor(unit, value));


  /// Returns a copy of this with the updated units of time.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 15).copyWith(day: 20); // 2023-04-20
  /// ```
  @useResult LocalDate copyWith({int? year, int? month, int? day}) => LocalDate(
    year ?? this.year,
    month ?? this.month,
    day ?? this.day,
  );


  /// Returns the difference between this and [other].
  ///
  /// ```dart
  /// final foo = LocalDate(2023, 4, 12);
  /// final bar = LocalDate(2023, 4, 1);
  ///
  /// foo.difference(bar); // 11 days
  ///
  /// bar.difference(foo); // -11 days
  /// ```
  @useResult Duration difference(LocalDate other) => Duration(microseconds: epochMicroseconds - other.epochMicroseconds);


  /// Returns a [LocalDateTime] on this date at the given time.
  @useResult LocalDateTime at(LocalTime time) => LocalDateTime(year, month, day, time.hour, time.minute, time.second, time.millisecond, time.microsecond);

  /// Converts this to a [DateTime] in UTC.
  @useResult DateTime toNative() => _native;


  @override
  @useResult int compareTo(LocalDate other) => epochMicroseconds.compareTo(other.epochMicroseconds);

  @override
  @useResult int get hashValue => runtimeType.hashCode ^ epochMicroseconds;

  /// Returns a ISO formatted string representation.
  ///
  /// ```dart
  /// LocalDate(2023, 5, 10).toString(); // '2023-05-10'
  /// ```
  @override
  @useResult String toString() => _string ??= _native.toDateString();


  /// The day of the week.
  ///
  /// A week starts on Monday (1) and ends on Sunday (7).
  ///
  /// ```dart
  /// LocalDate(1969, 7, 20).weekday; // Sunday, 7
  /// ```
  @useResult int get weekday => _native.weekday;

  /// The next day.
  @useResult LocalDate get tomorrow => plus(days: 1);

  /// The previous day.
  @useResult LocalDate get yesterday => minus(days: 1);


  /// The ordinal week of the year.
  ///
  /// A week is between `1` and `53`, inclusive.
  ///
  /// See [weeks per year](https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year).
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).weekOfYear; // 13
  /// ```
  @useResult int get weekOfYear => _native.weekOfYear;

  /// The ordinal day of the year.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 1).dayOfYear; // 91
  /// ```
  @useResult int get dayOfYear => _native.dayOfYear;


  /// The first day of the week.
  ///
  /// ```dart
  /// final tuesday = LocalDate(2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // 2023-04-10
  /// ```
  @useResult LocalDate get firstDayOfWeek => LocalDate._(_native.firstDayOfWeek);

  /// The last day of the week.
  ///
  /// ```dart
  /// final tuesday = LocalDate(2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // 2023-04-16
  /// ```
  @useResult LocalDate get lastDayOfWeek => LocalDate._(_native.lastDayOfWeek);


  /// The first day of the month.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).firstDayOfMonth; // 2023-04-01
  /// ```
  @useResult LocalDate get firstDayOfMonth => LocalDate._(_native.firstDayOfMonth);

  /// The last day of the month.
  ///
  /// ```dart
  /// LocalDate(2023, 4, 11).lastDayOfMonth; // 2023-04-30
  /// ```
  @useResult LocalDate get lastDayOfMonth => LocalDate._(_native.lastDayOfMonth);


  /// The number of days in the month.
  ///
  /// ```dart
  /// LocalDate(2019, 2).daysInMonth; // 28
  /// LocalDate(2020, 2).daysInMonth; // 29
  /// ```
  @useResult int get daysInMonth => _native.daysInMonth;

  /// Whether this year is a leap year.
  ///
  /// ```dart
  /// LocalDate(2020).leapYear; // true
  /// LocalDate(2021).leapYear; // false
  /// ```
  @useResult bool get leapYear => _native.leapYear;


  /// The days since Unix epoch, assuming this date is in UTC.
  @useResult int get epochDays => _native.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;

  /// The milliseconds since Unix epoch, assuming this date is in UTC.
  @useResult int get epochMilliseconds => _native.millisecondsSinceEpoch;

  /// The microseconds since Unix epoch, assuming this date is in UTC.
  @useResult int get epochMicroseconds => _native.microsecondsSinceEpoch;

}
