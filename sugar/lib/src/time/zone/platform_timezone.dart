import 'package:sugar/src/time/zone/timezone_rules.dart';
import 'package:sugar/src/time/zone/platform/web_provider.dart'
  if (dart.library.io) 'package:sugar/src/time/zone/platform/vm_provider.dart';

/// The default `TimezoneRules.platformTimezone` that retrieves the platform's timezone.
///
/// This is public to simplify customization of timezone retrieval. Most users should prefer [TimezoneRules.current].
///
/// Supported & tested platforms:
/// * Windows - Windows 11 & Windows Server 2022
/// * MacOS - MacOS 13
/// * Linux - Ubuntu 22.04
/// * Web - Latest stable versions of Chrome & Firefox
///
/// ## Implementation details:
/// Retrieval of timezones is performed on a best-effort basis. It is not guaranteed that the actual timezone is returned.
///
/// Only Windows, MacOS, Linux and Web platforms are supported. [`Factory`](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#factory)
/// is always returned on unsupported platforms.
///
/// We're waiting for the following to become stable before supporting mobile platforms:
/// * https://github.com/dart-lang/sdk/issues/49673
/// * https://github.com/dart-lang/sdk/issues/49674
/// * https://github.com/dart-lang/sdk/issues/50565
///
/// ### Linux & MacOS caveats
/// MacOS and Linux will use the `TZ` environment if it is a TZ database timezone that represents a geographical location.
/// Since the `TZ` environment variable's format is complicated and varies across distros, it is otherwise ignored.
///
/// Subsequently, it resolves the `/etc/localtime` symbolic link. Although most distros, i.e. Ubuntu and Debian, contains
/// this file, not all distros do.
///
/// ### Web caveats
///  Web uses Javascript's [`Intl.DateFormat().resolvedOptions().timeZone`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/resolvedOptions#description).
///  Some obsolete browsers, i.e. IE 11, do not support it.
///
/// See the following pages for more information on browser compatibility:
/// * http://kangax.github.io/compat-table/esintl/#test-DateTimeFormat_resolvedOptions().timeZone_defaults_to_the_host_environment
/// * https://caniuse.com/mdn-javascript_builtins_intl_datetimeformat_resolvedoptions_computed_timezone
String defaultPlatformTimezone() => provider();
