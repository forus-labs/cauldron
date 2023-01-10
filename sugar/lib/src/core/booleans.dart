import 'package:meta/meta.dart';

/// Provides functions for working with booleans.
extension Booleans on bool {

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