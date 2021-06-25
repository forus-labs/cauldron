import 'package:test/test.dart';
import 'package:sugar/sugar.dart';

void main() {
  group('DateTimePeriod', () {
    test('length', () => expect(Period<DateTime>(DateTime(2000), DateTime(2000, 1, 2)).length, const Duration(days: 1)));
  });

  group('TimePeriod', () {
    test('length', () => expect(Period<Time>(Time(20), Time(21)).length, const Duration(hours: 1)));
  });

  group('NumericPeriod', () {
    test('length', () => expect(Period<num>(1, 5).length, 4));
  });

  group('Period', () {
    final period = Period<num>(1, 3);

    for (final pair in [[period, 0], [Period<num>(2), -1], [Period<num>(1, 4), -1], [Period<num>(1, 3, -1), -1]].pairs<Period<num>, int>()) {
      test('compareTo ${pair.key}', () => expect(period.compareTo(pair.key), pair.value));
    }

    test('hashCode', () {
      final value = hash([1, 3, 0]);

      expect(period.hashCode, value);
      expect(period.hashCode, value);
    });

    test('toString', () => expect(period.toString(), 'Period{range: 1 - 3, priority: 0}'));
  });
}