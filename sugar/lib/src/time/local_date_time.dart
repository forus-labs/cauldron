part of 'date_time.dart';

/// A date-time without a timezone, i.e. `2023-04-10T09:30`.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// A [LocalDateTime] is immutable and should be treated as a value-type.
class LocalDateTime extends DateTimeBase {

  String? _string;

  /// Creates a [LocalDateTime] with the given milliseconds since Unix epoch (January 1st 1970), treating [LocalDateTime]
  /// as being in UTC.
  ///
  /// ```dart
  /// LocalDateTime.fromEpochMilliseconds(946684800000); // '2000-01-01T00:00'
  /// ```
  LocalDateTime.fromEpochMilliseconds(super.milliseconds) : super.fromEpochMilliseconds();

  /// Creates a [LocalDateTime] with the given milliseconds since Unix epoch (January 1st 1970), treating [LocalDateTime]
  /// as being in UTC.
  ///
  /// ```dart
  /// LocalDateTime.fromEpochMicroseconds(946684800000000); // '2000-01-01T00:00'
  /// ```
  LocalDateTime.fromEpochMicroseconds(super.microseconds) : super.fromEpochMicroseconds();

  /// Creates a [LocalDate] that represents the current date-time.
  LocalDateTime.now() : super.fromNative(DateTime.now());

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


  /// Returns a copy of this [LocalDateTime] with the [duration] added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 1);
  /// date.add(Duration(days: 1, hours: 1)); // '2023-04-02T01:00'
  /// ```
  @useResult LocalDateTime add(Duration duration) => LocalDateTime._(_native.add(duration));

  /// Returns a copy of this [LocalDateTime] with the [duration] subtracted.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 1);
  /// date.minus(Duration(days: 1, hours: 1)); // '2023-03-31T23:00'
  /// ```
  @useResult LocalDateTime subtract(Duration duration) => LocalDateTime._(_native.subtract(duration));

  /// Returns a copy of this [LocalDateTime] with the given time added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date.plus(months: -1, hours: 1); // '2023-04-10T09:00'
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

  /// Returns a copy of this [LocalDateTime] with the given time added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date.minus(months: -1, hours: 1); // '2023-05-10T07:00'
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

  /// Returns a copy of this [LocalDate] with the [Period] added.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date + Period(days: 1); // '2023-04-02T08:00'
  /// ```
  @useResult LocalDateTime operator + (Period period) => LocalDateTime._(_native + period);

  /// Returns a copy of this [LocalDate] with the [Period] subtracted.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 10, 8);
  /// date - Period(days: 1); // '2023-03-31T08:00'
  /// ```
  @useResult LocalDateTime operator - (Period period) => LocalDateTime._(_native - period);


  /// Returns a copy of this [LocalDateTime] truncated to the given temporal unit.
  ///
  /// ```dart
  /// final date = LocalDateTime(2023, 4, 15);
  /// date.truncate(to: DateUnit.months); // '2023-04-01'
  /// ```
  @useResult LocalDateTime truncate({required TemporalUnit to}) => LocalDateTime._(_native.truncate(to: to));

  /// Returns a copy of this [LocalDateTime] with only the given temporal unit rounded to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15).round(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDateTime(2023, 8, 15)).round(6, DateUnit.months); // '2023-06-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime round(int value, TemporalUnit unit) => LocalDateTime._(_native.round(value, unit));

  /// Returns a copy of this [LocalDateTime] with only the given temporal unit ceil to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15).ceil(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDateTime(2023, 8, 15)).ceil(6, DateUnit.months); // '2023-12-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime ceil(int value, TemporalUnit unit) => LocalDateTime._(_native.ceil(value, unit));

  /// Returns a copy of this [LocalDateTime] with only the given temporal unit floored to the nearest [value].
  ///
  /// ## Contract
  /// [value] must be positive, i.e. `1 < to`. Throws A [RangeError] otherwise.
  ///
  ///
  /// ## Example
  /// ```dart
  /// LocalDateTime(2023, 4, 15).floor(6, DateUnit.months); // '2023-01-15'
  ///
  /// LocalDateTime(2023, 8, 15)).floor(6, DateUnit.months); // '2023-06-15'
  /// ```
  @Possible({RangeError})
  @useResult LocalDateTime floor(int value, TemporalUnit unit) => LocalDateTime._(_native.floor(value, unit));


  /// Returns a copy of this [LocalDateTime] with the given updated parts.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 15).copyWith(day: 20); // '2023-04-20'
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

}
