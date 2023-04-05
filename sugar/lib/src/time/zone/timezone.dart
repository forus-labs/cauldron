import 'package:meta/meta.dart';

import 'package:sugar/src/time/zone/info/root.g.dart';
import 'package:sugar/src/time/zone/timezones.g.dart';
import 'package:sugar/time.dart';
import 'package:sugar/time_zone.dart';

/// A timezone is used to map instantaneous points on the timeline to the local date-times in different geographical regions.
///
/// There are two types of [Timezone]s:
/// * A fixed offset from UTC that uses the same offset for all points on the timeline.
/// * A timezone in the IANA TZ database. This includes geographical locations which offset may vary across points on the timeline.
@sealed abstract class Timezone {

  /// The supported IANA TZ database timezones, currently 2023c.
  static Set<String> get supported => iana;

  /// The IANA TZ database `Factory` timezone that has no offset. It is returned when parsing and retrieval fails.
  ///
  /// ```dart
  /// final factory = Timezone.parse('invalid/location'); // Timezone.factory
  /// ```
  static Timezone get factory => Root.factory;

  /// The provider used to retrieve the platform's timezone. It may be swapped to modify timezone retrieval.
  ///
  /// A TZ database timezone is always returned. It may be a canonical or link timezone. Defaults to `Factory` if the
  /// timezone could not be retrieved.
  ///
  /// See [defaultTimezoneProvider] for information on the default provider.
  static String Function() provider = defaultTimezoneProvider;

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
    final timezone = provider();
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
  factory Timezone.parse(String timezone) => parseTimezone(timezone);

  /// Returns this timezone's offset at the given milliseconds since Unix epoch.
  Offset offset({required EpochMilliseconds at});

  @override
  @mustBeOverridden
  String toString();

}
