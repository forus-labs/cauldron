import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('plus(...)', () {
    test('positive', () => expect(
      DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8).plus(
        years: 2,
        months: 3,
        days: 4,
        hours: 5,
        minutes: 6,
        seconds: 7,
        milliseconds: 8,
        microseconds: 9,
      ),
      DateTime.utc(3, 5, 7, 9, 11, 13, 15, 17),
    ));

    test('negative', () => expect(
      DateTime.utc(8, 7, 6, 5, 40, 30, 20, 10).plus(
        years: -1,
        months: -2,
        days: -3,
        hours: -5,
        minutes: -6,
        seconds: -7,
        milliseconds: -8,
        microseconds: -9,
      ),
      DateTime.utc(7, 5, 3, 0, 34, 23, 12, 1),
    ));

    test('nothing', () => expect(DateTime(1, 2, 3, 4, 5, 6, 7, 8).plus(), DateTime(1, 2, 3, 4, 5, 6, 7, 8)));
  });

  group('minus(...)', () {
    test('positive', () => expect(
      DateTime.utc(8, 7, 6, 5, 40, 30, 20, 10).minus(
        years: 1,
        months: 2,
        days: 3,
        hours: 5,
        minutes: 6,
        seconds: 7,
        milliseconds: 8,
        microseconds: 9,
      ),
      DateTime.utc(7, 5, 3, 0, 34, 23, 12, 1),
    ));

    test('negative', () => expect(
      DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8).minus(
        years: -2,
        months: -3,
        days: -4,
        hours: -5,
        minutes: -6,
        seconds: -7,
        milliseconds: -8,
        microseconds: -9,
      ),
      DateTime.utc(3, 5, 7, 9, 11, 13, 15, 17),
    ));

    test('nothing', () => expect(DateTime(1, 2, 3, 4, 5, 6, 7, 8).minus(), DateTime(1, 2, 3, 4, 5, 6, 7, 8)));
  });

  group('+', () {
    test('positive', () => expect(
      DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8) + const Period(
        years: 2,
        months: 3,
        days: 4,
        hours: 5,
        minutes: 6,
        seconds: 7,
        milliseconds: 8,
        microseconds: 9,
      ),
      DateTime.utc(3, 5, 7, 9, 11, 13, 15, 17),
    ));

    test('negative', () => expect(
      DateTime.utc(8, 7, 6, 5, 40, 30, 20, 10) + const Period(
        years: -1,
        months: -2,
        days: -3,
        hours: -5,
        minutes: -6,
        seconds: -7,
        milliseconds: -8,
        microseconds: -9,
      ),
      DateTime.utc(7, 5, 3, 0, 34, 23, 12, 1),
    ));

    test('nothing', () => expect(DateTime(1, 2, 3, 4, 5, 6, 7, 8) + const Period(), DateTime(1, 2, 3, 4, 5, 6, 7, 8)));
  });

  group('-', () {
    test('positive', () => expect(
      DateTime.utc(8, 7, 6, 5, 40, 30, 20, 10) - const Period(
        years: 1,
        months: 2,
        days: 3,
        hours: 5,
        minutes: 6,
        seconds: 7,
        milliseconds: 8,
        microseconds: 9,
      ),
      DateTime.utc(7, 5, 3, 0, 34, 23, 12, 1),
    ));

    test('negative', () => expect(
      DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8) - const Period(
        years: -2,
        months: -3,
        days: -4,
        hours: -5,
        minutes: -6,
        seconds: -7,
        milliseconds: -8,
        microseconds: -9,
      ),
      DateTime.utc(3, 5, 7, 9, 11, 13, 15, 17),
    ));

    test('nothing', () => expect(DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8) - const Period(), DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8)));
  });

  for (final arguments in [
    [DateUnit.years, DateTime(10)],
    [DateUnit.months, DateTime(10, 2)],
    [DateUnit.days, DateTime(10, 2, 3)],
    [TimeUnit.hours, DateTime(10, 2, 3, 4)],
    [TimeUnit.minutes, DateTime(10, 2, 3, 4, 5)],
    [TimeUnit.seconds, DateTime(10, 2, 3, 4, 5, 6)],
    [TimeUnit.milliseconds, DateTime(10, 2, 3, 4, 5, 6, 7)],
    [TimeUnit.microseconds, DateTime(10, 2, 3, 4, 5, 6, 7, 8)],
  ]) {
    final date = DateTime(10, 2, 3, 4, 5, 6, 7, 8);
    final unit = arguments[0] as TemporalUnit;
    final truncated = arguments[1] as DateTime;

    test('truncate to $unit', () => expect(date.truncate(to: unit), truncated));
  }

  for (final arguments in [
    [DateTime(3, 2), DateUnit.years, DateTime(5)],
    [DateTime(7, 2), DateUnit.years, DateTime(5)],
    [DateTime(1, 3, 2), DateUnit.months, DateTime(1, 5)],
    [DateTime(1, 7, 2), DateUnit.months, DateTime(1, 5)],
    [DateTime(1, 1, 3, 2), DateUnit.days, DateTime(1, 1, 5)],
    [DateTime(1, 1, 7, 2), DateUnit.days, DateTime(1, 1, 5)],
    [DateTime(1, 1, 1, 3, 2), TimeUnit.hours, DateTime(1, 1, 1, 5)],
    [DateTime(1, 1, 1, 7, 2), TimeUnit.hours, DateTime(1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 3, 2), TimeUnit.minutes, DateTime(1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 7, 2), TimeUnit.minutes, DateTime(1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 3, 2), TimeUnit.seconds, DateTime(1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 7, 2), TimeUnit.seconds, DateTime(1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 3, 2), TimeUnit.milliseconds, DateTime(1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 7, 2), TimeUnit.milliseconds, DateTime(1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 1, 3), TimeUnit.microseconds, DateTime(1, 1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 1, 7), TimeUnit.microseconds, DateTime(1, 1, 1, 1, 1, 1, 1, 5)],
  ]) {
    final date = arguments[0] as DateTime;
    final unit = arguments[1] as TemporalUnit;
    final truncated = arguments[2] as DateTime;

    test('round $unit to 5', () => expect(date.round(unit, 5), truncated));
  }

  for (final arguments in [
    [DateTime(2, 9), DateUnit.years, DateTime(5)],
    [DateTime(4, 9), DateUnit.years, DateTime(5)],
    [DateTime(1, 2, 9), DateUnit.months, DateTime(1, 5)],
    [DateTime(1, 4, 9), DateUnit.months, DateTime(1, 5)],
    [DateTime(1, 1, 2, 9), DateUnit.days, DateTime(1, 1, 5)],
    [DateTime(1, 1, 4, 9), DateUnit.days, DateTime(1, 1, 5)],
    [DateTime(1, 1, 1, 2, 9), TimeUnit.hours, DateTime(1, 1, 1, 5)],
    [DateTime(1, 1, 1, 4, 9), TimeUnit.hours, DateTime(1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 2, 9), TimeUnit.minutes, DateTime(1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 4, 9), TimeUnit.minutes, DateTime(1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 2, 9), TimeUnit.seconds, DateTime(1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 4, 9), TimeUnit.seconds, DateTime(1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 2, 9), TimeUnit.milliseconds, DateTime(1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 4, 9), TimeUnit.milliseconds, DateTime(1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 1, 2), TimeUnit.microseconds, DateTime(1, 1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 1, 4), TimeUnit.microseconds, DateTime(1, 1, 1, 1, 1, 1, 1, 5)],
  ]) {
    final date = arguments[0] as DateTime;
    final unit = arguments[1] as TemporalUnit;
    final truncated = arguments[2] as DateTime;

    test('ceil $unit to 5', () => expect(date.ceil(unit, 5), truncated));
  }

  for (final arguments in [
    [DateTime(6, 2), DateUnit.years, DateTime(5)],
    [DateTime(9, 2), DateUnit.years, DateTime(5)],
    [DateTime(1, 6, 2), DateUnit.months, DateTime(1, 5)],
    [DateTime(1, 9, 2), DateUnit.months, DateTime(1, 5)],
    [DateTime(1, 1, 6, 2), DateUnit.days, DateTime(1, 1, 5)],
    [DateTime(1, 1, 9, 2), DateUnit.days, DateTime(1, 1, 5)],
    [DateTime(1, 1, 1, 6, 2), TimeUnit.hours, DateTime(1, 1, 1, 5)],
    [DateTime(1, 1, 1, 9, 2), TimeUnit.hours, DateTime(1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 6, 2), TimeUnit.minutes, DateTime(1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 9, 2), TimeUnit.minutes, DateTime(1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 6, 2), TimeUnit.seconds, DateTime(1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 9, 2), TimeUnit.seconds, DateTime(1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 6, 2), TimeUnit.milliseconds, DateTime(1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 9, 2), TimeUnit.milliseconds, DateTime(1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 1, 6), TimeUnit.microseconds, DateTime(1, 1, 1, 1, 1, 1, 1, 5)],
    [DateTime(1, 1, 1, 1, 1, 1, 1, 9), TimeUnit.microseconds, DateTime(1, 1, 1, 1, 1, 1, 1, 5)],
  ]) {
    final date = arguments[0] as DateTime;
    final unit = arguments[1] as TemporalUnit;
    final truncated = arguments[2] as DateTime;

    test('floor $unit to 5', () => expect(date.floor(unit, 5), truncated));
  }


  group('gap(...)', () {
    test('positive', () => expect(
      DateTime.utc(2, 4, 6, 8, 10, 12, 14, 16).gap(DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8)),
      const Period(years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6, milliseconds: 7, microseconds: 8),
    ));

    test('negative', () => expect(
      DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8).gap(DateTime.utc(2, 4, 6, 8, 10, 12, 14, 16)),
      const Period(years: -1, months: -2, days: -3, hours: -4, minutes: -5, seconds: -6, milliseconds: -7, microseconds: -8),
    ));
  });


  group('toDateString()', () {
    test('pads year', () => expect(DateTime(0999, 12, 15, 1).toDateString(), '0999-12-15'));

    test('pads month', () => expect(DateTime(2023, 4, 15, 1).toDateString(), '2023-04-15'));

    test('pads day', () => expect(DateTime(2023, 12, 5, 1).toDateString(), '2023-12-05'));
  });

  for (final arguments in [
    [DateTime(2023, 4, 15, 1, 2, 3, 4, 5), '01:02:03.004005'],
    [DateTime(2023, 4, 15, 1), '01:00'],
    [DateTime(2023, 4, 15, 0, 1), '00:01'],
    [DateTime(2023, 4, 15, 0, 0, 1), '00:00:01'],
    [DateTime(2023, 4, 15, 0, 0, 0, 1), '00:00:00.001'],
    [DateTime(2023, 4, 15, 0, 0, 0, 0, 1), '00:00:00.000001'],
  ]) {
    final date = arguments[0] as DateTime;
    final string = arguments[1] as String;

    test('toTimeString()', () => expect(date.toTimeString(), string));
  }


  test('offset', () => expect(Offset(), DateTime.utc(1).offset));

  
  group('weekOfYear', () {
    test('last week of previous year', () => expect(DateTime(2023).weekOfYear, 52));

    test('first of year', () => expect(DateTime(2023, 1, 2).weekOfYear, 1));

    test('middle of year', () => expect(DateTime(2023, 6, 15).weekOfYear, 24));

    test('short year last week', () => expect(DateTime(2023, 12, 31).weekOfYear, 52));

    test('long year last week', () => expect(DateTime(2020, 12, 31).weekOfYear, 53));
  });

  group('dayOfYear(...)', () {
    test('leap year first day', () => expect(DateTime(2020).dayOfYear, 1));

    test('leap year before February', () => expect(DateTime(2020, 2, 20).dayOfYear, 51));

    test('leap year after February', () => expect(DateTime(2020, 3, 20).dayOfYear, 80));

    test('leap year last day', () => expect(DateTime(2020, 12, 31).dayOfYear, 366));

    test('non-leap year first day', () => expect(DateTime(2021).dayOfYear, 1));

    test('non-leap year', () => expect(DateTime(2021, 3, 20).dayOfYear, 79));

    test('non-leap year last day', () => expect(DateTime(2021, 12, 31).dayOfYear, 365));
  });


  group('firstDayOfWeek', () {
    test('current date', () => expect(DateTime(2023, 5, 8, 1).firstDayOfWeek, DateTime(2023, 5, 8)));

    test('last day of week', () => expect(DateTime(2023, 5, 14, 1).firstDayOfWeek, DateTime(2023, 5, 8)));

    test('across months', () => expect(DateTime(2023, 6, 2).firstDayOfWeek, DateTime(2023, 5, 29)));
  });

  group('lastDayOfWeek', () {
    test('current date', () => expect(DateTime(2023, 5, 8, 1).lastDayOfWeek, DateTime(2023, 5, 14)));

    test('last day of week', () => expect(DateTime(2023, 5, 14, 1).lastDayOfWeek, DateTime(2023, 5, 14)));

    test('across months', () => expect(DateTime(2023, 5, 29).lastDayOfWeek, DateTime(2023, 6, 4)));
  });


  group('firstDayOfMonth', () {
    test('current date', () => expect(DateTime(2023, 5, 1, 1).firstDayOfMonth, DateTime(2023, 5)));

    test('last day of the month', () => expect(DateTime(2023, 5, 31).firstDayOfMonth, DateTime(2023, 5)));
  });

  group('lastDayOfMonth', () {
    test('current date', () => expect(DateTime(2023, 2, 28).lastDayOfMonth, DateTime(2023, 2, 28)));

    test('first day of the month', () => expect(DateTime(2023, 2).lastDayOfMonth, DateTime(2023, 2, 28)));

    test('leap year', () => expect(DateTime(2020, 2).lastDayOfMonth, DateTime(2020, 2, 29)));
  });


  group('daysInMonth', () {
    test('leap year', () => expect(DateTime(2020, 2).daysInMonth, 29));

    test('non-leap year', () => expect(DateTime(2021, 2).daysInMonth, 28));
  });

  group('leapYear', () {
    test('leap year', () => expect(DateTime(2020).leapYear, true));

    test('non-leap year', () => expect(DateTime(2021).leapYear, false));
  });


  test('daysSinceEpoch', () => expect(DateTime.utc(2023, 5, 2).daysSinceEpoch, 19479));

  test('secondsSinceEpoch', () => expect(DateTime.utc(2023, 5, 2).secondsSinceEpoch, 1682985600));

  test('secondsSinceMidnight', () => expect(DateTime(2023, 5, 2, 1, 2, 3, 4, 5).secondsSinceMidnight, 3723));

  test('millisecondsSinceMidnight', () => expect(DateTime(2023, 5, 2, 1, 2, 3, 4, 5).millisecondsSinceMidnight, 3723004));

  test('microsecondsSinceMidnight', () => expect(DateTime(2023, 5, 2, 1, 2, 3, 4, 5).microsecondsSinceMidnight, 3723004005));
}
