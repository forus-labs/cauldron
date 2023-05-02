import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {

  group('format(...)', () {
    test('pads year', () => expect(Dates.format(999, 12 ,15), '0999-12-15'));

    test('pads month', () => expect(Dates.format(2023, 4 ,15), '2023-04-15'));

    test('pads day', () => expect(Dates.format(2023, 12, 5), '2023-12-05'));
  });

  group('weekday(...)', () {
    test('Monday', () => expect(Dates.weekday(2023, 5, 1), 1));

    test('Sunday', () => expect(Dates.weekday(2023, 4, 30), 7));
  });

  group('weekOfYear(...)', () {
    test('last week of previous year', () => expect(Dates.weekOfYear(2023, 1, 1), 52));

    test('first of year', () => expect(Dates.weekOfYear(2023, 1, 2), 1));

    test('middle of year', () => expect(Dates.weekOfYear(2023, 6, 15), 24));

    test('short year last week', () => expect(Dates.weekOfYear(2023, 12, 31), 52));

    test('long year last week', () => expect(Dates.weekOfYear(2020, 12, 31), 53));
  });

  group('dayOfYear(...)', () {
    test('leap year first day', () => expect(Dates.dayOfYear(2020, 1, 1), 1));

    test('leap year before February', () => expect(Dates.dayOfYear(2020, 2, 20), 51));

    test('leap year after February', () => expect(Dates.dayOfYear(2020, 3, 20), 80));

    test('leap year last day', () => expect(Dates.dayOfYear(2020, 12, 31), 366));

    test('non-leap year first day', () => expect(Dates.dayOfYear(2021, 1, 1), 1));

    test('non-leap year', () => expect(Dates.dayOfYear(2021, 3, 20), 79));

    test('non-leap year last day', () => expect(Dates.dayOfYear(2021, 12, 31), 365));
  });

  group('daysInMonth(...)', () {
    test('leap year', () => expect(Dates.daysInMonth(2020, 2), 29));

    test('non-leap year', () => expect(Dates.daysInMonth(2021, 2), 28));
  });

  group('leapYear(...)', () {
    test('leap year', () => expect(Dates.leapYear(2020), true));

    test('non-leap year', () => expect(Dates.leapYear(2021), false));
  });

}
