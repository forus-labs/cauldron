import 'package:meta/meta.dart';

import 'package:sugar/core_runtime.dart';
import 'package:sugar/src/time/zone/platform/posix_timezone.dart';
import 'package:sugar/src/time/zone/platform/windows_timezone.dart';

/// Retrieves the timezone on Windows, MacOS and Linux.
@internal String provider() => switch (const Runtime().type) {
  PlatformType.linux || PlatformType.macos => posixTimezone,
  PlatformType.windows => windowsTimezone,
  _ => 'Factory',
};
