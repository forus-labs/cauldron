import 'package:meta/meta.dart';

import 'package:sugar/src/time/zone/platform/web_timezone.dart';

/// Retrieves the timezone on web.
@internal
String provider() {
  try {
    return DateTimeFormat().resolvedOptions().timeZone ?? 'Factory';
    // ignore: avoid_catching_errors
  } on Error {
    return 'Factory';
  }
}
