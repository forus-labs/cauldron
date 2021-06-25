import 'package:test/test.dart';
import 'package:sugar/sugar.dart';

void main() {

  group('Strings', () {

    for (final arguments in [['', ''], ['a', 'A'], ['abc', 'Abc']].pairs<String, String>()) {
      test('capitalize ${arguments.key}', () => expect(arguments.key.capitalize(), arguments.value));
    }

    for (final arguments in [['a ', null, 'a '], [' a', null, ' a'], ['i phone', null, 'iPhone'], ['abc', 'b', 'aC']].triples<String, Pattern, String>()) {
      test('camelCase ${arguments.left}', () => expect(arguments.left.camelCase(arguments.middle), arguments.right));
    }

    for (final arguments in [['a ', null, 'A'], [' a', null, 'A'], ['a bc', null, 'ABc'], ['abc', 'b', 'AC']].triples<String, Pattern, String>()) {
      test('pascalCase ${arguments.left}', () => expect(arguments.left.pascalCase(arguments.middle), arguments.right));
    }

    for (final arguments in [['a ', null, 'a_'], [' a', null, '_a'], ['a bc', null, 'a_bc'], ['abc', 'b', 'a_c']].triples<String, Pattern, String>()) {
      test('snakeCase ${arguments.left}', () => expect(arguments.left.snakeCase(arguments.middle), arguments.right));
    }

    for (final arguments in [['a bc', true], ['a Bc', true], ['abc', false], ['a cb', false]].pairs<String, bool>()) {
      test('equalsIgnoreCase ${arguments.key}', () => expect('a bc'.equalsIgnoreCase(arguments.key), arguments.value));
    }

    for (final arguments in [['abc', true], ['abcd', false], ['a', false]].pairs<Pattern, bool>()) {
      test('matches ${arguments.key}', () => expect('abc'.matches(arguments.key), arguments.value));
    }

    for (final arguments in [['', true], [' ', true], [' a', false]].pairs<String, bool>()) {
      test('isBlank ${arguments.key}', () {
        expect(arguments.key.isBlank, arguments.value);
        expect(arguments.key.isNotBlank, !arguments.value);
      });
    }

    for (final arguments in [[r'$a', true], ['a', true], ['A', true], ['1', false], ['1a', false], ['a b', false], ['a!', false]].pairs<String, bool>()) {
      test('isIdentifier ${arguments.key}', () => expect(arguments.key.isIdentifier, arguments.value));
    }
  });

  group('PaddedNumber', () {
    for (final arguments in [[12, '012'], [123, '123'], [1234, '1234']].pairs<int, String>()) {
      test('padLeft ${arguments.key}', () => expect(arguments.key.padLeft(3), arguments.value));
    }

    for (final arguments in [[21, '210'], [321, '321'], [4321, '4321']].pairs<int, String>()) {
      test('padRight ${arguments.key}', () => expect(arguments.key.padRight(3), arguments.value));
    }
  });

}