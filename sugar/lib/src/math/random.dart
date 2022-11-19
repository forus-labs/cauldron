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
  /// * the resultant range is NaN
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


/// A fake [Random] implementation that always produces the given sequence of values. A [FakeRandom] should only be used
/// in tests.
///
/// **Motivation: **
/// Why prefer a [FakeRandom] over a seeded [Random]?
///
/// A [FakeRandom] avoids depending on the implementation details. Whereas a seeded [Random] is implicitly dependent on the
/// underlying PRNG algorithm. The values produced if the algorithm changes may not be the same. Furthermore, reverse-engineering
/// a seed from the expected values is cumbersome.
///
/// Why prefer a [FakeRandom] over a stubbed [Random]?
///
/// Dart's mocking frameworks are not the most user-friendly. They require a fair amount of ceremony to set-up. Furthermore,
/// Mockito does not provide a simple way to return different values from repeated method calls.
@visibleForTesting
class FakeRandom implements Random {

  final Iterator<int> _ints;
  final Iterator<double> _doubles;
  final Iterator<bool> _bools;

  /// Creates a [FakeRandom] with the given [Iterable]s of values used by the various methods.
  FakeRandom({
    Iterable<int> ints = const [],
    Iterable<double> doubles = const [],
    Iterable<bool> bools = const [],
  }): _ints = ints.iterator, _doubles = doubles.iterator, _bools = bools.iterator;

  /// Returns an integer in the given [Iterable] of integers.
  ///
  /// A [StateError] is thrown if there are no more integers in the given [Iterable] of integers.
  /// A [RangeError] is thrown if the integer returned by the given [Iterable] of integers is outside the range, `0 <= integer < max`.
  ///
  /// ```dart
  /// final random = FakeRandom(ints: [1, 2]);
  /// random.nextInt(5); // 1
  /// random.nextInt(5); // 2
  /// random.nextInt(5); // throws StateError
  ///
  /// final random = FakeRandom(ints: [5]);
  /// random.nextInt(1); // throws RangeError
  /// ```
  @override
  @Possible({StateError, RangeError})
  int nextInt(int max) {
    if (!_ints.moveNext()) {
      throw StateError('FakeRandom presently does not contain an integer. Try supply more integers to `FakeRandom(ints: [...])`.');
    }

    if (max <= 0) {
      throw RangeError('max is $max, should be in the range `0 < max`.');
    }

    if (_ints.current < 0 || max <= _ints.current) {
      throw RangeError('The current integer, ${_ints.current} is outside the range, `0 <= ${_ints.current} < $max`. Try change the integers supplied to `FakeRandom(ints: [...])`.');
    }

    return _ints.current;
  }

  /// Returns a double in the given [Iterable] of doubles.
  ///
  /// A [StateError] is thrown if there are no more doubles in the given [Iterable] of doubles.
  /// A [RangeError] is thrown if the double returned by the given [Iterable] of doubles is outside the range, `0.0 <= double < 1.0`.
  ///
  /// ```dart
  /// final random = FakeRandom(doubles: [0.1, 0.2]);
  /// random.nextDouble(); // 0.1
  /// random.nextDouble(); // 0.2
  /// random.nextDouble(); // throws StateError
  ///
  /// final random = FakeRandom(ints: [5]);
  /// random.nextInt(1); // throws RangeError
  /// ```
  @override
  double nextDouble() {
    if (!_doubles.moveNext()) {
      throw StateError('FakeRandom presently does not contain a double. Try supply more doubles to `FakeRandom(doubles: [...])`.');
    }

    if (_doubles.current < 0.0 || 1.0 <= _doubles.current) {
      throw RangeError('The current double, ${_doubles.current} is outside the range, `0.0 <= ${_doubles.current} < 1.0`. Try change the doubles supplied to `FakeRandom(doubles: [...])`.');
    }

    return _doubles.current;
  }

  /// Returns a boolean in the given [Iterable] of booleans.
  ///
  /// A [StateError] is thrown if there are no more booleans in the given [Iterable] of booleans.
  ///
  /// ```dart
  /// final random = FakeRandom(bools: [true, false]);
  /// random.nextBool(); // true
  /// random.nextBool(); // false
  /// random.nextBool(); // throws StateError
  /// ```
  @override
  bool nextBool() {
    if (!_bools.moveNext()) {
      throw StateError('FakeRandom presently does not contain a boolean. Try supply more booleans to `FakeRandom(bools: [...])`.');
    }

    return _bools.current;
  }

}
