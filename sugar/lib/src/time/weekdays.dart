/// Utilities to encode and decode the days in a week into an 8-bit bitfield.
/// A bitfield represents one week with each bit representing a day. The first bit
/// in the bitfield is always unused, hence starting with the the day with the largest
/// value (Sunday) on the 2nd left-most bit.
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

  /// Decodes the bitfield into days, i.e. (1 to 7) of a week. [encoded] should be between 0 and 128.
  ///
  /// Behaviour is undefined if [encoded] is invalid.
  static Iterable<int> decode(int encoded) sync* {
    int i = 1;
    for (final value in parse(encoded)) {
      if (value) {
        yield i;
      }
      i++;
    }
  }

  /// Parses the bitfield into booleans, i.e. `true` if a digit is 1. [encoded] should be between 0 and 128.
  ///
  /// Behaviour is undefined if [encoded] is invalid.
  static Iterable<bool> parse(int encoded) sync* {
    assert(encoded >= 0 && encoded < 128, 'Packed days is "$encoded", should be between 0 and 127');
    for (var day = 1; day <= 7; day++) {
      yield encoded.isOdd;
      encoded >>= 1;
    }
  }

}