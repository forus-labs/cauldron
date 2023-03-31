import 'package:sugar/src/time/zone/location.dart';

/// Retrieves the underlying platform's timezone name.
///
/// The returned name should be a TZ database name. It may be either a canonical or link TZ database name. For example,
/// if the current geographical location is Singapore, the returned name should be `Asia/Singapore`.
///
/// See this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) of TZ database timezones for more information.
typedef PlatformTimezone = String Function();

/// Default implementation of [PlatformTimezone] for retrieving the underlying platform's timezone name.
///
/// This function is only required in advanced use-cases such as custom platform timezone retrieval implementations.
/// Most users should prefer [Location.current] instead.
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
/// ### MacOS & Linux:
/// Testing is only conducted on MacOS13 and Ubuntu 22.04. No tests are conducted on other versions.
///
/// Internally, the MacOS & Linux implementation uses the `TZ` environment variable if it is a TZ database name. Due to
/// the complexity of the `TZ` environment variable format and variations across different distros, the variable is ignored
/// if is not a TZ database name.
///
/// Subsequently, the implementation resolves the `/etc/localtime` symbolic link. Although this file is not guaranteed to
/// be present across all linux distros, it should appear on most modern, mainstream distros, i.e. Ubuntu, Debian.
///
/// TL;DR: works on MacOS & most modern, mainstream Linux distros.
///
/// #### Web:
/// Testing is only conducted on the latest stable version of Chrome and Firefox.
///
/// Internally, the web implementation uses JavaScript's built-in [`Intl.DateFormat().resolvedOptions().timeZone`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/resolvedOptions#description).
/// Although most modern browser implement it, some obsolete browsers, i.e. IE 11 does not. [`Factory`](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#factory)
/// will be returned on a best-effort basis on unsupported/obsolete browsers.
///
/// TL;DR: works on most mainstream browser versions after ~2016.
///
/// See the following pages for more information on browser compatibility:
/// * http://kangax.github.io/compat-table/esintl/#test-DateTimeFormat_resolvedOptions().timeZone_defaults_to_the_host_environment
/// * https://caniuse.com/mdn-javascript_builtins_intl_datetimeformat_resolvedoptions_computed_timezone
String platformTimezone() {
  // For conditional imports on VM & web. See the vm & web subdirectories for the respective implementations.
  // This is necessary since the VM implementation uses dart:ffi & the web implementation uses package:js.
  throw UnimplementedError();
}

