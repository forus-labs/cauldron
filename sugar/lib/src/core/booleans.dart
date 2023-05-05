import 'package:meta/meta.dart';
import 'package:sugar/math.dart'; // documentation

/// Provides functions for working with booleans.
extension Bools on bool {

  /// Returns `1` if true and `0` otherwise.
  ///
  /// See [Integers.toBool].
  ///
  /// ```dart
  /// true.toInt(); // 1
  /// false.toInt(); // 0
  /// ```
  @useResult int toInt() => this ? 1 : 0;

}
