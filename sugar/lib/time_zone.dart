/// {@category Time}
///
/// Support for timezones and their rules.
///
/// The transition rules are derived from the [IANA TZ database](https://www.iana.org/time-zones). The supported database
/// version is currently 2024a.
library;

export 'src/time/zone/timezone.dart';
export 'src/time/zone/providers/universal/universal_provider.dart';
export 'src/time/zone/platform/platform_provider.dart';
