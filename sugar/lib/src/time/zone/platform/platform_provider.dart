import 'package:sugar/src/time/zone/platform/web_provider.dart'
    if (dart.library.io) 'package:sugar/src/time/zone/platform/native_provider.dart';

/// The default platform timezone provider.
///
/// Supported & tested platforms:
/// * Windows - Windows 11 & Windows Server 2022
/// * MacOS - MacOS 13
/// * Linux - Ubuntu 22.04
/// * Web - Latest stable versions of Chrome & Firefox
///
/// Android & iOS are supported by the currently experimental [stevia](https://github.com/forus-labs/cauldron/tree/master/stevia)
/// package.
///
/// ## Implementation details
/// Retrieval of timezones is performed on a best-effort basis. There is no guarantee that the actual timezone is returned.
///
/// [`Factory`](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#factory) is always returned on unsupported
/// platforms.
///
/// We're waiting for the following to become stable before supporting Android & iOS:
/// * https://github.com/dart-lang/sdk/issues/49673
/// * https://github.com/dart-lang/sdk/issues/49674
/// * https://github.com/dart-lang/sdk/issues/50565
///
/// ### MacOS & Linux caveats
/// MacOS and Linux will use the `TZ` environment if set to a TZ database timezone identifier such as `Asia/Singapore`.
/// Since the `TZ` environment variable format is complicated and varies across distros, it is otherwise ignored.
///
/// Subsequently, the `/etc/localtime` symbolic link is resolved. Most mainstream distros such as Ubuntu and Debian
/// has this symbolic link.
///
/// ### Web caveats
///  Web uses Javascript's [`Intl.DateFormat().resolvedOptions().timeZone`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/resolvedOptions#description).
///  Some obsolete browsers such as IE 11, do not support it.
///
/// See the following pages on browser compatibility:
/// * http://kangax.github.io/compat-table/esintl/#test-DateTimeFormat_resolvedOptions().timeZone_defaults_to_the_host_environment
/// * https://caniuse.com/mdn-javascript_builtins_intl_datetimeformat_resolvedoptions_computed_timezone
String defaultPlatformTimezoneProvider() => provider();
