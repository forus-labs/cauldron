// add method for finding random in list

// fake random

import 'dart:math';

import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Provides functions for using [Random]s.
extension Randoms on Random {

  /// Generates a random integer uniformly distributed in the range, `[min] <= value < [max]`.
  /// A [RangeError] is thrown if [min] is greater than or equal to [max].
  ///
  /// ```dart
  /// Random().nextBoundedInt(-1, 3); // -1 <= value < 3
  ///
  /// Random().nextBoundedInt(3, 3) // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult int nextBoundedInt(int min, int max) {
    if (min >= max) {
      throw RangeError.range(max, min, null, 'max');
    }

    return nextInt(max - min) + min;
  }

  /// Generates a random double in the range, `[min] <= value < [max]`. The generated double is not guaranteed to be
  /// uniformly distributed.
  ///
  /// A [RangeError] is thrown if:
  /// * [min] is infinite
  /// * [max] is infinite
  /// * [min] >= [max]
  /// * the resultant range is infinite
  ///
  /// ```dart
  /// Random().nextDouble(1.1, 1.3); // -1 <= value < 3
  ///
  /// Random().nextBoundedInt(3.0, 3.0) // throws RangeError
  ///
  /// Random().nextBoundedInt(-double.maxFinite, double.maxFinite) // throws RangeError
  /// ```
  ///
  /// **Implementation notes: **
  /// This method scales and translates the result of [nextDouble]. If the given range is sufficiently larger than [nextDouble]'s
  /// [0.0 - 1.0), certain doubles in the given range will never be returned (Pigeonhole Principle).
  @Possible({RangeError})
  @useResult double nextBoundedDouble(double min, double max) {
    _check(min, max);
    return nextDouble() * (max - min) + min;
  }


  /// Creates a [Stream] of the given [length] that produces random integers in the range, `[min] <= value < [max]`.
  /// If [length] is not given, creates an infinite [Stream] instead.
  ///
  /// A [RangeError] is thrown if
  /// * [length] is not positive
  /// * [min] is greater than or equal to [max]
  ///
  /// ```dart
  /// Random.ints(length: 5, min: 0, max: 3); // 5 values, 0 <= value < 3
  ///
  /// Random.ints(length: 1, min: 3, max: 2); // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult Stream<int> ints({int? length, int min = 0, required int max}) { // ignore: always_put_required_named_parameters_first
    if (length != null) {
      RangeError.checkNotNegative(length, 'length');
    }

    if (min >= max) {
      throw RangeError.range(max, min, null, 'max');
    }

    return _generate(length, () => nextInt(max - min) + min);
  }

  /// Creates a [Stream] of the given [length] that produces random doubles in the range, `[min] <= value < [max]`.
  /// If [length] is not given, creates an infinite [Stream] instead.
  ///
  /// A [RangeError] is thrown if:
  /// * [length] is not positive
  /// * [min] is infinite
  /// * [max] is infinite
  /// * [min] >= [max]
  /// * the resultant range is infinite
  ///
  /// ```dart
  /// Random.doubles(length: 5, min: 0.0, max: 1.1); // 5 values, 0.0 <= value < 1.1
  ///
  /// Random.doubles(length: 1, min: 3.0, max: 2.0); // throws RangeError
  /// ```
  ///
  /// **Implementation notes: **
  /// This method scales and translates the result of [nextDouble]. If the given range is sufficiently larger than [nextDouble]'s
  /// [0.0 - 1.0), certain doubles in the given range will never be returned (Pigeonhole Principle).
  @Possible({RangeError})
  @useResult Stream<double> doubles({int? length, double min = 0.0, double max = 1.0}) {
    if (length != null) {
      RangeError.checkNotNegative(length, 'length');
    }

    _check(min, max);
    return _generate(length, () => nextDouble() * (max - min) + min);
  }


  void _check(double min, double max) {
    if (!(min < max && (max - min) < double.infinity)) {
      throw RangeError('Range between min ($min) and max ($max) should be positive and finite.');
    }
  }

  Stream<T> _generate<T extends num>(int? length, T Function() next) async* {
    if (length == null) {
      while (true) {
        yield next();
      }

    } else {
      for (var i = 0; i < length; i++) {
        yield next();
      }
    }
  }

}
