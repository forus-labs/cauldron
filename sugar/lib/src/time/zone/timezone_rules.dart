import 'package:meta/meta.dart';

import 'package:sugar/src/time/zone/info/root.g.dart';
import 'package:sugar/src/time/zone/timezone_rules_registry.dart';
import 'package:sugar/time.dart';

/// The rules defining how a timezone offset varies for a single timezone.
///
/// There are two types of [TimezoneRules]:
/// * Those that have a fixed offset for all points in time.
/// * Those that model timezones in the IANA TZ database. These timezones may have offsets that vary across points in time.
abstract class TimezoneRules {

  /// A callback that retrieves the platform's timezone. It may be replaced, particularly in tests, to change timezone retrieval.
  ///
  /// A TZ database timezone, i.e. `Asia/Singapore`. is always returned. If the platform's timezone could not be retrieved,
  /// the `Factory` timezone is returned.
  ///
  /// See [defaultPlatformTimezone] for information on the default implementation.
  static String Function() platformTimezone = defaultPlatformTimezone;

  /// A registry that contains all known timezones rules. It may be replaced to support other timezones.
  ///
  /// The default implementation contains all timezones in the 2023c IANA timezone database.
  static TimezoneRulesRegistry registry = DefaultTimezoneRulesRegistry();

  /// The TZ database `Factory` timezone that has no offset. It is returned when parsing and retrieval fails.
  ///
  /// ```dart
  /// final factory = TimezoneRules.parse('invalid/location'); // TimezoneRules.factory
  /// ```
  static TimezoneRules get factory => Root.factory;

  /// The cached current timezone rules.
  static TimezoneRules _rules = factory;

  /// Creates a [TimezoneRules] with the platform's current timezone, or [factory] if the timezone could not be retrieved.
  ///
  /// ```dart
  /// final singapore = TimezoneRules.current(); // `Asia/Singapore`, assuming the current location is Singapore.
  /// ```
  ///
  /// ## Note:
  /// Only Windows, MacOS, Linux & Web is supported.
  factory TimezoneRules.current() {
    final timezone = platformTimezone();
    if (_rules.toString() != timezone) {
      _rules = TimezoneRules.parse(timezone);
    }

    return _rules;
  }

  /// Creates a [TimezoneRules] with the given TZ database timezone, or [factory] if it does not exist.
  ///
  /// ```dart
  /// final singapore = TimezoneRules.parse('Asia/Singapore'); // `Asia/Singapore`
  ///
  /// final factory = TimezoneRules.parse('invalid/location'); // TimezoneRules.factory
  /// ```
  factory TimezoneRules.parse(String timezone) => registry[timezone];

  /// Returns the [Timezone] which offset is subtracted from the given [local] time to get UTC time.
  ///
  /// If the given local datetime falls in the middle of a gap, the [Timezone] after the gap, i.e. "summer" is returned.
  ///
  /// ![gap](https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Begin_CEST.svg/200px-Begin_CEST.svg.png)
  ///
  /// If the given local datetime falls in the middle of an overlap, the [Timezone] before the gap, i.e. "winter" is returned.
  ///
  /// ![overlap](https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/End_CEST.svg/200px-End_CEST.svg.png)
  Timezone from({required int local});

  /// Returns the [Timezone] at the given milliseconds since Unix epoch.
  Timezone at(EpochMilliseconds milliseconds);

  /// Returns a string representation of this timezone, i.e. `Asia/Singapore`.
  @override
  @mustBeOverridden
  String toString();

}

/// A timezone.
abstract class Timezone {

  /// The name, typically a valid TZ database timezone, i.e. `Asia/Singapore`.
  final String name;
  /// The abbreviation, i.e. `CEST`.
  final String abbreviation;
  /// The milliseconds since Unix epoch at which this timezone starts, inclusive.
  final EpochMilliseconds? start;
  /// The milliseconds since Unix epoch at which this timezone ends, exclusive.
  final EpochMilliseconds? end;
  /// Whether this timezone is Daylight saving time.
  final bool dst;

  /// Creates a [Timezone].
  const Timezone(this.name, this.abbreviation, this.start, this.end, {required this.dst});

  /// The timezone's offset.
  Offset get offset;

  /// The timezone's offset in milliseconds.
  int toOffsetMilliseconds();

}
