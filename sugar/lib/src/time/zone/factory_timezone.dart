import 'package:sugar/src/time/zone/timezone.dart';
import 'package:sugar/src/time/zone/timezone_span.dart';
import 'package:sugar/time.dart';

/// A timezone which is used when the platform's timezone could not be retrieved.
class FactoryTimezone extends Timezone {
  /// Creates a new instance of [FactoryTimezone].
  ///
  /// This constructor calls the super constructor with the string 'Factory'.
  const FactoryTimezone() : super.from('Factory');

  @override
  (EpochMicroseconds, TimezoneSpan) convert(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) => (0, span(at: 0));

  @override
  TimezoneSpan span({required EpochMicroseconds at}) => TimezoneSpan(
    offset: Offset(),
    abbreviation: '+0000',
    start: TimezoneSpan.range.min.value,
    end: TimezoneSpan.range.max.value,
    dst: false,
  );
}
