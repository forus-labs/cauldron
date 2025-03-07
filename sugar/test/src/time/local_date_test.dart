import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  test('fromEpochDays(...)', () => expect(LocalDate.fromEpochDays(10957), LocalDate(2000)));

  group('fromEpochMilliseconds(...)', () {
    test('exact', () => expect(LocalDate.fromEpochMilliseconds(946684800000), LocalDate(2000)));

    test('floors', () => expect(LocalDate.fromEpochMilliseconds(946684800100), LocalDate(2000)));
  });

  group('fromEpochMicroseconds(...)', () {
    test('exact', () => expect(LocalDate.fromEpochMicroseconds(946684800000000), LocalDate(2000)));

    test('floors', () => expect(LocalDate.fromEpochMicroseconds(946684800000100), LocalDate(2000)));
  });

  group('now(...)', () {
    test('real date-time', () {
      final native = DateTime.now();
      final date = LocalDate.now();

      expect(date.epochMicroseconds, DateTime.utc(native.year, native.month, native.day).microsecondsSinceEpoch);

      expect(date.year, native.year);
      expect(date.month, native.month);
      expect(date.day, native.day);
    }, tags: ['flaky']);

    for (final (precision, expected) in [
      (DateUnit.days, LocalDate(2023, 7, 9)),
      (DateUnit.months, LocalDate(2023, 7)),
      (DateUnit.years, LocalDate(2023)),
    ]) {
      test('precision', () {
        System.currentDateTime = () => DateTime.utc(2023, 7, 9, 1, 2, 3, 4, 5);
        expect(LocalDate.now(precision), expected);
        System.currentDateTime = DateTime.now;
      });
    }
  });

  group('LocalDate(...)', () {
    test('values', () {
      final date = LocalDate(2023, 5, 3);
      expect(date.year, 2023);
      expect(date.month, 5);
      expect(date.day, 3);
    });

    test('default', () {
      final date = LocalDate(2023);
      expect(date.year, 2023);
      expect(date.month, 1);
      expect(date.day, 1);
    });
  });

  group('add(...)', () {
    test(
      'positive date units',
      () => expect(LocalDate(2023, 4, 5).add(const Duration(days: 1)), LocalDate(2023, 4, 6)),
    );

    test(
      'negative date units',
      () => expect(LocalDate(2023, 4, 5).add(const Duration(days: -1)), LocalDate(2023, 4, 4)),
    );

    test(
      'time units',
      () => expect(LocalDate(2023, 4, 5).add(const Duration(days: 1, microseconds: 1)), LocalDate(2023, 4, 6)),
    );
  });

  group('subtract(...)', () {
    test(
      'positive date units',
      () => expect(LocalDate(2023, 4, 5).subtract(const Duration(days: 1)), LocalDate(2023, 4, 4)),
    );

    test(
      'negative date units',
      () => expect(LocalDate(2023, 4, 5).subtract(const Duration(days: -1)), LocalDate(2023, 4, 6)),
    );

    test(
      'time units',
      () => expect(LocalDate(2023, 4, 5).subtract(const Duration(days: 1, microseconds: 1)), LocalDate(2023, 4, 4)),
    );
  });

  group('plus(...)', () {
    test('value', () => expect(LocalDate(2023, 4, 5).plus(years: 1, months: 2, days: 3), LocalDate(2024, 6, 8)));

    test('nothing', () => expect(LocalDate(2023, 4, 5).plus(), LocalDate(2023, 4, 5)));
  });

  group('minus(...)', () {
    test('value', () => expect(LocalDate(2023, 5, 7).minus(years: 1, months: 2, days: 3), LocalDate(2022, 3, 4)));

    test('nothing', () => expect(LocalDate(2023, 4, 5).minus(), LocalDate(2023, 4, 5)));
  });

  group('+', () {
    test('positive date units', () => expect(LocalDate(2023, 4, 5) + const Period(days: 1), LocalDate(2023, 4, 6)));

    test('negative date units', () => expect(LocalDate(2023, 4, 5) + const Period(days: -1), LocalDate(2023, 4, 4)));

    test(
      'time units',
      () => expect(LocalDate(2023, 4, 5) + const Period(days: 1, microseconds: 1), LocalDate(2023, 4, 6)),
    );
  });

  group('-', () {
    test('positive date units', () => expect(LocalDate(2023, 4, 5) - const Period(days: 1), LocalDate(2023, 4, 4)));

    test('negative date units', () => expect(LocalDate(2023, 4, 5) - const Period(days: -1), LocalDate(2023, 4, 6)));

    test(
      'time units',
      () => expect(LocalDate(2023, 4, 5) - const Period(days: 1, microseconds: 1), LocalDate(2023, 4, 4)),
    );
  });

  for (final (unit, truncated) in [
    (DateUnit.years, LocalDate(10)),
    (DateUnit.months, LocalDate(10, 2)),
    (DateUnit.days, LocalDate(10, 2, 3)),
  ]) {
    final date = LocalDate(10, 2, 3);
    test('truncate to $unit', () => expect(date.truncate(to: unit), truncated));
  }

  for (final (date, unit, truncated) in [
    (LocalDate(3, 2), DateUnit.years, LocalDate(5)),
    (LocalDate(7, 2), DateUnit.years, LocalDate(5)),
    (LocalDate(1, 3, 2), DateUnit.months, LocalDate(1, 5)),
    (LocalDate(1, 7, 2), DateUnit.months, LocalDate(1, 5)),
    (LocalDate(1, 1, 3), DateUnit.days, LocalDate(1, 1, 5)),
    (LocalDate(1, 1, 7), DateUnit.days, LocalDate(1, 1, 5)),
  ]) {
    test('round $unit to 5', () => expect(date.round(unit, 5), truncated));
  }

  for (final (date, unit, truncated) in [
    (LocalDate(2, 9), DateUnit.years, LocalDate(5)),
    (LocalDate(4, 9), DateUnit.years, LocalDate(5)),
    (LocalDate(1, 2, 9), DateUnit.months, LocalDate(1, 5)),
    (LocalDate(1, 4, 9), DateUnit.months, LocalDate(1, 5)),
    (LocalDate(1, 1, 2), DateUnit.days, LocalDate(1, 1, 5)),
    (LocalDate(1, 1, 4), DateUnit.days, LocalDate(1, 1, 5)),
  ]) {
    test('ceil $unit to 5', () => expect(date.ceil(unit, 5), truncated));
  }

  for (final (date, unit, truncated) in [
    (LocalDate(6, 2), DateUnit.years, LocalDate(5)),
    (LocalDate(9, 2), DateUnit.years, LocalDate(5)),
    (LocalDate(1, 6, 2), DateUnit.months, LocalDate(1, 5)),
    (LocalDate(1, 9, 2), DateUnit.months, LocalDate(1, 5)),
    (LocalDate(1, 1, 6), DateUnit.days, LocalDate(1, 1, 5)),
    (LocalDate(1, 1, 9), DateUnit.days, LocalDate(1, 1, 5)),
  ]) {
    test('floor $unit to 5', () => expect(date.floor(unit, 5), truncated));
  }

  group('copyWith(...)', () {
    test('values', () => expect(LocalDate(2023, 5, 2).copyWith(year: 2024, month: 6, day: 3), LocalDate(2024, 6, 3)));

    test('nothing', () => expect(LocalDate(2023, 5, 2).copyWith(), LocalDate(2023, 5, 2)));
  });

  test(
    'difference(...)',
    () => expect(LocalDate(2023, 5, 10).difference(LocalDate(2022, 3, 7)), const Duration(days: 429)),
  );

  test(
    'at(...)',
    () => expect(LocalDate(2023, 5, 10).at(LocalTime(1, 2, 3, 4, 5)), LocalDateTime(2023, 5, 10, 1, 2, 3, 4, 5)),
  );

  test('toNative()', () => expect(LocalDate(2023, 5, 10).toNative(), DateTime.utc(2023, 5, 10)));

  group('compareTo(...) & hashValue', () {
    test('-1', () {
      expect(LocalDate(2023, 5, 10).compareTo(LocalDate(2023, 5, 11)), -1);
      expect(LocalDate(2023, 5, 10).hashValue, isNot(LocalDate(2023, 5, 11).hashValue));
    });

    test('0', () {
      expect(LocalDate(2023, 5, 11).compareTo(LocalDate(2023, 5, 11)), 0);
      expect(LocalDate(2023, 5, 11).hashValue, LocalDate(2023, 5, 11).hashValue);
    });

    test('1', () {
      expect(LocalDate(2023, 5, 11).compareTo(LocalDate(2023, 5, 10)), 1);
      expect(LocalDate(2023, 5, 11).hashValue, isNot(LocalDate(2023, 5, 10).hashValue));
    });
  });

  group('toString()', () {
    test('pads year', () => expect(LocalDate(0999, 12, 15).toString(), '0999-12-15'));

    test('pads month', () => expect(LocalDate(2023, 4, 15).toString(), '2023-04-15'));

    test('pads day', () => expect(LocalDate(2023, 12, 5).toString(), '2023-12-05'));
  });

  test('weekday', () => expect(LocalDate(2023, 5, 3).weekday, 3));

  group('weekOfYear', () {
    test('last week of previous year', () => expect(LocalDate(2023).weekOfYear, 52));

    test('first of year', () => expect(LocalDate(2023, 1, 2).weekOfYear, 1));

    test('middle of year', () => expect(LocalDate(2023, 6, 15).weekOfYear, 24));

    test('short year last week', () => expect(LocalDate(2023, 12, 31).weekOfYear, 52));

    test('long year last week', () => expect(LocalDate(2020, 12, 31).weekOfYear, 53));
  });

  group('dayOfYear(...)', () {
    test('leap year first day', () => expect(LocalDate(2020).dayOfYear, 1));

    test('leap year before February', () => expect(LocalDate(2020, 2, 20).dayOfYear, 51));

    test('leap year after February', () => expect(LocalDate(2020, 3, 20).dayOfYear, 80));

    test('leap year last day', () => expect(LocalDate(2020, 12, 31).dayOfYear, 366));

    test('non-leap year first day', () => expect(LocalDate(2021).dayOfYear, 1));

    test('non-leap year', () => expect(LocalDate(2021, 3, 20).dayOfYear, 79));

    test('non-leap year last day', () => expect(LocalDate(2021, 12, 31).dayOfYear, 365));
  });

  group('firstDayOfWeek', () {
    test('current date', () => expect(LocalDate(2023, 5, 8).firstDayOfWeek, LocalDate(2023, 5, 8)));

    test('last day of week', () => expect(LocalDate(2023, 5, 14).firstDayOfWeek, LocalDate(2023, 5, 8)));

    test('across months', () => expect(LocalDate(2023, 6, 2).firstDayOfWeek, LocalDate(2023, 5, 29)));
  });

  group('lastDayOfWeek', () {
    test('current date', () => expect(LocalDate(2023, 5, 8).lastDayOfWeek, LocalDate(2023, 5, 14)));

    test('last day of week', () => expect(LocalDate(2023, 5, 14).lastDayOfWeek, LocalDate(2023, 5, 14)));

    test('across months', () => expect(LocalDate(2023, 5, 29).lastDayOfWeek, LocalDate(2023, 6, 4)));
  });

  group('firstDayOfMonth', () {
    test('current date', () => expect(LocalDate(2023, 5).firstDayOfMonth, LocalDate(2023, 5)));

    test('last day of the month', () => expect(LocalDate(2023, 5, 31).firstDayOfMonth, LocalDate(2023, 5)));
  });

  group('lastDayOfMonth', () {
    test('current date', () => expect(LocalDate(2023, 2, 28).lastDayOfMonth, LocalDate(2023, 2, 28)));

    test('first day of the month', () => expect(LocalDate(2023, 2).lastDayOfMonth, LocalDate(2023, 2, 28)));

    test('leap year', () => expect(LocalDate(2020, 2).lastDayOfMonth, LocalDate(2020, 2, 29)));
  });

  group('daysInMonth', () {
    test('leap year', () => expect(LocalDate(2020, 2).daysInMonth, 29));

    test('non-leap year', () => expect(LocalDate(2021, 2).daysInMonth, 28));
  });

  group('leapYear', () {
    test('leap year', () => expect(LocalDate(2020).leapYear, true));

    test('non-leap year', () => expect(LocalDate(2021).leapYear, false));
  });

  test('epochDays', () => expect(LocalDate(2023, 5, 3).epochDays, 19480));

  test(
    'epochMilliseconds',
    () => expect(LocalDate(2023, 5, 2).epochMilliseconds, DateTime.utc(2023, 5, 2).millisecondsSinceEpoch),
  );

  test(
    'epochMicroseconds',
    () => expect(LocalDate(2023, 5, 2).epochMicroseconds, DateTime.utc(2023, 5, 2).microsecondsSinceEpoch),
  );
}
