part of '../old/time/date_time.dart';


class LocalDateTime extends DateTimeBase with Orderable<LocalDateTime> {

  String? _string;


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
  @useResult LocalDateTime get firstDayOfWeek => LocalDateTime._(_native.firstDayOfWeek);

  /// The last day of this week.
  ///
  /// ```dart
  /// final tuesday = LocalDateTime(2023, 4, 11);
  /// final sunday = tuesday.lastDayOfWeek; // '2023-04-16'
  /// ```
  @useResult LocalDateTime get lastDayOfWeek => LocalDateTime._(_native.lastDayOfWeek);


  /// The first day of this month.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11).firstDayOfMonth; // '2023-04-01'
  /// ```
  @useResult LocalDateTime get firstDayOfMonth => LocalDateTime._(_native.firstDayOfMonth);

  /// The last day of this month.
  ///
  /// ```dart
  /// LocalDateTime(2023, 4, 11).lastDayOfMonth; // '2023-04-30'
  /// ```
  @useResult LocalDateTime get lastDayOfMonth => LocalDateTime._(_native.lastDayOfMonth);


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
