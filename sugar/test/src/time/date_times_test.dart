import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  group('Temporal', () {
    final date = UtcDateTime(1999, 1, 2);

    test('+', () => expect(date + const Duration(days: 1, microseconds: 4), UtcDateTime(1999, 1, 3, 0, 0, 0, 0, 4)));

    test('-', () => expect(date - const Duration(days: 1, microseconds: 3), UtcDateTime(1998, 12, 31, 23, 59, 59, 999, 997)));

    test('tomorrow', () {
      expect(date.tomorrow, UtcDateTime(1999, 1, 3));
      expect(date.tomorrow, UtcDateTime(1999, 1, 3));
    });

    test('yesterday', () {
      expect(date.yesterday, UtcDateTime(1999));
      expect(date.yesterday, UtcDateTime(1999));
    });
  });

  group('DefaultTemporal', () {
    final date = DateTime(1999, 1, 2);

    test('+', () => expect(date + const Duration(days: 1, microseconds: 4), DateTime(1999, 1, 3, 0, 0, 0, 0, 4)));

    test('-', () => expect(date - const Duration(days: 1, microseconds: 3), DateTime(1998, 12, 31, 23, 59, 59, 999, 997)));

    test('tomorrow', () => expect(date.tomorrow, DateTime(1999, 1, 3)));

    test('yesterday', () => expect(date.yesterday, DateTime(1999)));
  });

  group('Chronological', () {
    final before = DateTime(1999);
    final after = DateTime(1999, 1, 2);

    // If this test survives beyond this date I will be pretty impressed.
    test('isFuture', () => expect(DateTime(2300).isFuture, true));

    test('isPast', () => expect(DateTime(1999).isPast, true));

    test('<', () {
      expect(before < after, true);
      expect(after < before, false);
      expect(before < before, false);
    });

    test('>', () {
      expect(after > before, true);
      expect(before > after, false);
      expect(before > before, false);
    });

    test('<=', () {
      expect(before <= after, true);
      expect(after <= before, false);
      expect(before <= before, true);
    });

    test('>=', () {
      expect(after >= before, true);
      expect(before >= after, false);
      expect(before >= before, true);
    });

  });

  group('MultiPart', () {
    final date = UtcDateTime(1, 2, 3, 4, 5, 6, 7, 8);

    test('date', () {
      expect(date.date, Date(1, 2, 3));
      expect(date.date, Date(1, 2, 3));
    });

    test('time', () {
      expect(date.time, Time(4, 5, 6, 7, 8));
      expect(date.time, Time(4, 5, 6, 7, 8));
    });
  });
}