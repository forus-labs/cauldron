import 'package:sugar/sugar.dart';
import 'package:test/test.dart';

void main() {

  group('format(...)', () {
    test('format', () => expect(Times.format(1, 2, 3, 4, 5), '01:02:03.004005'));

    for (final arguments in [
      [LocalTime(0, 1), '00:01'],
      [LocalTime(0, 0, 1), '00:00:01'],
      [LocalTime(0, 0, 0, 1), '00:00:00.001'],
      [LocalTime(0, 0, 0, 0, 1), '00:00:00.000001'],
    ]) {
      final date = arguments[0] as LocalTime;
      final string = arguments[1] as String;

      test('truncates trailing zeros', () => expect(
        Times.format(date.hour, date.minute, date.second, date.millisecond, date.microsecond),
        string,
      ));
    }
  });

}