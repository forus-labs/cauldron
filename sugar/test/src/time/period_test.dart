import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  for (final (actual, expected) in [
    (const Period(), const Period()),

    (const Period(months: 11), const Period(months: 11)),
    (const Period(months: 13), const Period(years: 1, months: 1)),

    (const Period(hours: 23), const Period(hours: 23)),
    (
      const Period(days: 1, hours: 23, minutes: 59, seconds: 59, milliseconds: 999, microseconds: 1001),
      const Period(days: 2, microseconds: 1),
    ),

    (const Period(years: -1, months: 1), const Period(months: -11)),
    (
      const Period(days: -1, microseconds: 1),
      const Period(hours: -23, minutes: -59, seconds: -59, milliseconds: -999, microseconds: -999),
    ),

    (const Period(years: -1, months: 1, microseconds: 1), const Period(months: -11, microseconds: 1)),
    (
      const Period(years: -1, days: -1, microseconds: 1),
      const Period(years: -1, hours: -23, minutes: -59, seconds: -59, milliseconds: -999, microseconds: -999),
    ),

    (const Period(days: 100), const Period(days: 100)),
  ]) {
    test('normalize()', () => expect(actual.normalize(), expected));
  }

  test(
    'plus()',
    () => expect(
      const Period(
        years: 1,
        months: 2,
        days: 3,
        hours: 4,
        minutes: 5,
        seconds: 6,
        milliseconds: 7,
        microseconds: 8,
      ).plus(years: 2, months: 3, days: 4, hours: 5, minutes: 6, seconds: 7, milliseconds: 8, microseconds: 9),
      const Period(
        years: 3,
        months: 5,
        days: 7,
        hours: 9,
        minutes: 11,
        seconds: 13,
        milliseconds: 15,
        microseconds: 17,
      ),
    ),
  );

  test('plus() does not normalize ', () => expect(const Period(months: 11).plus(months: 2), const Period(months: 13)));

  test(
    'minus',
    () => expect(
      const Period(
        years: 1,
        months: 2,
        days: 3,
        hours: 4,
        minutes: 5,
        seconds: 6,
        milliseconds: 7,
        microseconds: 8,
      ).minus(years: 9, months: 8, days: 7, hours: 6, minutes: 5, seconds: 4, milliseconds: 3, microseconds: 2),
      const Period(
        years: -8,
        months: -6,
        days: -4,
        hours: -2,
        // ignore: avoid_redundant_argument_values
        minutes: 0,
        seconds: 2,
        milliseconds: 4,
        microseconds: 6,
      ),
    ),
  );

  test(
    'minus() does not normalize ',
    () => expect(const Period(months: -11).minus(months: 2), const Period(months: -13)),
  );

  test(
    '+',
    () => expect(
      const Period(years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6, milliseconds: 7, microseconds: 8) +
          const Period(
            years: 2,
            months: 3,
            days: 4,
            hours: 5,
            minutes: 6,
            seconds: 7,
            milliseconds: 8,
            microseconds: 9,
          ),
      const Period(
        years: 3,
        months: 5,
        days: 7,
        hours: 9,
        minutes: 11,
        seconds: 13,
        milliseconds: 15,
        microseconds: 17,
      ),
    ),
  );

  test(
    '+ does not normalize ',
    () => expect(const Period(months: 11) + const Period(months: 2), const Period(months: 13)),
  );

  test(
    '-',
    () => expect(
      const Period(years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6, milliseconds: 7, microseconds: 8) -
          const Period(
            years: 9,
            months: 8,
            days: 7,
            hours: 6,
            minutes: 5,
            seconds: 4,
            milliseconds: 3,
            microseconds: 2,
          ),
      const Period(
        years: -8,
        months: -6,
        days: -4,
        hours: -2,
        // ignore: avoid_redundant_argument_values
        minutes: 0,
        seconds: 2,
        milliseconds: 4,
        microseconds: 6,
      ),
    ),
  );

  test(
    '- does not normalize ',
    () => expect(const Period(months: -11) - const Period(months: 2), const Period(months: -13)),
  );

  test('copyWith() with nothing', () {
    const period = Period(
      years: 1,
      months: 2,
      days: 3,
      hours: 4,
      minutes: 5,
      seconds: 6,
      milliseconds: 7,
      microseconds: 8,
    );
    expect(period.copyWith(), period);
  });

  test('copyWith() with all units replaced', () {
    const period = Period(
      years: 1,
      months: 2,
      days: 3,
      hours: 4,
      minutes: 5,
      seconds: 6,
      milliseconds: 7,
      microseconds: 8,
    );

    expect(
      period.copyWith(years: 9, months: 8, days: 7, hours: 6, minutes: 5, seconds: 4, milliseconds: 3, microseconds: 2),
      const Period(years: 9, months: 8, days: 7, hours: 6, minutes: 5, seconds: 4, milliseconds: 3, microseconds: 2),
    );
  });

  test('period equal same period', () {
    expect(const Period(years: 1, months: 13), const Period(years: 1, months: 13));
    expect(const Period(years: 1, months: 13).hashCode, const Period(years: 1, months: 13).hashCode);
  });

  test('period not equal other period', () {
    expect(const Period(years: 1, months: 13), isNot(const Period(years: 1, months: 15)));
    expect(const Period(years: 1, months: 13).hashCode, isNot(const Period(years: 1, months: 15).hashCode));
  });

  test('period not equal normalized', () {
    expect(const Period(years: 1, months: 13), isNot(const Period(years: 2, months: 1)));
    expect(const Period(years: 1, months: 13).hashCode, isNot(const Period(years: 2, months: 1).hashCode));
  });

  test(
    'toString()',
    () => expect(
      const Period(
        years: 1,
        months: 2,
        days: 3,
        hours: 4,
        minutes: 5,
        seconds: 6,
        milliseconds: 7,
        microseconds: 8,
      ).toString(),
      'Period[1 years, 2 months, 3 days, 4 hours, 5 minutes, 6 seconds, 7 milliseconds, 8 microseconds]',
    ),
  );
}
