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

  /// The timezone rules.
  final TimezoneRules rules;
  /// The timezone.
  final Timezone timezone;
  final DateTime _utc;

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

  // ZonedDateTime.from(this.rules, int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]):
  //   _utc = DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond),
  //   timezone = rules.from(local: _utc.millisecondsSinceEpoch),

  factory ZonedDateTime.from(TimezoneRules rules, int year, [int month = 1, int day = 1, int hour = 0, int minute = 0, int second = 0, int millisecond = 0, int microsecond = 0]) {
    final local = DateTime.utc(year, month, day, hour, minute, second, millisecond, microsecond);
    final timezone = rules.from(local: local.millisecondsSinceEpoch);
    final utc = DateTime.fromMicrosecondsSinceEpoch(local.microsecondsSinceEpoch - (timezone.toOffsetMilliseconds() * 1000), isUtc: true);
    final f = rules.at(utc.millisecondsSinceEpoch);
    return ZonedDateTime._(rules, timezone, utc, utc.add(timezone.offset.toDuration()));
  }

  ZonedDateTime._(this.rules, this.timezone, this._utc, super._native): super.fromNativeDateTime();

  static String _fourDigits(int n) {
    var absN = n.abs();
    var sign = n < 0 ? '-' : '';
    if (absN >= 1000) return '$n';
    if (absN >= 100) return '${sign}0$absN';
    if (absN >= 10) return '${sign}00$absN';
    return '${sign}000$absN';
  }

  static String _threeDigits(int n) {
    if (n >= 100) return '$n';
    if (n >= 10) return '0$n';
    return '00$n';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  /// Returns a human-readable string for this instance.
  ///
  /// The returned string is constructed for the time zone of this instance.
  /// The `toString()` method provides a simply formatted string.
  /// It does not support internationalized strings.
  /// Use the [intl](http://pub.dartlang.org/packages/intl) package
  /// at the pub shared packages repo.
  @override
  String toString() => _toString(iso8601: false);

  /// Returns an ISO-8601 full-precision extended format representation.
  ///
  /// The format is yyyy-MM-ddTHH:mm:ss.mmmuuuZ for UTC time, and
  /// yyyy-MM-ddTHH:mm:ss.mmmuuu±hhmm for local/non-UTC time, where:
  ///
  /// *   yyyy is a, possibly negative, four digit representation of the year,
  ///     if the year is in the range -9999 to 9999, otherwise it is a signed
  ///     six digit representation of the year.
  /// *   MM is the month in the range 01 to 12,
  /// *   dd is the day of the month in the range 01 to 31,
  /// *   HH are hours in the range 00 to 23,
  /// *   mm are minutes in the range 00 to 59,
  /// *   ss are seconds in the range 00 to 59 (no leap seconds),
  /// *   mmm are milliseconds in the range 000 to 999, and
  /// *   uuu are microseconds in the range 001 to 999. If microsecond equals 0,
  ///     then this part is omitted.
  ///
  ///The resulting string can be parsed back using parse.
  @override
  String toIso8601String() => _toString(iso8601: true);

  String _toString({bool iso8601 = true}) {
    final offset = timezone.offset;

    final y = _fourDigits(year);
    var m = _twoDigits(month);
    var d = _twoDigits(day);
    var sep = iso8601 ? 'T' : ' ';
    var h = _twoDigits(hour);
    var min = _twoDigits(minute);
    var sec = _twoDigits(second);
    var ms = _threeDigits(millisecond);
    var us = microsecond == 0 ? '' : _threeDigits(microsecond);

    if (offset == Offset.utc) {
      return "$y-$m-$d$sep$h:$min:$sec.$ms${us}Z";
    } else {
      return "$y-$m-$d$sep$h:$min:$sec.$ms$us$offset";
    }
  }

}

void main() {
  // // CEST +2
  // // CET  +1
  // print(ZonedDateTime.from(TimezoneRules.parse('Europe/Berlin'), 2023, 5, 2));
  // print(ZonedDateTime.from(TimezoneRules.parse('Europe/Berlin'), 2023, 10, 29, 2));
  // print(ZonedDateTime.from(TimezoneRules.parse('Europe/Berlin'), 2023, 10, 29, 2, 30));
  // print(ZonedDateTime.from(TimezoneRules.parse('Europe/Berlin'), 2023, 10, 29, 4));
  //
  // // EDT -4
  // // EST -5
  // print(ZonedDateTime.from(TimezoneRules.parse('America/Detroit'), 2023, 11, 4));
  // print(ZonedDateTime.from(TimezoneRules.parse('America/Detroit'), 2023, 11, 5, 1));
  // print(ZonedDateTime.from(TimezoneRules.parse('America/Detroit'), 2023, 11, 5, 1, 30));
  // print(ZonedDateTime.from(TimezoneRules.parse('America/Detroit'), 2023, 11, 6));

  print(ZonedDateTime.from(TimezoneRules.parse('Europe/Berlin'), 2023, 3, 26, 2));
  print(ZonedDateTime.from(TimezoneRules.parse('Europe/Berlin'), 2023, 3, 26, 3));
  //
  // print(ZonedDateTime.from(TimezoneRules.parse('America/Detroit'), 2023, 3, 12, 2));
  // print(ZonedDateTime.from(TimezoneRules.parse('America/Detroit'), 2023, 3, 12, 3));
}
