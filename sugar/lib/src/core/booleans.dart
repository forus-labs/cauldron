import 'package:meta/meta.dart';
import 'package:sugar/math.dart'; // documentation

/// Provides functions for working with booleans.
extension Bools on bool {

  /// If `true`, returns `1`, otherwise returns `0`.
  ///
  /// ### Example:
  /// ```dart
  /// true.toInt(); // 1
  /// false.toInt(); // 0
  /// ```
  ///
  /// See [Integers.toBool].
  @useResult int toInt() => this ? 1 : 0;

}
