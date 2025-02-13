import 'package:test/test.dart';

import 'package:sugar/src/time/offset.dart';

void main() {
  group('Offset', () {
    group('range', () {
      for (final argument in [Offset(-18), Offset(18), Offset.utc]) {
        test('allow $argument', () => expect(Offset.range.contains(argument), true));
      }
    });

    group('parse(...)', () {
      for (final (input, output) in [
        ('Z', 'Z'),
        ('+0', 'Z'),
        ('-0', 'Z'),
        ('+8', '+08:00'),
        ('-8', '-08:00'),
        ('+08', '+08:00'),
        ('-08', '-08:00'),
        ('+18', '+18:00'),
        ('-18', '-18:00'),
        ('+08:12', '+08:12'),
        ('-08:12', '-08:12'),
        ('+0812', '+08:12'),
        ('-0812', '-08:12'),
        ('+08:12:34', '+08:12:34'),
        ('-08:12:34', '-08:12:34'),
        ('+081234', '+08:12:34'),
        ('-081234', '-08:12:34'),
      ]) {
        test('accepts $input', () => expect(Offset.parse(input).toString(), output));
      }

      for (final input in [
        'z',
        '0',
        '+19',
        '-19',
        '-:13',
        '+:13',
        '01:23',
        '-1:23',
        '+1:23',
        '-12:3',
        '+12:3',
        '0123',
        '-123',
        '+123',
        '-123',
        '+123',
        '01:23:45',
        '-01:23:4',
        '+01:23:4',
        '-01::4',
        '+01::4',
        '-12:3:4',
        '+12:3:4',
        '-01234',
        '+01234',
      ]) {
        test('with $input throws error', () => expect(() => Offset.parse(input).toString(), throwsA(anything)));
      }
    });

    test('now()', () => expect(Offset.now().toDuration(), DateTime.now().timeZoneOffset));

    group('fromSeconds(...)', () {
      for (final (seconds, output) in [
        (-18 * Duration.secondsPerHour, '-18:00'),
        (18 * Duration.secondsPerHour, '+18:00'),
        (123, '+00:02:03'),
      ]) {
        test('accepts $seconds', () => expect(Offset.fromSeconds(seconds).toString(), output));
      }

      for (final seconds in [(-18 * Duration.secondsPerHour) - 1, (18 * Duration.secondsPerHour) + 1]) {
        test('with $seconds throws error', () => expect(() => Offset.fromSeconds(seconds), throwsRangeError));
      }
    });

    group('fromMicroseconds(...)', () {
      for (final (microseconds, output) in [
        (-18 * Duration.microsecondsPerHour, '-18:00'),
        (18 * Duration.microsecondsPerHour, '+18:00'),
        (123 * Duration.microsecondsPerSecond, '+00:02:03'),
      ]) {
        test('accepts $microseconds', () => expect(Offset.fromMicroseconds(microseconds).toString(), output));
      }

      for (final microseconds in [(-18 * Duration.microsecondsPerHour) - 1, (18 * Duration.microsecondsPerHour) + 1]) {
        test(
          'with $microseconds throws error',
          () => expect(() => Offset.fromMicroseconds(microseconds), throwsRangeError),
        );
      }
    });

    group('unnamed constructor', () {
      for (final (hour, minute, second, output, timezoneAbbr) in [
        (-18, 0, 0, '-18:00', '-1800'),
        (18, 0, 0, '+18:00', '+1800'),
        (0, 59, 0, '+00:59', '+0059'),
        (0, 0, 59, '+00:00:59', '+0000'),
        (17, 59, 59, '+17:59:59', '+1759'),
        (-17, 59, 59, '-17:59:59', '-1759'),
        (-1, 30, 30, '-01:30:30', '-0130'),
        (0, 0, 0, 'Z', '+0000'),
      ]) {
        test('accepts $hour $minute $second', () {
          final offset = Offset(hour, minute, second);
          expect(offset.toString(), output);
          expect(offset.toTimezoneAbbreviation(), timezoneAbbr);
        });
      }

      for (final (hour, minute, second) in [
        (-19, 0, 0),
        (19, 0, 0),
        (18, 0, 1),
        (18, 0, -1),
        (0, 60, 0),
        (0, -1, 0),
        (0, 0, 60),
        (0, 0, -1),
        (-18, -1, -1),
      ]) {
        test('with $hour $minute $second throws error', () {
          expect(() => Offset(hour, minute, second), throwsRangeError);
        });
      }
    });

    group('add', () {
      test('succeeds', () => expect(Offset().add(const Duration(hours: 1, minutes: 2, seconds: 3)), Offset(1, 2, 3)));

      test('fails', () => expect(() => Offset(10).add(const Duration(hours: 10)), throwsRangeError));
    });

    group('subtract', () {
      test(
        'succeeds',
        () => expect(Offset().subtract(const Duration(hours: 1, minutes: 2, seconds: 3)), Offset(-1, 2, 3)),
      );

      test('fails', () => expect(() => Offset(-10).subtract(const Duration(hours: 10)), throwsRangeError));
    });

    group('plus', () {
      test('succeeds', () => expect(Offset().plus(hours: 1, minutes: 2, seconds: 3), Offset(1, 2, 3)));

      test('fails', () => expect(() => Offset(10).plus(hours: 10), throwsRangeError));
    });

    group('minus', () {
      test('succeeds', () => expect(Offset().minus(hours: 1, minutes: 2, seconds: 3), Offset(-1, 2, 3)));

      test('fails', () => expect(() => Offset(-10).minus(hours: 10), throwsRangeError));
    });

    group('tryPlus', () {
      test('succeeds', () => expect(Offset().tryPlus(hours: 1, minutes: 2, seconds: 3), Offset(1, 2, 3)));

      test('fails', () => expect(Offset(10).tryPlus(hours: 10), null));
    });

    group('tryMinus', () {
      test('succeeds', () => expect(Offset().tryMinus(hours: 1, minutes: 2, seconds: 3), Offset(-1, 2, 3)));

      test('fails', () => expect(Offset(-10).tryMinus(hours: 10), null));
    });

    test('difference(...)', () => expect(Offset(10).difference(Offset(-10)), const Duration(hours: 20)));

    test(
      'toDuration()',
      () => expect(Offset(-1, 2, 3).toDuration(), const Duration(hours: -1, minutes: -2, seconds: -3)),
    );

    test('inSeconds', () => expect(Offset(1, 2, 3).inSeconds, 3723));

    test('inMilliseconds', () => expect(Offset(1, 2, 3).inMilliseconds, 3723000));

    test('inMicroseconds', () => expect(Offset(1, 2, 3).inMicroseconds, 3723000000));

    for (final (other, expected) in [
      (Offset(1, 2, 3), true),
      (Offset(1, 2, 4), false),
      (Offset(-1, 2, 3), false),
      (const LiteralOffset('+01:02:03', 3723), true),
    ]) {
      test('equality ', () {
        expect(Offset(1, 2, 3) == other, expected);
        expect(Offset(1, 2, 3).compareTo(other) == 0, expected);
        expect(Offset(1, 2, 3).hashCode == other.hashCode, expected);
      });
    }
  });

  group('LiteralOffset', () {
    test('constructor', () {
      const offset = LiteralOffset('+01:02:03', 3723);
      expect(offset.inSeconds, 3723);
      expect(offset.toString(), '+01:02:03');
      expect(offset.toTimezoneAbbreviation(), '+0102');
    });

    test('constructor throws exception', () => expect(() => LiteralOffset('+01:02:03', -100000000), throwsA(anything)));

    for (final (other, expected) in [
      (Offset(1, 2, 3), true),
      (Offset(1, 2, 4), false),
      (Offset(-1, 2, 3), false),
      (const LiteralOffset('+01:02:03', 3723), true),
    ]) {
      test('equality ', () {
        expect(const LiteralOffset('+01:02:03', 3723) == other, expected);
        expect(const LiteralOffset('+01:02:03', 3723).compareTo(other) == 0, expected);
        expect(const LiteralOffset('+01:02:03', 3723).hashCode == other.hashCode, expected);
      });
    }
  });
}
