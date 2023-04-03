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
  /// The daylight saving times,
  final List<bool> _dsts;

  /// Creates a [Location].
  Location(this.name, this._transitions, this._offsets, this._dsts);


  @override
  Offset offset({required EpochMilliseconds at}) {
    final seconds = at ~/ 1000;
    return Offset(); // TODO: timezone
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

// // TODO: replace these 3 fields with a record/tuple when Dart 3.0 is released
// Timezone _timezone;
// EpochSeconds _start;
// EpochSeconds _end;
