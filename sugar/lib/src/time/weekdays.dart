/// Utilities to encode and decode the days in a week into an 8-bit bitfield.
/// A bitfield represents one week with each bit representing a day. It is big-endian
/// with the first bit in the bitfield always being unused.
///
/// That is to say, it start with the day with the largest value (Sunday) at the 2nd left-most bit.
/// For example `0100 0100`, will represent Sunday and Wednesday.
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
    assert(encoded >= 0 && encoded < 128, 'Packed days is "$encoded", should be between 0 and 127');
    for (var day = 1; day <= 7; day++) {
      if (encoded.isOdd) {
        yield day;
      }
      encoded >>= 1;
    }
  }


  /// Parses the bitfield into booleans, i.e. `true` if a digit is 1. [encoded] should be between 0 and 128.
  /// The returned [Iterable] is little-endian with `true` indicating the presence of a day.
  ///
  /// That is so say, the first element in the returned iterable will represent whether Monday is present.
  /// For example, `[true, false, false true, false, false, false]` will indicate that Monday and Thursday
  /// is present.
  ///
  /// Behaviour is undefined if [encoded] is invalid.
  static Iterable<bool> parse(int encoded) sync* {
    assert(encoded >= 0 && encoded < 128, 'Packed days is "$encoded", should be between 0 and 127');
    for (var day = 1; day <= 7; day++) {
      yield encoded.isOdd;
      encoded >>= 1;
    }
  }

  /// Encodes the booleans into a bitfield. The length of [week] should be 7.
  /// [week] is expected to be little-endian with `true` indicating the presence of a day.
  ///
  /// That is so say, the first element in [week] will represent whether Monday is present.
  /// For example, `[true, false, false true, false, false, false]` will indicate that Monday
  /// and Thursday is present.
  ///
  /// Behaviour is undefined if the given week is invalid.
  static int unparse(Iterable<bool> week) {
    assert(week.length == 7, 'Number of days is "${week.length}", should be 7');
    var encoded = 0;
    for (final day in week.toList().reversed) {
      encoded <<= 1;
      if (day) {
        encoded += 1;
      }
    }

    return encoded;
  }

}