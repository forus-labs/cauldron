import 'dart:math';

import 'package:sugar/sugar.dart';

/// Provides low-level functions for manipulating string indexes.
///
/// Users should generally prefer the higher-level collections instead.
///
/// ## Description
/// String indexes are strings compared alphabetically to determine order. For example, 'a' is ordered before 'b' since
/// `'a' < 'b'`. Each character in a string index is one of the allowed 64 characters, `+, -, [0-9], [A-Z] and [a-z]`.
///
/// If two indexes contain different number of characters, the shorter index will be implicitly suffixed with `+`s
/// (the first allowed character) until its length is equal to the longer index. For example, when comparing `a` and
/// `a+a`, `a` will be implicated suffixed as `a++`.
///
/// This guarantees that an element can always be inserted by suffixing its index with an allowed character. For example,
/// `aa` can be inserted between `a` and `b`.
///
/// It is still possible for two equivalent indexes without any empty space in-between to be generated concurrently. It
/// is impossible for the functions in [StringIndex] to prevent that. Such situations should be handled during merging instead.
extension type const StringIndex._(String _index) implements String {

  /// A regular expression that denotes a string index's expected format.
  static final RegExp format = RegExp(r'(\+|-|[0-9]|[A-Z]|[a-z])+');

  /// The minimum character.
  static const min = StringIndex._('+');
  /// The maximum character.
  static const max = StringIndex._('z');
  /// The allow character set in a SIL index.
  static const ascii = [
    43, 45, // +, -
    48, 49, 50, 51, 52, 53, 54, 55, 56, 57, // 0 - 9
    65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, // A - Z
    97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, // a - z
  ];

  static final Random _random = Random();
  static final RegExp _trailing = RegExp(r'(\+)+$');

  /// Creates a [StringIndex] from the given [index].
  ///
  /// ## Contract
  /// An [ArgumentError] is thrown if [index] does not match the expected [format].
  StringIndex(this._index) {
    if (!_index.matches(format)) {
      throw ArgumentError('Invalid string index: $_index, should follow the format: ${format.pattern}.');
    }
  }

  /// Create a [StringIndex] between the given [min], inclusive, and [max], exclusive.
  ///
  /// ## Contract
  /// An [ArgumentError] is thrown if [max] <= [min].
  @Possible({ArgumentError})
  factory StringIndex.between({StringIndex min = min, StringIndex max = max}) {
    if ((max.replaceAll(_trailing, '')) <= min.replaceAll(_trailing, '') ) {
      throw ArgumentError('Invalid range: $min - $max, minimum should be less than maximum.');
    }

    final buffer = StringBuffer();
    for (var i = 0; ; i++) {
      final first = ascii.indexOf(min.charCodeAt(i, ascii.first));
      final last = ascii.indexOf(max.charCodeAt(i, ascii.last));

      if (last - first == 0) {
        buffer.writeCharCode(ascii[first]);
        continue;
      }

      final between = _random.nextBoundedInt(first, (first < last ? last : ascii.length));
      buffer.writeCharCode(ascii[between]);

      // This detects cases where between is '+' and first is empty as empty characters in the minimum boundary are treated
      // as implicit `+`s.
      if (between - first != 0) {
        final index = buffer.toString();
        assert(!index.endsWith('+'), 'Invalid SIL index: $index, should not contain trailing "+"s.');
        return StringIndex(index.endsWith('+') ? index.replaceAll(_trailing, '') : index);
      }
    }
  }

}

extension on String {
  int charCodeAt(int index, int defaultValue) => index < length ? codeUnitAt(index) : defaultValue;
}
