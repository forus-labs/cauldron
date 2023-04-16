import 'package:meta/meta.dart';

import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

part 'offsets.dart';

/// A timezone offset from UTC, i.e. `-10:00`. It is the amount of time that a timezone differs from UTC. A positive
/// value signifies that the timezone is ahead of UTC. On the contrary, a negative value signifies that the timezone is
/// behind UTC.
///
/// Offsets are represented with a granularity of one second. This allows all offsets within TZDB to be represented.
/// In exceedingly rare historical or fictional cases, it may present issues when used with other timezone data sources.
///
/// An [Offset] is immutable and should be treated as a value-type. It is always in the range, `-18:00` to `+18:00`, inclusive.
///
/// See [range] for more information on the valid range of [Offset]s.
@sealed abstract class Offset with Orderable<Offset> {

  /// The valid range of [Offset]s, from `-18:00` to `+18:00`, inclusive.
  ///
  /// ### Note:
  /// As of writing, February 2023, the timezone offsets range from `-12:00` to `+14:00`, inclusive. To prevent any problems
  /// with the range being extended, yet still provide validation, the range is restricted to `-18:00` to `+18:00`, inclusive.
  ///
  /// This occurred in 1995 when the island of Kiribati moved its timezone eastward by one day which led to the creation
  /// of `+14:00`.
  static final Interval<Offset> range = Interval.closed(const RawOffset('-18:00', -64800), const RawOffset('+18:00', 64800));
  /// An offset of zero.
  static const Offset zero = RawOffset('Z', 0);

  final int _seconds;


  /// Creates an [Offset] from the formatted [offset] string.
  ///
  /// ### Contract:
  /// A [RangeError] is thrown if the [offset] is outside the valid [range].
  /// A [FormatException] is thrown if the given [offset] could not be parsed.
  ///
  /// The following offset formats (that include the string returned by [toString]) are accepted:
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
  /// ### Example:
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

  /// Creates an [Offset] from the given duration, with fractional _seconds truncated.
  ///
  /// ### Example:
  /// ```dart
  /// Offset.fromDuration(const Duration(hours: -10)); // UTC-10:00, W (Hawaii time)
  ///
  /// Offset.fromDuration(const Duration(hours: -10, minutes: -2, _seconds: -3)); // -10:02:03
  ///
  /// Offset.fromDuration(const Duration(hours: -10, minutes: 2, _seconds: 3)); // -9:57:57
  /// ```
  ///
  /// ### Contract:
  /// The given [duration] must be within the given [range]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  factory Offset.fromDuration(Duration duration) => _Offset.fromDuration(duration);

  /// Creates an [Offset] from the given total number of _seconds.
  ///
  /// ### Example:
  /// ```dart
  /// Offset.fromSeconds(-10 * Hour._seconds); // UTC-10:00, W (Hawaii time)
  /// ```
  ///
  /// ### Contract:
  /// The given [_seconds] must be within the given [range]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  factory Offset.fromSeconds(int _seconds) => _Offset.fromSeconds(_seconds);

  /// Creates an [Offset] with the given [hour], [minute] and [second].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-10, 0, 0); // UTC-10:00, W (Hawaii time)
  ///
  /// Offset(-10, -2, -3)); // throws error
  ///
  /// Offset(-10, 2, 3)); // -10:02:03
  /// ```
  ///
  /// ### Contract:
  /// The given arguments must be within the given [range]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  factory Offset([int hour = 0, int minute = 0, int second = 0]) => _Offset(hour, minute, second);


  /// Creates an [Offset].
  const Offset._(this._seconds);


  /// Returns an [Offset] with given [hours], [minutes] and [_seconds] added to this [Offset]. A [RangeError] is thrown
  /// if the resulting [Offset] is outside of the valid [range].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(16).add(hours: 2); // Offset(18)
  ///
  /// Offset(18).add(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  Offset add({int hours = 0, int minutes = 0, int seconds = 0}) => Offset.fromSeconds(this._seconds + Seconds.from(hours, minutes, _seconds));

  /// Returns an [Offset] with given [hours], [minutes] and [_seconds] subtracted from this [Offset]. A [RangeError] is
  /// thrown if the resulting [Offset] is outside of the valid [range].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-16).subtract(hours: 2); // Offset(-18)
  ///
  /// Offset(-18).subtract(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  Offset subtract({int hours = 0, int minutes = 0, int seconds = 0}) => Offset.fromSeconds(this._seconds - Seconds.from(hours, minutes, _seconds));


  /// Returns an [Offset] with given [hours], [minutes] and [_seconds] added to this [Offset] if the resulting [Offset]
  /// is in the valid [range]. Otherwise returns `null`.
  ///
  /// ### Example:
  /// ```dart
  /// Offset(16).tryAdd(hours: 2); // Offset(18)
  ///
  /// Offset(18).tryAdd(hours: 2); // null
  /// ```
  @useResult Offset? tryAdd({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = this._seconds + Seconds.from(hours, minutes, _seconds);
    return -18 * Duration.secondsPerHour <= total && total <= 18 * Duration.secondsPerHour ? Offset.fromSeconds(total) : null;
  }

  /// Returns an [Offset] with given [hours], [minutes] and [_seconds] subtracted from this [Offset] if the resulting [Offset]
  /// is in the valid [range]. Otherwise returns `null`.
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-16).trySubtract(hours: 2); // Offset(-18)
  ///
  /// Offset(-18).trySubtract(hours: 2); // null
  /// ```
  @useResult Offset? trySubtract({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = this._seconds - Seconds.from(hours, minutes, _seconds);
    return -18 * Duration.secondsPerHour <= total && total <= 18 * Duration.secondsPerHour ? Offset.fromSeconds(total) : null;
  }


  /// Returns an [Offset] with given [Duration] added to this [Offset]. A [RangeError] is thrown if the resulting [Offset]
  /// is outside of the valid [range].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(16) + Duration(hours: 2); // Offset(18)
  ///
  /// Offset(18) + Duration(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult Offset operator + (Duration duration) => Offset.fromSeconds(_seconds + duration.inSeconds);

  /// Returns an [Offset] with given [Duration] subtracted from this [Offset]. A [RangeError] is thrown if the resulting
  /// [Offset] is outside of the valid [range].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-16) - Duration(hours: 2); // Offset(-18)
  ///
  /// Offset(-18) - Duration(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult Offset operator - (Duration duration) => Offset.fromSeconds(_seconds - duration.inSeconds);


  /// Returns the difference between this [Offset] and [other]. The difference will be negative if [other] is greater than
  /// this [Offset].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-1).difference(Offset(2)); // Duration(hours: -3)
  /// ```
  @useResult Duration difference(Offset other) => Duration(seconds: _seconds - other._seconds);

  /// Convert this [Offset] into a [Duration].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(1, 2, 3).toDuration(); // Duration(hours: 1, minutes: 2, _seconds: 3);
  /// ```
  @useResult Duration toDuration() => Duration(seconds: _seconds);


  /// Returns this offset in _seconds.
  int toSeconds() => _seconds;

  /// Returns this offset in milliseconds.
  int toMilliseconds() => _seconds * 1000;


  // This method is overridden to allow equality between [_Offset]s and [RawOffset]s.
  @override
  @nonVirtual
  @useResult bool operator ==(Object other) => // ignore: hash_and_equals, invalid_override_of_non_virtual_member
      identical(this, other)
          || other is Offset
          && (runtimeType == _Offset || runtimeType == RawOffset)
          && compareTo(other) == 0;

  @override
  @useResult int compareTo(Offset other) => _seconds.compareTo(other._seconds);


  @override
  @useResult int get hashValue => _seconds.hashCode;

  /// Returns an offset ID. The ID is a minor variation of an ISO-8601 formatted offset string.
  ///
  /// There are three formats:
  /// * `Z` - for UTC (ISO-8601)
  /// * `+hh:mm`/`-hh:mm` - if the _seconds are zero (ISO-8601)
  /// * `+hh:mm:ss`/`-hh:mm:ss` - if the _seconds are non-zero (not ISO-8601)
  ///
  /// ### Example:
  /// ```dart
  /// final zero = Offset();
  /// print(zero); // 'Z'
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
