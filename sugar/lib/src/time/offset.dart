import 'package:meta/meta.dart';

import 'package:sugar/core.dart';
import 'package:sugar/src/time/temporal_unit.dart';

part 'offsets.dart';

/// An offset is the amount of time that a timezone differs from UTC. A positive and negative offset signifies that the
/// timezone is ahead and behind of UTC respectively.
///
/// ![Map of the world](https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/World_Time_Zones_Map.png/650px-World_Time_Zones_Map.png)
///
/// Offsets are stored to second precision. This allows all offsets in the TZ database to be represented. It may present
/// issues in obscure or fictional cases when used with other timezone data sources.
///
/// An [Offset] is immutable and should be treated as a value-type. It is always in the range, `-18:00` to `+18:00`, inclusive.
@sealed abstract class Offset with Orderable<Offset> {

  /// The valid range of [Offset]s, from `-18:00` to `+18:00`, inclusive.
  ///
  /// ## Note:
  /// As of February 2023, actual offsets range from `-12:00` to `+14:00`, inclusive. To ensure forward compatibility,
  /// the range is restricted to `-18:00` to `+18:00`, inclusive. The range was last extended in 1995 when the island of
  /// Kiribati moved its timezone eastward by one day, leading to the creation of `+14:00`.
  static final Interval<Offset> range = Interval.closed(const LiteralOffset('-18:00', -64800), const LiteralOffset('+18:00', 64800));
  /// An offset of zero.
  static const Offset utc = LiteralOffset('Z', 0);

  final int _microseconds;


  /// Creates an [Offset] from the formatted [offset].
  ///
  /// ## Contract:
  /// Throws [RangeError] if the [offset] is outside the valid [range].
  /// Throws [FormatException] if the [offset] is malformed.
  ///
  /// The following formats, which include the string returned by [toString], are accepted:
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
  /// ## Example:
  /// ```dart
  /// Offset.parse('-01:02:03'); // '-01:02:03'
  ///
  /// Offset.parse('-1:2:3') // throws FormatException
  ///
  /// Offset.parse('-19:00:00'); // throws RangeError
  /// ```
  @Possible({FormatException, RangeError})
  factory Offset.parse(String offset) => _Offset.parse(offset);

  /// Creates an [Offset] for the current timezone.
  factory Offset.current() => _Offset.current();

  /// Creates an [Offset] from the total seconds. Throws a [RangeError] if [seconds] is outside the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset.fromSeconds(28800); // UTC+8
  /// ```
  @Possible({RangeError})
  factory Offset.fromSeconds(int seconds) => _Offset.fromSeconds(seconds);

  /// Creates an [Offset] from the total microseconds, truncated to the nearest second. Throws a [RangeError] if [microseconds]
  /// is outside the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset.fromMicroseconds(28800000000); // UTC+8
  /// ```
  @Possible({RangeError})
  factory Offset.fromMicroseconds(int microseconds) => _Offset.fromMicroseconds(microseconds);

  /// Creates an [Offset] from the individual parts. Throws a [RangeError] if the [Offset] is outside the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset(-10, 0, 0); // UTC-10:00
  ///
  /// Offset(-10, -2, -3)); // throws error
  ///
  /// Offset(-10, 2, 3)); // -10:02:03
  /// ```
  @Possible({RangeError})
  factory Offset([int hour = 0, int minute = 0, int second = 0]) => _Offset(hour, minute, second);

  /// Creates an [Offset].
  const Offset._(this._microseconds);


  /// Returns a copy of this [Offset] with the sum of the individual parts added. Throws a [RangeError] if the [Offset] is
  /// outside the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset(16).add(hours: 2); // Offset(18)
  ///
  /// Offset(18).add(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  Offset add({int hours = 0, int minutes = 0, int seconds = 0}) => Offset.fromMicroseconds(_microseconds + sumMicroseconds(hours, minutes, seconds));

  /// Returns a copy of this [Offset] with the sum of the individual parts subtracted. Throws a [RangeError] if the [Offset]
  /// is outside the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset(-16).subtract(hours: 2); // Offset(-18)
  ///
  /// Offset(-18).subtract(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  Offset subtract({int hours = 0, int minutes = 0, int seconds = 0}) => Offset.fromMicroseconds(_microseconds - sumMicroseconds(hours, minutes, seconds));


  /// Returns a copy of this [Offset] with the sum of the individual parts added. Otherwise returns `null` if the [Offset]
  /// is outside the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset(16).tryAdd(hours: 2); // Offset(18)
  ///
  /// Offset(18).tryAdd(hours: 2); // null
  /// ```
  @useResult Offset? tryAdd({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = _microseconds + sumMicroseconds(hours, minutes, seconds);
    if (-18 * Duration.microsecondsPerHour <= total && total <= 18 * Duration.microsecondsPerHour) {
      return Offset.fromMicroseconds(total);
    } else {
      return null;
    }
  }

  /// Returns a copy of this [Offset] with the sum of the individual parts subtracted. Otherwise returns `null` if the
  /// [Offset] is outside the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset(-16).trySubtract(hours: 2); // Offset(-18)
  ///
  /// Offset(-18).trySubtract(hours: 2); // null
  /// ```
  @useResult Offset? trySubtract({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = _microseconds - sumMicroseconds(hours, minutes, seconds);
    if (-18 * Duration.microsecondsPerHour <= total && total <= 18 * Duration.microsecondsPerHour) {
      return Offset.fromMicroseconds(total);
    } else {
      return null;
    }
  }


  /// Returns a copy of this [Offset] with the [duration] added. Throws a [RangeError] if the [Offset] is outside the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset(16).plus(Duration(hours: 2)); // Offset(18)
  ///
  /// Offset(18).plus(Duration(hours: 2)); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult Offset plus(Duration duration) => Offset.fromMicroseconds(_microseconds + duration.inMicroseconds);

  /// Returns a copy of this [Offset] with the [duration] subtracted. Throws a [RangeError] if the [Offset] is outside
  /// the valid [range].
  ///
  /// ## Example:
  /// ```dart
  /// Offset(-16).minus(Duration(hours: 2)); // Offset(-18)
  ///
  /// Offset(-18).minus(Duration(hours: 2)); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult Offset minus(Duration duration) => Offset.fromMicroseconds(_microseconds - duration.inMicroseconds);


  // TODO: add period


  /// Returns the difference between the two offsets. The difference may be negative.
  ///
  /// ## Example:
  /// ```dart
  /// Offset(-1).difference(Offset(2)); // Duration(hours: -3)
  /// ```
  @useResult Duration difference(Offset other) => Duration(microseconds: _microseconds - other._microseconds);

  /// Convert this [Offset] into a [Duration].
  ///
  /// ## Example:
  /// ```dart
  /// // Duration(hours: 1, minutes: 2, _seconds: 3);
  /// Offset(1, 2, 3).toDuration();
  /// ```
  @useResult Duration toDuration() => Duration(microseconds: _microseconds);


  /// Returns this offset in seconds.
  int toSeconds() => _microseconds ~/ 1000 ~/ 1000;

  /// Returns this offset in milliseconds.
  int toMicroseconds() => _microseconds;


  // This method is overridden to allow equality between [_Offset]s and [RawOffset]s.
  @override
  @nonVirtual
  @useResult bool operator ==(Object other) => // ignore: hash_and_equals, invalid_override_of_non_virtual_member
      identical(this, other)
          || other is Offset
          && (runtimeType == _Offset || runtimeType == LiteralOffset)
          && compareTo(other) == 0;

  @override
  @useResult int compareTo(Offset other) => _microseconds.compareTo(other._microseconds);


  @override
  @useResult int get hashValue => _microseconds.hashCode;

  /// Returns an offset ID. The ID is a minor variation of an ISO-8601 formatted offset string.
  ///
  /// There are three formats:
  /// * `Z` - for UTC (ISO-8601)
  /// * `+hh:mm`/`-hh:mm` - if the _seconds are zero (ISO-8601)
  /// * `+hh:mm:ss`/`-hh:mm:ss` - if the _seconds are non-zero (not ISO-8601)
  ///
  /// ## Example:
  /// ```dart
  /// final utc = Offset();
  /// print(utc); // 'Z'
  ///
  /// final foo = Offset(1, 2);
  /// print(foo); // '+01:02'
  ///
  /// final bar = Offset(1, 2, 3);
  /// print(bar); // '+01:02:03'
  /// ```
  @override
  @mustBeOverridden
  @useResult String toString();

}
