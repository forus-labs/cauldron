import 'package:meta/meta.dart';

// ignore_for_file: public_member_api_docs

/// A unit of date-time, i.e. days and hours.
@sealed class TemporalUnit {}

/// A unit of date, i.e. months and days.
enum DateUnit implements TemporalUnit {
  years,
  months,
  days,
}

/// A unit of time, i.e. hours and minutes.
enum TimeUnit implements TemporalUnit {
  hours,
  minutes,
  seconds,
  milliseconds,
  microseconds,
}
