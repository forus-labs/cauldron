import 'package:meta/meta.dart';

/// A [Period] represents a quantity of time in terms of its individual parts. This is different from [Duration] which
/// sums all provided individual parts and stores them in microseconds.
///
/// Durations and periods differ in their treatment of daylight savings time when added to Dart's [DateTime] or this
/// library's [ZonedDateTime]. A [Duration] will add an exact number of microseconds. This means a duration of 1 day is
/// always 24 hours. On the contrary, a [Period] will add a conceptual unit of time.
///
/// ```dart
/// // DST occurs at 2023-03-12 02:00
/// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
///
/// final datetime = ZoneDateTime('America/Detroit', 2023, 3, 12);
/// datetime.add(Duration(days: 1)); // 2023-03-13 01:00
///
/// datetime + Period(days: 1); // 2023-03-13 00:00
/// ```
///
/// Unless otherwise stated, methods do not perform normalization. A period of "15 months" isn't automatically converted
/// to a period of "1 year and 3 months". Likewise, the aforementioned periods are not equal.
///
/// A [Period] is immutable and should be treated as a value-type. Also, it's individual parts may be negative.
class Period {

  /// The years.
  final int years;
  /// The months.
  final int months;
  /// The days.
  final int days;
  /// The hours.
  final int hours;
  /// The minutes.
  final int minutes;
  /// The seconds.
  final int seconds;
  /// The milliseconds.
  final int milliseconds;
  /// The microseconds.
  final int microseconds;

  /// Creates a [Period]. The individual units of time may be negative. No normalization is performed.
  ///
  /// ```dart
  /// Period(years: 1, minutes: -2); // '1 year, -2 minutes'
  /// ```
  const Period({
    this.years = 0,
    this.months = 0,
    this.days = 0,
    this.hours = 0,
    this.minutes = 0,
    this.seconds = 0,
    this.milliseconds = 0,
    this.microseconds = 0,
  });


  /// Returns a normalized copy of this [Period].
  ///
  /// This normalizes all units of time except for the days. For example, a period of "13 months, 50 days and 24 hours"
  /// will be normalized to "1 year, 1 month and 51 days".
  ///
  /// ```dart
  /// final foo = Period(months: 13, days: 50, hours: 24).normalize();
  /// print(foo); // 1 year, 1 month, 51 days
  /// ```
  @useResult Period normalize() {
    final totalMonths = years * 12 + months;
    final normalizedMonths = totalMonths.remainder(12);
    final normalizedYears = totalMonths ~/ 12;

    var total = inMicroseconds;
    final normalizedMicroseconds = total.remainder(1000);
    final normalizedMilliseconds = (total ~/= 1000).remainder(1000);
    final normalizedSeconds = (total ~/= 1000).remainder(60);
    final normalizedMinutes = (total ~/= 60).remainder(60);
    final normalizedHours = (total ~/= 60).remainder(24);
    final normalizedDays = total ~/ 24;

    return Period(
      years: normalizedYears,
      months: normalizedMonths,
      days: normalizedDays,
      hours: normalizedHours,
      minutes: normalizedMinutes,
      seconds: normalizedSeconds,
      milliseconds: normalizedMilliseconds,
      microseconds: normalizedMicroseconds,
    );
  }


  /// Returns a copy of this [Period] with the individual parts added. No normalization is performed.
  ///
  /// ```dart
  /// Period(years: 1, months: 1).plus(months: 12); // 1 year 13 months
  /// ```
  @useResult Period plus({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) => copyWith(
    years: this.years + years,
    months: this.months + months,
    days: this.days + days,
    hours: this.hours + hours,
    minutes: this.minutes + minutes,
    seconds: this.seconds + seconds,
    milliseconds: this.milliseconds + milliseconds,
    microseconds: this.microseconds + microseconds,
  );

  /// Returns a copy of this [Period] with the individual parts subtracted. No normalization is performed.
  ///
  /// ```dart
  /// Period(years: 1, months: 1).minus(months: 12); // 1 year -11 months
  /// ```
  @useResult Period minus({
    int years = 0,
    int months = 0,
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) => copyWith(
    years: this.years + years,
    months: this.months + months,
    days: this.days + days,
    hours: this.hours + hours,
    minutes: this.minutes + minutes,
    seconds: this.seconds + seconds,
    milliseconds: this.milliseconds + milliseconds,
    microseconds: this.microseconds + microseconds,
  );


  /// Returns the sum of this [Period] and [other]. No normalization is performed.
  ///
  /// ```dart
  /// Period(years: 1, months: 1) + Period(months: 12); // 1 year 13 months
  /// ```
  @useResult Period operator + (Period other) => Period(
    years: years + other.years,
    months: months + other.months,
    days: days + other.days,
    hours: hours + other.hours,
    minutes: minutes + other.minutes,
    seconds: seconds + other.seconds,
    milliseconds: milliseconds + other.milliseconds,
    microseconds: microseconds + other.microseconds,
  );

  /// Returns a copy of this [Period] with [other] subtracted from it. No normalization is performed.
  ///
  /// ```dart
  /// Period(years: 1, months: 1) - Period(months: 12); // 1 year -11 months
  /// ```
  @useResult Period operator - (Period other) => Period(
    years: years - other.years,
    months: months - other.months,
    days: days - other.days,
    hours: hours - other.hours,
    minutes: minutes - other.minutes,
    seconds: seconds - other.seconds,
    milliseconds: milliseconds - other.milliseconds,
    microseconds: microseconds - other.microseconds,
  );


  /// Creates a copy of this [Period] with the given updated parts. No normalization is performed.
  ///
  /// ```dart
  /// Period(years: 1, months: 1).copyWith(months: 13); // 1 year 13 months
  /// ```
  @useResult Period copyWith({
    int? years,
    int? months,
    int? days,
    int? hours,
    int? minutes,
    int? seconds,
    int? milliseconds,
    int? microseconds,
  }) => Period(
    years: years ?? this.years,
    months: years ?? this.months,
    days: days ?? this.days,
    hours: hours ?? this.hours,
    minutes: minutes ?? this.minutes,
    milliseconds: milliseconds ?? this.milliseconds,
    microseconds: microseconds ?? this.milliseconds,
  );


  /// This [Period] in microseconds.
  int get inMicroseconds => days * Duration.microsecondsPerDay
    + hours * Duration.microsecondsPerHour
    + minutes * Duration.microsecondsPerMinute
    + seconds * Duration.microsecondsPerSecond
    + milliseconds * Duration.microsecondsPerMillisecond
    + microseconds;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Period &&
    runtimeType == other.runtimeType &&
    years == other.years &&
    months == other.months &&
    days == other.days &&
    hours == other.hours &&
    minutes == other.minutes &&
    seconds == other.seconds &&
    milliseconds == other.milliseconds &&
    microseconds == other.microseconds;

  @override
  int get hashCode =>
    years.hashCode ^
    months.hashCode ^
    days.hashCode ^
    hours.hashCode ^
    minutes.hashCode ^
    seconds.hashCode ^
    milliseconds.hashCode ^
    microseconds.hashCode;

  @override
  String toString() => 'Period[$years years, $months months, $days days, $hours hours, $minutes minutes, $seconds seconds, $milliseconds milliseconds, $microseconds microseconds]';

}
