/// {@category Time}
///
/// Support for timezones and their rules.
///
/// The transition rules are derived from the [IANA TZ database](https://www.iana.org/time-zones). The supported database
/// version is currently 2024a.
library sugar.time.zone;

export 'src/time/zone/timezone.dart';
export 'src/time/zone/timezone_provider.dart';
export 'src/time/zone/timezone_span.dart';
export 'src/time/zone/platform/platform_provider.dart';
