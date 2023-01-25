import 'package:meta/meta.dart';

/// Provides functions for manipulating [String]s.
extension Strings on String {

  /// The default separators recognized by [toScreamingCase] and other related methods.
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
  /// It is recommended to use [partialSeparators] instead if the input strings are not expected to be camel-cased or pascal-cased.
  static final Pattern fullSeparators = RegExp(r'((\s|-|_)+)|(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])'); // Adapted from: https://stackoverflow.com/a/7599674/4189771

  /// A subset of the default separators, [fullSeparators] used by [toCamelCase] and [toPascalCase]. It does not support
  /// separation by capitalized letters. For example, `PascalCase` will be separated into `PascalCase`.
  ///
  /// The recognized separators are:
  /// * ` ` - space character
  /// * `-` - hyphen
  /// * `_` - underscore
  ///
  /// These separators are used to indicate word boundaries. For example, `separate by-multiple_words` will be seperated
  /// into `separate`, `by`, `multiple` and `words`.
  static final Pattern partialSeparators = RegExp(r'(\s|-|_)+');

  /// Returns a copy of this string with the first letter capitalized.
  ///
  /// ```dart
  /// 'abc'.capitalize(); // 'Abc'
  ///
  /// 'abC'.capitalize(); // 'AbC'
  ///
  /// ''.capitalize(); // ''
  /// ```
  @useResult String capitalize() => isEmpty ? this : this[0].toUpperCase() + substring(1);


  /// Returns a camel-cased copy of this string. If [separators] is unspecified, [partialSeparators] is used to separate words.
  ///
  /// ```dart
  /// 'json md5-hash'.toCamelCase(); // 'jsonMd5Hash'
  ///
  /// 'JSON string'.toCamelCase(); // 'jsonString'
  ///
  /// 'tyPo in cAsE'.toCamelCase(); // 'typoInCase'
  /// ```
  @useResult String toCamelCase([Pattern? separators]) {
    final words = split(separators ?? partialSeparators).where((e) => e.isNotEmpty);
    final buffer = StringBuffer()..write(words.first.toLowerCase());
    for (final word in words) {
      if (isNotEmpty) {
        buffer..write(word[0].toUpperCase())..write(word.substring(1).toLowerCase());
      }
    }

    return buffer.toString();
  }

  /// Returns a pascal-cased copy of this string. If [separators] is unspecified, [partialSeparators] is used to separate
  /// words.
  ///
  /// ```dart
  /// 'json md5-hash'.toPascalCase(); // 'JsonMd5Hash'
  ///
  /// 'JSON string'.toPascalCase(); // 'JsonString'
  /// ```
  String toPascalCase([Pattern? separators]) {
    final buffer = StringBuffer();
    for (final word in split(separators ?? partialSeparators)) {
      if (isNotEmpty) {
        buffer..write(word[0].toUpperCase())..write(word.substring(1).toLowerCase());
      }
    }

    return buffer.toString();
  }

  /// Returns a screaming-cased copy of this string. If [separators] is unspecified, [fullSeparators] is used to separate
  /// words.
  ///
  /// ```dart
  /// 'json md5-hash'.toScreamingCase(); // 'JSON_MD5_HASH'
  ///
  /// 'JSONStringTemplate'.toScreamingCase(); // 'JSON_STRING_TEMPLATE'
  ///
  /// `iPhone`.toScreamingCase(); // 'I_PHONE'
  /// ```
  String toScreamingCase([Pattern? separators]) => split(separators ?? fullSeparators)
    .where((e) => e.isNotEmpty)
    .join('_')
    .toUpperCase();

  /// Returns a snake-cased copy of this string. If [separators] is unspecified, [fullSeparators] is used to separate words.
  ///
  /// ```dart
  /// 'json md5-hash'.toSnakeCase(); // 'json_md5_hash'
  ///
  /// 'JSONStringTemplate'.toSnakeCase(); // 'json_string_template'
  ///
  /// `iPhone`.toSnakeCase(); // 'i_phone'
  /// ```
  String toSnakeCase([Pattern? separators]) => split(separators ?? fullSeparators)
    .where((e) => e.isNotEmpty)
    .join('_')
    .toLowerCase();

  /// Returns a snake-cased copy of this string. If [separators] is unspecified, [fullSeparators] is used to separate words.
  ///
  /// ```dart
  /// 'json md5-hash'.toKebabCase(); // 'json-md5-hash'
  ///
  /// 'JSONStringTemplate'.toKebabCase(); // 'json-string-template'
  ///
  /// `iPhone`.toKebabCase(); // 'i-phone'
  /// ```
  String toKebabCase([Pattern? separators]) => split(separators ?? fullSeparators)
    .where((e) => e.isNotEmpty)
    .join('-')
    .toLowerCase();

  /// Returns a title-cased copy of this string. If [separators] is unspecified, [fullSeparators] is used to separate words.
  ///
  /// ```dart
  /// 'json md5-hash'.toTitleCase(); // 'Json Md5 Hash'
  ///
  /// 'JSONStringTemplate'.toTitleCase(); // 'JSON String Template'
  ///
  /// `iPhone`.toTitleCase(); // 'I Phone'
  /// ```
  String toTitleCase([Pattern? separators]) => split(separators ?? fullSeparators)
    .where((e) => e.isNotEmpty)
    .map((e) => e.capitalize())
    .join(' ');

  /// Returns a sentence-cased copy of this string. If [separators] is unspecified, [fullSeparators] is used to separate words.
  /// A word is assumed to be an acronym if it is fully uppercase and will not be uncapitalized.
  ///
  /// ```dart
  /// 'json md5-hash'.toSentenceCase(); // 'Json md5 hash'
  ///
  /// 'JSONStringTemplate'.toSentenceCase(); // 'JSON string template'
  ///
  /// 'SomeXMLValue'.toSentenceCase(); // 'Some XML value'
  ///
  /// `iPhone`.toSentenceCase(); // 'I phone'
  /// ```
  String toSentenceCase([Pattern? separators]) => split(separators ?? fullSeparators)
      .where((e) => e.isNotEmpty)
      .map((e) => e.isUpperCase ? e : e.toLowerCase())
      .join(' ')
      .capitalize();

  /// Whether this string is comprised entirely of uppercase characters.
  ///
  /// ```dart
  /// 'HELLO'.isUpperCase; // true
  ///
  /// 'Hello'.isUpperCase; // false
  /// ```
  bool get isUpperCase => this == toUpperCase();

  /// Whether this string is comprised entirely of uppercase characters.
  ///
  /// ```dart
  /// 'hello'.isLowerCase; // true
  ///
  /// 'Hello'.isLowerCase; // false
  /// ```
  bool get isLowerCase => this == toLowerCase();

  /// Whether this string is comprised of only whitespaces.
  ///
  /// ```dart
  /// '  '.isBlank; // true
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
  bool get isBlank => trim().isEmpty;

  /// Whether this string is not comprised of only whitespaces.
  ///
  /// ```dart
  /// '  '.isNotBlank; // false
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
  bool get isNotBlank => trim().isNotEmpty;

}
