import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {

  test('plus(...)', () => expect(
    DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8).plus(
      years: 2,
      months: 3,
      days: 4,
      hours: 5,
      minutes: 6,
      seconds: 7,
      milliseconds: 8,
      microseconds: 9,
    ),
    DateTime.utc(3, 5, 7, 9, 11, 13, 15, 17),
  ));

  test('plus(...) nothing', () => expect(DateTime(1, 2, 3, 4, 5, 6, 7, 8).plus(), DateTime(1, 2, 3, 4, 5, 6, 7, 8)));


  test('minus', () => expect(
    DateTime.utc(8, 7, 6, 5, 40, 30, 20, 10).minus(
      years: 1,
      months: 2,
      days: 3,
      hours: 5,
      minutes: 6,
      seconds: 7,
      milliseconds: 8,
      microseconds: 9,
    ),
    DateTime.utc(7, 5, 3, 0, 34, 23, 12, 1),
  ));

  test('minus(...) nothing', () => expect(DateTime(1, 2, 3, 4, 5, 6, 7, 8).minus(), DateTime(1, 2, 3, 4, 5, 6, 7, 8)));


  test('+', () => expect(
    DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8) + const Period(
      years: 2,
      months: 3,
      days: 4,
      hours: 5,
      minutes: 6,
      seconds: 7,
      milliseconds: 8,
      microseconds: 9,
    ),
    DateTime.utc(3, 5, 7, 9, 11, 13, 15, 17),
  ));

  test('+ nothing', () => expect(DateTime(1, 2, 3, 4, 5, 6, 7, 8) + const Period(), DateTime(1, 2, 3, 4, 5, 6, 7, 8)));


  test('-', () => expect(
    DateTime.utc(8, 7, 6, 5, 40, 30, 20, 10) - const Period(
      years: 1,
      months: 2,
      days: 3,
      hours: 5,
      minutes: 6,
      seconds: 7,
      milliseconds: 8,
      microseconds: 9,
    ),
    DateTime.utc(7, 5, 3, 0, 34, 23, 12, 1),
  ));

  test('- nothing', () => expect(DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8) - const Period(), DateTime.utc(1, 2, 3, 4, 5, 6, 7, 8)));


  for (final arguments in [
    [DateUnit.years, DateTime(10)],
    [DateUnit.months, DateTime(10, 2)],
    [DateUnit.days, DateTime(10, 2, 3)],
    [TimeUnit.hours, DateTime(10, 2, 3, 4)],
    [TimeUnit.minutes, DateTime(10, 2, 3, 4, 5)],
    [TimeUnit.seconds, DateTime(10, 2, 3, 4, 5, 6)],
    [TimeUnit.milliseconds, DateTime(10, 2, 3, 4, 5, 6, 7)],
    [TimeUnit.microseconds, DateTime(10, 2, 3, 4, 5, 6, 7, 8)],
  ]) {
    final date = DateTime(10, 2, 3, 4, 5, 6, 7, 8);
    final unit = arguments[0] as TemporalUnit;
    final truncated = arguments[1] as DateTime;

    test('truncate to $unit', () => expect(date.truncate(to: unit), truncated));
  }



}
