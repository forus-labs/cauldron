import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {
  group('Offset', () {
    group('range', () {
      for (final argument in [Offset(-18), Offset(18), Offset.zero]) {
        test('allow $argument', () => expect(Offset.range.contains(argument), true));
      }
    });

    group('parse(...)', () {
      for (final arguments in [
        ['Z', 'Z'],
        ['+0', 'Z'],
        ['-0', 'Z'],
        ['+8', '+08:00'],
        ['-8', '-08:00'],
        ['+08', '+08:00'],
        ['-08', '-08:00'],
        ['+18', '+18:00'],
        ['-18', '-18:00'],
        ['+08:12', '+08:12'],
        ['-08:12', '-08:12'],
        ['+0812', '+08:12'],
        ['-0812', '-08:12'],
        ['+08:12:34', '+08:12:34'],
        ['-08:12:34', '-08:12:34'],
        ['+081234', '+08:12:34'],
        ['-081234', '-08:12:34'],
      ]) {
        test('accepts ${arguments[0]}', () => expect(Offset.parse(arguments[0]).toString(), arguments[1]));
      }

      for (final argument in [
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
        test('with $argument throws error', () => expect(() => Offset.parse(argument).toString(), throwsA(anything)));
      }
    });

    test('current()', () => expect(Offset.current().toDuration(), DateTime.now().timeZoneOffset));

    group('fromDuration(...)', () {
      for (final argument in [
        [const Duration(hours: -18), '-18:00'],
        [const Duration(hours: 18), '+18:00'],
        [const Duration(hours: -17, minutes: -10,seconds: -3), '-17:10:03'],
      ]) {
        test('accepts ${argument[0]}', () {
          expect(Offset.fromDuration(argument[0] as Duration).toString(), argument[1]);
        });
      }

      for (final argument in [
        const Duration(hours: 18,seconds: 1),
        const Duration(hours: -18,seconds: -1),
      ]) {
        test('with $argument throws error', () {
          expect(() => Offset.fromDuration(argument), throwsRangeError);
        });
      }
    });

    group('fromSeconds(...)', () {
      for (final argument in [
        [(-18 * Duration.secondsPerHour), '-18:00'],
        [(18 * Duration.secondsPerHour), '+18:00'],
        [123, '+00:02:03'],
      ]) {
        test('accepts ${argument[0]}', () {
          expect(Offset.fromSeconds(argument[0] as int).toString(), argument[1]);
        });
      }

      for (final argument in [
        (-18 * Duration.secondsPerHour) - 1,
        (18 * Duration.secondsPerHour) + 1,
      ]) {
        test('with $argument throws error', () {
          expect(() => Offset.fromSeconds(argument), throwsRangeError);
        });
      }
    });

    group('unnamed constructor', () {
      for (final arguments in [
        [-18, 0, 0, '-18:00'],
        [18, 0, 0, '+18:00'],
        [18, 0, 0, '+18:00'],
        [0, 59, 0, '+00:59'],
        [0, 0, 59, '+00:00:59'],
        [17, 59, 59, '+17:59:59'],
        [-17, 59, 59, '-17:59:59'],
        [-1, 30, 30, '-01:30:30'],
        [0, 0, 0, 'Z'],
      ]) {
        test('accepts $arguments', () {
          expect(Offset(arguments[0] as int, arguments[1] as int, arguments[2] as int).toString(), arguments[3]);
        });
      }

      for (final arguments in [
        [-19, 0, 0],
        [19, 0, 0],
        [18, 0, 1],
        [18, 0, -1],
        [0, 60, 0],
        [0, -1, 0],
        [0, 0, 60],
        [0, 0, -1],
        [-18, -1, -1],
      ]) {
        test('with $arguments throws error', () {
          expect(() => Offset(arguments[0], arguments[1], arguments[2]), throwsRangeError);
        });
      }
    });


    group('add', () {
      test('succeeds', () => expect(Offset().add(hours: 1, minutes: 2, seconds: 3), Offset(1, 2, 3)));

      test('fails', () => expect(() => Offset(10).add(hours: 10), throwsRangeError));
    });

    group('subtract', () {
      test('succeeds', () => expect(Offset().subtract(hours: 1, minutes: 2, seconds: 3), Offset(-1, 2, 3)));

      test('fails', () => expect(() => Offset(-10).subtract(hours: 10), throwsRangeError));
    });


    group('tryAdd', () {
      test('succeeds', () => expect(Offset().tryAdd(hours: 1, minutes: 2, seconds: 3), Offset(1, 2, 3)));

      test('fails', () => expect(Offset(10).tryAdd(hours: 10), null));
    });

    group('trySubtract', () {
      test('succeeds', () => expect(Offset().trySubtract(hours: 1, minutes: 2, seconds: 3), Offset(-1, 2, 3)));

      test('fails', () => expect(Offset(-10).trySubtract(hours: 10), null));
    });


    group('+', () {
      test('succeeds', () => expect(Offset() + const Duration(hours: 1, minutes: 2, seconds: 3), Offset(1, 2, 3)));

      test('fails', () => expect(() => Offset(10) + const Duration(hours: 10), throwsRangeError));
    });

    group('+', () {
      test('succeeds', () => expect(Offset() - const Duration(hours: 1, minutes: 2, seconds: 3), Offset(-1, 2, 3)));

      test('fails', () => expect(() => Offset(-10) - const Duration(hours: 10), throwsRangeError));
    });

    test('difference(...)', () => expect(Offset(10).difference(Offset(-10)), const Duration(hours: 20)));

    test('toDuration()', () => expect(Offset(-1, 2, 3).toDuration(), const Duration(hours: -1, minutes: -2, seconds: -3)));

    for (final argument in [
      // [Offset(1, 2, 3), true],
      [Offset(1, 2, 4), false],
      [Offset(-1, 2, 3), false],
    ]) {
      test('equality ', () {
        final other = argument[0] as Offset;
        final expected = argument[1] as bool;

        expect(Offset(1, 2, 3) == other, expected);
        expect(Offset(1, 2, 3).compareTo(other) == 0, expected);
        expect(Offset(1, 2, 3).hashCode == other.hashCode, expected);
      });
    }

  });
}
