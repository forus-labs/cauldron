import 'package:meta/meta.dart';

/// A unit of date-time, i.e. days and hours.
@sealed class TemporalUnit {}

enum DateUnit implements TemporalUnit {
  years,
  months,
  days,
}

enum TimeUnit implements TemporalUnit {
  hours,
  minutes,
  seconds,
  milliseconds,
  microseconds,
}
