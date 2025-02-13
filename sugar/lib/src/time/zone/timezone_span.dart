import 'package:sugar/sugar.dart';

/// A [TimezoneSpan] contains information about a timezone between two points in time.
///
/// In most cases, [TimezoneSpan]s represent the "summer" and "winter" times of a timezone with Daylight Saving Time.
class TimezoneSpan {
  /// The valid range of the start and end microseconds, inclusive.
  static final Interval<EpochMicroseconds> range = Interval.closed(-8640000000000000000, 8640000000000000000);

  /// The abbreviation, i.e. `EST`.
  final String? abbreviation;

  /// This span's starting time in microseconds since Unix epoch.
  final EpochMicroseconds start;

  /// This span's ending time in microseconds since Unix epoch.
  final EpochMicroseconds end;

  /// Whether this span is currently daylight savings time.
  final bool dst;

  /// The offset of this span.
  final Offset offset;

  /// Creates a [TimezoneSpan].
  const TimezoneSpan({
    required this.offset,
    required this.abbreviation,
    required this.start,
    required this.end,
    required this.dst,
  });

  /// Whether this span is the final
  /// span in the timezone database.
  bool get isFinalSpan => start == range.min.value;

  /// Whether this span is the first
  /// span in the timezone database.
  bool get isInitialSpan => end == range.max.value;
}
