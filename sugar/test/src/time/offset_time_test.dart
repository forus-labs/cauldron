import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {

  test('fromDayMilliseconds(...)', () => expect(OffsetTime.fromDayMilliseconds(Offset(8), 43200000), OffsetTime(Offset(8), 12)));

  test('fromDayMicroseconds(...)', () => expect(OffsetTime.fromDayMicroseconds(Offset(8), 43200000000), OffsetTime(Offset(8), 12)));

  test('now()', () {
    final time = OffsetTime.now();
    final native = DateTime.now();

    expect(time.offset, native.offset);
    expect(time.hour, native.hour);
    expect(time.minute, native.minute);
    expect(time.second, native.second);
  }, tags: ['flaky']);

  group('OffsetTime', () {
    test('value', () {
      final time = OffsetTime(Offset(8), 1, 2, 3, 4, 5);
      expect(time.offset, Offset(8));
      expect(time.hour, 1);
      expect(time.minute, 2);
      expect(time.second, 3);
      expect(time.millisecond, 4);
      expect(time.microsecond, 5);
    });

    test('default arguments', () {
      final time = OffsetTime(Offset(8));
      expect(time.offset, Offset(8));
      expect(time.hour, 0);
      expect(time.minute, 0);
      expect(time.second, 0);
      expect(time.millisecond, 0);
      expect(time.microsecond, 0);
    });
  });

  group('add(...)', () {
    test('positive time units', () => expect(OffsetTime(Offset(8), 12, 30).add(const Duration(minutes: 5)), OffsetTime(Offset(8), 12, 35)));

    test('negative time units', () => expect(OffsetTime(Offset(8), 12, 30).add(const Duration(minutes: -5)), OffsetTime(Offset(8), 12, 25)));

    test('overflow wrap around', () => expect(OffsetTime(Offset(8), 23).add(const Duration(hours: 2)), OffsetTime(Offset(8), 1)));

    test('date units', () => expect(OffsetTime(Offset(8), 12, 30).add(const Duration(days: 1, seconds: 1)), OffsetTime(Offset(8), 12, 30, 1)));
  });

  group('subtract(...)', () {
    test('positive time units', () => expect(OffsetTime(Offset(8), 12, 30).subtract(const Duration(minutes: 5)), OffsetTime(Offset(8), 12, 25)));

    test('negative time units', () => expect(OffsetTime(Offset(8), 12, 30).subtract(const Duration(minutes: -5)), OffsetTime(Offset(8), 12, 35)));

    test('underflow wrap around', () => expect(OffsetTime(Offset(8), 1).subtract(const Duration(hours: 2)), OffsetTime(Offset(8), 23)));

    test('date units', () => expect(OffsetTime(Offset(8), 12, 30).subtract(const Duration(days: 1, seconds: 1)), OffsetTime(Offset(8), 12, 29, 59)));
  });


  group('plus(...)', () {
    test('value', () {
      expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5).plus(hours: 2, minutes: 4, seconds: 6, milliseconds: 8, microseconds: 10), OffsetTime(Offset(8), 3, 6, 9, 12, 15));
    });

    test('nothing', () => expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5).plus(), OffsetTime(Offset(8), 1, 2, 3, 4, 5)));
  });

  group('minus(...)', () {
    test('value', () {
      expect(OffsetTime(Offset(8), 3, 6, 9, 12, 15).minus(hours: 2, minutes: 4, seconds: 6, milliseconds: 8, microseconds: 10), OffsetTime(Offset(8), 1, 2, 3, 4, 5));
    });

    test('nothing', () => expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5).minus(), OffsetTime(Offset(8), 1, 2, 3, 4, 5)));
  });


  group('+', () {
    test('positive time units', () => expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5) + const Period(hours: 10), OffsetTime(Offset(8), 11, 2, 3, 4, 5)));

    test('negative time units', () => expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5) + const Period(hours: -10), OffsetTime(Offset(8), 15, 2, 3, 4, 5)));

    test('overflow wraps around', () => expect(OffsetTime(Offset(8), 23) + const Period(hours: 2), OffsetTime(Offset(8), 1)));

    test('date units', () => expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5) + const Period(days: 1, seconds: 10), OffsetTime(Offset(8), 1, 2, 13, 4, 5)));
  });

  group('-', () {
    test('positive time units', () => expect(OffsetTime(Offset(8), 11, 2, 3, 4, 5) - const Period(hours: 10), OffsetTime(Offset(8), 1, 2, 3, 4, 5)));

    test('negative time units', () => expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5) - const Period(hours: -10), OffsetTime(Offset(8), 11, 2, 3, 4, 5)));

    test('underflow wraps around', () => expect(OffsetTime(Offset(8), 1) - const Period(hours: 2), OffsetTime(Offset(8), 23)));

    test('date units', () => expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5) - const Period(days: 1, seconds: 1), OffsetTime(Offset(8), 1, 2, 2, 4, 5)));
  });

  for (final (unit, truncated) in [
    (TimeUnit.hours, OffsetTime(Offset(8), 1)),
    (TimeUnit.minutes, OffsetTime(Offset(8), 1, 2)),
    (TimeUnit.seconds, OffsetTime(Offset(8), 1, 2, 3)),
    (TimeUnit.milliseconds, OffsetTime(Offset(8), 1, 2, 3, 4)),
    (TimeUnit.microseconds, OffsetTime(Offset(8), 1, 2, 3, 4, 5)),
  ]) {
    final time = OffsetTime(Offset(8), 1, 2, 3, 4, 5);
    test('truncate to $unit', () => expect(time.truncate(to: unit), truncated));
  }

  for (final (time, unit, truncated) in [
    (OffsetTime(Offset(8), 3, 2), TimeUnit.hours, OffsetTime(Offset(8), 5)),
    (OffsetTime(Offset(8), 7, 2), TimeUnit.hours, OffsetTime(Offset(8), 5)),
    (OffsetTime(Offset(8), 1, 3, 2), TimeUnit.minutes, OffsetTime(Offset(8), 1, 5)),
    (OffsetTime(Offset(8), 1, 7, 2), TimeUnit.minutes, OffsetTime(Offset(8), 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 3, 2), TimeUnit.seconds, OffsetTime(Offset(8), 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 7, 2), TimeUnit.seconds, OffsetTime(Offset(8), 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 3, 2), TimeUnit.milliseconds, OffsetTime(Offset(8), 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 7, 2), TimeUnit.milliseconds, OffsetTime(Offset(8), 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 1, 3), TimeUnit.microseconds, OffsetTime(Offset(8), 1, 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 1, 7), TimeUnit.microseconds, OffsetTime(Offset(8), 1, 1, 1, 1, 5)),
  ]) {
    test('round $unit to 5', () => expect(time.round(unit, 5), truncated));
  }

  for (final (time, unit, truncated)  in [
    (OffsetTime(Offset(8), 2, 9), TimeUnit.hours, OffsetTime(Offset(8), 5)),
    (OffsetTime(Offset(8), 4, 9), TimeUnit.hours, OffsetTime(Offset(8), 5)),
    (OffsetTime(Offset(8), 1, 2, 9), TimeUnit.minutes, OffsetTime(Offset(8), 1, 5)),
    (OffsetTime(Offset(8), 1, 4, 9), TimeUnit.minutes, OffsetTime(Offset(8), 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 2, 9), TimeUnit.seconds, OffsetTime(Offset(8), 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 4, 9), TimeUnit.seconds, OffsetTime(Offset(8), 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 2, 9), TimeUnit.milliseconds, OffsetTime(Offset(8), 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 4, 9), TimeUnit.milliseconds, OffsetTime(Offset(8), 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 1, 2), TimeUnit.microseconds, OffsetTime(Offset(8), 1, 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 1, 4), TimeUnit.microseconds, OffsetTime(Offset(8), 1, 1, 1, 1, 5)),
  ]) {
    test('ceil $unit to 5', () => expect(time.ceil(unit, 5), truncated));
  }

  for (final (time, unit, truncated)  in [
    (OffsetTime(Offset(8), 6, 2), TimeUnit.hours, OffsetTime(Offset(8), 5)),
    (OffsetTime(Offset(8), 9, 2), TimeUnit.hours, OffsetTime(Offset(8), 5)),
    (OffsetTime(Offset(8), 1, 6, 2), TimeUnit.minutes, OffsetTime(Offset(8), 1, 5)),
    (OffsetTime(Offset(8), 1, 9, 2), TimeUnit.minutes, OffsetTime(Offset(8), 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 6, 2), TimeUnit.seconds, OffsetTime(Offset(8), 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 9, 2), TimeUnit.seconds, OffsetTime(Offset(8), 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 6, 2), TimeUnit.milliseconds, OffsetTime(Offset(8), 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 9, 2), TimeUnit.milliseconds, OffsetTime(Offset(8), 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 1, 6), TimeUnit.microseconds, OffsetTime(Offset(8), 1, 1, 1, 1, 5)),
    (OffsetTime(Offset(8), 1, 1, 1, 1, 9), TimeUnit.microseconds, OffsetTime(Offset(8), 1, 1, 1, 1, 5)),
  ]) {
    test('floor $unit to 5', () => expect(time.floor(unit, 5), truncated));
  }


  group('copyWith(...)', () {
    test('values', () => expect(OffsetTime(Offset(8), 1, 3, 5, 7, 9).copyWith(hour: 2, minute: 4, second: 6, millisecond: 8, microsecond: 10), OffsetTime(Offset(8), 2, 4, 6, 8, 10)));

    test('nothing', () => expect(OffsetTime(Offset(8), 1, 2, 3, 4, 5).copyWith(), OffsetTime(Offset(8), 1, 2, 3, 4, 5)));
  });


  test('difference(...)', () => expect(
    OffsetTime(Offset(8), 5, 7, 9, 11, 13).difference(OffsetTime(Offset(8), 2, 3, 4, 5, 6)),
    const Duration(microseconds: 11045006007),
  ));

  test('toLocal()', () => expect(OffsetTime(Offset(8), 2, 3, 4, 5, 6).toLocal(), LocalTime(2, 3, 4, 5, 6)));


  group('isBefore()', () {
    test('different offset, before', () => expect(OffsetTime(Offset(12), 6).isBefore(OffsetTime(Offset(), 6)), true));

    test('different offset, after', () => expect(OffsetTime(Offset(), 6).isBefore(OffsetTime(Offset(12), 6)), false));

    test('same moment', () => expect(OffsetTime(Offset(), 6).isBefore(OffsetTime(Offset(), 6)), false));

    test('same offset, before', () => expect(OffsetTime(Offset(8), 6).isBefore(OffsetTime(Offset(8), 7)), true));

    test('same offset, after', () => expect(OffsetTime(Offset(8), 7).isBefore(OffsetTime(Offset(8), 6)), false));
  });

  group('isSameMomentAs()', () {
    test('different offset, same', () => expect(OffsetTime(Offset(4), 12).isSameMomentAs(OffsetTime(Offset(-4), 4)), true));

    test('different offset, different', () => expect(OffsetTime(Offset(4), 1).isSameMomentAs(OffsetTime(Offset(12), 6)), false));

    test('same offset, same', () => expect(OffsetTime(Offset(8), 6).isSameMomentAs(OffsetTime(Offset(8), 6)), true));

    test('same offset, different', () => expect(OffsetTime(Offset(8), 7).isSameMomentAs(OffsetTime(Offset(8), 6)), false));
  });

  group('isAfter()', () {
    test('different offset, after', () => expect(OffsetTime(Offset(), 6).isAfter(OffsetTime(Offset(12), 6)), true));

    test('different offset, before', () => expect(OffsetTime(Offset(12), 6).isAfter(OffsetTime(Offset(), 6)), false));

    test('same moment', () => expect(OffsetTime(Offset(), 6).isAfter(OffsetTime(Offset(), 6)), false));

    test('same offset, after', () => expect(OffsetTime(Offset(8), 7).isAfter(OffsetTime(Offset(8), 6)), true));

    test('same offset, before', () => expect(OffsetTime(Offset(8), 6).isAfter(OffsetTime(Offset(8), 7)), false));
  });


  group('equality', () {
    test('not equal', () {
      expect(OffsetTime(Offset(8), 1), isNot(OffsetTime(Offset(8), 2)));
      expect(OffsetTime(Offset(8), 1).hashCode, isNot(OffsetTime(Offset(8), 2).hashCode));
    });

    test('equal', () {
      expect(OffsetTime(Offset(8), 1), OffsetTime(Offset(8), 1));
      expect(OffsetTime(Offset(8), 1).hashCode, OffsetTime(Offset(8), 1).hashCode);
    });

    test('overflow equality', () {
      expect(OffsetTime(Offset(8), 1), OffsetTime(Offset(8), 25));
      expect(OffsetTime(Offset(8), 1).hashCode, OffsetTime(Offset(8), 25).hashCode);
    });
  });

  for (final (time, string) in [
    (OffsetTime(Offset(8), 1, 2, 3, 4, 5), '01:02:03.004005+08:00'),
    (OffsetTime(Offset(8), 1), '01:00+08:00'),
    (OffsetTime(Offset(8), 0, 1), '00:01+08:00'),
    (OffsetTime(Offset(8), 0, 0, 1), '00:00:01+08:00'),
    (OffsetTime(Offset(8), 0, 0, 0, 1), '00:00:00.001+08:00'),
    (OffsetTime(Offset(8), 0, 0, 0, 0, 1), '00:00:00.000001+08:00'),
  ]) {
    test('toString()', () => expect(time.toString(), string));
  }

}
