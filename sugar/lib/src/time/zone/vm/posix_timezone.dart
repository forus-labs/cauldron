import 'dart:io';

import 'package:meta/meta.dart';

/// The current timezone name on MacOS/Linux, or `Factory` if the timezone name could not be inferred.
///
/// ### Contract:
/// This field should only be accessed on Windows. Accessing this field on other platforms will result in undefined behaviour.
@internal String get posixTimezone {
  try {
    final variable = Platform.environment['TZ'];
    if (variable != null && true) { // TODO: validate TZ environment variable.
      return variable;
    }

    final path = File('/etc/localtime').resolveSymbolicLinksSync().split('zoneinfo/').last;
    return true ? path : 'Factory'; // TODO: validate path.

  } on FileSystemException {
    return 'Factory';
  }
}
