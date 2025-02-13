import 'package:sugar/src/time/zone/providers/base_provider.dart';
import 'package:sugar/src/time/zone/providers/embedded/embedded_timezone.dart';
import 'package:sugar/src/time/zone/providers/embedded/tzdb.dart';
import 'package:sugar/src/time/zone/timezone.dart';

/// A [Timezone] provider for the embedded timezone database.
///
/// This provider uses a bundled timezone database to provide timezone
/// information for all known timezones.
class EmbeddedTimezoneProvider extends BaseTimezoneProvider {
  @override
  EmbeddedTimezone? fetchTimezone(String name) => parseTimezone(name: name);

  @override
  Set<String> listTimezones() => knownTimezones;
}
