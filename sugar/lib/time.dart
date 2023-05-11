/// {@category Time}
///
/// The main API for dates, times and timezones.
///
/// All classes in this library are based on the ISO calendar system. It is not a goal to support other calendar systems.
///
/// All dates and times are all immutable. They are stored to microsecond precision. Weeks start on Monday and end on Sunday.
///
/// Except for the `toNative()` functions, classes do not use or return [DateTime]s.  See `sugar.time.interop` for
/// working with native `DateTime`s.
///
/// ## Dates and times
/// [LocalDate] stores a date without a time such as `2023-05-08`.
///
/// [LocalTime] stores a time without a date such as `11:30`.
///
/// [LocalDateTime] stores a date-time such as `2023-05-08 11:30`.
///
/// [OffsetTime] stores a time with a fixed offset from UTC such as `11:30+08:00`.
///
/// [ZonedDateTime] stores a date-time and timezone such as `2023-05-08T11:30+08:00[Asia/Singapore]`. It is useful
/// for representing date-times with a dynamic offset, typically due to Daylight Saving Time (DST). A class without a
/// timezone should be preferred whenever possible.
///
/// ## Durations and Periods
/// A [Duration] stores a fixed amount of time in microseconds while a [Period] stores the conceptual units of time.
/// For example, a duration of 1 day is always 86,400,000,000 microseconds while a period of 1 day is 1 "day".
/// Adding either to a [DateTime] or [ZonedDateTime] nearing a DST transition can produce different results.
///
/// ```dart
/// // DST occurs at 2023-03-12 02:00
/// // https://www.timeanddate.com/time/change/usa/detroit?year=2023
///
/// final datetime = ZoneDateTime('America/Detroit', 2023, 3, 12);
///
/// datetime.add(Duration(days: 1)); // 2023-03-13 01:00 [America/Detroit]
/// datetime + Period(days: 1);      // 2023-03-13 00:00 [America/Detroit]
/// ```
library sugar.time;

import 'package:sugar/src/time/date.dart';
import 'package:sugar/src/time/date_time.dart';
import 'package:sugar/src/time/period.dart';
import 'package:sugar/src/time/time.dart';

export 'src/time/date.dart' hide Date;
export 'src/time/date_time.dart' hide DateTimeBase;
export 'src/time/offset.dart' hide LiteralOffset, format;
export 'src/time/period.dart';
export 'src/time/temporal_unit.dart' hide sumMicroseconds;
export 'src/time/time.dart' hide Time;
