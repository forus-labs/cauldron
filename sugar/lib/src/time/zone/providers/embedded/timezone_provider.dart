import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/src/time/zone/providers/embedded/tzdb.dart';
import 'package:sugar/src/time/zone/timezone.dart';

part 'embedded_timezone.dart';

/// A [Timezone] provider for the embedded timezone database.
///
/// This provider uses a bundled timezone database to provide timezone
/// information for all known timezones.
class EmbeddedTimezoneProvider extends UnmodifiableMapBase<String, Timezone> {
  final _cache = <String, EmbeddedTimezone>{};

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
    final effectiveName = getOriginalForAlias(key) ?? key;
    var timezone = _cache[effectiveName];
    if (timezone == null) {
      timezone = parseTimezone(name: effectiveName);
      if (timezone == null) {
        return null;
      }
      _cache[effectiveName] = timezone;
    }
    if (effectiveName != key) {
      return timezone._withName(key);
    } else {
      return timezone;
    }
  }

  @override
  // Factory is a special timezone that is not in the TZDB
  // which is handled separately
  late final keys = knownTimezones.union({'Factory'});
}
