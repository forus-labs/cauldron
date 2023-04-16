import 'package:meta/meta.dart';

import 'package:sugar/src/time/zone/info/root.g.dart';
import 'package:sugar/src/time/zone/timezone_registry.dart';
import 'package:sugar/time.dart';

/// A timezone is used to map instantaneous points on the timeline to the local date-times in different geographical regions.
///
/// There are two types of [Timezone]s:
/// * A fixed offset from UTC that uses the same offset for all points on the timeline.
/// * A timezone in the IANA TZ database. This includes geographical locations which offset may vary across points on the timeline.
@sealed abstract class Timezone {

  /// A callback used to retrieve the platform's timezone. It may be replaced to modify timezone retrieval.
  /// This is particularly useful in tests.
  ///
  /// A TZ database timezone is always returned. It may be a canonical or link timezone. Defaults to `Factory` if the
  /// timezone could not be retrieved.
  ///
  /// See [defaultPlatformTimezone] for information on the default provider.
  static String Function() platformTimezone = defaultPlatformTimezone;

  /// A registry that contains supported timezones. It may be replaced to modify the supported timezones. This is particularly
  /// useful in tests.
  ///
  /// The default implementation supports all timezones in the 2023c IANA timezone database.
  static TimezoneRegistry registry = DefaultTimezoneRegistry();

  /// The IANA TZ database `Factory` timezone that has no offset. It is returned when parsing and retrieval fails.
  ///
  /// ```dart
  /// final factory = Timezone.parse('invalid/location'); // Timezone.factory
  /// ```
  static Timezone get factory => Root.factory;

  /// The cached current timezone.
  static Timezone _timezone = factory;

  /// Creates a [Timezone] with the platform's current timezone, or [factory] if the timezone could not be retrieved.
  ///
  /// ```dart
  /// final singapore = Timezone.current(); // `Asia/Singapore`, assuming the current timezone is Singapore.
  /// ```
  ///
  /// ## Note:
  /// Only Windows, MacOS, Linux & Web platforms are supported.
  factory Timezone.current() {
    final timezone = platformTimezone();
    if (_timezone.toString() != timezone) {
      _timezone = Timezone.parse(timezone);
    }

    return _timezone;
  }

  /// Creates a [Timezone] with the given TZ database timezone if it exists. Otherwise returns [factory].
  ///
  /// ```dart
  /// final singapore = Timezone.parse('Asia/Singapore'); // `Asia/Singapore`
  ///
  /// final factory = Timezone.parse('invalid/location'); // Timezone.factory
  /// ```
  factory Timezone.parse(String timezone) => registry[timezone];


  /// Converts the milliseconds instant, relative to this timezone, to milliseconds since Unix epoch.
  MapEntry<EpochMilliseconds, EffectiveTimezone> convert(EpochMilliseconds local); // TODO: replace with tuple

  /// Returns the effective timezone at the given milliseconds since Unix epoch
  EffectiveTimezone at(EpochMilliseconds milliseconds);

  /// Returns a string representation of this timezone, i.e. `Asia/Singapore`.
  @override
  @mustBeOverridden
  String toString();

}

/// A timezone's that effective at a given date-time.
class EffectiveTimezone {

  /// The start of this timezone, or null if this timezone does not have a starting date-time.
  final EpochMilliseconds? start;
  /// The end of this timezone, or null if this timezone does not have a ending date-time.
  final EpochMilliseconds? end;
  /// The offset in milliseconds.
  final int offset;
  /// The timezone's abbreviation.
  final String abbreviation;
  /// Whether this timezone is Daylight saving time.
  final bool dst;

  /// Creates a [EffectiveTimezone].
  EffectiveTimezone(this.start, this.end, this.offset, this.abbreviation, {required this.dst});

}
