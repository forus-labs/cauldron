import 'package:sugar/sugar.dart';

/// The [TimezoneSpan] used by the embedded timezone database.
class EmbeddedTimezoneSpan extends TimezoneSpan {
  @override
  final EpochMicroseconds start;
  @override
  final EpochMicroseconds end;

  /// Creates a new instance of [EmbeddedTimezoneSpan].
  EmbeddedTimezoneSpan({
    required super.offset,
    required super.abbreviation,
    required super.dst,
    required this.start,
    required this.end,
  });

  /// Whether this span is the final
  /// span in the timezone database.
  bool get isFinalSpan => end == TimezoneSpan.range.max.value;

  /// Whether this span is the first
  /// span in the timezone database.
  bool get isInitialSpan => start == TimezoneSpan.range.min.value;
}
