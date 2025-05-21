import 'package:meta/meta.dart';

import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/src/time/zone/factory_timezone.dart';
import 'package:sugar/time_zone.dart';

/// A timezone that contains rules defining how an offset varies for a single timezone.
///
/// There are two types of [Timezone]s:
/// * Those that have a fixed offset at all points in time.
/// * Those that have offsets which vary across points in time, typically due to daylight savings time.
///
/// As of Sugar 4.0.0, most timezones in the 2025a TZ database are supported. This can be configured by replacing
/// [timezoneProvider]. Similarly, retrieval of the platform's timezone can be configured by replacing
/// [platformTimezoneProvider].
///
/// ## Caveats
/// By default, [Timezone.now] without specifying a timezone only works on Windows, MacOS, Linux and web. The
/// `Factory` timezone will be returned on all other platforms. This is due to limitations with `dart:ffi`. See
/// [Timezone.platformTimezoneProvider].
///
/// If you're feeling adventurous, consider using [stevia](https://github.com/forus-labs/cauldron/tree/master/stevia),
/// an experimental add-on package for retrieving the timezone on other Android and iOS.
///
/// ## Timezones Transitions
///
/// Obtaining the offset for a local date-time is not trivial. Due to timezone transitions, it is possible for a local
/// date-time to be ambiguous or invalid. There are three cases.
///
/// Normal, with one valid offset. This is the case for most of the year.
/// <br>
///
///
/// Gap, with zero offsets. This is when the clock jumps forward, when transitioning from winter to summer time.
/// If a local date-time fails in the middle of a gap, the offset after the gap, i.e. summer time, is returned.
///
/// ![Clock jumping forward](https://upload.wikimedia.org/wikipedia/commons/thumb/3/35/Begin_CEST.svg/120px-Begin_CEST.svg.png)
/// <br>
///
///
/// Overlap, with two valid offsets. This is when clocks are set back, typically when transitioning from summer to
/// winter time. If a local date-time falls in the middle of an overlap, the offset before the overlap, i.e. winter time,
/// is returned.
///
/// ![Clock moving backwards](https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/End_CEST.svg/120px-End_CEST.svg.png)
/// <br>
abstract class Timezone {
  /// A callback that retrieves the platform's timezone.
  ///
  /// A TZ database timezone identifier such as `Asia/Singapore` is always returned. Otherwise returns `Factory` if the
  /// platform's timezone could not be retrieved.
  ///
  /// It may be replaced to change timezone retrieval.
  ///
  /// Retrieving a timezone directly from this callback is discouraged. Users should prefer [Timezone.now].
  ///
  /// See [defaultPlatformTimezoneProvider] for the default implementation.
  static String Function() platformTimezoneProvider = defaultPlatformTimezoneProvider;

  /// All known TZ database timezone identifiers associated with the timezones.
  ///
  /// It may be replaced to support other timezone sources.
  ///
  /// Retrieving a timezone directly from this map is discouraged. Users should prefer [Timezone.new].
  ///
  /// The default implementation is unmodifiable and lazy. Iterating over the entries/values is discouraged since it will
  /// initialize the iterated [Timezone]s, thereby increasing memory footprint. However, iterating over the keys is fine.
  static Map<String, Timezone> timezoneProvider = EmbeddedTimezoneProvider();

  /// The `Factory` timezone in the TZ database that has no offset.
  ///
  /// It is used as a default value for when parsing/retrieving a timezone fails.
  static Timezone get factory => const FactoryTimezone();

  /// The last used timezone.
  static Timezone _timezone = factory;

  /// The timezone name, typically a TZ database timezone identifier such as `Asia/Singapore`.
  final String name;

  /// Creates a [Timezone] with the current timezone, or [factory] if the current timezone could not be retrieved.
  ///
  /// **By default, this only works on Windows, MacOS, Linux & web. See [platformTimezoneProvider].**
  ///
  /// ```dart
  /// // Assume the current location is Singapore, `Asia/Singapore`.
  /// final singapore = Timezone.now(); // Asia/Singapore
  /// ```
  factory Timezone.now() {
    final timezone = platformTimezoneProvider();
    if (_timezone.name != timezone) {
      _timezone = Timezone(timezone);
    }

    return _timezone;
  }

  /// Creates a [Timezone] from the [name], typically a TZ database timezone identifier such as `Asia/Singapore`, or
  /// [factory] if the name could not be parsed.
  ///
  /// ```dart
  /// final singapore = Timezone('Asia/Singapore'); // `Asia/Singapore`
  /// final factory = Timezone('invalid'); // `Factory`
  /// ```
  factory Timezone(String name) => timezoneProvider[name] ?? factory;

  /// Creates a [Timezone].
  const Timezone.from(this.name);

  /// Converts the provided date-time in this timezone to microseconds since Unix epoch (in UTC). The corresponding
  /// [TimezoneSpan] is also returned.
  @useResult
  (EpochMicroseconds, TimezoneSpan) convert(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]);

  /// Returns the [TimezoneSpan] at the microseconds since Unix epoch.
  @useResult
  TimezoneSpan span({required EpochMicroseconds at});

  @override
  String toString() => name;
}
