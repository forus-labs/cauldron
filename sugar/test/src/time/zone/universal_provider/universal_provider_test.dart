import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:jni/jni.dart';
import 'package:path/path.dart';
import 'package:sugar/src/time/zone/providers/universal/embedded_timezone.dart';
import 'package:sugar/src/time/zone/providers/universal/lazy_provider.dart';

import 'package:test/test.dart';

import 'java_provider/java_timezone_provider.dart';

void main() {
  Jni.spawn(
    dylibDir: join(Directory.current.path, 'build', 'jni_libs'),
  );
  final tests = <TestJob>[];
  final javaProvider = JavaTimezoneProvider();
  final universalProvider = EmbeddedTimezoneProvider();

  final testTimezones = universalProvider.keys.toSet().intersection(
        javaProvider.keys.toSet(),
      );

  for (final tz in testTimezones) {
    final universalTz = universalProvider[tz]!;
    final effectiveYears =
        _defaultYears(universalTz as EmbeddedTimezone).shuffled();
    for (final year in effectiveYears) {
      tests.add((tz: tz, year: year));
    }
  }
  tests.shuffle();

  group(
    'test universal provider against java',
    () {
      for (final t in tests) {
        test('${t.tz} - ${t.year}', () {
          final javaTz = javaProvider[t.tz]!;
          final uniTz = universalProvider[t.tz]!;
          expect(uniTz.name, javaTz.name);
          var dt = DateTime.utc(t.year);
          while (dt.year < t.year + 1) {
            final uniOffset = uniTz.offset(at: dt.microsecondsSinceEpoch);
            final javaOffset = javaTz.offset(at: dt.microsecondsSinceEpoch);
            expect(
              uniOffset,
              javaOffset,
              reason:
                  'Date: $dt, UniversalOffset:$uniOffset, JavaConverted:$javaOffset',
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
                  'Date: $localized, UniversalConverted:$uniConverted, JavaConverted:$javaConverted',
            );
            dt = dt.add(const Duration(minutes: 30));
          }
        });
      }
    },
  );
}

typedef TestJob = ({String tz, int year});

List<int> _defaultYears(EmbeddedTimezone tz) {
  final random = Random();

  final years = [
    ...uniqueYears(random.nextInt(20)),
    ...uniqueYears(random.nextInt(20) - 100),
    ...uniqueYears(random.nextInt(20) + 1950),
    ...uniqueYears(random.nextInt(20) + 2000),
    ...uniqueYears(random.nextInt(20) + 1900),
    ...uniqueYears(random.nextInt(20) + 2038),
    ...uniqueYears(random.nextInt(20) + 2200),
  ];

  if (tz.lastYear case final int endYear) {
    years
      ..add(endYear - 2)
      ..add(endYear - 1)
      ..add(endYear)
      ..add(endYear + 1)
      ..add(endYear + 2);
  }

  if (tz.firstYear case final int firstYear) {
    years
      ..add(firstYear - 2)
      ..add(firstYear - 1)
      ..add(firstYear)
      ..add(firstYear + 1)
      ..add(firstYear + 2);
  }
  return years;
}

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
