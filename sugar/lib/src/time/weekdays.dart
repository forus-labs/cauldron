class Weekdays {

  static int encode(Iterable<int> week) {
    assert(week.length <= 7, 'Number of days is "${week.length}", should be less than 7');
    assert(week.every((day) => day >= 1 && day <= 7), 'Invalid day in week, should be between 1 and 7');

    var packed = 0;
    for (var day = 7; day >= 1; day--) {
      packed <<= 1;
      if (week.contains(day)) {
        packed += 1;
      }
    }

    return packed;
  }

  static Iterable<int> decode(int packed) sync* {
    assert(packed >= 0 && packed < 128, 'Packed days is "$packed", should be between 0 and 127');

    for (var day = 1; day <= 7; day++) {
      if (packed.isOdd) {
        yield day;
      }

      packed >>= 1;
    }
  }

}