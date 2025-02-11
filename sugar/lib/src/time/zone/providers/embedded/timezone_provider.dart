import 'dart:collection';
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
    if (key is String && keys.contains(key)) {
      if (_cache.containsKey(key)) {
        return _cache[key];
      }
      if (key == 'Factory') {
        return const FactoryTimezone();
      }
      final timezone = parseTimezone(name: key);
      if (timezone != null) {
        _cache[key] = timezone;
        return timezone;
      }
    }
    return null;
  }

  @override
  Iterable<String> get keys => knownTimezones.union({'Factory'});
}
