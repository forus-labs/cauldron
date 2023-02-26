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
  
  static void 
  
  
  final int _seconds;

  
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


  @Possible({RangeError})
  Offset add({int hours = 0, int minutes = 0, int seconds = 0}) => Offset.fromSeconds(
    _seconds + Seconds.from(hours, minutes, seconds),
  );
  
  @Possible({RangeError})
  Offset substract({int hours = 0, int minutes = 0, int seconds = 0}) => Offset.fromSeconds(
    _seconds - Seconds.from(hours, minutes, seconds),
  );
      
  @override
  int compareTo(Offset other) => _seconds.compareTo(other._seconds);

  @override
  int get hashValue => Object.hash(runtimeType, _seconds);

  @override
  String toString()

}