import 'dart:io';

import 'package:meta/meta.dart';
import 'package:sugar/src/time/zone/timezones.g.dart';

final _localtime =  File('/etc/localtime');

/// The current timezone name on MacOS/Linux, or `Factory` if the timezone name could not be inferred.
///
/// ### Contract:
/// This field should only be accessed on MacOS/Linux. Accessing this field on other platforms will result in undefined behaviour.
@internal String get posixTimezone {
  try {
    final variable = Platform.environment['TZ'];
    if (variable != null && iana.contains(variable)) {
      return variable;
    }

    if (!_localtime.existsSync()) {
      return 'Factory';
    }

    final path = _localtime.resolveSymbolicLinksSync().split('zoneinfo/').last;
    return iana.contains(path) ? path : 'Factory';

  } on FileSystemException {
    return 'Factory';
  }
}
