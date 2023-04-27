import 'package:meta/meta.dart';
import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/time_zone.dart';

/// A [FixedTimezone] with a fixed abbreviation and offset throughout points in time.
class FixedTimezone extends Timezone {

  final FixedTimezoneSpan _span;

  /// Creates a [FixedTimezone].
  FixedTimezone(super.name, this._span);

  @override
  @useResult MapEntry<EpochMicroseconds, TimezoneSpan> convert({required int local}) => MapEntry(local - _span.offset.inMicroseconds, _span);

  @override
  @useResult TimezoneSpan span({required EpochMicroseconds at}) => _span;

}

/// A [TimezoneSpan] for a TZ database timezone with a fixed offset throughout points in time.
class FixedTimezoneSpan extends TimezoneSpan {

  @override
  final Offset offset;

  /// Creates a [FixedTimezoneSpan].
  FixedTimezoneSpan(this.offset, super.abbreviation, super.start, super.end, {required super.dst});

}
