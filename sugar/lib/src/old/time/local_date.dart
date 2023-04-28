part of 'date.dart';

/// Represents a local date as seen in a calendar, i.e. `2023-04-11`.
///
/// It cannot be used to represent a specific point in time without an additional offset or timezone.
///
/// A [LocalDate] is immutable and should be treated as a value-type.
class LocalDate extends Date with Orderable<LocalDate> {






  /// Returns a [LocalDateTime] on this date at the given time.
  @useResult LocalDateTime at(LocalTime time) => LocalDateTime(year, month, day, time.hour, time.minute, time.second, time.millisecond, time.microsecond);







}
