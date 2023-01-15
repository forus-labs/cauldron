import 'package:sugar/core.dart';
import 'package:test/test.dart';

void main() {
  group('Booleans', () {
    for (final entry in {
      'true': true,
      'tRuE': true,
      'false': false,
      'fAlsE': false,
    }.entries) {
      test('parse(...)', () => expect(Bools.tryParse(entry.key), entry.value));
    }

    for (final entry in {
      'true ': null,
      '0': null,
    }.entries) {
      test('parse(...) throws exception', () => expect(() => Bools.parse(entry.key), throwsFormatException));
    }
    
    for (final entry in {
      'true': true,
      'tRuE': true,
      'false': false,
      'fAlsE': false,
      'true ': null,
      '0': null,
    }.entries) {
      test('tryParse(...)', () => expect(Bools.tryParse(entry.key), entry.value));
    }

    group('toInt()', () {
      test('returns 1', () => expect(true.toInt(), 1));

      test('returns 0', () => expect(false.toInt(), 0));
    });
  });
}