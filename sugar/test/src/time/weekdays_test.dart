import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  const week = [1, 3, 5, 6];
  const serialized = 53;

  test('pack', () => expect(Weekdays.encode(week), serialized));

  test('pack more than 7 days', () => expect(
      () => Weekdays.encode([1, 2, 3, 4, 5, 6, 7, 8]),
      throwsA(predicate<AssertionError>((e) => e.message == 'Number of days is "8", should be less than 7'))
  ));
  test('pack invalid day', () => expect(
      () => Weekdays.encode([9]),
      throwsA(predicate<AssertionError>((e) => e.message == 'Invalid day in week, should be between 1 and 7'))
  ));


  test('unpack', () => expect(Weekdays.decode(serialized), week));

  test('unpack invalid number', () {
    expect(
      () => Weekdays.decode(-1),
      throwsA(predicate<AssertionError>((e) => e.message == 'Packed days is "-1", should be between 0 and 127'))
    );

    expect(
      () => Weekdays.decode(128),
      throwsA(predicate<AssertionError>((e) => e.message == 'Packed days is "128", should be between 0 and 127'))
    );
  });

  test('pack & unpack', () => expect(Weekdays.decode(Weekdays.encode(week)), week));
}