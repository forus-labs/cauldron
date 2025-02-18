import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:jni/jni.dart';
import 'package:path/path.dart';
import 'package:sugar/src/time/zone/providers/embedded/embedded_timezone.dart';
import 'package:sugar/sugar.dart';

import 'package:test/test.dart';

import '../known_timezones.dart';
import 'java_provider/java_timezone_provider.dart';

void main() {
  Jni.spawn(dylibDir: join(Directory.current.path, 'build', 'jni_libs'));
  final tests = <TestJob>[];
  final javaProvider = JavaTimezoneProvider();
  final embeddedProvider = EmbeddedTimezoneProvider();

  group('EmbeddedTimezoneProvider', () {
    test('containts known timezones', () {
      /// Test that the embedded provider contains all known timezones
      expect(known.difference(embeddedProvider.keys.toSet()).length, 0);
    });

    // Only test time zones that are in both the embedded and java providers
    final testTimezones = embeddedProvider.keys.toSet().intersection(javaProvider.keys.toSet());

    for (final tz in testTimezones) {
      final embeddedTz = embeddedProvider[tz]!;
      final effectiveYears = _defaultYears(embeddedTz as EmbeddedTimezone).shuffled();
      for (final year in effectiveYears) {
        tests.add((tz: tz, year: year));
      }
    }
    tests.shuffle();

    group('against java', () {
      for (final t in tests) {
        test('${t.tz} - ${t.year}', () {
          final javaTz = javaProvider[t.tz]!;
          final uniTz = embeddedProvider[t.tz]!;
          expect(uniTz.name, javaTz.name);
          var dt = DateTime.utc(t.year);
          while (dt.year < t.year + 1) {
            final uniSpan = uniTz.span(at: dt.microsecondsSinceEpoch);
            final javaSpan = javaTz.span(at: dt.microsecondsSinceEpoch);
            expect(
              uniSpan.offset,
              javaSpan.offset,
              reason: 'Date: $dt, EmbeddedOffset:${uniSpan.offset}, JavaConverted:${javaSpan.offset}',
            );
            final localized = dt.add(Duration(microseconds: uniSpan.offset.inMicroseconds));
            final javaConverted = javaTz.convert(
              localized.year,
              localized.month,
              localized.day,
              localized.hour,
              localized.minute,
              localized.second,
              localized.millisecond,
              localized.microsecond,
            );
            final uniConverted = uniTz.convert(
              localized.year,
              localized.month,
              localized.day,
              localized.hour,
              localized.minute,
              localized.second,
              localized.millisecond,
              localized.microsecond,
            );

            expect(
              uniConverted.$1,
              javaConverted.$1,
              reason: 'Date: $localized, EmbeddedConverted:$uniConverted, JavaConverted:$javaConverted',
            );
            dt = dt.add(const Duration(minutes: 30));
          }
        });
      }
    });

    group('dst and abbr', () {
      test('timezone with dst', () {
        final embeddedTz = embeddedProvider['America/New_York']!;
        // Regular years
        _testDstAndAbbr(embeddedTz, DateTime.utc(2000), 'EST', false);
        _testDstAndAbbr(embeddedTz, DateTime.utc(2000, 6), 'EDT', true);
        _testDstAndAbbr(embeddedTz, DateTime.utc(2000, 12), 'EST', false);
        // Before the first transition
        _testDstAndAbbr(embeddedTz, DateTime.utc(1700), 'LMT', false);
        _testDstAndAbbr(embeddedTz, DateTime.utc(1700, 6), 'LMT', false);
        _testDstAndAbbr(embeddedTz, DateTime.utc(1700, 12), 'LMT', false);
        // After the last transition
        _testDstAndAbbr(embeddedTz, DateTime.utc(2500), null, false);
        _testDstAndAbbr(embeddedTz, DateTime.utc(2500, 6), null, true);
        _testDstAndAbbr(embeddedTz, DateTime.utc(2500, 12), null, false);
      });
      test('fixed timezone', () {
        final embeddedTz = embeddedProvider['Etc/GMT+2']!;
        _testDstAndAbbr(embeddedTz, DateTime.utc(2000), '-0200', false);
        _testDstAndAbbr(embeddedTz, DateTime.utc(2000, 6), '-0200', false);
        _testDstAndAbbr(embeddedTz, DateTime.utc(2000, 12), '-0200', false);
      });
    });
  });
}

typedef TestJob = ({String tz, int year});

Set<int> _defaultYears(EmbeddedTimezone tz) {
  final random = Random();

  final years = {
    -10,
    10,
    1700,
    1800,
    1900,
    2000,
    2100,
    2200,

    /// Pick a  3 random years between 1700 and 2200
    /// and get the 14 possible years after it it
    ...uniqueYears(random.nextInt(500) + 1700),
    ...uniqueYears(random.nextInt(500) + 1700),
    ...uniqueYears(random.nextInt(500) + 1700),
  };

  /// Test the years around the first and last transitions
  /// to ensure that the provider is able to handle them
  if (tz.lastYear case final int endYear) {
    years
      ..add(endYear - 1)
      ..add(endYear)
      ..add(endYear + 1);
  }

  if (tz.firstYear case final int firstYear) {
    years
      ..add(firstYear - 1)
      ..add(firstYear)
      ..add(firstYear + 1);
  }
  return years;
}

/// There are only 14 ways that a year can fall out
/// 1. Starting weekday (7 possibilities)
/// 2. Leap year or not (2 possibilities)
/// This function returns a set of 14 unique years
/// right after the start year
Set<int> uniqueYears([int? startYear]) {
  bool isLeapYear(int year) => (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  final uniqueYears = <({int startDay, bool isLeapYear}), int>{};
  var year = startYear ?? DateTime.now().year;
  while (uniqueYears.length != 14) {
    uniqueYears[(startDay: DateTime(year).weekday, isLeapYear: isLeapYear(year))] = year;
    year++;
  }
  return uniqueYears.values.toSet();
}

void _testDstAndAbbr(Timezone tz, DateTime dt, String? abbr, bool dst) {
  final span = tz.span(at: dt.microsecondsSinceEpoch);
  expect(span.abbreviation, abbr);
  expect(span.dst, dst);
}
