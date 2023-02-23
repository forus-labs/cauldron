import 'package:sugar/core.dart';
import 'package:sugar/time.dart';

class Offset with Orderable<Offset> {

  /// The valid range of [Offset]s, from `-18:00` to `+18:00`, inclusive.
  ///
  /// ### Note:
  /// As of writing, the timezone offsets range from `-12:00` to `+14:00`, inclusive. To prevent any problems with
  /// the range being extended, yet still provide validation, the range is restricted to `-18:00` to `+18:00`, inclusive.
  ///
  /// This occurred in 1995 when the island of Kiribati moved its timezone eastward by one day which led to the creation
  /// of `+14:00`.
  static final Interval<Offset> range = Interval.closed(Offset(-18), Offset(18));

  final int _seconds;
  String? _id;


  /// Creates an [Offset] for the current timezone.
  Offset.current(): this.fromDuration(DateTime.now().timeZoneOffset);

  /// Creates an [Offset] from the given duration, with fractional seconds truncated.
  ///
  /// ```dart
  /// Offset.fromDuration(const Duration(hours: -10)); // UTC-10:00, W (Hawaii time)
  /// ```
  ///
  /// ### Contract:
  /// The given [duration] must be within the given [range]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Offset.fromDuration(Duration duration): _seconds = duration.inSeconds {
    RangeError.checkValueInInterval(_seconds, -18 * Duration.secondsPerHour, 18 * Duration.secondsPerHour, 'duration');
  }

  /// Creates an [Offset] from the given total number of seconds.
  ///
  /// ```dart
  /// Offset.fromSeconds(-10 * Hour.seconds); // UTC-10:00, W (Hawaii time)
  /// ```
  ///
  /// ### Contract:
  /// The given [seconds] must be within the given [range]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Offset.fromSeconds(int seconds): _seconds = seconds {
    RangeError.checkValueInInterval(seconds, -18 * Duration.secondsPerHour, 18 * Duration.secondsPerHour, 'seconds');
  }

  /// Creates an [Offset] with the given [hour], [minute] and [second].
  ///
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

  // TODO: Offset.parse(...)

  // TODO: addition & subtraction (operator on duration + on individual components)

  // TODO: to duration

  // TODO: in minutes/seconds?


  @override
  int compareTo(Offset other) => _seconds.compareTo(other._seconds);

  @override
  int get hashValue => Object.hash(runtimeType, _seconds);

  /// Returns an offset ID.
  ///
  /// An offset ID is a minor variation to the standard ISO-8601 formatted offset string.
  ///
  /// There are three formats:
  /// * `Z` - for UTC (ISO-8601)
  /// * `+hh:mm`/`-hh:mm` - if seconds are zero (ISO-8601)
  /// * `+hh:mm:ss`/`-hh:mm:ss` - if the seconds are non-zero (not ISO-8601)
  @override
  String toString() => _id ??= _string;

  String get _string {
    if (_seconds == 0) {
      return 'Z';
    }

    var value = _seconds;

    final second = (value % 60).toString().padLeft(2, '0');
    value ~/= 60;

    final minute = (value % 60).toString().padLeft(2, '0');
    value ~/= 60;

    final hour = (value % 60).toString().padLeft(2, '0');
    final sign = _seconds > 0 ? '+' : '-';

    return'$sign$hour:$minute${second == '00' ? '' : ':$second'}';
  }
  
}