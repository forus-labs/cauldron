import 'package:meta/meta.dart';

import 'package:sugar/sugar.dart';

import 'package:sugar/src/math/numbers_web.dart' if (dart.library.io) 'package:sugar/src/math/numbers_native.dart';

/// Provides functions for working with [int]s.
///
/// See [Numbers in Dart](https://dart.dev/guides/language/numbers) for behaviour discrepancies between native and web.
extension Integers on int {
  /// The range of [int] on the current platform.
  ///
  /// Platforms:
  /// * native - `-2^63` to `2^63 - 1`
  /// * web  - `-2^53` to `2^53 - 1`
  static Interval<int> get range => platformRange;

  /// Rounds this to the closest multiple of [factor].
  ///
  /// The returned [int] may overflow or underflow if sufficiently large or small.
  ///
  /// ## Contract
  /// Throws [RangeError] if `factor <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// 12.roundTo(10); // 10
  ///
  /// 22.roundTo(10); // 20
  ///
  /// 25.roundTo(10) // 30
  ///
  /// 25.roundTo(-5); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  int roundTo(int factor) => this % factor >= (factor.toDouble() / 2) ? ceilTo(factor) : floorTo(factor);

  /// Ceils this to the closest multiple of [factor].
  ///
  /// The returned [int] may overflow if sufficiently large.
  ///
  /// ## Contract
  /// Throws [RangeError] if `factor <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// 12.ceilTo(10); // 20
  ///
  /// 22.ceilTo(10); // 30
  ///
  /// 25.ceilTo(10) // 30
  ///
  /// 25.ceilTo(-5); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  int ceilTo(int factor) {
    if (factor < 1) {
      throw RangeError.range(factor, 1, null, 'factor');
    }

    final sum = this + factor - 1;
    return sum - (sum % factor);
  }

  /// Floors this to the closest multiple of [factor].
  ///
  /// The returned [int] may underflow if sufficiently small.
  ///
  /// ## Contract
  /// Throws [RangeError] if `factor <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// 12.floorTo(10); // 10
  ///
  /// 22.floorTo(10); // 20
  ///
  /// 25.floorTo(10) // 20
  ///
  /// 1.floorTo(-5); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult
  int floorTo(int factor) => switch (factor) {
    < 1 => throw RangeError.range(factor, 1, null, 'factor'),
    _ => this - (this % factor),
  };

  /// If `0`, returns `false`, otherwise returns `true`.
  ///
  /// ```dart
  /// 3.toBool(); // true
  /// -1.toBool(); // true
  ///
  /// 0.toBool(); false
  /// ```
  @useResult
  bool toBool() => this != 0;
}

/// Provides functions for working with [double]s.
extension Doubles on double {
  /// Returns true if this and [other] are within the [tolerance] of each other.
  ///
  /// ```dart
  /// 1.0002.around(1.0, 0.01); // true
  ///
  /// 1.2.around(1.0, 0.01); // false
  /// ```
  @useResult
  bool around(num other, double tolerance) => (this - other).abs() <= tolerance;
}
