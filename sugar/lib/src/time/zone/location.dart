import 'package:sugar/time.dart';
import 'package:sugar/time_zone.dart';

import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/zone/location_mappings.g.dart';

/// Represents a geographical location in the IANA timezone database. A location maps instantaneous points on the time-line
/// to the timezones in used at those times.
///
/// A [Location] is immutable and should be treated as a value-type.
class Location {

  static PlatformTimezone platform = platformTimezone;
  static Location? _location;

  /// The location's name. It should be a valid IANA timezone database.
  final String name;
  /// The seconds since epoch at which the offsets transitioned.
  final List<EpochSeconds> _transitions;
  /// The seconds since epoch at which the associated timezone offset goes into effect.
  final List<Timezone> _timezones;
  // TODO: replace these 3 fields with a record/tuple when Dart 3.0 is released
  Timezone _timezone;
  EpochSeconds _start;
  EpochSeconds _end;

  /// Creates a [Location] using the platform's current timezone. Otherwise returns a `Factory` [Location] if the platform
  /// is unsupported or the timezone could not be retrieved.
  ///
  /// ```dart
  /// final singapore = Location.current(); // Returns `Asia/Singapore` assuming the current geographical location is Singapore.
  /// ```
  ///
  /// ### Note:
  /// Only Windows, MacOS & Linux are supported. `Factory` will always be returned on other platforms.
  factory Location.current() {
    final name = platform();
    if (_location?.name != name) {
      _location = Location.parse(name);
    }

    return _location!;
  }

  /// Creates a [Location] with the given [name] if it exists. Otherwise returns a `Factory` [Location].
  ///
  /// ```dart
  /// final singapore = Location.parse('Asia/Singapore'); // Returns `Asia/Singapore`
  ///
  /// final factory = Location.parse('invalid/location'); // Returns `Factory`
  /// ```
  factory Location.parse(String name) => parseLocation(name);

  /// Creates a [Location].
  Location(this.name, this._transitions, this._timezones): _timezone = Timezone.utc, _start = 0, _end = 0;

  //
  // Timezone timezone({required EpochMilliseconds at}) {
  //   final seconds = at ~/ 1000;
  //   if (_timezones.isEmpty || (_start <= seconds && seconds < _end)) {
  //     return _timezone;
  //   }
  //
  //   if ()
  //
  //
  // }
  //
  // int _binarySearch(EpochSeconds seconds) {
  //   var max = _transitions.length;
  //   var min = 0;
  //
  //   while (max - min > 1) {
  //     final middle = min + (max - min) ~/ 2;
  //     final transition = _transitions[middle];
  //
  //     if (seconds < transition) {
  //       max = middle;
  //     } else {
  //       min = middle;
  //     }
  //   }
  //
  //   return min;
  // }

}


/// Represents a timezone at an instantaneous point on the time-line.
///
/// Different parts of the world have different timezones. The rules for how a timezone's offset vary by place and time
/// of the year are captured in the [Location] class.
///
/// For example, Paris has an offset of `+01:00` in winter and `+02:00` in summer due to Daylight Saving Time. The [Location]
/// for Paris will reference two [Timezone]s, `+01:00` for winter, and `+02:00` for summer.
///
/// A [Timezone] is immutable and should be treated as a value-type.
class Timezone {

  static const Timezone utc = Timezone(RawOffset('Z', 0), abbreviation: 'UTC', dst: false);

  /// The abbreviation, i.e. Central European Time will be abbreviated as 'CET', and Central European Summer Time will
  /// be abbreviated as `CEST`.
  final String abbreviation;
  /// The offset.
  final Offset offset;
  /// Whether this timezone is Daylight Saving Time (DST).
  final bool dst;

  /// Creates a [Timezone].
  const Timezone(
    this.offset, {
    required this.abbreviation,
    required this.dst,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || other is Timezone &&
    runtimeType == other.runtimeType &&
    abbreviation == other.abbreviation &&
    offset == other.offset &&
    dst == other.dst;

  @override
  int get hashCode => abbreviation.hashCode ^ offset.hashCode ^ dst.hashCode;

  @override
  String toString() => '[$abbreviation offset = $offset dst = $dst]';

}
