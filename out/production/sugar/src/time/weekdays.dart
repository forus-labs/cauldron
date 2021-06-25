class Weekdays {

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