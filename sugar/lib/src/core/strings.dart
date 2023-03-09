import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Provides functions for manipulating [String]s.
extension Strings on String {

  /// The default separators recognized by [toCamelCase] and other related methods.
  ///
  /// The recognized separators are:
  /// * Consecutive uppercase characters
  /// * ` ` - space character
  /// * `-` - hyphen
  /// * `_` - underscore
  ///
  /// These separators are used to indicate word boundaries. For example, `separate by-multiple_YAMLWords` will be seperated
  /// into `separate`, `by`, `multiple`, `YAML` and `Words`. Notice that all separators are removed except for the consecutive
  /// uppercase characters.
  ///
  /// It is recommended to use [partialWordSeparators] instead if the input strings are not expected to be camel-cased or pascal-cased.
  static final Pattern wordSeparators = RegExp(r'((\s|-|_)+)|(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])'); // Adapted from: https://stackoverflow.com/a/7599674/4189771

  /// A subset of the default separators, [wordSeparators]. It does not support separation by capitalized letters. For example,
  /// `PascalCase` will be separated into `PascalCase`.
  ///
  /// The recognized separators are:
  /// * ` ` - space character
  /// * `-` - hyphen
  /// * `_` - underscore
  ///
  /// These separators are used to indicate word boundaries. For example, `separate by-multiple_wordsAndLetters` will be
  /// seperated into `separate`, `by`, `multiple` and `wordsAndLetters`.
  static final Pattern partialWordSeparators = RegExp(r'(\s|-|_)+');


  /// Returns `true` if this [String] and [other] are equal, ignoring capitalization.
  ///
  /// ### Example:
  /// ```dart
  /// 'aBc'.equalsIgnoreCase('abC'); // true
  ///
  /// 'aB'.equalsIgnoreCase('aC'); // false
  /// ```
  @useResult bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();

  /// Returns `true` if this [String] matches the given [pattern].
  ///
  /// ### Example:
  /// ```dart
  /// 'abc'.matches('abC'); // true
  ///
  /// 'ab'.matches('abc'); // false
  ///
  /// 'abcabc'.matches('abc'); // false
  /// ```
  @useResult bool matches(Pattern pattern) {
    final match = pattern.matchAsPrefix(this);
    return match != null && match.start == 0 && match.end == length;
  }


  /// Returns a copy of this string with the first letter capitalized.
  ///
  /// ### Example:
  /// ```dart
  /// 'abc'.capitalize(); // 'Abc'
  ///
  /// 'abC'.capitalize(); // 'AbC'
  ///
  /// ''.capitalize(); // ''
  /// ```
  @useResult String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);


  /// Returns a camel-cased copy of this string. If [separators] is unspecified, [wordSeparators] is used to separate words.
  ///
  /// ### Example:
  /// ```dart
  /// 'camelCase'.toCamelCase(); // 'camelCase'
  ///
  /// 'PascalCase'.toCamelCase(); // 'pascalCase'
  ///
  /// 'SCREAMING_CASE'.toCamelCase(); // 'screamingCase'
  ///
  /// 'snake_case'.toCamelCase(); // 'snakeCase'
  ///
  /// 'kebab-case'.toCamelCase(); // 'kebabCase'
  ///
  /// 'Title Case'.toCamelCase(); // 'titleCase'
  ///
  /// 'Sentence case'.toCamelCase(); // 'sentenceCase'
  /// ```
  @useResult String toCamelCase([Pattern? separators]) {
    final words = split(separators ?? wordSeparators).where((e) => e.isNotEmpty);
    final buffer = StringBuffer()..write(words.first.toLowerCase());
    for (final word in words.skip(1)) {
      if (isNotEmpty) {
        buffer..write(word[0].toUpperCase())..write(word.substring(1).toLowerCase());
      }
    }

    return buffer.toString();
  }

  /// Returns a pascal-cased copy of this string. If [separators] is unspecified, [wordSeparators] is used to separate
  /// words.
  ///
  /// ### Example:
  /// ```dart
  /// 'camelCase'.toPascalCase(); // 'CamelCase'
  ///
  /// 'PascalCase'.toPascalCase(); // 'PascalCase'
  ///
  /// 'SCREAMING_CASE'.toPascalCase(); // 'ScreamingCase'
  ///
  /// 'snake_case'.toPascalCase(); // 'SnakeCase'
  ///
  /// 'kebab-case'.toPascalCase(); // 'KebabCase'
  ///
  /// 'Title Case'.toPascalCase(); // 'TitleCase'
  ///
  /// 'Sentence case'.toPascalCase(); // 'SentenceCase'
  /// ```
  @useResult String toPascalCase([Pattern? separators]) {
    final buffer = StringBuffer();
    for (final word in split(separators ?? wordSeparators)) {
      if (isNotEmpty) {
        buffer..write(word[0].toUpperCase())..write(word.substring(1).toLowerCase());
      }
    }

    return buffer.toString();
  }

  /// Returns a screaming-cased copy of this string. If [separators] is unspecified, [wordSeparators] is used to separate
  /// words.
  ///
  /// ### Example:
  /// ```dart
  /// 'camelCase'.toScreamingCase(); // 'CAMEL_CASE'
  ///
  /// 'PascalCase'.toScreamingCase(); // 'PASCAL_CASE'
  ///
  /// 'SCREAMING_CASE'.toScreamingCase(); // 'SCREAMING_CASE'
  ///
  /// 'snake_case'.toScreamingCase(); // 'SNAKE_CASE'
  ///
  /// 'kebab-case'.toScreamingCase(); // 'KEBAB_CASE'
  ///
  /// 'Title Case'.toScreamingCase(); // 'TITLE_CASE'
  ///
  /// 'Sentence case'.toScreamingCase(); // 'SENTENCE_CASE'
  /// ```
  @useResult String toScreamingCase([Pattern? separators]) => split(separators ?? wordSeparators)
    .where((e) => e.isNotEmpty)
    .join('_')
    .toUpperCase();

  /// Returns a snake-cased copy of this string. If [separators] is unspecified, [wordSeparators] is used to separate words.
  ///
  /// ### Example:
  /// ```dart
  /// 'camelCase'.toSnakeCase(); // 'camel_case'
  ///
  /// 'PascalCase'.toSnakeCase(); // 'pascal_case'
  ///
  /// 'SCREAMING_CASE'.toSnakeCase(); // 'screaming_case'
  ///
  /// 'snake_case'.toSnakeCase(); // 'snake_case'
  ///
  /// 'kebab-case'.toSnakeCase(); // 'kebab_case'
  ///
  /// 'Title Case'.toSnakeCase(); // 'title_case'
  ///
  /// 'Sentence case'.toSnakeCase(); // 'sentence_case'
  /// ```
  @useResult String toSnakeCase([Pattern? separators]) => split(separators ?? wordSeparators)
    .where((e) => e.isNotEmpty)
    .join('_')
    .toLowerCase();

  /// Returns a snake-cased copy of this string. If [separators] is unspecified, [wordSeparators] is used to separate words.
  ///
  /// ### Example:
  /// ```dart
  /// 'camelCase'.toKebabCase(); // 'camel-case'
  ///
  /// 'PascalCase'.toKebabCase(); // 'pascal-case'
  ///
  /// 'SCREAMING_CASE'.toKebabCase(); // 'screaming-case'
  ///
  /// 'snake_case'.toKebabCase(); // 'snake-case'
  ///
  /// 'kebab-case'.toKebabCase(); // 'kebab-case'
  ///
  /// 'Title Case'.toKebabCase(); // 'title-case'
  ///
  /// 'Sentence case'.toKebabCase(); // 'sentence-case'
  /// ```
  @useResult String toKebabCase([Pattern? separators]) => split(separators ?? wordSeparators)
    .where((e) => e.isNotEmpty)
    .join('-')
    .toLowerCase();

  /// Returns a title-cased copy of this string. If [separators] is unspecified, [wordSeparators] is used to separate words.
  ///
  /// ### Example:
  /// ```dart
  /// 'camelCase'.toTitleCase(); // 'Camel Case'
  ///
  /// 'PascalCase'.toTitleCase(); // 'Pascal Case'
  ///
  /// 'SCREAMING_CASE'.toTitleCase(); // 'SCREAMING CASE'
  ///
  /// 'documenting HTML code'.toTitleCase(); // 'Documenting HTML Code'
  ///
  /// 'snake_case'.toTitleCase(); // 'Snake Case'
  ///
  /// 'kebab-case'.toTitleCase(); // 'Kebab Case'
  ///
  /// 'Title Case'.toTitleCase(); // 'Title Case'
  ///
  /// 'Sentence case'.toTitleCase(); // 'Sentence Case'
  /// ```
  @useResult String toTitleCase([Pattern? separators]) => split(separators ?? wordSeparators)
    .where((e) => e.isNotEmpty)
    .map((e) => e.capitalize())
    .join(' ');

  /// Returns a sentence-cased copy of this string. If [separators] is unspecified, [wordSeparators] is used to separate words.
  /// A word is assumed to be an acronym if it is fully uppercase and will not be uncapitalized.
  ///
  /// ### Example:
  /// ```dart
  /// 'camelCase'.toSentenceCase(); // 'Camel case'
  ///
  /// 'PascalCase'.toSentenceCase(); // 'Pascal case'
  ///
  /// 'SCREAMING_CASE'.toSentenceCase(); // 'Screaming case'
  ///
  /// 'documenting HTML code'.toTitleCase(); // 'Documenting HTML code'
  ///
  /// 'snake_case'.toSentenceCase(); // 'Snake case'
  ///
  /// 'kebab case'.toSentenceCase(); // 'Kebab case'
  ///
  /// 'Title Case'.toSentenceCase(); // 'Title case'
  ///
  /// 'Sentence case'.toSentenceCase(); // 'Sentence case'
  /// ```
  @useResult String toSentenceCase([Pattern? separators]) => split(separators ?? wordSeparators)
      .where((e) => e.isNotEmpty)
      .map((e) => e.isUpperCase ? e : e.toLowerCase())
      .join(' ')
      .capitalize();


  /// Lazily splits this [String] into individual lines.
  ///
  /// A line is terminated by either:
  /// * a CR, carriage return: U+000D ('\r')
  /// * a LF, line feed (Unix line break): U+000A ('\n') or
  /// * a CR+LF sequence (DOS/Windows line break), and
  /// * a final non-empty line can be ended by the end of the input.
  ///
  /// The resulting lines do not contain the line terminators.
  ///
  /// ### Example:
  /// ```dart
  /// final lines =
  ///   'Dart is: \r an object-oriented \n class-based \n garbage-collected '
  ///   '\r\n language with C-style syntax \r\n'.lines;
  ///
  /// for (final line in lines) {
  ///   print(line);
  /// }
  ///
  /// // 'Dart is: '
  /// // ' an object-oriented '
  /// // ' class-based '
  /// // ' garbage-collected '
  /// // ' language with C-style syntax '
  ///
  ///
  /// ''.lines // []
  /// ```
  ///
  /// This an alternative to [LineSplitter.convert] that returns a lazy [Iterable] rather than an eager [List].
  @lazy
  @useResult Iterable<String> get lines sync* {
    const LF = 10; // ignore: constant_identifier_names
    const CR = 13; // ignore: constant_identifier_names

    var start = 0;
    for (var char = 0, i = 0; i < length; i++) {
      final previous = char;
      char = codeUnitAt(i);

      if (char != CR) {
        if (char != LF) {
          continue; // Normal characters

        } else if (previous == CR) {
          start = i + 1;
          continue; // CR LF
        }
      }

      yield substring(start, i);
      start = i + 1;
    }

    if (start < length) {
      yield substring(start);
    }
  }


  /// Whether this string is comprised entirely of uppercase characters.
  ///
  /// ### Example:
  /// ```dart
  /// 'HELLO'.isUpperCase; // true
  ///
  /// 'Hello'.isUpperCase; // false
  /// ```
  @useResult bool get isUpperCase => this == toUpperCase();

  /// Whether this string is comprised entirely of uppercase characters.
  ///
  /// ### Example:
  /// ```dart
  /// 'hello'.isLowerCase; // true
  ///
  /// 'Hello'.isLowerCase; // false
  /// ```
  @useResult bool get isLowerCase => this == toLowerCase();

  /// Whether this string is comprised of only whitespaces.
  ///
  /// ### Example:
  /// ```dart
  /// '  '.isBlank; // true
  ///
  /// '\n '.isBlank; // true
  ///
  /// '1 '.isBlank; // false
  /// ```
  ///
  /// Whitespace is defined by the Unicode White_Space property (as defined in
  /// version 6.2 or later) and the BOM character, `0xFEFF`.
  ///
  /// Here is the list of trimmed characters according to Unicode version 6.3:
  /// ```plaintext
  ///     0009..000D    ; White_Space # Cc   <control-0009>..<control-000D>
  ///     0020          ; White_Space # Zs   SPACE
  ///     0085          ; White_Space # Cc   <control-0085>
  ///     00A0          ; White_Space # Zs   NO-BREAK SPACE
  ///     1680          ; White_Space # Zs   OGHAM SPACE MARK
  ///     2000..200A    ; White_Space # Zs   EN QUAD..HAIR SPACE
  ///     2028          ; White_Space # Zl   LINE SEPARATOR
  ///     2029          ; White_Space # Zp   PARAGRAPH SEPARATOR
  ///     202F          ; White_Space # Zs   NARROW NO-BREAK SPACE
  ///     205F          ; White_Space # Zs   MEDIUM MATHEMATICAL SPACE
  ///     3000          ; White_Space # Zs   IDEOGRAPHIC SPACE
  ///
  ///     FEFF          ; BOM                ZERO WIDTH NO_BREAK SPACE
  /// ```
  /// Some later versions of Unicode do not include U+0085 as a whitespace
  /// character. Whether it is trimmed depends on the Unicode version
  /// used by the system.
  ///
  /// See [isNotBlank].
  @useResult bool get isBlank => trim().isEmpty;

  /// Whether this string is not comprised of only whitespaces.
  ///
  /// ### Example:
  /// ```dart
  /// '  '.isNotBlank; // false
  ///
  /// '\n '.isNotBlank; // false
  ///
  /// '1 '.isNotBlank; // true
  /// ```
  ///
  /// Whitespace is defined by the Unicode White_Space property (as defined in
  /// version 6.2 or later) and the BOM character, `0xFEFF`.
  ///
  /// Here is the list of trimmed characters according to Unicode version 6.3:
  /// ```plaintext
  ///     0009..000D    ; White_Space # Cc   <control-0009>..<control-000D>
  ///     0020          ; White_Space # Zs   SPACE
  ///     0085          ; White_Space # Cc   <control-0085>
  ///     00A0          ; White_Space # Zs   NO-BREAK SPACE
  ///     1680          ; White_Space # Zs   OGHAM SPACE MARK
  ///     2000..200A    ; White_Space # Zs   EN QUAD..HAIR SPACE
  ///     2028          ; White_Space # Zl   LINE SEPARATOR
  ///     2029          ; White_Space # Zp   PARAGRAPH SEPARATOR
  ///     202F          ; White_Space # Zs   NARROW NO-BREAK SPACE
  ///     205F          ; White_Space # Zs   MEDIUM MATHEMATICAL SPACE
  ///     3000          ; White_Space # Zs   IDEOGRAPHIC SPACE
  ///
  ///     FEFF          ; BOM                ZERO WIDTH NO_BREAK SPACE
  /// ```
  /// Some later versions of Unicode do not include U+0085 as a whitespace
  /// character. Whether it is trimmed depends on the Unicode version
  /// used by the system.
  ///
  /// See [isBlank].
  @useResult bool get isNotBlank => trim().isNotEmpty;

}