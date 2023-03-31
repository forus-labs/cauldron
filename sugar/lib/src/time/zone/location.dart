import 'package:sugar/time.dart';
import 'package:sugar/time_zone.dart';

import 'package:sugar/src/time/zone/location_mapping.g.dart';


/// Represents a geographical location in the IANA timezone database. A location maps instantaneous points on the time-line
/// to the timezones in used at those times.
///
/// A [Location] is immutable and should be treated as a value-type.
class Location {

  static PlatformTimezone platform = platformTimezone;

  /// The location's name. It should be a valid IANA timezone database.
  final String name;
  /// The seconds since epoch at which the offsets transitioned.
  final List<EpochSeconds> _transitions;
  /// The seconds since epoch at which the associated timezone offset goes into effect.
  final List<Timezone> _timezones;

  factory Location.current() => Location.parse(platform());

  factory Location.parse(String name) => mapLocation(name);

  /// Creates a [Location].
  Location(this.name, this._transitions, this._timezones);

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
