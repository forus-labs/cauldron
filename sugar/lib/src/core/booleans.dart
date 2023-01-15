import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/math.dart'; // documentation

/// Provides functions for working with booleans.
extension Bools on bool {

  /// Parses [source], case insensitive, as a [bool]. A [FormatException] is thrown if [source] cannot be parsed as a [bool].
  ///
  /// ```dart
  /// Bools.parse('TRUE'); // true
  /// Bools.parse('true'); // true
  ///
  /// Bools.parse('FALSE'); // false
  /// Bools.parse('false'); // false
  ///
  /// Bools.parse('TRUE '); // throws FormatException
  /// Bools.parse('0'); // throws FormatException
  /// ```
  @Possible({FormatException})
  static bool parse(String source) {
    final bool = tryParse(source);
    if (bool != null) {
      return bool;

    } else {
      throw FormatException('Invalid boolean', source);
    }
  }

  /// Parses [source], case insensitive, as a [bool]. `null` is returned if [source] cannot be parsed as a [bool].
  ///
  /// ```dart
  /// Bools.tryParse('TRUE'); // true
  /// Bools.tryParse('true'); // true
  ///
  /// Bools.tryParse('FALSE'); // false
  /// Bools.tryParse('false'); // false
  ///
  /// Bools.tryParse('TRUE '); // null
  /// Bools.tryParse('0'); // null
  /// ```
  static bool? tryParse(String source) {
    final formatted = source.toLowerCase();
    if (formatted == 'true') {
      return true;

    } else if (formatted == 'false') {
      return false;

    } else {
      return null;
    }
  }

  /// If `true`, returns `1`, otherwise returns `0`.
  ///
  /// ```dart
  /// true.toInt(); // 1
  /// false.toInt(); // 0
  /// ```
  ///
  /// See [Integers.toBool].
  @useResult int toInt() => this ? 1 : 0;

}

void main() {
  int.tryParse('value');
}