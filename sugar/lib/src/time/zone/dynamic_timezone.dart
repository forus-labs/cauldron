import 'dart:typed_data';

import 'package:meta/meta.dart';

import 'package:sugar/sugar.dart';

/// A [Timezone] with abbreviations and/or offsets that vary throughout points in time.
@sealed class DynamicTimezone extends Timezone {

  /// The span before the first timezone transition.
  final DynamicTimezoneSpan _initial;
  /// The seconds since epoch at which the timezone transition. It should never be empty. Stored as seconds to reduce memory usage.
  final Int64List _transitions;
  /// The offsets in seconds. It should never be empty. The offset may be stored in hours, minutes or seconds depending on
  /// [_unit]. This is done to reduce memory footprint.
  final List<int> _offsets;
  /// The amount used to convert an offset to microseconds, i.e. [Duration.microsecondsPerSecond].
  final int _unit;
  /// The abbreviations. It should never be empty.
  final List<String> _abbreviations; // TODO: replace with int map to reduce memory footprint
  /// Whether the timezone is daylight savings time. It should never be empty.
  final List<bool> _dsts; // TODO: replace with more bitfield to reduce memory footprint
  /// The range of the least recently used offset in seconds.
  late Range<int> _range;
  /// The last used span.
  DynamicTimezoneSpan _timezone;

  /// Creates a [DynamicTimezone].
  ///
  /// ## Contract:
  /// The transitions, offsets, abbreviations and DSTs should be non-empty and have the same length.
  DynamicTimezone(super._name, this._initial, this._transitions, this._offsets, this._unit, this._abbreviations, this._dsts):
    _range = const Interval.empty(0),
    _timezone = _initial,
    super.from();

  @override
  @useResult MapEntry<EpochMicroseconds, DynamicTimezoneSpan> convert({required int local}) {
    // Adapted from https://github.com/JodaOrg/joda-time/blob/main/src/main/java/org/joda/time/DateTimeZone.java#L951
    // Get the offset at local (first estimate).
    final localInstant = local;
    final localSpan = span(at: localInstant);
    final localOffset = localSpan._microseconds;

    // Adjust localInstant using the estimate and recalculate the offset.
    final adjustedInstant = localInstant - localOffset;
    final adjustedSpan = span(at: adjustedInstant);
    final adjustedOffset = adjustedSpan._microseconds;

    var microseconds = localInstant - adjustedOffset;

    // If the offsets differ, we must be near a DST boundary
    if (localOffset != adjustedOffset) {
      // We need to ensure that time is always after the DST gap
      // this happens naturally for positive offsets, but not for negative.
      // If we just use adjustedOffset then the time is pushed back before the
      // transition, whereas it should be on or after the transition
      if (localOffset - adjustedOffset < 0 && adjustedOffset != span(at: microseconds)._microseconds) {
        microseconds = adjustedInstant;
      }
    } else if (localOffset >= 0) {
      final previousSpan = span(at: adjustedSpan.start - 1);
      if (previousSpan.start < adjustedInstant) {
        final previousOffset = previousSpan._microseconds;
        final difference = previousOffset - localOffset;

        if (adjustedInstant - adjustedSpan.start < difference) {
          microseconds = localInstant - previousOffset;
        }
      }
    }

    // We have to fetch the offset again otherwise it'll be incorrect for DST transitions.
    return MapEntry(microseconds, span(at: microseconds));
  }

  @override
  @useResult DynamicTimezoneSpan span({required EpochMicroseconds at}) {
    final atSeconds = at ~/ Duration.microsecondsPerSecond;
    if (_range.contains(atSeconds)) {
      return _timezone;
    }

    if (atSeconds < _transitions.first) { // initial span is computed at compile-time instead of runtime.
      _range = Max.open(at);
      return _timezone = _initial;
    }

    // TODO: improve performance by probing neighbouring transitions first

    // It is impossible for _timezone._index to be < 0, those instances are handled above.
    var max = at < _timezone.start ? _timezone._index : _transitions.length;
    var min = _timezone.end <= at ? _timezone._index : 0;

    while (max - min > 1) {
      final middle = min + (max - min) ~/ 2;
      final transition = _transitions[middle];

      if (atSeconds < transition) {
        max = middle;
      } else {
        min = middle;
      }
    }

    final EpochMicroseconds end;
    if (max == _transitions.length) {
      _range = Min.closed(_transitions[min]);
      end = TimezoneSpan.range.max;

    } else {
      _range = Interval.closedOpen(_transitions[min], _transitions[max]);
      end = _transitions[max] * Duration.microsecondsPerSecond;
    }

    return _timezone = DynamicTimezoneSpan(
      min,
      _offsets[min] * _unit,
      _abbreviations[min],
      _transitions[min] * Duration.microsecondsPerSecond,
      end,
      dst: _dsts[min],
    );
  }

}

/// A [TimezoneSpan] for a TZ database timezone with varying offsets throughout points in time.
@sealed class DynamicTimezoneSpan extends TimezoneSpan {

  final int _index;
  final int _microseconds;
  Offset? _offset;

  /// Creates a [DynamicTimezoneSpan].
  DynamicTimezoneSpan(this._index, this._microseconds, super.abbreviation, super.start, super.end, {required super.dst});

  @override
  Offset get offset => _offset ??= Offset.fromMicroseconds(_microseconds);

}
