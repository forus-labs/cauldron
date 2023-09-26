import 'dart:math';

import 'package:sugar/sugar.dart';

/// Provides low-level functions for manipulating indexes in a String Indexed List (SIL).
///
/// Users should generally prefer the higher-level [SIL] instead.
///
/// ## Description
/// SIL indexes are strings compared alphabetically to determine order. For example, 'a' is ordered before 'b' since
/// `'a' < 'b'`. Each character in a SIL index is one of the allowed 64 characters, `+, -, [0-9], [A-Z] and [a-z]`.
///
/// If two indexes contain different number of characters, the shorter index will be implicitly suffixed with `+`s
/// (the first allowed character) until its length is equal to the longer index. For example, when comparing `a` and
/// `a+a`, `a` will be implicated suffixed as `a++`.
///
/// This guarantees that an element can always be inserted by suffixing its index with an allowed character. For example,
/// `aa` can be inserted between `a` and `b`.
///
/// It is still possible for two equivalent indexes without any empty space in-between to be generated concurrently. It
/// is impossible for the functions in [SilIndex] to prevent that. Such situations should be handled during merging instead.
///
/// ## The `strict` flag
/// In the original closed-source implementation, the allowed character set contained `/` instead of `-`. To maintain
/// backwards-compatibility, most functions accept a `strict` flag which disables index format validation.
///
/// External users are discouraged from enabling the `lenient` flag.
extension SilIndex on Never {

  /// The minimum character.
  static const min = '+';
  /// The maximum character.
  static const max = 'z';
  /// The allow character set in a SIL index.
  static const ascii = [
    // The original implementation used / instead of -, however this made working with URLs/escaping troublesome.
    43, 45, // +, -
    48, 49, 50, 51, 52, 53, 54, 55, 56, 57, // 0 - 9
    65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, // A - Z
    97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, // a - z
  ];

  static final Random _random = Random();
  static final RegExp _format = RegExp(r'(\+|-|[0-9]|[A-Z]|[a-z])+');
  static final RegExp _trailing = RegExp(r'(\+)+$');

  /// Generates a new SIL index between the given [min], inclusive, and [max], exclusive.
  ///
  /// ## The `strict` flag
  /// In the original closed-source implementation, the allowed character set contained `/` instead of `-`. To maintain
  /// backwards-compatibility, [between] ] accept a [strict] flag which disables index format validation.
  ///
  /// ## Contract
  /// An [ArgumentError] is thrown if
  /// * [max] <= [min]
  /// * [strict] is true and either [min] or [max] is not a valid SIL index
  @Possible({ArgumentError})
  static String between({String min = min, String max = max, bool strict = true}) {
    _validate(min, max, strict: strict);

    final index = StringBuffer();
    for (var i = 0; ; i++) {
      final first = ascii.indexOf(min.charCodeAt(i, ascii.first));
      final last = ascii.indexOf(max.charCodeAt(i, ascii.last));

      if (last - first == 0) {
        index.writeCharCode(ascii[first]);
        continue;
      }

      final between = _random.nextBoundedInt(first, (first < last ? last : ascii.length));
      index.writeCharCode(ascii[between]);

      // This detects cases where between is '+' and first is empty as empty characters in the minimum boundary are treated
      // as implicit `+`s.
      if (between - first != 0) {
        return _stripTrailing(index.toString());
      }
    }
  }

  static void _validate(String min, String max, {required bool strict}) {
    if (strict && !min.matches(_format)) {
      throw ArgumentError('SIL index, "$min", is invalid. Should be in the format: ([0-9]|[A-Z]|[a-z]|\\+|-)+');
    }

    if (strict && !max.matches(_format)) {
      throw ArgumentError('SIL index, "$max", is invalid. Should be in the format: ([0-9]|[A-Z]|[a-z]|\\+|-)+');
    }

    if ((max.replaceAll(_trailing, '')) <= min.replaceAll(_trailing, '') ) {
      throw ArgumentError('Minimum SIL index, "$min", is greater than or equal to the maximum SIL index, "$max". Minimum should be less than maximum.');
    }
  }

  static String _stripTrailing(String index) {
    assert(!index.endsWith('+'), 'SIL index, "$index", contains trailing "+"s.');
    return index.endsWith('+') ? index.replaceAll(_trailing, '') : index;
  }

}

extension on String {
  int charCodeAt(int index, int defaultValue) => index < length ? codeUnitAt(index) : defaultValue;
}
