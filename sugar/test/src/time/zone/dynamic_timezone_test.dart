import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

// We use ZonedDateTime to test DynamicTimezone since it's easier.
void main() {
  group('initial timezone', () {
    final timezone = UniversalTimezoneProvider()['America/Detroit']!;
    final offset =
        timezone.offset(at: DateTime.utc(1900).microsecondsSinceEpoch);

    test('offset', () => expect(offset, Offset.fromMicroseconds(-19931000000)));
  });

  group('non-DST timezone span', () {
    // https://www.timeanddate.com/time/change/usa/detroit?year=2023
    final offset = ZonedDateTime('America/Detroit', 2023, 12, 12, 4).offset;

    test('offset', () => expect(offset, Offset(-5)));
  });

  group('DST timezone span', () {
    // https://www.timeanddate.com/time/change/usa/detroit?year=2023
    final offset = ZonedDateTime('America/Detroit', 2023, 5, 12, 4).offset;

    test('offset', () => expect(offset, Offset(-4)));
  });

  group('convert(...) & span(...)', () {
    group('America/Detroit DST (negative offset)', () {
      // https://www.timeanddate.com/time/change/usa/detroit?year=2023
      const detroit = 'America/Detroit';

      group('EST/EDT transition', () {
        test('2 months before transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 1, 12, 4);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-01-12T04:00-05:00[America/Detroit]');
        });

        test('1 hour before transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 3, 12, 1);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-03-12T01:00-05:00[America/Detroit]');
        });

        test('lower transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 3, 12, 2);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-03-12T03:00-04:00[America/Detroit]');
        });

        test('upper transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 3, 12, 3);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-03-12T03:00-04:00[America/Detroit]');
        });

        test('1 hour after transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 3, 12, 4);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-03-12T04:00-04:00[America/Detroit]');
        });

        test('2 months after transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 5, 12, 4);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-05-12T04:00-04:00[America/Detroit]');
        });
      });

      group('EST/EDT transition', () {
        test('2 months before transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 9, 5, 1);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-09-05T01:00-04:00[America/Detroit]');
        });

        test('1 hour before transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 11, 5);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-11-05T00:00-04:00[America/Detroit]');
        });

        test('lower transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 11, 5, 1);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-11-05T01:00-04:00[America/Detroit]');
        });

        test('upper transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 11, 5, 2);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-11-05T02:00-05:00[America/Detroit]');
        });

        test('1 hour after transition', () {
          final datetime = ZonedDateTime(detroit, 2023, 11, 5, 3);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2023-11-05T03:00-05:00[America/Detroit]');
        });

        test('2 months after transition', () {
          final datetime = ZonedDateTime(detroit, 2024, 1, 5, 2);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(detroit), datetime.epochMicroseconds));
          expect(
              datetime.toString(), '2024-01-05T02:00-05:00[America/Detroit]');
        });
      });
    });

    group('Europe/Berlin DST (positive offset)', () {
      // https://www.timeanddate.com/time/change/germany/berlin?year=2023
      const berlin = 'Europe/Berlin';

      group('EST/EDT transition', () {
        test('2 months before transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 1, 26, 2);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-01-26T02:00+01:00[Europe/Berlin]');
        });

        test('1 hour before transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 3, 26, 1);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-03-26T01:00+01:00[Europe/Berlin]');
        });

        test('lower transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 3, 26, 2);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-03-26T03:00+02:00[Europe/Berlin]');
        });

        test('upper transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 3, 26, 3);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-03-26T03:00+02:00[Europe/Berlin]');
        });

        test('1 hour after transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 3, 26, 4);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-03-26T04:00+02:00[Europe/Berlin]');
        });

        test('2 months after transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 5, 26, 3);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-05-26T03:00+02:00[Europe/Berlin]');
        });
      });

      group('EDT/EST transition', () {
        test('2 months before transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 8, 29, 2);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-08-29T02:00+02:00[Europe/Berlin]');
        });

        test('1 hour before transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 10, 29, 1);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-10-29T01:00+02:00[Europe/Berlin]');
        });

        test('lower transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 10, 29, 2);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-10-29T02:00+02:00[Europe/Berlin]');
        });

        test('upper transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 10, 29, 3);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-10-29T03:00+01:00[Europe/Berlin]');
        });

        test('1 hour after transition', () {
          final datetime = ZonedDateTime(berlin, 2023, 10, 29, 4);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2023-10-29T04:00+01:00[Europe/Berlin]');
        });

        test('2 months after transition', () {
          final datetime = ZonedDateTime(berlin, 2024, 1, 29, 3);

          expect(
              datetime,
              ZonedDateTime.fromEpochMicroseconds(
                  Timezone(berlin), datetime.epochMicroseconds));
          expect(datetime.toString(), '2024-01-29T03:00+01:00[Europe/Berlin]');
        });
      });
    });
  });

  test('toString()', () {
    final singapore = UniversalTimezoneProvider()['Asia/Singapore']!;

    expect(singapore.name, 'Asia/Singapore');
    expect(singapore.toString(), 'Asia/Singapore');
  });
}
