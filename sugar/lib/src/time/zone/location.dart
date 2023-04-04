import 'package:sugar/core.dart';
import 'package:sugar/time.dart';
import 'package:sugar/time_zone.dart';

/// Represents a geographical location in the IANA timezone database.
///
/// A [Timezone] is immutable and should be treated as a value-type.
class Location implements Timezone {

  /// The location's name. It should be a valid IANA timezone name, i.e. `Asia/Singapore`.
  final String name;
  /// The seconds since epoch at which the offsets transitioned.
  final List<EpochSeconds> _transitions;
  /// The seconds since epoch at which the associated offset goes into effect.
  final List<Offset> _offsets;
  /// Whether the offsets at the various indexes are daylight saving time.
  final List<bool> _dsts;
  /// The range of the least recently used offset.
  late Range<EpochSeconds> _range;
  /// The least recently used offset.
  Offset _offset;

  /// Creates a [Location].
  Location(this.name, this._transitions, this._offsets, this._dsts):
    _offset = Offset.zero;


  @override
  Offset offset({required EpochMilliseconds at}) {
    final seconds = at ~/ 1000;
    return Offset(); // TODO: timezonel


    // if (_timezones.isEmpty || (_start <= seconds && seconds < _end)) {
    //   return _timezone;
    // }
    //
    // if ()
  }

  int _binarySearch(EpochSeconds seconds) {
    var max = _transitions.length;
    var min = 0;

    while (max - min > 1) {
      final middle = min + (max - min) ~/ 2;
      final transition = _transitions[middle];

      if (seconds < transition) {
        max = middle;
      } else {
        min = middle;
      }
    }

    return min;
  }

  @override
  String toString() => name;

}
