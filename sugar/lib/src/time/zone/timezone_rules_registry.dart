import 'package:meta/meta.dart';
import 'package:sugar/sugar.dart';
import 'package:sugar/src/time/zone/timezones.g.dart';

/// A registry that contains all known timezones rules.
///
/// This mixin is only necessary for implementing custom timezone rule registries. Most users should otherwise not need
/// use this.
mixin TimezoneRulesRegistry {

  /// Returns whether this registry contains the rules for the given timezone.
  bool contains(String timezone);

  /// Returns a [TimezoneRules] with the given name. A `Factory` timezone should always be returned if this registry does not
  /// contain the given timezone.
  TimezoneRules operator[] (String timezone);

}

/// The default [TimezoneRulesRegistry] for `TimezoneRules.registry`.
@internal class DefaultTimezoneRulesRegistry with TimezoneRulesRegistry {

  @override
  bool contains(String timezone) => iana.contains(timezone);

  @override
  TimezoneRules operator [](String timezone) => parseTimezone(timezone);

}
