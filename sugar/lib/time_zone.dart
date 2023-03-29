library sugar.time.zone;

export 'src/time/zone/platform_timezone.dart'
  if (dart.library.io) 'src/time/zone/vm/platform_timezone.dart'
  if (dart.library.html) 'src/time/zone/web/platform_timezone.dart';

export 'src/time/zone/location.dart';
export 'src/time/zone/timezones.g.dart';
