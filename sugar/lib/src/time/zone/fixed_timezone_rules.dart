import 'package:sugar/time.dart';

/// The rules for a timezone with a single, fixed offset throughout all points in time.
class FixedTimezoneRules implements TimezoneRules {

  final FixedTimezone _timezone;

  /// Creates a [FixedTimezoneRules].
  const FixedTimezoneRules(this._timezone);

  @override
  Timezone from({required int local}) => _timezone;

  @override
  Timezone at(EpochMilliseconds milliseconds) => _timezone;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FixedTimezoneRules && runtimeType == other.runtimeType
                && _timezone == other._timezone;

  @override
  int get hashCode => _timezone.hashCode;

  @override
  String toString() => _timezone.name;

}

/// Represents a timezone in the IANA timezone database with a single, fixed offset.
class FixedTimezone extends Timezone {

  /// The timezone's offset.
  @override final Offset offset;

  /// Creates a [FixedTimezone].
  const FixedTimezone(this.offset, super.name, super.abbreviation, super.start, super.end, {required super.dst});

  @override
  int toOffsetMilliseconds() => offset.toMilliseconds();

}
