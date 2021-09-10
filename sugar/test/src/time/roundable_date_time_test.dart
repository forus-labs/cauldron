import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('RoundableDateTime', () {
    final date = LocalDateTime(2, 2, 4, 6, 7, 8, 9, 11);

    for (final pair in [
      [TimeUnit.year, LocalDateTime(0, 2, 4, 6, 7, 8, 9, 11)],
      [TimeUnit.month, LocalDateTime(2, 1, 4, 6, 7, 8, 9, 11)],
      [TimeUnit.day, LocalDateTime(2, 2, 5, 6, 7, 8, 9, 11)],
      [TimeUnit.hour, LocalDateTime(2, 2, 4, 5, 7, 8, 9, 11)],
      [TimeUnit.minute, LocalDateTime(2, 2, 4, 6, 5, 8, 9, 11)],
      [TimeUnit.second, LocalDateTime(2, 2, 4, 6, 7, 10, 9, 11)],
      [TimeUnit.millisecond, LocalDateTime(2, 2, 4, 6, 7, 8, 10, 11)],
      [TimeUnit.microsecond, LocalDateTime(2, 2, 4, 6, 7, 8, 9, 10)],
    ].pairs<TimeUnit, LocalDateTime>()) {
      test('round ${pair.key}', () => expect(date.round(5, pair.key), pair.value));
    }

    test('ceil', () => expect(date.ceil(6, TimeUnit.day), LocalDateTime(2, 2, 6, 6, 7, 8, 9, 11)));

    test('floor', () => expect(date.floor(6, TimeUnit.day), LocalDateTime(2, 2, 1, 6, 7, 8, 9, 11)));
  });

  group('DefaultRoundableDateTime', () {
    final date = DateTime(2, 2, 4, 6, 7, 8, 9, 11);

    for (final pair in [
      [TimeUnit.year, DateTime(0, 2, 4, 6, 7, 8, 9, 11)],
      [TimeUnit.month, DateTime(2, 1, 4, 6, 7, 8, 9, 11)],
      [TimeUnit.day, DateTime(2, 2, 5, 6, 7, 8, 9, 11)],
      [TimeUnit.hour, DateTime(2, 2, 4, 5, 7, 8, 9, 11)],
      [TimeUnit.minute, DateTime(2, 2, 4, 6, 5, 8, 9, 11)],
      [TimeUnit.second, DateTime(2, 2, 4, 6, 7, 10, 9, 11)],
      [TimeUnit.millisecond, DateTime(2, 2, 4, 6, 7, 8, 10, 11)],
      [TimeUnit.microsecond, DateTime(2, 2, 4, 6, 7, 8, 9, 10)],
    ].pairs<TimeUnit, DateTime>()) {
      test('round ${pair.key}', () => expect(date.round(5, pair.key), pair.value));
    }

    test('ceil', () => expect(date.ceil(6, TimeUnit.day), DateTime(2, 2, 6, 6, 7, 8, 9, 11)));

    test('floor', () => expect(date.floor(6, TimeUnit.day), DateTime(2, 2, 1, 6, 7, 8, 9, 11)));

    test('_of', () {
      final local = DateTime(1);
      expect(local.round(1, TimeUnit.microsecond).isUtc, false);

      final utc = DateTime.utc(1);
      expect(utc.round(1, TimeUnit.microsecond).isUtc, true);
    });
  });

}