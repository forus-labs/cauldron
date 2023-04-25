import 'package:meta/meta.dart';
import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/src/time/zone/info/root.g.dart';
import 'package:sugar/src/time/zone/timezone_provider.dart';
import 'package:sugar/time_zone.dart';

/// A timezone that contains rules defining how an offset varies for a single timezone. By default, most timezones in the
/// 2023c TZ database are supported. This can be configured by replacing [timezoneProvider].
///
/// There are two types of [Timezone]s:
/// * Those that have a fixed offset for all points in time.
/// * Those that have offsets which vary across points in time, typically due to daylight savings time.
abstract class Timezone {

  /// A callback that retrieves the platform's timezone. It may be replaced to change timezone retrieval.
  ///
  /// A TZ database timezone identifier such as `Asia/Singapore` is always returned. Otherwise returns `Factory` if the
  /// platform's timezone could not be retrieved.
  ///
  /// Retrieving a timezone directly from this callback is discouraged. Users should prefer [Timezone.now].
  ///
  /// See [defaultPlatformTimezoneProvider] for information about the default implementation.
  static String Function() platformTimezoneProvider = defaultPlatformTimezoneProvider;

  /// All known TZ database timezone identifiers associated with the timezones. It may be replaced to support other timezone
  /// sources.
  ///
  /// Retrieving a timezone directly from this map is discouraged. Users should prefer [Timezone.parse].
  ///
  /// The default implementation is unmodifiable and lazy. Iterating through the entries/values is discouraged since it
  /// will initialize the iterated [Timezone]s thereby increasing memory footprint. However, iterating over the keys is
  /// fine.
  static Map<String, Timezone> timezoneProvider = DefaultTimezoneProvider();

  /// The `Factory` timezone in the TZ database that has no offset. It is used as a default value for when parsing/retrieving
  /// a timezone fails.
  static Timezone get factory => Root.factory;

  /// The last used timezone.
  static Timezone _timezone = factory;

  /// The timezone name, typically a TZ database timezone identifier such as `Asia/Singapore`.
  final String name;


  /// Creates a [Timezone] with the current timezone, or [factory] if the current timezone could not be retrieved.
  ///
  /// ## Note
  /// By default, this only works on Windows, MacOS, Linux & web. See [platformTimezoneProvider].
  ///
  /// ## Example
  /// ```dart
  /// // Assuming the current location is Singapore, `Asia/Singapore`.
  /// final singapore = Timezone.now();
  /// ```
  factory Timezone.now() {
    final timezone = platformTimezoneProvider();
    if (_timezone.name != timezone) {
      _timezone = Timezone.parse(timezone);
    }

    return _timezone;
  }

  /// Creates a [Timezone] from the given name, typically a TZ database timezone identifier such as `Asia/Singapore`,
  /// or [factory] if the name could not be parsed.
  ///
  /// ```dart
  /// // `Asia/Singapore`
  /// final singapore = Timezone.parse('Asia/Singapore');
  ///
  /// // `Factory`
  /// final factory = Timezone.parse('invalid');
  /// ```
  factory Timezone.parse(String name) => timezoneProvider[name] ?? factory;

  /// Creates a [Timezone].
  const Timezone(this.name);


  /// Converts the given [local] datetime in microseconds to microseconds since Unix epoch (in UTC). The corresponding
  /// [TimezoneSpan] is also returned.
  ///
  /// It is possible that the local datetime is ambiguous or invalid due to timezone transitions.
  ///
  /// ## Transition gaps
  /// ![gap](https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Begin_CEST.svg/200px-Begin_CEST.svg.png)
  ///
  /// If the given local datetime falls in the middle of a gap, the [TimezoneSpan] after the gap, i.e. "summer" time is
  /// returned.
  ///
  /// ## Transition overlaps
  /// ![overlap](https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/End_CEST.svg/200px-End_CEST.svg.png)
  ///
  /// If the given local datetime falls in the middle of an overlap, the [TimezoneSpan] before the overlap, i.e. "winter"
  /// time is returned.
  @useResult MapEntry<EpochMicroseconds, TimezoneSpan> convert({required int local}); // TODO: convert to tuple in Dart 3.0

  /// Returns the [TimezoneSpan] at the given microseconds since Unix epoch.
  @useResult TimezoneSpan span({required EpochMicroseconds at});

  @override
  String toString() => 'name';

}
