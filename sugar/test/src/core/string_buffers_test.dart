import 'package:sugar/core.dart';
import 'package:test/test.dart';

void main() {

  group('writeEnclosed(...)', () {
    test('encloses non-empty string', () => expect((StringBuffer()..writeEnclosed(5, '"')).toString(), '"5"'));

    test('encloses empty string', () => expect((StringBuffer()..writeEnclosed()).toString(), "'null'"));
  });

  group('writeIndented(...)', () {
    test('indent non-empty string', () => expect((StringBuffer()..writeIndented(4, 'hello')).toString(), '    hello'));

    test('indent empty string', () => expect((StringBuffer()..writeIndented(4)).toString(), '    null'));
  });

}
