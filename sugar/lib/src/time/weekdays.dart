/// Provides utilities to encode and decode the days in a week into a 8-bit
/// bitfield. Each bitfield represents a week, with days ranging from 1 to 7.
///
/// To ensure the bitfield fits in a byte, the left-most bit is un-used. The bitfield
/// is otherwise big-endian, starting with the day with the largest value (Sunday)
/// at the second left-most. The presence of a day is represented by a `1` in the bitfield,
/// the contrary represented by a `0`.
class Weekdays {

  /// Encodes the days of a week into a bitfield. The length of [week] should be less
  /// than or equal to `7` with elements ranging from 1 to 7.
  ///
  /// Behaviour is undefined if the given week is invalid.
  static int encode(Iterable<int> week) {
    assert(week.length <= 7, 'Number of days is "${week.length}", should be less than 7');
    assert(week.every((day) => day >= 1 && day <= 7), 'Invalid day in week, should be between 1 and 7');

    var encoded = 0;
    for (var day = 7; day >= 1; day--) {
      encoded <<= 1;
      if (week.contains(day)) {
        encoded += 1;
      }
    }

    return encoded;
  }

  /// Decodes the bitfield into days of a week. [encoded] should be between o and 128.
  ///
  /// Behaviour is undefined if [encoded] is invalid.
  static Iterable<int> decode(int encoded) sync* {
    assert(encoded >= 0 && encoded < 128, 'Packed days is "$encoded", should be between 0 and 127');

    for (var day = 1; day <= 7; day++) {
      if (encoded.isOdd) {
        yield day;
      }

      encoded >>= 1;
    }
  }

}