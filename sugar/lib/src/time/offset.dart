import 'package:meta/meta.dart';

import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

const _allowed = '''
The following offset formats are accepted:
 * Z - for UTC
 * +h
 * +hh
 * +hh:mm
 * -hh:mm
 * +hhmm
 * -hhmm
 * +hh:mm:ss
 * -hh:mm:ss
 * +hhmmss
 * -hhmmss
''';

/// A timezone offset from UTC, i.e. `-10:00`. It is the amount of time that a timezone differs from UTC. A positive
/// value signifies that the timezone is ahead of UTC. On the contrary, a negative value signifies that the timezone is
/// behind UTC.
///
/// Offsets are represented with a granularity of one second. This allows all offsets within TZDB to be represented.
/// In exceedingly rare historical or fictional cases, it may present issues when used with other timezone data sources.
///
/// An [Offset] is immutable and should be treated as a value-type. It is always in the range, `-18:00` to `+18:00`, inclusive.
/// See [range] for more information on the valid range of [Offset]s.
@sealed class Offset with Orderable<Offset> {

  /// The valid range of [Offset]s, from `-18:00` to `+18:00`, inclusive.
  ///
  /// ### Note:
  /// As of writing, February 2023, the timezone offsets range from `-12:00` to `+14:00`, inclusive. To prevent any problems
  /// with the range being extended, yet still provide validation, the range is restricted to `-18:00` to `+18:00`, inclusive.
  ///
  /// This occurred in 1995 when the island of Kiribati moved its timezone eastward by one day which led to the creation
  /// of `+14:00`.
  static final Interval<Offset> range = Interval.closed(Offset(-18), Offset(18));

  /// Determines if the given [seconds] is within [range]. Throws a [RangeError] otherwise.
  ///
  /// This method differs from [RangeError.checkValueInInterval] as it parses the seconds into a more human-friendly format.
  @Possible({RangeError})
  static void _precondition(int seconds) {
    if (seconds < -18 * Duration.secondsPerHour || 18 * Duration.secondsPerHour < seconds) {
      throw RangeError('Invalid offset: ${_format(seconds)}, offset is out of bounds. Valid range: "-18:00 <= offset <= +18:00"');
    }
  }

  /// Returns an offset ID. The ID is a minor variation of an ISO-8601 formatted offset string.
  ///
  /// There are three formats:
  /// * `Z` - for UTC (ISO-8601)
  /// * `+hh:mm`/`-hh:mm` - if the seconds are zero (ISO-8601)
  /// * `+hh:mm:ss`/`-hh:mm:ss` - if the seconds are non-zero (not ISO-8601)
  static String _format(int seconds) {
    if (seconds == 0) {
      return 'Z';
    }

    final second = seconds % 60;
    seconds ~/= 60;

    final minute = seconds % 60;
    seconds ~/= 60;

    final hour = seconds % 60;

    final sign = hour.isNegative ? '' : '+';
    final hours = hour.toString().padLeft(2, '0');
    final minutes = minute.toString().padLeft(2, '0');
    final suffix = second == 0 ? '' : ':${second.toString().padLeft(2, '0')}';

    return '$sign$hours:$minutes$suffix';
  }
  
  
  final int _seconds;
  String? _string;


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
  factory Offset.parse(String offset) {
    if (offset == 'Z') {
      return Offset();
    }

    // Derived from Java's java.time.ZoneOffset.of(String)

    int parse(int position, {required bool colon}) {
      if (colon && offset[position - 1] != ':') {
        throw FormatException('Invalid offset format: "$offset". A colon was not found when expected. \n$_allowed');
      }

      final parsed = int.tryParse(offset.substring(position, position + 2));
      if (parsed == null || parsed.isNegative) {
        throw FormatException('Invalid offset format: "$offset". A non-numeric character was found. \n$_allowed');
      }

      return parsed;
    }
    
    late final int hour, minute, second; // ignore: avoid_multiple_declarations_per_line
    switch (offset.length) {
      case 2:
        offset = '${offset[0]}0${offset[1]}';
        continue fallthrough;
        
      fallthrough:
      case 3:
        hour = parse(1, colon: false);
        minute = 0;
        second = 0;
        break;

      case 5:
        hour = parse(1, colon: false);
        minute = parse(3, colon: false);
        second = 0;
        break;

      case 6:
        hour = parse(1, colon: false);
        minute = parse(4, colon: true);
        second = 0;
        break;

      case 7:
        hour = parse(1, colon: false);
        minute = parse(3, colon: false);
        second = parse(5, colon: false);
        break;

      case 9:
        hour = parse(1, colon: false);
        minute = parse(4, colon: true);
        second = parse(7, colon: true);
        break;

      default:
        throw FormatException('Invalid offset format: "$offset". \n$_allowed');
    }

    final sign = offset[0];
    if (sign == '+') {
      return Offset(hour, minute, second);

    } else if (sign == '-') {
      return Offset(-hour, minute, second);

    } else {
      throw FormatException('Invalid offset format: "$offset". Offset should start with "+" or "-". \n$_allowed');
    }
  }

  /// Creates an [Offset] for the current timezone.
  Offset.current(): this.fromDuration(DateTime.now().timeZoneOffset);
  
  /// Creates an [Offset] from the given duration, with fractional seconds truncated.
  ///
  /// ### Example:
  /// ```dart
  /// Offset.fromDuration(const Duration(hours: -10)); // UTC-10:00, W (Hawaii time)
  /// ```
  ///
  /// ### Contract:
  /// The given [duration] must be within the given [range]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Offset.fromDuration(Duration duration): _seconds = duration.inSeconds {
    _precondition(_seconds);
  }

  /// Creates an [Offset] from the given total number of seconds.
  ///
  /// ### Example:
  /// ```dart
  /// Offset.fromSeconds(-10 * Hour.seconds); // UTC-10:00, W (Hawaii time)
  /// ```
  ///
  /// ### Contract:
  /// The given [seconds] must be within the given [range]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Offset.fromSeconds(int seconds): _seconds = seconds {
    _precondition(_seconds);
  }

  /// Creates an [Offset] with the given [hour], [minute] and [second].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-10, 0, 0); // UTC-10:00, W (Hawaii time)
  /// ```
  ///
  /// ### Contract:
  /// The given arguments must be within the given [range]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Offset([int hour = 0, int minute = 0, int second = 0]): _seconds = Seconds.from(hour, minute, second) {
    RangeError.checkValueInInterval(hour, -18, 18, 'hour');
    RangeError.checkValueInInterval(minute, 0, 60, 'minute');
    RangeError.checkValueInInterval(hour, 0, 60, 'second');
  }


  /// Returns an [Offset] with given [hours], [minutes] and [seconds] added to this [Offset]. A [RangeError] is thrown
  /// if the resulting [Offset] is outside of the valid [range].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(16).add(hours: 2); // Offset(18)
  ///
  /// Offset(18).add(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  Offset add({int hours = 0, int minutes = 0, int seconds = 0}) => Offset.fromSeconds(
    _seconds + Seconds.from(hours, minutes, seconds),
  );

  /// Returns an [Offset] with given [hours], [minutes] and [seconds] subtracted from this [Offset]. A [RangeError] is
  /// thrown if the resulting [Offset] is outside of the valid [range].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-16).subtract(hours: 2); // Offset(-18)
  ///
  /// Offset(-18).subtract(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  Offset subtract({int hours = 0, int minutes = 0, int seconds = 0}) => Offset.fromSeconds(
    _seconds - Seconds.from(hours, minutes, seconds),
  );


  /// Returns an [Offset] with given [hours], [minutes] and [seconds] added to this [Offset] if the resulting [Offset]
  /// is in the valid [range]. Otherwise returns `null`.
  ///
  /// ### Example:
  /// ```dart
  /// Offset(16).tryAdd(hours: 2); // Offset(18)
  ///
  /// Offset(18).tryAdd(hours: 2); // null
  /// ```
  Offset? tryAdd({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = _seconds + Seconds.from(hours, minutes, seconds);
    return -18 * Duration.secondsPerHour <= total && total <= 18 * Duration.secondsPerHour ? Offset.fromSeconds(total) : null;
  }

  /// Returns an [Offset] with given [hours], [minutes] and [seconds] subtracted from this [Offset] if the resulting [Offset]
  /// is in the valid [range]. Otherwise returns `null`.
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-16).trySubtract(hours: 2); // Offset(-18)
  ///
  /// Offset(-18).trySubtract(hours: 2); // null
  /// ```
  @useResult
  Offset? trySubtract({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = _seconds - Seconds.from(hours, minutes, seconds);
    return -18 * Duration.secondsPerHour <= total && total <= 18 * Duration.secondsPerHour ? Offset.fromSeconds(total) : null;
  }


  /// Returns an [Offset] with given [Duration] added to this [Offset]. A [RangeError] is thrown if the resulting [Offset]
  /// is outside of the valid [range].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(16) + const Duration(hours: 2); // Offset(18)
  ///
  /// Offset(18) + const Duration(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  Offset operator + (Duration duration) => Offset.fromSeconds(_seconds + duration.inSeconds);

  /// Returns an [Offset] with given [Duration] subtracted from this [Offset]. A [RangeError] is thrown if the resulting
  /// [Offset] is outside of the valid [range].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-16) - const Duration(hours: 2); // Offset(-18)
  ///
  /// Offset(-18) - const Duration(hours: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  Offset operator - (Duration duration) => Offset.fromSeconds(_seconds - duration.inSeconds);


  /// Returns the difference between this [Offset] and [other]. The difference will be negative if [other] is greater than
  /// this [Offset].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(-1).difference(Offset(2)); // Duration(hours: -3)
  /// ```
  Duration difference(Offset other) => Duration(seconds: _seconds - other._seconds);

  /// Convert this [Offset] into a [Duration].
  ///
  /// ### Example:
  /// ```dart
  /// Offset(1, 2, 3).toDuration(); // Duration(hours: 1, minutes: 2, seconds: 3);
  /// ```
  Duration toDuration() => Duration(seconds: _seconds);


  @override
  @useResult
  int compareTo(Offset other) => _seconds.compareTo(other._seconds);

  @override
  @useResult
  int get hashValue => Object.hash(runtimeType, _seconds);

  /// Returns an offset ID. The ID is a minor variation of an ISO-8601 formatted offset string.
  ///
  /// There are three formats:
  /// * `Z` - for UTC (ISO-8601)
  /// * `+hh:mm`/`-hh:mm` - if the seconds are zero (ISO-8601)
  /// * `+hh:mm:ss`/`-hh:mm:ss` - if the seconds are non-zero (not ISO-8601)
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
  String toString() => _string ??= _format(_seconds);

}
