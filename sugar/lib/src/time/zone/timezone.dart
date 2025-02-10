import 'package:meta/meta.dart';

import 'package:sugar/sugar.dart';

/// A timezone that contains rules defining how an offset varies for a single timezone.
///
/// There are two types of [Timezone]s:
/// * Those that have a fixed offset at all points in time.
/// * Those that have offsets which vary across points in time, typically due to daylight savings time.
///
/// As of Sugar 3.1.0, most timezones in the 2023c TZ database are supported. This can be configured by replacing [timezoneProvider].
/// Similarly, retrieval of the platform's timezone can be configured by replacing [platformTimezoneProvider].
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
  static String Function() platformTimezoneProvider =
      defaultPlatformTimezoneProvider;

  /// All known TZ database timezone identifiers associated with the timezones.
  ///
  /// It may be replaced to support other timezone sources.
  ///
  /// Retrieving a timezone directly from this map is discouraged. Users should prefer [Timezone.new].
  ///
  /// The default implementation is unmodifiable and lazy. Iterating over the entries/values is discouraged since it will
  /// initialize the iterated [Timezone]s, thereby increasing memory footprint. However, iterating over the keys is fine.
  static Map<String, Timezone> timezoneProvider = UniversalTimezoneProvider();

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
  factory Timezone(String name) =>
      timezoneProvider[name] ?? const FactoryTimezone();

  /// Creates a [Timezone].
  const Timezone.from(this.name);

  /// Converts the [local] date-time in microseconds to microseconds since Unix epoch (in UTC).
  @useResult
  EpochMicroseconds convert({required int local});

  /// Returns the offset of this timezone at the given [at] date-time.
  @useResult
  Offset offset({required EpochMicroseconds at});

  @override
  String toString() => name;
}

/// A timezone which is used when the platform's timezone could not be retrieved.
class FactoryTimezone extends Timezone {
  /// Creates a new instance of [FactoryTimezone].
  ///
  /// This constructor calls the super constructor with the string 'Factory'.
  const FactoryTimezone() : super.from('Factory');

  @override
  EpochMicroseconds convert({required int local}) => 0;

  @override
  Offset offset({required EpochMicroseconds at}) => Offset();
}
