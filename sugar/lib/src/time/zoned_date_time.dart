part of 'date_time.dart';

/// A date-time with a timezone such as `2023-04-13T10:15:30+08:00 Asia/Singapore`. This class stores fields to microsecond
/// precision. It can be used to represent a specific point in time.
///
/// A [ZonedDateTime] can represent date-times with:
/// * A fixed offset from UTC that uses the same offset for all points on the timeline.
/// * A timezone in the IANA TZ database. This includes geographical locations which offset may vary across points on the timeline.
///
/// ## Note:
/// Detecting and retrieving the current timezone, i.e. [ZonedDateTime.now] is only supported on Windows, MacOS, Linux &
/// Web platforms. See [defaultPlatformTimezone] for more information.
///
/// A [ZonedDateTime] is immutable and should be treated as a value-type.
class ZonedDateTime extends DateTimeBase {

  /// The timezone.
  final Timezone timezone;

  // ZonedDateTime.fromMilliseconds(Timezone timezone, EpochMilliseconds milliseconds);
  //
  // ZonedDateTime.fromMicroseconds(Timezone timezone, EpochMicroseconds microseconds);
  //
  // ZonedDateTime.now([Timezone? timezone]);
  //
  // ZonedDateTime.from(Timezone timezone, int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]);
  //
  // /// Creates a [ZonedDateTime] with the given timezone and datetime.
  // ///
  // ZonedDateTime(String timezone, super.year, [super.month = 1, super.day = 1, super.hour = 0, super.minute = 0, super.second = 0, super.millisecond = 0, super.microsecond = 0]):
  //   timezone = Timezone.parse(timezone), super._();

  ZonedDateTime._copy(this.timezone, super.date): super._();

}
