import 'package:meta/meta.dart';
import 'package:sugar/sugar.dart';
import 'package:sugar/src/time/zone/timezones.g.dart';

/// A registry which contains supported timezones. It is used to retrieve timezones.
///
/// This mixin is only necessary when implementing a custom timezone registry. Most users should not need to use it.
mixin TimezoneRegistry {

  /// Returns whether this registry contains the given timezone.
  bool contains(String timezone);

  /// Returns a [Timezone] with the given name. A `Factory` timezone should always be returned if this registry does not
  /// contain the given timezone.
  Timezone operator[] (String timezone);

}

/// The default [TimezoneRegistry] for `Timezone.registry`.
@internal class DefaultTimezoneRegistry with TimezoneRegistry {

  @override
  bool contains(String timezone) => iana.contains(timezone);

  @override
  Timezone operator [](String timezone) => parseTimezone(timezone);

}
