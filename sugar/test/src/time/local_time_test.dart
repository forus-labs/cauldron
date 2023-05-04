import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  test('fromDayMilliseconds(...)', () => expect(LocalTime.fromDayMilliseconds(43200000), LocalTime(12)));

  test('fromDayMicroseconds(...)', () => expect(LocalTime.fromDayMicroseconds(43200000000), LocalTime(12)));

  group('LocalTime', () {
    test('value', () {
      final time = LocalTime(1, 2, 3, 4, 5);
      expect(time.hour, 1);
      expect(time.minute, 2);
      expect(time.second, 3);
      expect(time.millisecond, 4);
      expect(time.microsecond, 5);
    });

    test('default arguments', () {
      final time = LocalTime();
      expect(time.hour, 0);
      expect(time.minute, 0);
      expect(time.second, 0);
      expect(time.millisecond, 0);
      expect(time.microsecond, 0);
    });
  });

  group('add(...)', () {
    test('positive time units', () => expect(LocalTime(12, 30).add(const Duration(minutes: 5)), LocalTime(12, 35)));

    test('negative time units', () => expect(LocalTime(12, 30).add(const Duration(minutes: -5)), LocalTime(12, 25)));

    test('overflow wrap around', () => expect(LocalTime(23).add(const Duration(hours: 2)), LocalTime(1)));

    test('date units', () => expect(LocalTime(12, 30).add(const Duration(days: 1, seconds: 1)), LocalTime(12, 30, 1)));
  });

  group('subtract(...)', () {
    test('positive time units', () => expect(LocalTime(12, 30).subtract(const Duration(minutes: 5)), LocalTime(12, 25)));

    test('negative time units', () => expect(LocalTime(12, 30).subtract(const Duration(minutes: -5)), LocalTime(12, 35)));

    test('underflow wrap around', () => expect(LocalTime(1).subtract(const Duration(hours: 2)), LocalTime(23)));

    test('date units', () => expect(LocalTime(12, 30).subtract(const Duration(days: 1, seconds: 1)), LocalTime(12, 29, 59)));
  });

  
  group('plus(...)', () {
    test('value', () {
      expect(LocalTime(1, 2, 3, 4, 5).plus(hours: 2, minutes: 4, seconds: 6, milliseconds: 8, microseconds: 10), LocalTime(3, 6, 9, 12, 15));
    });

    test('nothing', () => expect(LocalTime(1, 2, 3, 4, 5).plus(), LocalTime(1, 2, 3, 4, 5)));
  });

  group('minus(...)', () {
    test('value', () {
      expect(LocalTime(3, 6, 9, 12, 15).minus(hours: 2, minutes: 4, seconds: 6, milliseconds: 8, microseconds: 10), LocalTime(1, 2, 3, 4, 5));
    });

    test('nothing', () => expect(LocalTime(1, 2, 3, 4, 5).minus(), LocalTime(1, 2, 3, 4, 5)));
  });


  group('+', () {
    test('positive time units', () => expect(LocalTime(1, 2, 3, 4, 5) + const Period(hours: 10), LocalTime(11, 2, 3, 4, 5)));

    test('negative time units', () => expect(LocalTime(1, 2, 3, 4, 5) + const Period(hours: -10), LocalTime(15, 2, 3, 4, 5)));

    test('overflow wraps around', () => expect(LocalTime(23) + const Period(hours: 2), LocalTime(1)));

    test('date units', () => expect(LocalTime(1, 2, 3, 4, 5) + const Period(days: 1, seconds: 10), LocalTime(1, 2, 13, 4, 5)));
  });

  group('-', () {
    test('positive time units', () => expect(LocalTime(11, 2, 3, 4, 5) - const Period(hours: 10), LocalTime(1, 2, 3, 4, 5)));

    test('negative time units', () => expect(LocalTime(1, 2, 3, 4, 5) - const Period(hours: -10), LocalTime(11, 2, 3, 4, 5)));

    test('underflow wraps around', () => expect(LocalTime(1) - const Period(hours: 2), LocalTime(23)));

    test('date units', () => expect(LocalTime(1, 2, 3, 4, 5) - const Period(days: 1, seconds: 1), LocalTime(1, 2, 2, 4, 5)));
  });

  for (final arguments in [
    [TimeUnit.hours, LocalTime(1)],
    [TimeUnit.minutes, LocalTime(1, 2)],
    [TimeUnit.seconds, LocalTime(1, 2, 3)],
    [TimeUnit.milliseconds, LocalTime(1, 2, 3, 4)],
    [TimeUnit.microseconds, LocalTime(1, 2, 3, 4, 5)],
  ]) {
    final time = LocalTime(1, 2, 3, 4, 5);
    final unit = arguments[0] as TimeUnit;
    final truncated = arguments[1] as LocalTime;

    test('truncate to $unit', () => expect(time.truncate(to: unit), truncated));
  }

  for (final arguments in [
    [LocalTime(3, 2), TimeUnit.hours, LocalTime(5)],
    [LocalTime(7, 2), TimeUnit.hours, LocalTime(5)],
    [LocalTime(1, 3, 2), TimeUnit.minutes, LocalTime(1, 5)],
    [LocalTime(1, 7, 2), TimeUnit.minutes, LocalTime(1, 5)],
    [LocalTime(1, 1, 3, 2), TimeUnit.seconds, LocalTime(1, 1, 5)],
    [LocalTime(1, 1, 7, 2), TimeUnit.seconds, LocalTime(1, 1, 5)],
    [LocalTime(1, 1, 1, 3, 2), TimeUnit.milliseconds, LocalTime(1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 7, 2), TimeUnit.milliseconds, LocalTime(1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 1, 3), TimeUnit.microseconds, LocalTime(1, 1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 1, 7), TimeUnit.microseconds, LocalTime(1, 1, 1, 1, 5)],
  ]) {
    final date = arguments[0] as LocalTime;
    final unit = arguments[1] as TimeUnit;
    final truncated = arguments[2] as LocalTime;

    test('round $unit to 5', () => expect(date.round(unit, 5), truncated));
  }

  for (final arguments in [
    [LocalTime(2, 9), TimeUnit.hours, LocalTime(5)],
    [LocalTime(4, 9), TimeUnit.hours, LocalTime(5)],
    [LocalTime(1, 2, 9), TimeUnit.minutes, LocalTime(1, 5)],
    [LocalTime(1, 4, 9), TimeUnit.minutes, LocalTime(1, 5)],
    [LocalTime(1, 1, 2, 9), TimeUnit.seconds, LocalTime(1, 1, 5)],
    [LocalTime(1, 1, 4, 9), TimeUnit.seconds, LocalTime(1, 1, 5)],
    [LocalTime(1, 1, 1, 2, 9), TimeUnit.milliseconds, LocalTime(1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 4, 9), TimeUnit.milliseconds, LocalTime(1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 1, 2), TimeUnit.microseconds, LocalTime(1, 1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 1, 4), TimeUnit.microseconds, LocalTime(1, 1, 1, 1, 5)],
  ]) {
    final date = arguments[0] as LocalTime;
    final unit = arguments[1] as TimeUnit;
    final truncated = arguments[2] as LocalTime;

    test('ceil $unit to 5', () => expect(date.ceil(unit, 5), truncated));
  }

  for (final arguments in [
    [LocalTime(6, 2), TimeUnit.hours, LocalTime(5)],
    [LocalTime(9, 2), TimeUnit.hours, LocalTime(5)],
    [LocalTime(1, 6, 2), TimeUnit.minutes, LocalTime(1, 5)],
    [LocalTime(1, 9, 2), TimeUnit.minutes, LocalTime(1, 5)],
    [LocalTime(1, 1, 6, 2), TimeUnit.seconds, LocalTime(1, 1, 5)],
    [LocalTime(1, 1, 9, 2), TimeUnit.seconds, LocalTime(1, 1, 5)],
    [LocalTime(1, 1, 1, 6, 2), TimeUnit.milliseconds, LocalTime(1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 9, 2), TimeUnit.milliseconds, LocalTime(1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 1, 6), TimeUnit.microseconds, LocalTime(1, 1, 1, 1, 5)],
    [LocalTime(1, 1, 1, 1, 9), TimeUnit.microseconds, LocalTime(1, 1, 1, 1, 5)],
  ]) {
    final date = arguments[0] as LocalTime;
    final unit = arguments[1] as TimeUnit;
    final truncated = arguments[2] as LocalTime;

    test('floor $unit to 5', () => expect(date.floor(unit, 5), truncated));
  }


  group('copyWith(...)', () {
    test('values', () => expect(LocalTime(1, 3, 5, 7, 9).copyWith(hour: 2, minute: 4, second: 6, millisecond: 8, microsecond: 10), LocalTime(2, 4, 6, 8, 10)));

    test('nothing', () => expect(LocalTime(1, 2, 3, 4, 5).copyWith(), LocalTime(1, 2, 3, 4, 5)));
  });


  group('gap(...)', () {
    test('positive', () => expect(
      LocalTime(5, 7, 9, 11, 13).gap(LocalTime(1, 2, 3, 4, 5)),
      const Period(hours: 4, minutes: 5, seconds: 6, milliseconds: 7, microseconds: 8),
    ));

    test('negative', () => expect(
      LocalTime(1, 2, 3, 4, 5).gap(LocalTime(5, 7, 9, 11, 13)),
      const Period(hours: -4, minutes: -5, seconds: -6, milliseconds: -7, microseconds: -8),
    ));
  });
  
  
  test('at(...)', () => expect(LocalTime(1, 2, 3, 4, 5).at(Offset(8)), OffsetTime(Offset(8), 1, 2, 3, 4, 5)));

  test('toNative()', () => expect(LocalTime(2, 3, 4, 5, 6).toNative(), DateTime.utc(1970, 1, 1, 2, 3, 4, 5, 6)));

  group('compareTo(...) & hashValue', () {
    test('-1', () {
      expect(LocalTime(1).compareTo(LocalTime(2)), -1);
      expect(LocalTime(1).hashValue, isNot(LocalTime(2).hashValue));
    });

    test('0', () {
      expect(LocalTime(1).compareTo(LocalTime(1)), 0);
      expect(LocalTime(1).hashValue, LocalTime(1).hashValue);
    });

    test('1', () {
      expect(LocalTime(2).compareTo(LocalTime(1)), 1);
      expect(LocalTime(2).hashValue, isNot(LocalTime(1).hashValue));
    });
  });

  for (final arguments in [
    [LocalTime(1, 2, 3, 4, 5), '01:02:03.004005'],
    [LocalTime(1), '01:00'],
    [LocalTime(0, 1), '00:01'],
    [LocalTime(0, 0, 1), '00:00:01'],
    [LocalTime(0, 0, 0, 1), '00:00:00.001'],
    [LocalTime(0, 0, 0, 0, 1), '00:00:00.000001'],
  ]) {
    final time = arguments[0] as LocalTime;
    final string = arguments[1] as String;

    test('toString()', () => expect(time.toString(), string));
  }

  test('dayMilliseconds', () => expect(LocalTime(1, 2, 3, 4, 5).dayMilliseconds, 3723004));

  test('dayMicroseconds', () => expect(LocalTime(1, 2, 3, 4, 5).dayMicroseconds, 3723004005));
}
