import 'dart:collection';
import 'package:sugar/src/time/zone/factory_timezone.dart';
import 'package:sugar/src/time/zone/timezone.dart';

/// Base class for all timezone providers.
///
/// This class is used to provide a Map interface, while using a cache
/// to store the timezones that have already been fetched.
/// This class also handles the 'Factory' timezone which is a special timezone
/// which is treated separately from the other timezones.
abstract class BaseTimezoneProvider extends UnmodifiableMapBase<String, Timezone> {
  final _cache = <String, Timezone>{};

  /// Returns a set of all known timezone identifiers.
  Set<String> listTimezones();

  /// Fetches the timezone with the given name.
  Timezone? fetchTimezone(String name);

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
      timezone = fetchTimezone(key);
      if (timezone != null) {
        _cache[key] = timezone;
      }
    }
    return timezone;
  }

  @override
  // Factory is a special timezone that is not in any
  // timezone database which is handled separately
  late final keys = listTimezones().union({'Factory'});
}
