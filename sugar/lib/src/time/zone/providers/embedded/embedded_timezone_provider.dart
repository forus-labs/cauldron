import 'dart:collection';

import 'package:sugar/src/time/zone/factory_timezone.dart';
import 'package:sugar/src/time/zone/providers/embedded/tzdb.dart';
import 'package:sugar/src/time/zone/timezone.dart';

/// A [Timezone] provider for the embedded timezone database.
///
/// This provider uses a bundled timezone database to provide timezone
/// information for all known timezones.
class EmbeddedTimezoneProvider extends UnmodifiableMapBase<String, Timezone> {
  final _cache = <String, Timezone>{};

  @override
  Timezone? operator [](Object? key) {
    if (key is! String) {
      return null;
    }
    if (!keys.contains(key)) {
      return null;
    }
    if (key == 'Factory') {
      return const FactoryTimezone();
    }
    var timezone = _cache[key];
    if (timezone == null) {
      timezone = parseTimezone(name: key);
      if (timezone != null) {
        _cache[key] = timezone;
      }
    }
    return timezone;
  }

  @override
  // Factory is a special timezone that is not in any
  // timezone database which is handled separately
  late final keys = knownTimezones.union({'Factory'});
}
