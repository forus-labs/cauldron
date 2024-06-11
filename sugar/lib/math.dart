/// {@category Core}
///
/// Utilities for performing numeric operations.
///
/// ## Basic numeric operations
/// * [Integers] - functions that ceil, floor and round numbers.
/// * [Doubles] - function for fuzzy equality
///
/// ## Nullable numeric operations
/// * [NullableNumbers] - overloaded operators for working with nullable numbers.
/// * [NullableIntegers] - overloaded operators for working with nullable integers.
/// * [NullableDoubles] - overloaded operators for working with nullable doubles.
///
/// ## Random
/// * [Randoms] - functions for using [Random]
/// * [FakeRandom] - a fake [Random] implementation for testing
library sugar.math;

import 'dart:math';

import 'package:sugar/src/math/nullable_numbers.dart';
import 'package:sugar/src/math/numbers.dart';
import 'package:sugar/src/math/random.dart';

export 'src/math/arithmetic_exception.dart';
export 'src/math/nullable_numbers.dart';
export 'src/math/numbers.dart';
export 'src/math/random.dart';
