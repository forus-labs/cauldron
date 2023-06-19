import 'dart:math';

import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// Provides functions for using [Random]s.
extension Randoms on Random {

  /// Generates a random integer uniformly distributed in the range, `[min] <= value < [max]`.
  ///
  /// ## Contract
  /// Throws [RangeError] if `min >= max`.
  ///
  /// ## Example
  /// ```dart
  /// Random().nextBoundedInt(-1, 3); // -1 <= value < 3
  ///
  /// Random().nextBoundedInt(3, 3) // throws RangeError
  /// ```
  @Possible({RangeError})
  @useResult int nextBoundedInt(int min, int max) => switch (min < max) {
    true => nextInt(max - min) + min,
    false => throw RangeError.range(max, min, null, 'max'),
  };

  /// Generates a random double in the range, `[min] <= value < [max]`.
  ///
  /// The generated double is not guaranteed to be uniformly distributed.
  ///
  /// ## Contract
  /// Throws [RangeError] if:
  /// * [min] is infinite
  /// * [max] is infinite
  /// * [min] >= [max]
  /// * the resultant range is NaN
  /// * the resultant range is infinite
  ///
  /// ## Example
  /// ```dart
  /// Random().nextDouble(1.1, 1.3); // -1 <= value < 3
  ///
  /// Random().nextBoundedInt(3.0, 3.0) // throws RangeError
  ///
  /// Random().nextBoundedInt(-double.maxFinite, double.maxFinite) // throws RangeError
  /// ```
  ///
  /// ## Implementation details
  /// This function scales the result of [nextDouble]. If the given range is sufficiently larger than `[0.0 - 1.0)`,
  /// certain doubles in the given range will never be returned, Pigeonhole Principle.
  @Possible({RangeError})
  @useResult double nextBoundedDouble(double min, double max) {
    _check(min, max);
    return nextDouble() * (max - min) + min;
  }


  /// Returns a weighted boolean value based on [probability].
  ///
  /// The probability of this function returning true increases with the value of [probability].
  ///
  /// ## Contract
  /// Throws [RangeError] if:
  /// [probability] < 0 or 1 < [probability]
  /// [probability] is infinite
  /// [probability is NaN
  ///
  /// ## Example
  /// ```dart
  /// Random().nextWeightedBool(1); // Always returns true
  ///
  /// Random().nextWeightedBool(0); // Always returns false
  /// ```
  @Possible({RangeError})
  @useResult bool nextWeightedBool(double probability) {
    if (!(0 <= probability && probability <= 1)) {
      throw RangeError.range(probability, 0, 1, 'probability');
    }

    return nextDouble() < probability;
  }


  /// Returns a [Stream] of [length] that produces random integers in the range, `[min] <= value < [max]`.
  ///
  /// If [length] is not given, returns an infinite [Stream] instead.
  ///
  /// ## Contract
  /// Throws [RangeError] if:
  /// * [length] is not positive
  /// * [min] is greater than or equal to [max]
  ///
  /// ## Example
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

    return switch (min < max) {
      true => _generate(length, () => nextInt(max - min) + min),
      false => throw RangeError.range(max, min, null, 'max'),
    };
  }

  /// Returns a [Stream] of [length] that produces random doubles in the range, `[min] <= value < [max]`.
  ///
  /// If [length] is not given, returns an infinite [Stream] instead.
  ///
  /// ## Contract
  /// Throws [RangeError] if:
  /// * [length] is not positive
  /// * [min] is infinite
  /// * [max] is infinite
  /// * [min] >= [max]
  /// * the resultant range is infinite
  ///
  /// ## Example
  /// ```dart
  /// Random.doubles(length: 5, min: 0.0, max: 1.1); // 5 values, 0.0 <= value < 1.1
  ///
  /// Random.doubles(length: 1, min: 3.0, max: 2.0); // throws RangeError
  /// ```
  ///
  /// ## Implementation details
  /// This function scales the result of [nextDouble]. If the given range is sufficiently larger than `[0.0 - 1.0)`,
  /// certain doubles in the given range will never be returned, Pigeonhole Principle.
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


/// A fake [Random] implementation that always produces a given sequence of values. It should only be used in tests.
///
/// ## Why prefer a [FakeRandom] over a seeded [Random]?
/// A `FakeRandom` avoids depending on implementation details. A seeded `Random` is implicitly dependent on the underlying
/// PRNG algorithm. The generated values may change if the algorithm changes. Furthermore, reverse-engineering a seed is
/// cumbersome.
@visibleForTesting
class FakeRandom implements Random {

  final Iterator<int> _ints;
  final Iterator<double> _doubles;
  final Iterator<bool> _bools;

  /// Creates a [FakeRandom] with the `Iterable`s used by the various function to produce values.
  FakeRandom({
    Iterable<int> ints = const [],
    Iterable<double> doubles = const [],
    Iterable<bool> bools = const [],
  }): _ints = ints.iterator, _doubles = doubles.iterator, _bools = bools.iterator;

  /// Returns the next integer in the iterable.
  ///
  /// ## Contract
  /// Throws:
  /// * a [StateError] if there are no more integers in the iterable.
  /// * a [RangeError] if an integer in the iterable is outside the range, `0 <= integer < max`.
  ///
  /// ## Example
  /// ```dart
  /// final random = FakeRandom(ints: [1, 2]);
  /// random.nextInt(5); // 1
  /// random.nextInt(5); // 2
  /// random.nextInt(5); // throws StateError
  /// ```
  @override
  @Possible({StateError, RangeError})
  @useResult int nextInt(int max) {
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

  /// Returns the next double in the iterable.
  ///
  /// ## Contract
  /// Throws:
  /// * a [StateError] if there are no more doubles in the iterable.
  /// * a [RangeError] if a double in the iterable is outside the range, `0 <= double < 1.0`.
  ///
  /// ## Example
  /// ```dart
  /// final random = FakeRandom(doubles: [0.1, 0.2]);
  /// random.nextDouble(); // 0.1
  /// random.nextDouble(); // 0.2
  /// random.nextDouble(); // throws StateError
  /// ```
  @override
  @useResult double nextDouble() {
    if (!_doubles.moveNext()) {
      throw StateError('FakeRandom presently does not contain a double. Try supply more doubles to `FakeRandom(doubles: [...])`.');
    }

    if (_doubles.current < 0.0 || 1.0 <= _doubles.current) {
      throw RangeError('The current double, ${_doubles.current} is outside the range, `0.0 <= ${_doubles.current} < 1.0`. Try change the doubles supplied to `FakeRandom(doubles: [...])`.');
    }

    return _doubles.current;
  }

  /// Returns the next boolean in the iterable.
  ///
  /// ## Contract
  /// Throws a [StateError] if there are no more booleans in the iterable.
  ///
  /// ## Example
  /// ```dart
  /// final random = FakeRandom(bools: [true, false]);
  /// random.nextBool(); // true
  /// random.nextBool(); // false
  /// random.nextBool(); // throws StateError
  /// ```
  @override
  @useResult bool nextBool() {
    if (!_bools.moveNext()) {
      throw StateError('FakeRandom presently does not contain a boolean. Try supply more booleans to `FakeRandom(bools: [...])`.');
    }

    return _bools.current;
  }

}
