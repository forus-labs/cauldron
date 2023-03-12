import 'package:sugar/time.dart';

/// Represents an offset of a timezone at a historic or future point in time.
class TimezoneOffset {

  /// The abbreviation, i.e. Central European Time will be abbreviated as 'CET'.
  final String abbreviation;
  /// The offset.
  final Offset offset;
  /// Whether this timezone is Daylight Saving Time (DST).
  final bool dst;

  /// Creates a [TimezoneOffset].
  const TimezoneOffset(this.offset, {
    required this.abbreviation,
    required this.dst,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is TimezoneOffset &&
    runtimeType == other.runtimeType &&
    abbreviation == other.abbreviation &&
    offset == other.offset &&
    dst == other.dst;

  @override
  int get hashCode => abbreviation.hashCode ^ offset.hashCode ^ dst.hashCode;

  @override
  String toString() => '[$abbreviation offset = $offset dst = $dst]';

}
