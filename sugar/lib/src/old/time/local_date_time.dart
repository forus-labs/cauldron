part of '../old/time/date_time.dart';

/// Represents a date-time without a timezone, i.e. `2023-04-10T09:30`.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// A [LocalDateTime] is immutable and should be treated as a value-type.
class LocalDateTime extends DateTimeBase with Orderable<LocalDateTime> {

  String? _string;

  /// Creates a [LocalDateTime] with the given milliseconds since Unix epoch (January 1st 1970), floored to the nearest day.
  /// Treats the [LocalDateTime] as being in `UTC+0`.
  ///
  /// ```dart
  /// LocalDateTime.fromEpochMillisecondsAsUtc(946684800000); // '2000-01-01T00:00'
  /// ```
  LocalDateTime.fromEpochMillisecondsAsUtc(super.milliseconds) : super.fromEpochMillisecondsAsUtc0();

  /// Creates a [LocalDateTime] with the given milliseconds since Unix epoch (January 1st 1970), floored to the nearest day.
  /// Treats the [LocalDateTime] as being in `UTC+0`.
  ///
  /// ```dart
  /// LocalDateTime.fromEpochMicrosecondsAsUtc(946684800000000); // '2000-01-01T00:00'
  /// ```
  LocalDateTime.fromEpochMicrosecondsAsUtc(super.microseconds) : super.fromEpochMicrosecondsAsUtc0();

  /// Creates a [LocalDate] that represents the current date-time.
  LocalDateTime.now() : super.fromNativeDateTime(DateTime.now());

  /// Creates a [LocalDateTime].
  LocalDateTime(super.year,
      [super.month = 1, super.day = 1, super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]);

  LocalDateTime._copy(super._native) : super._();


  /// Returns a copy of this [LocalDateTime] with the given time added.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 10, 8).plus(months: -1, hours: 1); // '2023-04-10T09:00'
  /// ```
  ///
  /// See [add].
  @useResult LocalDateTime plus({int years = 0, int months = 0, int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
      LocalDateTime._copy(DateTimeBase.add(
          _native,
          years,
          months,
          days,
          hours,
          minutes,
          seconds,
          milliseconds,
          microseconds));

  /// Returns a copy of this [LocalDateTime] with the given time added.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 10, 8).minus(months: -1, hours: 1); // '2023-05-10T07:00'
  /// ```
  ///
  /// See [subtract].
  @useResult LocalDateTime minus({int years = 0, int months = 0, int days = 0, int hours = 0, int minutes = 0, int seconds = 0, int milliseconds = 0, int microseconds = 0}) =>
      LocalDateTime._copy(DateTimeBase.subtract(
          _native,
          years,
          months,
          days,
          hours,
          minutes,
          seconds,
          milliseconds,
          microseconds));


  /// Returns a copy of this [LocalDateTime] with the given [duration] added.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 1).add(Duration(days: 1, hours: 1)); // '2023-04-02T01:00'
  /// ```
  ///
  /// See [plus].
  @useResult LocalDateTime add(Duration duration) => LocalDateTime._copy(_native.add(duration));

  /// Returns a copy of this [LocalDateTime] with the given [duration] subtracted.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 1).minus(Duration(days: 1, hours: 1)); // '2023-03-31T23:00'
  /// ```
  ///
  /// See [minus].
  @useResult LocalDateTime subtract(Duration duration) => LocalDateTime._copy(_native.subtract(duration));


  /// Returns a copy of this [LocalDate] truncated to the given time unit.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 15).truncate(to: DateUnit.months); // '2023-04-01'
  /// ```
  @useResult LocalDateTime truncate({required TemporalUnit to}) =>
      LocalDateTime._copy(DateTimeBase.truncate(_native, to));

  /// Returns a copy of this [LocalDateTime] with only the given date unit rounded to the nearest [value].
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 15).round(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDateTime(2023, 8, 15)).round(6, DateUnit.months); // '2023-06-15'
  /// ```
  ///
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult
  LocalDateTime round(int value, TemporalUnit unit) => LocalDateTime._copy(DateTimeBase.round(_native, value, unit));

  /// Returns a copy of this [LocalDateTime] with only the given date unit ceil to the nearest [value].
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 15).ceil(6, DateUnit.months); // '2023-06-15'
  ///
  /// LocalDateTime(2023, 8, 15)).ceil(6, DateUnit.months); // '2023-12-15'
  /// ```
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult
  LocalDateTime ceil(int value, TemporalUnit unit) => LocalDateTime._copy(DateTimeBase.ceil(_native, value, unit));

  /// Returns a copy of this [LocalDateTime] with only the given date unit floored to the nearest [value].
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 15).floor(6, DateUnit.months); // '2023-01-15'
  ///
  /// LocalDateTime(2023, 8, 15)).floor(6, DateUnit.months); // '2023-06-15'
  /// ```
  /// ## Contract:
  /// [value] must be positive, i.e. `1 < to`. A [RangeError] is otherwise thrown.
  @Possible({RangeError})
  @useResult
  LocalDateTime floor(int value, TemporalUnit unit) => LocalDateTime._copy(DateTimeBase.floor(_native, value, unit));


  /// Returns a copy of this [LocalDateTime] with the given updated parts.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 15).copyWith(day: 20); // '2023-04-20'
  /// ```
  @useResult LocalDateTime copyWith(
      {int? year, int? month, int? day, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) =>
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


  /// Returns the difference between this [LocalDateTime] and other.
  ///
  /// ```dart
  /// LocalDateTime(22).difference(LocalDateTime(12)); // 10 hours
  ///
  /// LocalDateTime(13).difference(LocalDateTime(23)); // -10 hours
  /// ```
  @useResult Duration difference(LocalDateTime other) =>
      Duration(microseconds: toEpochMicrosecondsAsUtc() - other.toEpochMicrosecondsAsUtc());


  /// Returns this [LocalDateTime] as milliseconds since Unix epoch (January 1st 1970). Treats [LocalDateTime] as being in `UTC+0`.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11).toEpochMillisecondsAsUtc(); // 1681171200000
  /// ```
  @useResult EpochMilliseconds toEpochMillisecondsAsUtc() => _native.millisecondsSinceEpoch;

  /// Returns this [LocalDateTime] as milliseconds since Unix epoch (January 1st 1970). Treats [LocalDateTime] as being in `UTC+0`.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11).toEpochMicrosecondsAsUtc(); // 1681171200000000
  /// ```
  @useResult EpochMicroseconds toEpochMicrosecondsAsUtc() => _native.microsecondsSinceEpoch;


  /// The date.
  @useResult LocalDate get date => LocalDate(year, month, day);

  /// The time.
  @useResult LocalTime get time => LocalTime(hour, minute, second, millisecond, microsecond);

  /// The first day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDateTime(2023, 4, 11);
  /// final monday = tuesday.firstDayOfWeek; // '2023-04-10'
  /// ```
  @useResult LocalDateTime get firstDayOfWeek => LocalDateTime._copy(_native.firstDayOfWeek);

  /// The last day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDateTime(2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // '2023-04-16'
  /// ```
  @useResult LocalDateTime get lastDayOfWeek => LocalDateTime._copy(_native.lastDayOfWeek);


  /// The first day of this month.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11).firstDayOfMonth; // '2023-04-01'
  /// ```
  @useResult LocalDateTime get firstDayOfMonth => LocalDateTime._copy(_native.firstDayOfMonth);

  /// The last day of this month.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11).lastDayOfMonth; // '2023-04-30'
  /// ```
  @useResult LocalDateTime get lastDayOfMonth => LocalDateTime._copy(_native.lastDayOfMonth);


  @override
  int compareTo(LocalDateTime other) => toEpochMicrosecondsAsUtc().compareTo(other.toEpochMicrosecondsAsUtc());

  @override
  int get hashValue => runtimeType.hashCode ^ toEpochMicrosecondsAsUtc();

  @override
  String toString() {
    if (_string != null) {
      return _string!;
    }

    final string = _native.toIso8601String();
    return _string = string.endsWith('Z') ? string.substring(0, string.length - 1) : string;
  }

}
