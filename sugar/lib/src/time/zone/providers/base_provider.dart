import 'dart:collection';

import 'package:sugar/src/time/zone/timezone.dart';

abstract class TimezoneProvider extends UnmodifiableMapBase<String, Timezone> {
  /// The default timezone to use when a timezone is not found.
  Timezone get factory;
}
