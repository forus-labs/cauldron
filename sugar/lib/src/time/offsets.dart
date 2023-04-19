part of 'offset.dart';

/// Returns an offset ID. The ID is a minor variation of an ISO-8601 formatted offset string.
///
/// There are three formats:
/// * `Z` - for UTC (ISO-8601)
/// * `+hh:mm`/`-hh:mm` - if the seconds are zero (ISO-8601)
/// * `+hh:mm:ss`/`-hh:mm:ss` - if the seconds are non-zero (not ISO-8601)
@internal String format(int microseconds) {
  if (microseconds == 0) {
    return 'Z';
  }

  var value = microseconds ~/ 1000 ~/ 1000;
  final sign = value.isNegative ? '-' : '+';
  value = value.abs();

  final second = value % 60;
  value ~/= 60;

  final minute = value % 60;
  value ~/= 60;

  final hour = value % 60;


  final hours = hour.toString().padLeft(2, '0');
  final minutes = minute.toString().padLeft(2, '0');
  final suffix = second == 0 ? '' : ':${second.toString().padLeft(2, '0')}';

  return '$sign$hours:$minutes$suffix';
}

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


/// An [Offset] that validates its value at compile-time. Since this does validate its value at runtime, the range invariant
/// may be violated. Hence, it is not available to external users.
@internal class LiteralOffset extends Offset {

  final String _string;

  /// Creates a [LiteralOffset].
  const LiteralOffset(this._string, int seconds): assert(
    -64800 <= seconds && seconds <= 64800,
    'Invalid offset: $seconds, offset is out of bounds. Valid range: "-64800 <= offset <= 64800"',
  ),  super._(seconds * Duration.microsecondsPerSecond);

  @override
  String toString() => _string;

}


/// An [Offset] that validates its value at runtime-time.
class _Offset extends Offset {

  /// Determines if the [microseconds] is within [range]. Throws a [RangeError] otherwise.
  ///
  /// This method differs from [RangeError.checkValueInInterval] as it parses the seconds into a more human-friendly format.
  @Possible({RangeError})
  static void _precondition(int microseconds) {
    if (microseconds < -18 * Duration.microsecondsPerHour || 18 * Duration.microsecondsPerHour < microseconds) {
      throw RangeError('Invalid offset: ${format(microseconds)}, offset is out of bounds. Valid range: "-18:00 <= offset <= +18:00"');
    }
  }


  String? _string;


  factory _Offset.parse(String offset) {
    if (offset == 'Z') {
      return _Offset();
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
      return _Offset(hour, minute, second);

    } else if (sign == '-') {
      return _Offset(-hour, minute, second);

    } else {
      throw FormatException('Invalid offset format: "$offset". Offset should start with "+" or "-". \n$_allowed');
    }
  }

  _Offset.current(): this.fromMicroseconds(DateTime.now().timeZoneOffset.inMicroseconds);
  
  _Offset.fromSeconds(int seconds): super._(seconds * Duration.microsecondsPerSecond) {
    _precondition(_microseconds);
  }

  _Offset.fromMicroseconds(super._microseconds): super._() {
    _precondition(_microseconds);
  }

  _Offset([int hour = 0, int minute = 0, int second = 0]): super._(_toMicroseconds(hour, minute, second)) {
    RangeError.checkValueInInterval(hour, -18, 18, 'hour');
    RangeError.checkValueInInterval(minute, 0, 59, 'minute');
    RangeError.checkValueInInterval(second, 0, 59, 'second');
    _precondition(_microseconds);
  }

  static int _toMicroseconds(int hour, int minute, int second) {
    if (hour.isNegative) {
      return -1 *  sumMicroseconds(hour.abs(), minute, second);
    } else {
      return sumMicroseconds(hour, minute, second);
    }
  }


  @override
  String toString() => _string ??= format(_microseconds);

}
