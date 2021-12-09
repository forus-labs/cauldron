import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('LocalDateTime', () {
    final local = LocalDateTime(1, 2, 3, 4, 5, 6, 7, 8);

    test('constructor', () {
      expect(local.year, 1);
      expect(local.month, 2);
      expect(local.day, 3);
      expect(local.hour, 4);
      expect(local.minute, 5);
      expect(local.second, 6);
      expect(local.millisecond, 7);
      expect(local.microsecond, 8);
      expect(local.isUtc, false);
    });

    test('fromMilliseconds', () {
      final date = LocalDateTime.fromMilliseconds(local.millisecondsSinceEpoch);
      expect(date, LocalDateTime(1, 2, 3, 4, 5, 6, 8));
      expect(date.isUtc, false);
    });

    test('fromMicroseconds', () {
      final date = LocalDateTime.fromMicroseconds(local.microsecondsSinceEpoch);
      expect(date, local);
      expect(date.isUtc, false);
    });

    test('now', () => expect(LocalDateTime.now().isUtc, false));

    test('+', () => expect(local + const Duration(microseconds: 1), LocalDateTime(1, 2, 3, 4, 5, 6, 7, 9)));

    // ignore: invalid_use_of_protected_member
    test('of', () => expect(local.of(8, 7, 6, 5, 4, 3, 2, 1), LocalDateTime(8, 7, 6, 5, 4, 3, 2, 1)));
  });

  group('UtcDateTime', () {
    final utc = UtcDateTime(1, 2, 3, 4, 5, 6, 7, 8);

    test('constructor', () {
      expect(utc.year, 1);
      expect(utc.month, 2);
      expect(utc.day, 3);
      expect(utc.hour, 4);
      expect(utc.minute, 5);
      expect(utc.second, 6);
      expect(utc.millisecond, 7);
      expect(utc.microsecond, 8);
      expect(utc.isUtc, true);
    });

    test('fromMilliseconds', () {
      final date = UtcDateTime.fromMilliseconds(utc.millisecondsSinceEpoch);
      expect(date, UtcDateTime(1, 2, 3, 4, 5, 6, 8));
      expect(date.isUtc, true);
    });

    test('fromMicroseconds', () {
      final date = UtcDateTime.fromMicroseconds(utc.microsecondsSinceEpoch);
      expect(date, utc);
      expect(date.isUtc, true);
    });

    test('now', () => expect(utc.isUtc, true));

    test('+', () => expect(utc + const Duration(microseconds: 1), UtcDateTime(1, 2, 3, 4, 5, 6, 7, 9)));

    // ignore: invalid_use_of_protected_member
    test('of', () => expect(utc.of(8, 7, 6, 5, 4, 3, 2, 1), UtcDateTime(8, 7, 6, 5, 4, 3, 2, 1)));
  });
}
