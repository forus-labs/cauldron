import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  final dateTime = DateTime(1, 2, 3, 4, 5, 6, 7, 8);
  final date = Date(1, 2, 3);

  test('constructor', () {
    final date = DateTime(1, 2, 3);
    expect(date.year, 1);
    expect(date.month, 2);
    expect(date.day, 3);
  });

  test('fromMilliseconds', () => expect(Date.fromMilliseconds(dateTime.millisecondsSinceEpoch), Date(1, 2, 3)));

  test('fromMicroseconds', () => expect(Date.fromMicroseconds(dateTime.microsecondsSinceEpoch), Date(1, 2, 3)));

  test('today', () {
    // Might fail if we are unlucky enough that the DateTime.now() and Date.today() are called before & after midnight
    final now = DateTime.now();
    final today = Date.today();

    expect(today.year, now.year);
    expect(today.month, now.month);
    expect(today.day, now.day);
  });

  test('+', () {
    expect(date + const Duration(days: 1, microseconds: 4), Date(1, 2, 4));
    expect(date + const Duration(microseconds: 4), Date(1, 2, 3));
  });

  test('toLocal', () {
    final local = date.toLocal();

    expect(local, LocalDateTime(1, 2, 3));
    expect(local, same(date.toLocal()));
    expect(local.date, same(date));
  });

  test('toUtc', () {
    final utc = date.toUtc();

    expect(utc, UtcDateTime(1, 2, 3));
    expect(utc, same(date.toUtc()));
    expect(utc.date, same(date));
  });

  // ignore: invalid_use_of_protected_member
  test('of', () => expect(date.of(8, 7, 6, 5, 4, 3, 2, 1), Date(8, 7, 6)));

}