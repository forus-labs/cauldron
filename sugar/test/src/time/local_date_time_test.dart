import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  test('fromEpochMilliseconds(...)', () => expect(
    LocalDateTime.fromEpochMilliseconds(946782245006),
    LocalDateTime(2000, 1, 2, 3, 4, 5, 6),
  ));

  test('fromEpochMicroseconds(...)', () => expect(
    LocalDateTime.fromEpochMicroseconds(946782245006007),
    LocalDateTime(2000, 1, 2, 3, 4, 5, 6, 7)),
  );

  group('now(...)', () {
    test('real date-time', () {
      final native = DateTime.now();
      final date = LocalDateTime.now();

      expect(date.year, native.year);
      expect(date.month, native.month);
      expect(date.day, native.day);
      expect(date.hour, native.hour);
      expect(date.minute, native.minute);
      expect(date.second, native.second);
    }, tags: ['flaky']);

    for (final (precision, expected) in <(TemporalUnit, LocalDateTime)>[
      (TimeUnit.microseconds, LocalDateTime(2023, 2, 3, 4, 5, 6, 7, 8)),
      (TimeUnit.milliseconds, LocalDateTime(2023, 2, 3, 4, 5, 6, 7)),
      (TimeUnit.seconds, LocalDateTime(2023, 2, 3, 4, 5, 6)),
      (TimeUnit.minutes, LocalDateTime(2023, 2, 3, 4, 5)),
      (TimeUnit.hours, LocalDateTime(2023, 2, 3, 4)),
      (DateUnit.days, LocalDateTime(2023, 2, 3)),
      (DateUnit.months, LocalDateTime(2023, 2)),
      (DateUnit.years, LocalDateTime(2023)),
    ]) {
      test('precision', () {
        System.currentDateTime = () => DateTime.utc(2023, 2, 3, 4, 5, 6, 7, 8);
        expect(LocalDateTime.now(precision), expected);
        System.currentDateTime = DateTime.now;
      });
    }
  });



  group('LocalDateTime', () {
    test('value', () {
      final date = LocalDateTime(2000, 1, 2, 3, 4, 5, 6, 7);
      expect(date.year, 2000);
      expect(date.month, 1);
      expect(date.day, 2);
      expect(date.hour, 3);
      expect(date.minute, 4);
      expect(date.second, 5);
      expect(date.millisecond, 6);
      expect(date.microsecond, 7);
    });

    test('default', () {
      final date = LocalDateTime(2000);
      expect(date.year, 2000);
      expect(date.month, 1);
      expect(date.day, 1);
      expect(date.hour, 0);
      expect(date.minute, 0);
      expect(date.second, 0);
      expect(date.millisecond, 0);
      expect(date.microsecond, 0);
    });
  });


  group('add(...)', () {
    test('positive time units', () => expect(
      LocalDateTime(2023, 1, 5, 12, 30).add(const Duration(days: 1, minutes: 5)),
      LocalDateTime(2023, 1, 6, 12, 35),
    ));

    test('negative time units', () => expect(
      LocalDateTime(2023, 1, 5, 12, 30).add(const Duration(days: -1, minutes: -5)),
      LocalDateTime(2023, 1, 4, 12, 25),
    ));
  });

  group('subtract(...)', () {
    test('positive time units', () => expect(
      LocalDateTime(2023, 1, 5, 12, 30).subtract(const Duration(days: 1, minutes: 5)),
      LocalDateTime(2023, 1, 4, 12, 25),
    ));

    test('negative time units', () => expect(
      LocalDateTime(2023, 1, 5, 12, 30).subtract(const Duration(days: -1, minutes: -5)),
      LocalDateTime(2023, 1, 6, 12, 35),
    ));
  });


  group('plus(...)', () {
    test('value', () => expect(
      LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8).plus(years: 2, months: 3, days: 4, hours: 5, minutes: 6, seconds: 7, milliseconds: 8, microseconds: 9),
      LocalDateTime(3, 5, 7, 9, 11, 13, 15, 17),
    ));

    test('nothing', () => expect(LocalDateTime(1, 2, 3, 4, 5).plus(), LocalDateTime(1, 2, 3, 4, 5)));
  });

  group('minus(...)', () {
    test('value', () => expect(
      LocalDateTime(3, 5, 7, 9, 11, 13, 15, 17).minus(years: 2, months: 3, days: 4, hours: 5, minutes: 6, seconds: 7, milliseconds: 8, microseconds: 9),
      LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8),
    ));

    test('nothing', () => expect(LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8).minus(), LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8)));
  });


  group('+', () {
    test('positive', () => expect(
      LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8) + const Period(
        years: 2,
        months: 3,
        days: 4,
        hours: 5,
        minutes: 6,
        seconds: 7,
        milliseconds: 8,
        microseconds: 9,
      ),
      LocalDateTime(3, 5, 7, 9, 11, 13, 15, 17),
    ));

    test('negative', () => expect(
      LocalDateTime(8, 7, 6, 5, 40, 30, 20, 10) + const Period(
        years: -1,
        months: -2,
        days: -3,
        hours: -5,
        minutes: -6,
        seconds: -7,
        milliseconds: -8,
        microseconds: -9,
      ),
      LocalDateTime(7, 5, 3, 0, 34, 23, 12, 1),
    ));

    test('nothing', () => expect(LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8) + const Period(), LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8)));
  });

  group('-', () {
    test('positive', () => expect(
      LocalDateTime(8, 7, 6, 5, 40, 30, 20, 10) - const Period(
        years: 1,
        months: 2,
        days: 3,
        hours: 5,
        minutes: 6,
        seconds: 7,
        milliseconds: 8,
        microseconds: 9,
      ),
      LocalDateTime(7, 5, 3, 0, 34, 23, 12, 1),
    ));

    test('negative', () => expect(
      LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8) - const Period(
        years: -2,
        months: -3,
        days: -4,
        hours: -5,
        minutes: -6,
        seconds: -7,
        milliseconds: -8,
        microseconds: -9,
      ),
      LocalDateTime(3, 5, 7, 9, 11, 13, 15, 17),
    ));

    test('nothing', () => expect(LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8) - const Period(), LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8)));
  });


  for (final (unit, truncated) in [
    (DateUnit.years, LocalDateTime(10)),
    (DateUnit.months, LocalDateTime(10, 2)),
    (DateUnit.days, LocalDateTime(10, 2, 3)),
    (TimeUnit.hours, LocalDateTime(10, 2, 3, 4)),
    (TimeUnit.minutes, LocalDateTime(10, 2, 3, 4, 5)),
    (TimeUnit.seconds, LocalDateTime(10, 2, 3, 4, 5, 6)),
    (TimeUnit.milliseconds, LocalDateTime(10, 2, 3, 4, 5, 6, 7)),
    (TimeUnit.microseconds, LocalDateTime(10, 2, 3, 4, 5, 6, 7, 8)),
  ]) {
    final date = LocalDateTime(10, 2, 3, 4, 5, 6, 7, 8);
    test('truncate to $unit', () => expect(date.truncate(to: unit as TemporalUnit), truncated));
  }

  for (final (date, unit, truncated) in [
    (LocalDateTime(3, 2), DateUnit.years, LocalDateTime(5)),
    (LocalDateTime(7, 2), DateUnit.years, LocalDateTime(5)),
    (LocalDateTime(1, 3, 2), DateUnit.months, LocalDateTime(1, 5)),
    (LocalDateTime(1, 7, 2), DateUnit.months, LocalDateTime(1, 5)),
    (LocalDateTime(1, 1, 3, 2), DateUnit.days, LocalDateTime(1, 1, 5)),
    (LocalDateTime(1, 1, 7, 2), DateUnit.days, LocalDateTime(1, 1, 5)),
    (LocalDateTime(1, 1, 1, 3, 2), TimeUnit.hours, LocalDateTime(1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 7, 2), TimeUnit.hours, LocalDateTime(1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 3, 2), TimeUnit.minutes, LocalDateTime(1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 7, 2), TimeUnit.minutes, LocalDateTime(1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 3, 2), TimeUnit.seconds, LocalDateTime(1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 7, 2), TimeUnit.seconds, LocalDateTime(1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 3, 2), TimeUnit.milliseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 7, 2), TimeUnit.milliseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 1, 3), TimeUnit.microseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 1, 7), TimeUnit.microseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 1, 5)),
  ]) {
    test('round $unit to 5', () => expect(date.round(unit as TemporalUnit, 5), truncated));
  }

  for (final (date, unit, truncated) in [
    (LocalDateTime(2, 9), DateUnit.years, LocalDateTime(5)),
    (LocalDateTime(4, 9), DateUnit.years, LocalDateTime(5)),
    (LocalDateTime(1, 2, 9), DateUnit.months, LocalDateTime(1, 5)),
    (LocalDateTime(1, 4, 9), DateUnit.months, LocalDateTime(1, 5)),
    (LocalDateTime(1, 1, 2, 9), DateUnit.days, LocalDateTime(1, 1, 5)),
    (LocalDateTime(1, 1, 4, 9), DateUnit.days, LocalDateTime(1, 1, 5)),
    (LocalDateTime(1, 1, 1, 2, 9), TimeUnit.hours, LocalDateTime(1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 4, 9), TimeUnit.hours, LocalDateTime(1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 2, 9), TimeUnit.minutes, LocalDateTime(1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 4, 9), TimeUnit.minutes, LocalDateTime(1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 2, 9), TimeUnit.seconds, LocalDateTime(1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 4, 9), TimeUnit.seconds, LocalDateTime(1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 2, 9), TimeUnit.milliseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 4, 9), TimeUnit.milliseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 1, 2), TimeUnit.microseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 1, 4), TimeUnit.microseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 1, 5)),
  ]) {
    test('ceil $unit to 5', () => expect(date.ceil(unit as TemporalUnit, 5), truncated));
  }

  for (final (date, unit, truncated) in [
    (LocalDateTime(6, 2), DateUnit.years, LocalDateTime(5)),
    (LocalDateTime(9, 2), DateUnit.years, LocalDateTime(5)),
    (LocalDateTime(1, 6, 2), DateUnit.months, LocalDateTime(1, 5)),
    (LocalDateTime(1, 9, 2), DateUnit.months, LocalDateTime(1, 5)),
    (LocalDateTime(1, 1, 6, 2), DateUnit.days, LocalDateTime(1, 1, 5)),
    (LocalDateTime(1, 1, 9, 2), DateUnit.days, LocalDateTime(1, 1, 5)),
    (LocalDateTime(1, 1, 1, 6, 2), TimeUnit.hours, LocalDateTime(1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 9, 2), TimeUnit.hours, LocalDateTime(1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 6, 2), TimeUnit.minutes, LocalDateTime(1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 9, 2), TimeUnit.minutes, LocalDateTime(1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 6, 2), TimeUnit.seconds, LocalDateTime(1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 9, 2), TimeUnit.seconds, LocalDateTime(1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 6, 2), TimeUnit.milliseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 9, 2), TimeUnit.milliseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 1, 6), TimeUnit.microseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 1, 5)),
    (LocalDateTime(1, 1, 1, 1, 1, 1, 1, 9), TimeUnit.microseconds, LocalDateTime(1, 1, 1, 1, 1, 1, 1, 5)),
  ]) {
    test('floor $unit to 5', () => expect(date.floor(unit as TemporalUnit, 5), truncated));
  }

  
  group('copyWith(...)', () {
    test('values', () => expect(
      LocalDateTime(2023, 1, 2, 3, 4, 5, 6, 7).copyWith(year: 2024, month: 8, day: 9, hour: 10, minute: 11, second: 12, millisecond: 13, microsecond: 14),
      LocalDateTime(2024, 8, 9, 10, 11, 12, 13, 14),
    ));

    test('nothing', () => expect(LocalDateTime(2023, 1, 2, 3, 4, 5, 6, 7).copyWith(), LocalDateTime(2023, 1, 2, 3, 4, 5, 6, 7)));
  });


  test('difference(...)', () => expect(
    LocalDateTime(5, 7, 9, 11, 13, 14, 15, 16).difference(LocalDateTime(2, 3, 4, 5, 6, 7, 8, 9)),
    const Duration(microseconds: 105689227007007),
  ));


  test('at(...)', () => expect(
    LocalDateTime(2023, 1, 2, 3, 4, 5, 6, 7).at(Timezone('Asia/Singapore')),
    ZonedDateTime('Asia/Singapore', 2023, 1, 2, 3, 4, 5, 6, 7),
  ));
  
  test('toNative()', () => expect(LocalDateTime(2023, 1, 2, 3, 4, 5, 6, 7).toNative(), DateTime.utc(2023, 1, 2, 3, 4, 5, 6, 7)));


  test('date', () => expect(LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8).date, LocalDate(1, 2, 3)));

  test('time', () => expect(LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8).time, LocalTime(4, 5, 6, 7, 8)));


  group('compareTo(...) & hashValue', () {
    test('-1', () {
      expect(LocalDateTime(1).compareTo(LocalDateTime(2)), -1);
      expect(LocalDateTime(1).hashValue, isNot(LocalDateTime(2).hashValue));
    });

    test('0', () {
      expect(LocalDateTime(1).compareTo(LocalDateTime(1)), 0);
      expect(LocalDateTime(1).hashValue, LocalDateTime(1).hashValue);
    });

    test('1', () {
      expect(LocalDateTime(2).compareTo(LocalDateTime(1)), 1);
      expect(LocalDateTime(2).hashValue, isNot(LocalDateTime(1).hashValue));
    });
  });

  for (final (date, string) in [
    (LocalDateTime(2023, 4, 6, 1, 2, 3, 4, 5), '2023-04-06T01:02:03.004005'),
    (LocalDateTime(2023, 4, 15, 1), '2023-04-15T01:00'),
    (LocalDateTime(2023, 4, 15, 0, 1), '2023-04-15T00:01'),
    (LocalDateTime(2023, 4, 15, 0, 0, 1), '2023-04-15T00:00:01'),
    (LocalDateTime(2023, 4, 15, 0, 0, 0, 1), '2023-04-15T00:00:00.001'),
    (LocalDateTime(2023, 4, 15, 0, 0, 0, 0, 1), '2023-04-15T00:00:00.000001'),
  ]) {
    test('toString()', () => expect(date.toString(), string));
  }

  test('weekday', () => expect(LocalDateTime(2023, 5, 3).weekday, 3));

  group('weekOfYear', () {
    test('last week of previous year', () => expect(LocalDateTime(2023).weekOfYear, 52));

    test('first of year', () => expect(LocalDateTime(2023, 1, 2).weekOfYear, 1));

    test('middle of year', () => expect(LocalDateTime(2023, 6, 15).weekOfYear, 24));

    test('short year last week', () => expect(LocalDateTime(2023, 12, 31).weekOfYear, 52));

    test('long year last week', () => expect(LocalDateTime(2020, 12, 31).weekOfYear, 53));
  });

  group('dayOfYear(...)', () {
    test('leap year first day', () => expect(LocalDateTime(2020).dayOfYear, 1));

    test('leap year before February', () => expect(LocalDateTime(2020, 2, 20).dayOfYear, 51));

    test('leap year after February', () => expect(LocalDateTime(2020, 3, 20).dayOfYear, 80));

    test('leap year last day', () => expect(LocalDateTime(2020, 12, 31).dayOfYear, 366));

    test('non-leap year first day', () => expect(LocalDateTime(2021).dayOfYear, 1));

    test('non-leap year', () => expect(LocalDateTime(2021, 3, 20).dayOfYear, 79));

    test('non-leap year last day', () => expect(LocalDateTime(2021, 12, 31).dayOfYear, 365));
  });


  group('firstDayOfWeek', () {
    test('current date', () => expect(LocalDateTime(2023, 5, 8, 1).firstDayOfWeek, LocalDateTime(2023, 5, 8)));

    test('last day of week', () => expect(LocalDateTime(2023, 5, 14, 1).firstDayOfWeek, LocalDateTime(2023, 5, 8)));

    test('across months', () => expect(LocalDateTime(2023, 6, 2).firstDayOfWeek, LocalDateTime(2023, 5, 29)));
  });

  group('lastDayOfWeek', () {
    test('current date', () => expect(LocalDateTime(2023, 5, 8, 1).lastDayOfWeek, LocalDateTime(2023, 5, 14)));

    test('last day of week', () => expect(LocalDateTime(2023, 5, 14, 1).lastDayOfWeek, LocalDateTime(2023, 5, 14)));

    test('across months', () => expect(LocalDateTime(2023, 5, 29).lastDayOfWeek, LocalDateTime(2023, 6, 4)));
  });


  group('firstDayOfMonth', () {
    test('current date', () => expect(LocalDateTime(2023, 5, 1, 1).firstDayOfMonth, LocalDateTime(2023, 5)));

    test('last day of the month', () => expect(LocalDateTime(2023, 5, 31).firstDayOfMonth, LocalDateTime(2023, 5)));
  });

  group('lastDayOfMonth', () {
    test('current date', () => expect(LocalDateTime(2023, 2, 28).lastDayOfMonth, LocalDateTime(2023, 2, 28)));

    test('first day of the month', () => expect(LocalDateTime(2023, 2).lastDayOfMonth, LocalDateTime(2023, 2, 28)));

    test('leap year', () => expect(LocalDateTime(2020, 2).lastDayOfMonth, LocalDateTime(2020, 2, 29)));
  });


  group('daysInMonth', () {
    test('leap year', () => expect(LocalDateTime(2020, 2).daysInMonth, 29));

    test('non-leap year', () => expect(LocalDateTime(2021, 2).daysInMonth, 28));
  });

  group('leapYear', () {
    test('leap year', () => expect(LocalDateTime(2020).leapYear, true));

    test('non-leap year', () => expect(LocalDateTime(2021).leapYear, false));
  });


  test('epochMilliseconds', () => expect(
    LocalDateTime(2023, 1, 2, 3, 4, 5, 6, 7).epochMilliseconds,
    DateTime.utc(2023, 1, 2, 3, 4, 5, 6, 7).millisecondsSinceEpoch,
  ));

  test('epochMicroseconds', () => expect(
      LocalDateTime(2023, 1, 2, 3, 4, 5, 6, 7).epochMicroseconds,
    DateTime.utc(2023, 1, 2, 3, 4, 5, 6, 7).microsecondsSinceEpoch),
  );
  
}
