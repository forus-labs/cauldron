import 'package:sugar/core.dart';
import 'package:sugar/src/time/zone/vm/windows_timezone.dart';

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
/// Retrieval of timezone names from the underlying platform is performed on a best-effort basis. There is no guarantee
/// that the actual timezone name will be returned.
///
/// This default implementation only supports desktop & web environments. This is due to a limitation with Dart's toolchain.
/// If called on an unsupported platform, [`Factory`](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#factory)
/// is returned.
///
///
/// ### Caveats & testing policies:
///
/// ### Windows:
/// Testing is only conducted on Windows Server 2022 & Windows 11. No tests are conducted on other versions.
///
/// #### Web:
/// Testing is only conducted on the latest stable version of Chrome and Firefox.
///
/// Internally, the web implementation uses JavaScript's built-in [`Intl.DateFormat().resolvedOptions().timeZone`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/resolvedOptions#description).
/// Although most modern browser implement it, some obsolete browsers, i.e. IE 11 does not. [`Factory`](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#factory)
/// will be returned on a best-effort basis on unsupported/obsolete browsers.
///
/// See the following pages for more information on browser compatibility:
/// * http://kangax.github.io/compat-table/esintl/#test-DateTimeFormat_resolvedOptions().timeZone_defaults_to_the_host_environment
/// * https://caniuse.com/mdn-javascript_builtins_intl_datetimeformat_resolvedoptions_computed_timezone
String platformTimezone() {
  switch (const Runtime().type) {
    case PlatformType.linux:

    case PlatformType.macos:

    case PlatformType.windows:
      return windowsTimezone;

    default:
      return 'Factory';
  }
}
