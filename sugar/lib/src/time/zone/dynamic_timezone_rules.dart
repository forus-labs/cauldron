import 'dart:math' as math;
import 'dart:typed_data';

import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

/// The rules for a timezone with varying offsets throughout points in time.
///
/// ### Implementation details:
/// Timezones with a single offset are handled by [FixedTimezoneRules]. This simplifies offset look-up & improves performance.
class DynamicTimezoneRules implements TimezoneRules {

  /// The timezone's name. It should be a valid IANA timezone name, i.e. `Asia/Singapore`.
  final String _name;
  /// The timezone before the first timezone transition.
  final DynamicTimezone _initial;
  /// The milliseconds since epoch at which the timezone transition. It should never be empty.
  final Int64List _transitions;
  /// The offsets. It should never be empty.
  final Int32List _offsets;
  /// The abbreviations. It should never be empty.
  final List<String> _abbreviations;
  /// Whether the timezone is Daylight saving time. It should never be empty.
  final List<bool> _dsts; // TODO: replace with more space efficient implementation
  /// The range of the least recently used offset.
  late Range<int> _range;
  /// The least recently used offset.
  DynamicTimezone _timezone;

  /// Creates a [DynamicTimezoneRules].
  ///
  /// ### Contract:
  /// The transitions, offsets, abbreviations and DSTs should:
  /// * be non-empty
  /// * have the same length
  DynamicTimezoneRules(this._name, this._initial, this._transitions, this._offsets, this._abbreviations, this._dsts):
    _range = const Interval.empty(0),
    _timezone = _initial;

  @override
  Timezone from({required int local}) {
    // Adapted from https://github.com/JodaOrg/joda-time/blob/main/src/main/java/org/joda/time/DateTimeZone.java#L951
    // Get the local offset (first estimate)
    final localInstant = local;
    final localTimezone = at(local);
    final localOffset = localTimezone.toOffsetMilliseconds();

    // Adjust localInstant using the estimate and recalculate the offset.
    final adjustedInstant = localInstant - localOffset;
    final adjustedTimezone = at(adjustedInstant);
    final adjustedOffset = adjustedTimezone.toOffsetMilliseconds();
    print(adjustedOffset);

    // If the offsets differ, we must be near a DST boundary
    if (localOffset != adjustedOffset) {
      // We need to ensure that time is always after the DST gap
      // this happens naturally for positive offsets, but not for negative.
      // If we just use adjustedOffset then the time is pushed back before the
      // transition, whereas it should be on or after the transition
      if (localOffset - adjustedOffset < 0 && adjustedOffset != at(localInstant - adjustedOffset).toOffsetMilliseconds()) {
        return localTimezone;
      }

    } else if (localOffset >= 0) {
      final previous = adjustedTimezone.start == null ? adjustedTimezone : at(adjustedTimezone.start! - 1);
      if ((previous.start ?? -8640000000000000) < adjustedInstant) {
        final previousOffset = previous.toOffsetMilliseconds();
        final difference = previousOffset - localOffset;

        if (adjustedInstant - (adjustedTimezone.start ?? -8640000000000000) <= difference) {
          print('here');
          return previous;
        }
      }
    }

    print(adjustedOffset);
    return adjustedTimezone;
  }

  @override
  Timezone at(EpochMilliseconds milliseconds) {
    if (_range.contains(milliseconds)) {
      return _timezone;
    }

    if (milliseconds < _transitions.first) { // we compute the initial transition at compile-time rather than at runtime
      _range = Max.open(milliseconds);
      return _timezone = _initial;
    }

    final start = _timezone.start;
    final end = _timezone.end;

    var max = (start != null && milliseconds < start) ? _timezone._index : _transitions.length;
    var min = (end != null && end <= milliseconds) ? math.max(_timezone._index, 0) : 0;

    while (max - min > 1) {
      final middle = min + (max - min) ~/ 2;
      final transition = _transitions[middle];

      if (milliseconds < transition) {
        max = middle;
      } else {
        min = middle;
      }
    }

    if (max == _transitions.length) {
      // TODO: range enhancement such that x < range
      _range = Min.closed(_transitions[min]);
      return _timezone = DynamicTimezone(min, _offsets[min], _name, _abbreviations[min], _transitions[min], null, dst: _dsts[min]);

    } else {
      // TODO: range enhancement such that x < range or range < x
      _range = Interval.closedOpen(_transitions[min], _transitions[max]);
      return _timezone = DynamicTimezone(min, _offsets[min], _name, _abbreviations[min], _transitions[min], _transitions[max], dst: _dsts[min]);
    }
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DynamicTimezoneRules && runtimeType == other.runtimeType && _name == other._name;

  @override
  int get hashCode => runtimeType.hashCode ^ _name.hashCode;

  @override
  String toString() => _name;

}

/// Represents a timezone in the IANA timezone database with varying offsets throughout points in time.
class DynamicTimezone extends Timezone {

  final int _index;
  final int _milliseconds;
  Offset? _offset;

  /// Creates a [DynamicTimezone].
  DynamicTimezone(this._index, this._milliseconds, super.name, super.abbreviation, super.start, super.end, {required super.dst});

  @override
  Offset get offset => _offset ??= Offset.fromSeconds(_milliseconds ~/ 1000);

  @override
  int toOffsetMilliseconds() => _milliseconds;

}
