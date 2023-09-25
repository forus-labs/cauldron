import 'package:test/test.dart';

import 'package:sugar/core.dart';

void main() {

  group('equalsIgnoreCase(...)', () {
    test('equals other, same case', () => expect('abc'.equalsIgnoreCase('abc'), true));

    test('equals other, different case', () => expect('abc'.equalsIgnoreCase('aBc'), true));

    test('not equals other, same case', () => expect('abc'.equalsIgnoreCase('abcd'), false));

    test('not equals other, different case', () => expect('abc'.equalsIgnoreCase('aBcd'), false));
  });

  group('matches(...)', () {
    test('matches other', () => expect('abc'.matches('abc'), true));

    test('does not match other, different case', () => expect('abc'.matches('aBc'), false));

    test('does not match other, partial', () => expect('abc'.matches('ab'), false));

    test('does not match other, prefix', () => expect('abc'.matches('aabc'), false));

    test('does not match other, suffix', () => expect('abc'.matches('abcc'), false));

    test('does not match other, repeating', () => expect('abc'.matches('abcabc'), false));
  });

  group('capitalize(...)', () {
    test('empty string', () => expect(''.capitalize(), ''));

    test('all lowercase', () => expect('abc'.capitalize(), 'Abc'));

    test('existing uppercase', () => expect('Abc'.capitalize(), 'Abc'));

    test('single letter', () => expect('a'.capitalize(), 'A'));

    test('existing capitalized letters', () => expect('aBc a'.capitalize(), 'ABc a'));
  });


  group('toCamelCase()', () {
    test('empty string', () => expect(''.toCamelCase(), ''));

    test('single word', () => expect('abc'.toCamelCase(), 'abc'));

    test('camel case', () => expect('camelCase'.toCamelCase(), 'camelCase'));

    test('pascal case', () => expect('PascalCase'.toCamelCase(), 'pascalCase'));

    test('screaming case', () => expect('SCREAMING_CASE'.toCamelCase(), 'screamingCase'));

    test('snake case', () => expect('snake_case'.toCamelCase(), 'snakeCase'));

    test('kebab case', () => expect('kebab-case'.toCamelCase(), 'kebabCase'));

    test('title case', () => expect('Title Case'.toCamelCase(), 'titleCase'));

    test('sentence case', () => expect('Sentence case'.toCamelCase(), 'sentenceCase'));
  });

  group('toPascalCase()', () {
    test('empty string', () => expect(''.toPascalCase(), ''));

    test('single word', () => expect('abc'.toPascalCase(), 'Abc'));

    test('camel case', () => expect('camelCase'.toPascalCase(), 'CamelCase'));

    test('pascal case', () => expect('PascalCase'.toPascalCase(), 'PascalCase'));

    test('screaming case', () => expect('SCREAMING_CASE'.toPascalCase(), 'ScreamingCase'));

    test('snake case', () => expect('snake_case'.toPascalCase(), 'SnakeCase'));

    test('kebab case', () => expect('kebab-case'.toPascalCase(), 'KebabCase'));

    test('title case', () => expect('Title Case'.toPascalCase(), 'TitleCase'));

    test('sentence case', () => expect('Sentence case'.toPascalCase(), 'SentenceCase'));
  });

  group('toScreamingCase()', () {
    test('empty string', () => expect(''.toScreamingCase(), ''));

    test('single word', () => expect('abc'.toScreamingCase(), 'ABC'));

    test('camel case', () => expect('camelCase'.toScreamingCase(), 'CAMEL_CASE'));

    test('pascal case', () => expect('PascalCase'.toScreamingCase(), 'PASCAL_CASE'));

    test('screaming case', () => expect('SCREAMING_CASE'.toScreamingCase(), 'SCREAMING_CASE'));

    test('snake case', () => expect('snake_case'.toScreamingCase(), 'SNAKE_CASE'));

    test('kebab case', () => expect('kebab-case'.toScreamingCase(), 'KEBAB_CASE'));

    test('title case', () => expect('Title Case'.toScreamingCase(), 'TITLE_CASE'));

    test('sentence case', () => expect('Sentence case'.toScreamingCase(), 'SENTENCE_CASE'));
  });

  group('toSnakeCase()', () {
    test('empty string', () => expect(''.toSnakeCase(), ''));

    test('single word', () => expect('abc'.toSnakeCase(), 'abc'));

    test('camel case', () => expect('camelCase'.toSnakeCase(), 'camel_case'));

    test('pascal case', () => expect('PascalCase'.toSnakeCase(), 'pascal_case'));

    test('screaming case', () => expect('SCREAMING_CASE'.toSnakeCase(), 'screaming_case'));

    test('snake case', () => expect('snake_case'.toSnakeCase(), 'snake_case'));

    test('kebab case', () => expect('kebab-case'.toSnakeCase(), 'kebab_case'));

    test('title case', () => expect('Title Case'.toSnakeCase(), 'title_case'));

    test('sentence case', () => expect('Sentence case'.toSnakeCase(), 'sentence_case'));
  });

  group('toKebabCase()', () {
    test('empty string', () => expect(''.toKebabCase(), ''));

    test('single word', () => expect('abc'.toKebabCase(), 'abc'));

    test('camel case', () => expect('camelCase'.toKebabCase(), 'camel-case'));

    test('pascal case', () => expect('PascalCase'.toKebabCase(), 'pascal-case'));

    test('screaming case', () => expect('SCREAMING_CASE'.toKebabCase(), 'screaming-case'));

    test('snake case', () => expect('snake_case'.toKebabCase(), 'snake-case'));

    test('kebab case', () => expect('kebab-case'.toKebabCase(), 'kebab-case'));

    test('title case', () => expect('Title Case'.toKebabCase(), 'title-case'));

    test('sentence case', () => expect('Sentence case'.toKebabCase(), 'sentence-case'));
  });

  group('toTitleCase()', () {
    test('empty string', () => expect(''.toTitleCase(), ''));

    test('single word', () => expect('abc'.toTitleCase(), 'Abc'));

    test('camel case', () => expect('camelCase'.toTitleCase(), 'Camel Case'));

    test('pascal case', () => expect('PascalCase'.toTitleCase(), 'Pascal Case'));

    test('screaming case', () => expect('SCREAMING_CASE'.toTitleCase(), 'SCREAMING CASE'));

    test('snake case', () => expect('snake_case'.toTitleCase(), 'Snake Case'));

    test('kebab case', () => expect('kebab-case'.toTitleCase(), 'Kebab Case'));

    test('title case', () => expect('Title Case'.toTitleCase(), 'Title Case'));

    test('sentence case', () => expect('Sentence case'.toTitleCase(), 'Sentence Case'));
  });

  group('toSentenceCase()', () {
    test('empty string', () => expect(''.toSentenceCase(), ''));

    test('single word', () => expect('abc'.toSentenceCase(), 'Abc'));

    test('camel case', () => expect('camelCase'.toSentenceCase(), 'Camel case'));

    test('pascal case', () => expect('PascalCase'.toSentenceCase(), 'Pascal case'));

    test('screaming case', () => expect('SCREAMING_CASE'.toSentenceCase(), 'SCREAMING CASE'));

    test('snake case', () => expect('snake_case'.toSentenceCase(), 'Snake case'));

    test('kebab case', () => expect('kebab-case'.toSentenceCase(), 'Kebab case'));

    test('title case', () => expect('Title Case'.toSentenceCase(), 'Title case'));

    test('sentence case', () => expect('Sentence case'.toSentenceCase(), 'Sentence case'));
  });


  group('lines', () {
    test('empty', () => expect(''.lines.toList(), []));

    test('End with CR', () => expect('AB\rCD\rEF'.lines.toList(), ['AB', 'CD', 'EF']));

    test('End with LF', () => expect('AB\nCD\nEF'.lines.toList(), ['AB', 'CD', 'EF']));

    test('End with CR+LF', () => expect('AB\r\nCD\r\nEF'.lines.toList(), ['AB', 'CD', 'EF']));

    test('End with LF+CR', () => expect('AB\n\rCD\n\rEF'.lines.toList(), ['AB', '', 'CD', '', 'EF']));

    test('End with no line terminator', () => expect('AB\nCD'.lines.toList(), ['AB', 'CD']));
  });

  group('isUppercase', () {
    test('uppercase', () => expect('ABC'.isUpperCase, true));

    test('mixed', () => expect('aBc'.isUpperCase, false));

    test('lowercase', () => expect('abc'.isUpperCase, false));
  });

  group('isLowerCase', () {
    test('uppercase', () => expect('ABC'.isLowerCase, false));

    test('mixed', () => expect('aBc'.isLowerCase, false));

    test('lowercase', () => expect('abc'.isLowerCase, true));
  });

  group('isBlank', () {
    test('blank', () => expect('  '.isBlank, true));

    test('newline', () => expect('\n '.isBlank, true));

    test('empty', () => expect(''.isBlank, true));

    test('not blank', () => expect('ABC'.isBlank, false));

    test('prefix', () => expect('  ABC'.isBlank, false));

    test('suffix', () => expect('ABC  '.isBlank, false));
  });

  group('isNotBlank', () {
    test('blank', () => expect('  '.isNotBlank, false));

    test('newline', () => expect('\n '.isNotBlank, false));

    test('empty', () => expect(''.isNotBlank, false));

    test('not blank', () => expect('ABC'.isNotBlank, true));

    test('prefix', () => expect('  ABC'.isNotBlank, true));

    test('suffix', () => expect('ABC  '.isNotBlank, true));
  });

  group('<', () {
    test('A < B', () => expect('A' < 'B', true));

    test('B < A', () => expect('B' < 'A', false));

    test('A < A', () => expect('A' < 'A', false));

    test('A < Apple', () => expect('A' < 'Apple', true));

    test('Apple < A', () => expect('Apple' < 'A', false));

    test('a < A', () => expect('a' < 'A', false));

    test('A < a', () => expect('A' < 'a', true));
  });

  group('<=', () {
    test('A <= B', () => expect('A' <= 'B', true));

    test('B <= A', () => expect('B' <= 'A', false));

    test('A <= A', () => expect('A' <= 'A', true));

    test('A <= Apple', () => expect('A' <= 'Apple', true));

    test('Apple <= A', () => expect('Apple' <= 'A', false));

    test('a <= A', () => expect('a' <= 'A', false));

    test('A <= a', () => expect('A' <= 'a', true));
  });

  group('>', () {
    test('A > B', () => expect('A' > 'B', false));

    test('B > A', () => expect('B' > 'A', true));

    test('A > A', () => expect('A' > 'A', false));

    test('A > Apple', () => expect('A' > 'Apple', false));

    test('Apple > A', () => expect('Apple' > 'A', true));

    test('a > A', () => expect('a' > 'A', true));

    test('A > a', () => expect('A' > 'a', false));
  });

  group('>=', () {
    test('A >= B', () => expect('A' >= 'B', false));

    test('B >= A', () => expect('B' >= 'A', true));

    test('A >= A', () => expect('A' >= 'A', true));

    test('A >= Apple', () => expect('A' >= 'Apple', false));

    test('Apple >= A', () => expect('Apple' >= 'A', true));

    test('a >= A', () => expect('a' >= 'A', true));

    test('A >= a', () => expect('A' >= 'a', false));
  });
  
}
