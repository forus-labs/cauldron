import 'package:meta/meta.dart';

import 'package:sugar/src/time/zone/platform/web_timezone.dart';

/// Retrieves the timezone on web.
@internal String provider() {
  try {
    return DateTimeFormat().resolvedOptions().timeZone ?? 'Factory';
  } on Error { // ignore: avoid_catching_errors
    return 'Factory';
  }
}
