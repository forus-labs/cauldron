import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

/// Represents a timezone in the IANA timezone database with varying offsets.
///
/// ### Implementation details:
/// Timezones with a single offset are handled by [FixedTimezone]. This simplifies offset look-up & improves performance.
class DynamicTimezone implements TimezoneRules {

  /// The timezone's name. It should be a valid IANA timezone name, i.e. `Asia/Singapore`.
  final String name;
  /// The offset in milliseconds before the first timezone transition.
  final int _initial;
  /// The milliseconds since epoch at which the timezone transition. It should never be empty.
  final List<EpochMilliseconds> _transitions;
  /// The milliseconds since epoch at which the associated offset goes into effect. It should never be empty.
  final List<int> _offsets;
  /// The range of the least recently used offset.
  late Range<int> _range;
  /// The least recently used offset.
  int _milliseconds;

  /// Creates a [DynamicTimezone].
  ///
  /// ### Contract:
  /// The transitions and offsets should:
  /// * be non-empty
  /// * have the same length
  DynamicTimezone(this.name, this._initial, this._transitions, this._offsets):
    _range = const Interval.empty(0),
    _milliseconds = 0;

  @override
  Offset offset({required EpochMilliseconds at}) {
    final epochSeconds = at ~/ 1000;
    if (_range.contains(epochSeconds)) {
      return _milliseconds;
    }

    if (epochSeconds < _transitions.first) { // we compute the initial transition at compile-time rather than at runtime
      _range = Max.open(epochSeconds);
      return _milliseconds = _initial;
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

    return _milliseconds = _offsets[min];
  }


  @override
  bool operator ==(Object other) => identical(this, other) || other is DynamicTimezone && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => runtimeType.hashCode ^ name.hashCode;

  @override
  String toString() => name;

}
