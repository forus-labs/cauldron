import 'package:sugar/src/time/zone/timezone.dart';
import 'package:sugar/src/time/zone/platform/web_provider.dart'
  if (dart.library.io) 'package:sugar/src/time/zone/platform/vm_provider.dart';

/// The default `Timezone.provider`.
///
/// It is public to simplify custom timezone retrieval implementations. Most users should prefer [Timezone.current].
///
/// Tested platforms:
/// * Windows - Windows 11 & Windows Server 2022
/// * MacOS - MacOS 13
/// * Linux - Ubuntu 22.04
/// * Web - Latest stable versions of Chrome & Firefox
///
/// ## Implementation details:
/// Retrieval of timezones is performed on a best-effort basis. It is not guaranteed that the actual timezone is returned.
///
/// Only Windows, MacOS, Linux and Web platforms are supported.  This is due to limitations with Dart FFI on mobile platforms.
/// [`Factory`](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#factory) is always returned on unsupported platforms.
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
///  Some obsolete browsers, i.e. IE 11, do not implement it.
///
/// See the following pages for more information on browser compatibility:
/// * http://kangax.github.io/compat-table/esintl/#test-DateTimeFormat_resolvedOptions().timeZone_defaults_to_the_host_environment
/// * https://caniuse.com/mdn-javascript_builtins_intl_datetimeformat_resolvedoptions_computed_timezone
String defaultTimezoneProvider() => provider();