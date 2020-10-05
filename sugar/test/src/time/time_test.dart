import 'package:test/test.dart';

import 'package:sugar/sugar.dart';

void main() {
  final time = Time(1, 2, 3, 4, 6);

  group('constructor', () {
    test('invalid hour', () {
      expect(() => Time(-1), throwsA(predicate<AssertionError>((e) => e.message == 'Hour is "-1", should be between 0 and 24')));
      expect(() => Time(24), throwsA(predicate<AssertionError>((e) => e.message == 'Hour is "24", should be between 0 and 24')));
    });

    test('invalid minute', () {
      expect(() => Time(0, -1), throwsA(predicate<AssertionError>((e) => e.message == 'Minute is "-1", should be between 0 and 60')));
      expect(() => Time(0, 60), throwsA(predicate<AssertionError>((e) => e.message == 'Minute is "60", should be between 0 and 60')));
    });

    test('invalid second', () {
      expect(() => Time(0, 0, -1), throwsA(predicate<AssertionError>((e) => e.message == 'Second is "-1", should be between 0 and 60')));
      expect(() => Time(0, 0, 60), throwsA(predicate<AssertionError>((e) => e.message == 'Second is "60", should be between 0 and 60')));
    });

    test('invalid millisecond', () {
      expect(() => Time(0, 0, 0, -1), throwsA(predicate<AssertionError>((e) => e.message == 'Millisecond is "-1", should be between 0 and 1000')));
      expect(() => Time(0, 0, 0, 1000), throwsA(predicate<AssertionError>((e) => e.message == 'Millisecond is "1000", should be between 0 and 1000')));
    });

    test('invalid microsecond', () {
      expect(() => Time(0, 0, 0, 0, -1), throwsA(predicate<AssertionError>((e) => e.message == 'Microsecond is "-1", should be between 0 and 1000')));
      expect(() => Time(0, 0, 0, 0, 1000), throwsA(predicate<AssertionError>((e) => e.message == 'Microsecond is "1000", should be between 0 and 1000')));
    });
  });

  test('fromMilliseconds', () => expect(Time.fromMilliseconds(Hour.milliseconds * 20), Time(20)));

  test('fromMicroseconds', () => expect(Time.fromMicroseconds(Hour.microseconds * 20), Time(20)));


  for (final pair in [
    [TimeUnit.hour, Time(0, 2, 3, 4, 6)],
    [TimeUnit.minute, Time(1, 0, 3, 4, 6)],
    [TimeUnit.second, Time(1, 2, 5, 4, 6)],
    [TimeUnit.millisecond, Time(1, 2, 3, 5, 6)],
    [TimeUnit.microsecond, Time(1, 2, 3, 4, 5)],
  ].pairs<TimeUnit, Time>()) {
    test('round ${pair.key}', () => expect(time.round(5, pair.key), pair.value));
  }

  test('ceil', () => expect(time.ceil(6, TimeUnit.hour), Time(6, 2, 3, 4, 6)));

  test('floor', () => expect(time.floor(6, TimeUnit.hour), Time(0, 2, 3, 4, 6)));

  test('difference', () => expect(Time(23).difference(Time(5)), const Duration(hours: 18)));

  test('+', () => expect(Time(1, 2, 3, 4, 5) + const Duration(hours: 1, minutes: 2, seconds: 3, milliseconds: 4, microseconds: 5), Time(2, 4, 6, 8, 10)));

  test('-', () => expect(Time(1) - const Duration(hours: 3), Time(22)));

  test('inSeconds', () => expect(time.inSeconds, Hour.seconds + Minute.seconds * 2 + 3));

  test('inMilliseconds', () => expect(time.inMilliseconds, Hour.milliseconds + Minute.milliseconds * 2 + Second.milliseconds * 3 + 4));

  test('inMicroseconds', () {
    const microseconds = Hour.microseconds + Minute.microseconds * 2 + Second.microseconds * 3 + Millisecond.microseconds * 4 + 6;
    expect(time.inMicroseconds, microseconds);
    expect(time.inMicroseconds, microseconds);
  });

  test('hashCode', () => expect(time.hashCode, time.inMicroseconds));

  test('toString', () => expect(time.toString(), '01:02:03.004006'));
}