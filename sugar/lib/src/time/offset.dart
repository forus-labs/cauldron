import 'package:meta/meta.dart';

import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/sugar.dart';

part 'offsets.dart';

/// An offset is the time difference between a timezone and UTC.
///
/// A positive offset indicates a timezone ahead of UTC, while a negative offset indicates a timezone behind UTC.
///
/// ![Map of the world](https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/World_Time_Zones_Map.png/650px-World_Time_Zones_Map.png)
///
/// An [Offset] is immutable. It is always in the range, `-18:00` to `+18:00`, inclusive.
///
/// Offsets are stored to second precision. This allows all offsets in the TZ database to be represented. It can cause
/// issues in rare or fictional cases when used with other timezone data sources.
///
/// See:
/// * [OffsetTime] to represent times with fixed offsets.
/// * [ZonedDateTime] to represent date-times with timezones.
sealed class Offset with Orderable<Offset> {
  /// The valid range of [Offset]s, from `-18:00` to `+18:00`, inclusive.
  ///
  /// As of February 2023, actual offsets range from `-12:00` to `+14:00`, inclusive. The range was last extended in 1995
  /// when the island of Kiribati moved its timezone eastward by one day, leading to the creation of `+14:00`. To ensure
  /// forward compatibility, the range is restricted to `-18:00` to `+18:00`, inclusive.
  static final Interval<Offset> range = Interval.closed(
    const LiteralOffset('-18:00', -64800),
    const LiteralOffset('+18:00', 64800),
  );

  /// An offset of zero.
  static const Offset utc = LiteralOffset('Z', 0);

  final int _microseconds;

  /// Creates an [Offset] from the formatted [offset].
  ///
  /// The following formats, including the result of [toString], are accepted:
  /// * `Z` - for UTC
  /// * `+h`
  /// * `+hh`
  /// * `+hh:mm`
  /// * `-hh:mm`
  /// * `+hhmm`
  /// * `-hhmm`
  /// * `+hh:mm:ss`
  /// * `-hh:mm:ss`
  /// * `+hhmmss`
  /// * `-hhmmss`
  ///
  /// ## Contract
  /// Throws [RangeError] if [offset] is outside the valid [range].
  /// Throws [FormatException] if [offset] is malformed.
  ///
  /// ## Example
  /// ```dart
  /// Offset.parse('-01:02:03'); // '-01:02:03'
  ///
  /// Offset.parse('-1:2:3') // throws FormatException
  ///
  /// Offset.parse('-19:00:00'); // throws RangeError
  /// ```
  @Possible({FormatException, RangeError})
  factory Offset.parse(String offset) => _Offset.parse(offset);

  /// Creates an [Offset] that represents the current offset.
  factory Offset.now() => _Offset.now();

  /// Creates an [Offset] from the total [seconds].
  ///
  /// ## Contract
  /// Throws a [RangeError] if [seconds] is outside the valid [range].
  ///
  /// ## Example
  /// ```dart
  /// Offset.fromSeconds(28800); // +08:00
  /// ```
  @Possible({RangeError})
  factory Offset.fromSeconds(int seconds) => _Offset.fromSeconds(seconds);

  /// Creates an [Offset] from the total [microseconds], truncated to the nearest second.
  ///
  /// ## Contract
  /// Throws a [RangeError] if [microseconds] is outside the valid [range].
  ///
  /// ## Example
  /// ```dart
  /// Offset.fromMicroseconds(28800000000); // +08:00
  /// ```
  @Possible({RangeError})
  factory Offset.fromMicroseconds(int microseconds) => _Offset.fromMicroseconds(microseconds);

  /// Creates an [Offset].
  ///
  /// ## Contract
  /// Throws a [RangeError] if the [Offset] is outside the valid [range].
  ///
  /// ## Example
  /// ```dart
  /// Offset(-10, 0, 0); // -10:00
  ///
  /// Offset(-10, -2, -3)); // throws RangeError
  ///
  /// Offset(-10, 2, 3)); // -10:02:03
  /// ```
  @Possible({RangeError})
  factory Offset([int hour = 0, int minute = 0, int second = 0]) => _Offset(hour, minute, second);

  const Offset._(this._microseconds);

  /// Returns a copy of this with the [duration] added.
  ///
  /// ## Contract
  /// Throws a [RangeError] if the result is outside the valid [range].
  ///
  /// ## Example
  /// ```dart
  /// Offset(16).add(Duration(hours: 2)); // Offset(18)
  ///
  /// Offset(18).add(Duration(hours: 2)); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  Offset add(Duration duration) => Offset.fromMicroseconds(_microseconds + duration.inSeconds * 1000 * 1000);

  /// Returns a copy of this with the [duration] subtracted.
  ///
  /// ## Contract
  /// Throws a [RangeError] if the result is outside the valid [range].
  ///
  /// ## Example
  /// ```dart
  /// Offset(-16).subtract(Duration(hours: 2)); // Offset(-18)
  ///
  /// Offset(-18).subtract(Duration(hours: 2)); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  Offset subtract(Duration duration) => Offset.fromMicroseconds(_microseconds - duration.inSeconds * 1000 * 1000);

  /// Returns a copy of this with the sum of the units of time added.
  ///
  /// ## Contract
  /// Throws a [RangeError] if the result is outside the valid [range].
  ///
  /// ## Example
  /// ```dart
  /// Offset(16).plus(hours: 2); // Offset(18)
  ///
  /// Offset(18).plus(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  Offset plus({int hours = 0, int minutes = 0, int seconds = 0}) =>
      Offset.fromMicroseconds(_microseconds + sumMicroseconds(hours, minutes, seconds));

  /// Returns a copy of this with the sum of the units of time subtracted.
  ///
  /// ## Contract
  /// Throws a [RangeError] if the result is outside the valid [range].
  ///
  /// ## Example
  /// ```dart
  /// Offset(-16).minus(hours: 2); // Offset(-18)
  ///
  /// Offset(-18).minus(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  Offset minus({int hours = 0, int minutes = 0, int seconds = 0}) =>
      Offset.fromMicroseconds(_microseconds - sumMicroseconds(hours, minutes, seconds));

  /// Returns a copy of this with the sum of the units of time added.
  ///
  /// Otherwise returns `null` if the result is outside the valid [range].
  ///
  /// ```dart
  /// Offset(16).tryPlus(hours: 2); // Offset(18)
  ///
  /// Offset(18).tryPlus(hours: 2); // null
  /// ```
  @useResult
  Offset? tryPlus({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = _microseconds + sumMicroseconds(hours, minutes, seconds);
    if (-18 * Duration.microsecondsPerHour <= total && total <= 18 * Duration.microsecondsPerHour) {
      return Offset.fromMicroseconds(total);
    } else {
      return null;
    }
  }

  /// Returns a copy of this with the sum of the units of time subtracted.
  ///
  /// Otherwise returns `null` if the result is outside the valid [range].
  ///
  /// ```dart
  /// Offset(-16).tryMinus(hours: 2); // Offset(-18)
  ///
  /// Offset(-18).tryMinus(hours: 2); // null
  /// ```
  @useResult
  Offset? tryMinus({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = _microseconds - sumMicroseconds(hours, minutes, seconds);
    if (-18 * Duration.microsecondsPerHour <= total && total <= 18 * Duration.microsecondsPerHour) {
      return Offset.fromMicroseconds(total);
    } else {
      return null;
    }
  }

  /// Returns the difference between this and [other].
  ///
  /// The difference may be negative.
  ///
  /// ```dart
  /// Offset(-1).difference(Offset(2)); // Duration(hours: -3)
  /// ```
  @useResult
  Duration difference(Offset other) => Duration(microseconds: _microseconds - other._microseconds);

  /// Convert this to a [Duration].
  ///
  /// ```dart
  /// Offset(1, 2, 3).toDuration(); // Duration(hours: 1, minutes: 2, seconds: 3)
  /// ```
  @useResult
  Duration toDuration() => Duration(microseconds: _microseconds);

  /// This offset in seconds.
  int get inSeconds => _microseconds ~/ 1000 ~/ 1000;

  /// This offset in milliseconds.
  int get inMilliseconds => _microseconds ~/ 1000;

  /// This offset in microseconds.
  int get inMicroseconds => _microseconds;

  // This method is overridden to allow equality between [_Offset]s and [RawOffset]s.
  @override
  @nonVirtual
  @useResult
  bool operator ==(Object other) => // ignore: hash_and_equals, invalid_override_of_non_virtual_member
      identical(this, other) ||
      other is Offset && (runtimeType == _Offset || runtimeType == LiteralOffset) && compareTo(other) == 0;

  @override
  @useResult
  int compareTo(Offset other) => _microseconds.compareTo(other._microseconds);

  @override
  @useResult
  int get hashValue => _microseconds.hashCode;

  /// Returns an offset ID. The ID is a minor variation of an ISO-8601 formatted offset string.
  ///
  /// There are three formats:
  /// * `Z` - for UTC (ISO-8601)
  /// * `+hh:mm`/`-hh:mm` - if the _seconds are zero (ISO-8601)
  /// * `+hh:mm:ss`/`-hh:mm:ss` - if the _seconds are non-zero (not ISO-8601)
  ///
  /// ```dart
  /// print(Offset()); // 'Z'
  ///
  /// print(Offset(1, 2)); // '+01:02'
  ///
  /// print(Offset(1, 2, 3)); // '+01:02:03'
  /// ```
  @override
  @mustBeOverridden
  @useResult
  String toString();
}
