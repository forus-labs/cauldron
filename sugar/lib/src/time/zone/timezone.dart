import 'package:meta/meta.dart';

import 'package:sugar/src/time/offset.dart';
import 'package:sugar/time.dart';
import 'package:sugar/time_zone.dart';

/// A timezone is used to map instantaneous points on the time-line to the local date-times in different geographical regions.
///
/// There are two types of [Timezone]s:
///
/// ## [FixedOffset]
/// A fixed offset from UTC/Greenwich that uses the same offset for all local date-times.
///
/// ## [Location]
/// A location in the IANA TZ database with a varying offset.
@sealed abstract class Timezone {

  /// The TZ database `Factory` timezone that has no offset. It is returned when parsing and retrieval fails.
  ///
  /// ```dart
  /// final factory = Timezone.parse('invalid/location'); // Timezone.factory
  /// ```
  static const Timezone factory = _Factory();

  /// The provider used to retrieve the platform's timezone. It may be swapped to modify timezone retrieval.
  ///
  /// A TZ database timezone is always returned. It may be a canonical or link timezone. Defaults to `Factory` if the
  /// timezone could not be retrieved.
  ///
  /// See [defaultTimezoneProvider] for information on the default provider.
  static String Function() provider = defaultTimezoneProvider;
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
    final name = provider();
    if (_timezone.toString() != name) {
      _timezone = Timezone.parse(name);
    }

    return _timezone;
  }

  /// Creates a [Timezone] with the given [name] if it exists. Otherwise returns [factory].
  /// [name] should be either a TZ database timezone or an offset ID.
  ///
  /// ```dart
  /// final singapore = Timezone.parse('Asia/Singapore'); // `Asia/Singapore`
  ///
  /// final utc8 = Timezone.parse('+08:00'); // UTC+8
  ///
  /// final factory = Timezone.parse('invalid/location'); // Timezone.factory
  /// ```
  ///
  /// See [Offset.toString] for more information about offset IDs.
  factory Timezone.parse(String name) {
    // TODO: parse timezone
    return Timezone.factory;
  }


  /// Returns this timezone's offset at the given milliseconds since Unix epoch.
  Offset offset({required EpochMilliseconds at});

  @override
  @mustBeOverridden
  String toString();

}

class _Factory implements Timezone {
  const _Factory();

  @override
  Offset offset({required EpochMilliseconds at}) => const RawOffset('Z', 0);

  @override
  String toString() => 'Factory';
}
