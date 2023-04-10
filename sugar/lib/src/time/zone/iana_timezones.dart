import 'package:meta/meta.dart';

import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

/// Represents a timezone in the IANA timezone database with varying offsets.
///
/// ### Implementation details:
/// Timezones with a single offset are handled by [FixedTimezone]. This simplifies offset look-up & improves performance.
@internal class DynamicTimezone implements Timezone {

  /// The location's name. It should be a valid IANA timezone name, i.e. `Asia/Singapore`.
  final String name;
  /// The offset before the first timezone transition.
  final Offset _initial;
  /// The seconds since epoch at which the timezone transition. It should never be empty.
  final List<EpochSeconds> _transitions;
  /// The seconds since epoch at which the associated offset goes into effect. It should never be empty.
  final List<Offset> _offsets;
  /// The range of the least recently used offset.
  late Range<EpochSeconds> _range;
  /// The least recently used offset.
  Offset _offset;

  /// Creates a [DynamicTimezone].
  ///
  /// ### Contract:
  /// The transitions and offsets should:
  /// * be non-empty
  /// * have the same length
  DynamicTimezone(this.name, this._initial, this._transitions, this._offsets):
    _range = const Interval.empty(0),
    _offset = Offset.zero;

  @override
  Offset offset({required EpochMilliseconds at}) {
    final epochSeconds = at ~/ 1000;
    if (_range.contains(epochSeconds)) {
      return _offset;
    }

    if (epochSeconds < _transitions.first) { // we compute the initial transition at compile-time rather than at runtime
      _range = Max.open(epochSeconds);
      return _offset = _initial;
    }

    var max = _transitions.length; // binary search
    var min = 0;
    while (max - min > 1) {
      final middle = min + (max - min) ~/ 2;
      final transition = _transitions[middle];

      if (epochSeconds < transition) {
        max = middle;
      } else {
        min = middle;
      }
    }

    if (max == _transitions.length) {
      _range = Min.closed(_transitions[min]);

    } else {
      _range = Interval.closedOpen(_transitions[min], _transitions[max]);
    }

    return _offset = _offsets[min];
  }


  @override
  bool operator ==(Object other) => identical(this, other) || other is DynamicTimezone && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => runtimeType.hashCode ^ name.hashCode;

  @override
  String toString() => name;

}

/// Represents a timezone in the IANA timezone database with a single, fixed offset.
///
/// ### Implementation details:
/// Timezones with varying offset are handled by [DynamicTimezone]. This simplifies offset look-up & improves performance.
@internal class FixedTimezone implements Timezone {

  final String _name;
  final Offset _offset;

  /// Creates a [FixedTimezone].
  const FixedTimezone(this._name, this._offset);

  @override
  Offset offset({required EpochMilliseconds at}) => _offset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixedTimezone && runtimeType == other.runtimeType && _name == other._name && _offset == other._offset;

  @override
  int get hashCode => _name.hashCode ^ _offset.hashCode;

  @override
  String toString() => _name;

}
