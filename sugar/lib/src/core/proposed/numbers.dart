import 'package:sugar/core.dart';
import 'package:sugar/math.dart';

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
  int toInt() => this ? 1 : 0;

}

/// Provides functions for working with integers.
extension Integers on int {

  // TODO: add bounds

  @Possible({RangeError, ArithmeticException})
  int roundTo(int factor) => this % factor >= (factor.toDouble() / 2) ? ceilTo(factor) : floorTo(factor);

  @Possible({RangeError, ArithmeticException})
  int ceilTo(int factor) {
    if (factor < 1) {
      throw RangeError.range(factor, 1, null, 'factor');
    }

    final number = this + factor - 1;
    if (number < this) {
      throw ArithmeticException('Integer overflow.');
    }

    return number - (number % factor);
  }

  @Possible({RangeError})
  int floorTo(int factor) => factor >= 1 ? this - (this % factor) : throw RangeError.range(factor, 1, null, 'factor');


  /// If `0`, returns `false`, otherwise returns `true`.
  ///
  /// ```dart
  /// 3.toBool(); // true
  /// -1.toBool(); // true
  ///
  /// 0.toBool(); false
  /// ```
  bool toBool() => this != 0;

}

extension Doubles on double {

  bool close(double epsilon, {required double to}) => (this - to).abs() < epsilon;

}