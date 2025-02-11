import 'dart:io';

import 'package:collection/collection.dart';
import 'package:jni/jni.dart';
import 'package:path/path.dart';
import 'package:sugar/src/time/zone/providers/embedded/embedded_timezone.dart';
import 'package:sugar/src/time/zone/providers/embedded/timezone_provider.dart';

import 'package:test/test.dart';

import '../known_timezones.dart';
import 'java_provider/java_timezone_provider.dart';

void main() {
  Jni.spawn(
    dylibDir: join(Directory.current.path, 'build', 'jni_libs'),
  );
  final tests = <TestJob>[];
  final javaProvider = JavaTimezoneProvider();
  final embeddedProvider = EmbeddedTimezoneProvider();

  group('EmbeddedTimezoneProvider', () {
    test('containts known timezones', () {
      /// All the known timezones should be in the embedded provider
      expect(known.difference(embeddedProvider.keys.toSet()).length, 0);
    });

    final testTimezones = embeddedProvider.keys.toSet().intersection(
          javaProvider.keys.toSet(),
        );

    for (final tz in testTimezones) {
      final embeddedTz = embeddedProvider[tz]!;
      final effectiveYears =
          _defaultYears(embeddedTz as EmbeddedTimezone).shuffled();
      for (final year in effectiveYears) {
        tests.add((tz: tz, year: year));
      }
    }
    tests.shuffle();

    group('embedded provider against java', () {
      for (final t in tests) {
        test('${t.tz} - ${t.year}', () {
          final javaTz = javaProvider[t.tz]!;
          final uniTz = embeddedProvider[t.tz]!;
          expect(uniTz.name, javaTz.name);
          var dt = DateTime.utc(t.year);
          while (dt.year < t.year + 1) {
            final uniOffset = uniTz.offset(at: dt.microsecondsSinceEpoch);
            final javaOffset = javaTz.offset(at: dt.microsecondsSinceEpoch);
            expect(
              uniOffset,
              javaOffset,
              reason:
                  'Date: $dt, EmbeddedOffset:$uniOffset, JavaConverted:$javaOffset',
            );
            final localized =
                dt.add(Duration(microseconds: uniOffset.inMicroseconds));
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
              uniConverted,
              javaConverted,
              reason:
                  'Date: $localized, EmbeddedConverted:$uniConverted, JavaConverted:$javaConverted',
            );
            dt = dt.add(const Duration(minutes: 30));
          }
        });
      }
    });
  });
}

typedef TestJob = ({String tz, int year});

Set<int> _defaultYears(EmbeddedTimezone tz) => {0};

/// There are only 14 ways that a year can fall out
/// 1. Starting weekday (7 possibilities)
/// 2. Leap year or not (2 possibilities)
/// This function returns a set of 14 unique years
/// right after the start year
Set<int> uniqueYears([int? startYear]) {
  bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  final uniqueYears = <({int startDay, bool isLeapYear}), int>{};
  var year = startYear ?? DateTime.now().year;
  while (uniqueYears.length != 14) {
    uniqueYears[(
      startDay: DateTime(year).weekday,
      isLeapYear: isLeapYear(year)
    )] = year;
    year++;
  }
  return uniqueYears.values.toSet();
}
