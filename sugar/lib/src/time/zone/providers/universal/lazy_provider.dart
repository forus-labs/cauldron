import 'dart:collection';
import 'package:sugar/src/time/zone/providers/universal/tzdb.dart';
import 'package:sugar/src/time/zone/timezone.dart';

/// A [Timezone] provider for the universal timezone database.
///
/// This provider uses a bundled timezone database to provide timezone
/// information for all known timezones.
class EmbeddedTimezoneProvider extends UnmodifiableMapBase<String, Timezone> {
  @override
  Timezone? operator [](Object? key) {
    if (key is String && keys.contains(key)) {
      return parseTimezone(name: key);
    }
    return null;
  }

  @override
  Iterable<String> get keys => knownTimezones;
}
