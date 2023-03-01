import 'package:sugar/core.dart';

/// Retrieves the underlying platform's timezone name.
///
/// The returned name should be a TZ database name. It may be either a canonical or link TZ database name. For example,
/// if the current geographical location is Singapore, the returned name should be `Asia/Singapore`.
///
/// See this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) of TZ database timezones for more information.
typedef PlatformTimezone = String Function();

/// Default implementation of [PlatformTimezone] for retrieving the underlying platform's timezone name.
///
/// ### Note:
/// This default implementation only supports desktop & web environments. This is due to a limitation with Dart's toolchain.
/// If called on an unsupported platform, a message is logged to console and [`Factory`](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#factory)
/// is returned.
String defaultPlatformTimezone() {
  switch (const Runtime().type) {
    case PlatformType.linux:

    case PlatformType.macos:

    case PlatformType.windows:


    default:
      return 'Factory';
  }
}