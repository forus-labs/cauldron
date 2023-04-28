part of '../../time/time.dart';

class LocalTime extends Time with Orderable<LocalTime> {

  /// Combines this time with an offset to create an [OffsetTime].
  ///
  /// ```dart
  /// LocalTime(12).at(Offset(8)); // '12:00+08:00'
  /// ```
  @useResult OffsetTime at(Offset offset) => OffsetTime._(offset, _native);

}
