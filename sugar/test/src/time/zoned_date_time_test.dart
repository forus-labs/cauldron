import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

const singapore = 'Asia/Singapore';

void main() {
  test('fromEpochMilliseconds(...)', () {
    final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12, 2);
    final other = ZonedDateTime.fromEpochMilliseconds(Timezone('America/Detroit'), datetime.epochMilliseconds);
    final timezone = other.timezone;
    final span = other.span;
    
    expect(other.epochMilliseconds, datetime.epochMilliseconds);
    expect(datetime.toString(), '2023-03-12T03:00-04:00[America/Detroit]');
    expect(timezone.name, 'America/Detroit');
    expect(span.abbreviation, 'EDT');
    expect(span.dst, true);
    expect(span.offset, Offset(-4));
  });

  test('fromEpochMicroseconds(...)', () {
    final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12, 2);
    final other = ZonedDateTime.fromEpochMicroseconds(Timezone('America/Detroit'), datetime.epochMicroseconds);
    final timezone = other.timezone;
    final span = other.span;

    expect(other.epochMicroseconds, datetime.epochMicroseconds);
    expect(datetime.toString(), '2023-03-12T03:00-04:00[America/Detroit]');
    expect(timezone.name, 'America/Detroit');
    expect(span.abbreviation, 'EDT');
    expect(span.dst, true);
    expect(span.offset, Offset(-4));
  });

  test('now()', () {
    final zoned = ZonedDateTime.now();
    final native = DateTime.now();

    expect(zoned.epochMicroseconds, closeTo(native.microsecondsSinceEpoch, 10000));

    expect(zoned.year, native.year);
    expect(zoned.month, native.month);
    expect(zoned.day, native.day);
    expect(zoned.hour, native.hour);
    expect(zoned.minute, native.minute);
    expect(zoned.second, native.second);
  }, tags: ['flaky']);

  group('from(...)', () {
    test('values', () {
      final datetime = ZonedDateTime.from(Timezone('America/Detroit'), 2023, 3, 12, 2, 3, 4, 5, 6);
      final other = ZonedDateTime.fromEpochMicroseconds(Timezone('America/Detroit'), datetime.epochMicroseconds);
      final timezone = datetime.timezone;
      final span = datetime.span;

      expect(datetime.epochMicroseconds, closeTo(other.epochMicroseconds, 10000));
      expect(datetime.toString(), '2023-03-12T03:03:04.005006-04:00[America/Detroit]');

      expect(datetime.year, 2023);
      expect(datetime.month, 3);
      expect(datetime.day, 12);
      expect(datetime.hour, 3);
      expect(datetime.minute, 3);
      expect(datetime.second, 4);
      expect(datetime.millisecond, 5);
      expect(datetime.microsecond, 6);

      expect(timezone.name, 'America/Detroit');
      expect(span.abbreviation, 'EDT');
      expect(span.dst, true);
      expect(span.offset, Offset(-4));
    });

    test('default values', () {
      final datetime = ZonedDateTime.from(Timezone('America/Detroit'), 2023);
      final other = ZonedDateTime.fromEpochMicroseconds(Timezone('America/Detroit'), datetime.epochMicroseconds);
      final timezone = datetime.timezone;
      final span = datetime.span;

      expect(datetime.epochMicroseconds, closeTo(other.epochMicroseconds, 10000));
      expect(datetime.toString(), '2023-01-01T00:00-05:00[America/Detroit]');

      expect(datetime.year, 2023);
      expect(datetime.month, 1);
      expect(datetime.day, 1);
      expect(datetime.hour, 0);
      expect(datetime.minute, 0);
      expect(datetime.second, 0);
      expect(datetime.millisecond, 0);
      expect(datetime.microsecond, 0);

      expect(timezone.name, 'America/Detroit');
      expect(span.abbreviation, 'EST');
      expect(span.dst, false);
      expect(span.offset, Offset(-5));
    });
  });

  group('ZonedDateTime(...)', () {
    test('values', () {
      final datetime = ZonedDateTime('America/Detroit', 2023, 3, 12, 2, 3, 4, 5, 6);
      final other = ZonedDateTime.fromEpochMicroseconds(Timezone('America/Detroit'), datetime.epochMicroseconds);
      final timezone = datetime.timezone;
      final span = datetime.span;

      expect(datetime.epochMicroseconds, closeTo(other.epochMicroseconds, 10000));
      expect(datetime.toString(), '2023-03-12T03:03:04.005006-04:00[America/Detroit]');

      expect(datetime.year, 2023);
      expect(datetime.month, 3);
      expect(datetime.day, 12);
      expect(datetime.hour, 3);
      expect(datetime.minute, 3);
      expect(datetime.second, 4);
      expect(datetime.millisecond, 5);
      expect(datetime.microsecond, 6);

      expect(timezone.name, 'America/Detroit');
      expect(span.abbreviation, 'EDT');
      expect(span.dst, true);
      expect(span.offset, Offset(-4));
    });

    test('default values', () {
      final datetime = ZonedDateTime('America/Detroit', 2023);
      final other = ZonedDateTime.fromEpochMicroseconds(Timezone('America/Detroit'), datetime.epochMicroseconds);
      final timezone = datetime.timezone;
      final span = datetime.span;

      expect(datetime.epochMicroseconds, closeTo(other.epochMicroseconds, 10000));
      expect(datetime.toString(), '2023-01-01T00:00-05:00[America/Detroit]');

      expect(datetime.year, 2023);
      expect(datetime.month, 1);
      expect(datetime.day, 1);
      expect(datetime.hour, 0);
      expect(datetime.minute, 0);
      expect(datetime.second, 0);
      expect(datetime.millisecond, 0);
      expect(datetime.microsecond, 0);

      expect(timezone.name, 'America/Detroit');
      expect(span.abbreviation, 'EST');
      expect(span.dst, false);
      expect(span.offset, Offset(-5));
    });
  });


  group('add(...)', () {
    test('DST', () => expect(
      ZonedDateTime('America/Detroit', 2023, 3, 12).add(const Duration(days: 1)),
      ZonedDateTime('America/Detroit', 2023, 3, 13, 1),
    ));

    test('non-DST', () => expect(
        ZonedDateTime('America/Detroit', 2023, 3, 15).add(const Duration(days: 1)),
        ZonedDateTime('America/Detroit', 2023, 3, 16),
    ));
  });

  group('subtract(...)', () {
    test('DST', () => expect(
        ZonedDateTime('America/Detroit', 2023, 3, 13).subtract(const Duration(days: 1)),
        ZonedDateTime('America/Detroit', 2023, 3, 11, 23),
    ));

    test('non-DST', () => expect(
        ZonedDateTime('America/Detroit', 2023, 3, 16).subtract(const Duration(days: 1)),
        ZonedDateTime('America/Detroit', 2023, 3, 15),
    ));
  });


  group('plus(...)', () {
    test('DST', () => expect(
        ZonedDateTime('America/Detroit', 2023, 3, 12).plus(days: 1),
        ZonedDateTime('America/Detroit', 2023, 3, 13),
    ));

    test('non-DST', () => expect(
        ZonedDateTime('America/Detroit', 2023, 3, 15).plus(days: 1),
        ZonedDateTime('America/Detroit', 2023, 3, 16),
    ));
  });

  group('minus(...)', () {
    test('DST', () => expect(
      ZonedDateTime('America/Detroit', 2023, 3, 13).minus(days: 1),
      ZonedDateTime('America/Detroit', 2023, 3, 12),
    ));

    test('non-DST', () => expect(
      ZonedDateTime('America/Detroit', 2023, 3, 16).minus(days: 1),
      ZonedDateTime('America/Detroit', 2023, 3, 15),
    ));
  });


  group('+', () {
    test('DST', () => expect(
      ZonedDateTime('America/Detroit', 2023, 3, 12) + const Period(days: 1),
      ZonedDateTime('America/Detroit', 2023, 3, 13),
    ));

    test('non-DST', () => expect(
      ZonedDateTime('America/Detroit', 2023, 3, 15) + const Period(days: 1),
      ZonedDateTime('America/Detroit', 2023, 3, 16),
    ));
  });

  group('-', () {
    test('DST', () => expect(
      ZonedDateTime('America/Detroit', 2023, 3, 13) - const Period(days: 1),
      ZonedDateTime('America/Detroit', 2023, 3, 12),
    ));

    test('non-DST', () => expect(
      ZonedDateTime('America/Detroit', 2023, 3, 16) - const Period(days: 1),
      ZonedDateTime('America/Detroit', 2023, 3, 15),
    ));
  });

  
  for (final (unit, truncated) in [
    (DateUnit.years, ZonedDateTime('America/Detroit', 10)),
    (DateUnit.months, ZonedDateTime('America/Detroit', 10, 2)),
    (DateUnit.days, ZonedDateTime('America/Detroit', 10, 2, 3)),
    (TimeUnit.hours, ZonedDateTime('America/Detroit', 10, 2, 3, 4)),
    (TimeUnit.minutes, ZonedDateTime('America/Detroit', 10, 2, 3, 4, 5)),
    (TimeUnit.seconds, ZonedDateTime('America/Detroit', 10, 2, 3, 4, 5, 6)),
    (TimeUnit.milliseconds, ZonedDateTime('America/Detroit', 10, 2, 3, 4, 5, 6, 7)),
    (TimeUnit.microseconds, ZonedDateTime('America/Detroit', 10, 2, 3, 4, 5, 6, 7, 8)),
  ]) {
    final date = ZonedDateTime('America/Detroit', 10, 2, 3, 4, 5, 6, 7, 8);
    test('truncate to $unit', () => expect(date.truncate(to: unit as TemporalUnit), truncated));
  }

  for (final (date, unit, truncated) in [
    (ZonedDateTime('America/Detroit', 3, 2), DateUnit.years, ZonedDateTime('America/Detroit', 5)),
    (ZonedDateTime('America/Detroit', 7, 2), DateUnit.years, ZonedDateTime('America/Detroit', 5)),
    (ZonedDateTime('America/Detroit', 1, 3, 2), DateUnit.months, ZonedDateTime('America/Detroit', 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 7, 2), DateUnit.months, ZonedDateTime('America/Detroit', 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 3, 2), DateUnit.days, ZonedDateTime('America/Detroit', 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 7, 2), DateUnit.days, ZonedDateTime('America/Detroit', 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 3, 2), TimeUnit.hours, ZonedDateTime('America/Detroit', 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 7, 2), TimeUnit.hours, ZonedDateTime('America/Detroit', 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 3, 2), TimeUnit.minutes, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 7, 2), TimeUnit.minutes, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 3, 2), TimeUnit.seconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 7, 2), TimeUnit.seconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 3, 2), TimeUnit.milliseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 7, 2), TimeUnit.milliseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 3), TimeUnit.microseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 7), TimeUnit.microseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 5)),
  ]) {
    test('round $unit to 5', () => expect(date.round(unit as TemporalUnit, 5), truncated));
  }

  for (final (date, unit, truncated) in [
    (ZonedDateTime('America/Detroit', 2, 9), DateUnit.years, ZonedDateTime('America/Detroit', 5)),
    (ZonedDateTime('America/Detroit', 4, 9), DateUnit.years, ZonedDateTime('America/Detroit', 5)),
    (ZonedDateTime('America/Detroit', 1, 2, 9), DateUnit.months, ZonedDateTime('America/Detroit', 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 4, 9), DateUnit.months, ZonedDateTime('America/Detroit', 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 2, 9), DateUnit.days, ZonedDateTime('America/Detroit', 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 4, 9), DateUnit.days, ZonedDateTime('America/Detroit', 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 2, 9), TimeUnit.hours, ZonedDateTime('America/Detroit', 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 4, 9), TimeUnit.hours, ZonedDateTime('America/Detroit', 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 2, 9), TimeUnit.minutes, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 4, 9), TimeUnit.minutes, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 2, 9), TimeUnit.seconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 4, 9), TimeUnit.seconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 2, 9), TimeUnit.milliseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 4, 9), TimeUnit.milliseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 2), TimeUnit.microseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 4), TimeUnit.microseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 5)),
  ]) {
    test('ceil $unit to 5', () => expect(date.ceil(unit as TemporalUnit, 5), truncated));
  }

  for (final (date, unit, truncated) in [
    (ZonedDateTime('America/Detroit', 6, 2), DateUnit.years, ZonedDateTime('America/Detroit', 5)),
    (ZonedDateTime('America/Detroit', 9, 2), DateUnit.years, ZonedDateTime('America/Detroit', 5)),
    (ZonedDateTime('America/Detroit', 1, 6, 2), DateUnit.months, ZonedDateTime('America/Detroit', 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 9, 2), DateUnit.months, ZonedDateTime('America/Detroit', 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 6, 2), DateUnit.days, ZonedDateTime('America/Detroit', 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 9, 2), DateUnit.days, ZonedDateTime('America/Detroit', 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 6, 2), TimeUnit.hours, ZonedDateTime('America/Detroit', 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 9, 2), TimeUnit.hours, ZonedDateTime('America/Detroit', 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 6, 2), TimeUnit.minutes, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 9, 2), TimeUnit.minutes, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 6, 2), TimeUnit.seconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 9, 2), TimeUnit.seconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 6, 2), TimeUnit.milliseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 9, 2), TimeUnit.milliseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 6), TimeUnit.microseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 5)),
    (ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 9), TimeUnit.microseconds, ZonedDateTime('America/Detroit', 1, 1, 1, 1, 1, 1, 1, 5)),
  ]) {
    test('floor $unit to 5', () => expect(date.floor(unit as TemporalUnit, 5), truncated));
  }


  group('copyWith(...)', () {
    test('values', () => expect(
      ZonedDateTime('America/Detroit', 2023, 1, 2, 3, 4, 5, 6, 7)
        .copyWith(timezone: Timezone('Asia/Tokyo'), year: 2024, month: 8, day: 9, hour: 10, minute: 11, second: 12, millisecond: 13, microsecond: 14),
      ZonedDateTime('Asia/Tokyo', 2024, 8, 9, 10, 11, 12, 13, 14),
    ));

    test('nothing', () => expect(
      ZonedDateTime('America/Detroit',2023, 1, 2, 3, 4, 5, 6, 7).copyWith(),
      ZonedDateTime('America/Detroit', 2023, 1, 2, 3, 4, 5, 6, 7),
    ));
  });


  group('difference(...)', () {
    group('DST', () {
      final winter = ZonedDateTime('America/Detroit', 2023, 3, 12);
      final summer = ZonedDateTime('America/Detroit', 2023, 3, 13);

      test('positive', () => expect(summer.difference(winter), const Duration(hours: 23)));

      test('negative', () => expect(winter.difference(summer), const Duration(hours: -23)));
    });

    group('non-DST', () {
      final before = ZonedDateTime('America/Detroit', 2023, 5, 12);
      final after = ZonedDateTime('America/Detroit', 2023, 5, 13);

      test('positive', () => expect(after.difference(before), const Duration(days: 1)));

      test('negative', () => expect(before.difference(after), const Duration(days: -1)));
    });
  });
  
  test('toLocal()', () => expect(ZonedDateTime('America/Detroit', 2023, 5, 13).toLocal(), LocalDateTime(2023, 5, 13)));


  group('isBefore(...)', () {
    final first = ZonedDateTime('America/Detroit', 2023, 5, 12);
    final second = ZonedDateTime('America/Detroit', 2023, 5, 13);
    final other = ZonedDateTime(singapore, 2023, 5, 13, 12);

    test('same timezone, before', () => expect(first.isBefore(second), true));

    test('same timezone, same moment', () => expect(first.isBefore(first), false));

    test('same timezone, after', () => expect(second.isBefore(first), false));


    test('different timezone, before', () => expect(first.isBefore(other), true));

    test('different timezone, same moment', () => expect(second.isBefore(other), false));

    test('different timezone, after', () => expect(other.isBefore(first), false));
  });

  group('isSameMomentAs(...)', () {
    final first = ZonedDateTime('America/Detroit', 2023, 5, 12);
    final second = ZonedDateTime('America/Detroit', 2023, 5, 13);
    final other = ZonedDateTime(singapore, 2023, 5, 13, 12);

    test('same timezone, before', () => expect(first.isSameMomentAs(second), false));

    test('same timezone, same moment', () => expect(first.isSameMomentAs(first), true));

    test('same timezone, after', () => expect(second.isSameMomentAs(first), false));


    test('different timezone, before', () => expect(first.isSameMomentAs(other), false));

    test('different timezone, same moment', () => expect(second.isSameMomentAs(other), true));

    test('different timezone, after', () => expect(other.isSameMomentAs(first), false));
  });

  group('isAfter(...)', () {
    final first = ZonedDateTime('America/Detroit', 2023, 5, 12);
    final second = ZonedDateTime('America/Detroit', 2023, 5, 13);
    final other = ZonedDateTime(singapore, 2023, 5, 13, 12);

    test('same timezone, before', () => expect(first.isAfter(second), false));

    test('same timezone, same moment', () => expect(first.isAfter(first), false));

    test('same timezone, after', () => expect(second.isAfter(first), true));


    test('different timezone, before', () => expect(first.isAfter(other), false));

    test('different timezone, same moment', () => expect(second.isAfter(other), false));

    test('different timezone, after', () => expect(other.isAfter(first), true));
  });


  group('equality', () {
    test('equal', () {
      final foo = ZonedDateTime('America/Detroit', 2023, 5, 12);
      final bar = ZonedDateTime('America/Detroit', 2023, 5, 12);

      expect(foo, bar);
      expect(foo.hashCode, bar.hashCode);
    });

    test('not equal', () {
      final foo = ZonedDateTime('America/Detroit', 2023, 5, 12);
      final bar = ZonedDateTime('America/Detroit', 2023, 5, 13);

      expect(foo, isNot(bar));
      expect(foo.hashCode, isNot(bar.hashCode));
    });

    test('same moment, different timezone', () {
      final foo = ZonedDateTime('America/Detroit', 2023, 5, 12);
      final bar = ZonedDateTime(singapore, 2023, 5, 12, 12);

      expect(foo, isNot(bar));
      expect(foo.hashCode, isNot(bar.hashCode));
    });
  });

  test('toString()', () {
    final date = ZonedDateTime('America/Detroit', 2023, 3, 12, 2, 3, 4, 5, 6);
    expect(date.toString(), '2023-03-12T03:03:04.005006-04:00[America/Detroit]');
  });


  test('weekday', () => expect(ZonedDateTime(singapore, 2023, 5, 3).weekday, 3));

  group('weekOfYear', () {
    test('last week of previous year', () => expect(ZonedDateTime(singapore, 2023).weekOfYear, 52));

    test('first of year', () => expect(ZonedDateTime(singapore, 2023, 1, 2).weekOfYear, 1));

    test('middle of year', () => expect(ZonedDateTime(singapore, 2023, 6, 15).weekOfYear, 24));

    test('short year last week', () => expect(ZonedDateTime(singapore, 2023, 12, 31).weekOfYear, 52));

    test('long year last week', () => expect(ZonedDateTime(singapore, 2020, 12, 31).weekOfYear, 53));
  });

  group('dayOfYear(...)', () {
    test('leap year first day', () => expect(ZonedDateTime(singapore, 2020).dayOfYear, 1));

    test('leap year before February', () => expect(ZonedDateTime(singapore, 2020, 2, 20).dayOfYear, 51));

    test('leap year after February', () => expect(ZonedDateTime(singapore, 2020, 3, 20).dayOfYear, 80));

    test('leap year last day', () => expect(ZonedDateTime(singapore, 2020, 12, 31).dayOfYear, 366));

    test('non-leap year first day', () => expect(ZonedDateTime(singapore, 2021).dayOfYear, 1));

    test('non-leap year', () => expect(ZonedDateTime(singapore, 2021, 3, 20).dayOfYear, 79));

    test('non-leap year last day', () => expect(ZonedDateTime(singapore, 2021, 12, 31).dayOfYear, 365));
  });


  group('firstDayOfWeek', () {
    test('current date', () => expect(ZonedDateTime(singapore, 2023, 5, 8, 1).firstDayOfWeek, ZonedDateTime(singapore, 2023, 5, 8)));

    test('last day of week', () => expect(ZonedDateTime(singapore, 2023, 5, 14, 1).firstDayOfWeek, ZonedDateTime(singapore, 2023, 5, 8)));

    test('across months', () => expect(ZonedDateTime(singapore, 2023, 6, 2).firstDayOfWeek, ZonedDateTime(singapore, 2023, 5, 29)));
  });

  group('lastDayOfWeek', () {
    test('current date', () => expect(ZonedDateTime(singapore, 2023, 5, 8, 1).lastDayOfWeek, ZonedDateTime(singapore, 2023, 5, 14)));

    test('last day of week', () => expect(ZonedDateTime(singapore, 2023, 5, 14, 1).lastDayOfWeek, ZonedDateTime(singapore, 2023, 5, 14)));

    test('across months', () => expect(ZonedDateTime(singapore, 2023, 5, 29).lastDayOfWeek, ZonedDateTime(singapore, 2023, 6, 4)));
  });


  group('firstDayOfMonth', () {
    test('current date', () => expect(ZonedDateTime(singapore, 2023, 5, 1, 1).firstDayOfMonth, ZonedDateTime(singapore, 2023, 5)));

    test('last day of the month', () => expect(ZonedDateTime(singapore, 2023, 5, 31).firstDayOfMonth, ZonedDateTime(singapore, 2023, 5)));
  });

  group('lastDayOfMonth', () {
    test('current date', () => expect(ZonedDateTime(singapore, 2023, 2, 28).lastDayOfMonth, ZonedDateTime(singapore, 2023, 2, 28)));

    test('first day of the month', () => expect(ZonedDateTime(singapore, 2023, 2).lastDayOfMonth, ZonedDateTime(singapore, 2023, 2, 28)));

    test('leap year', () => expect(ZonedDateTime(singapore, 2020, 2).lastDayOfMonth, ZonedDateTime(singapore, 2020, 2, 29)));
  });


  group('daysInMonth', () {
    test('leap year', () => expect(ZonedDateTime(singapore, 2020, 2).daysInMonth, 29));

    test('non-leap year', () => expect(ZonedDateTime(singapore, 2021, 2).daysInMonth, 28));
  });

  group('leapYear', () {
    test('leap year', () => expect(ZonedDateTime(singapore, 2020).leapYear, true));

    test('non-leap year', () => expect(ZonedDateTime(singapore, 2021).leapYear, false));
  });


  test('epochMilliseconds', () => expect(
    ZonedDateTime(singapore, 2023, 1, 2, 3, 4, 5, 6, 7).epochMilliseconds,
    DateTime.utc(2023, 1, 1, 19, 4, 5, 6, 7).millisecondsSinceEpoch,
  ));

  test('epochMicroseconds', () => expect(
    ZonedDateTime(singapore, 2023, 1, 2, 3, 4, 5, 6, 7).epochMicroseconds,
    DateTime.utc(2023, 1, 1, 19, 4, 5, 6, 7).microsecondsSinceEpoch),
  );
  
}
