import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sugar/src/time/zone/timezones.g.dart';
import 'package:sugar/time_zone.dart';

/// The default [Timezone] provider.
@internal class DefaultTimezoneProvider extends UnmodifiableMapBase<String, Timezone> {

  @override
  @useResult Timezone? operator [](Object? key) => key is String ? parseTimezone(key) : null;

  @override
  @useResult Set<String> get keys => known;

}
