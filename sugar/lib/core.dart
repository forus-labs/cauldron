/// {@category Core}
///
/// General purpose utilities for every Dart program.
///
/// ## Annotations
/// Annotations that express intent, similar to those in `package:meta`.
///
/// * [Possible]
/// * [NotTested]
/// * [lazy]
///
/// ## Comparables & Equality
/// Mixins that simplify implementation of [Comparable], utilities for working with [Comparable], and determining deep
/// equality of inbuilt collections.
///
/// Mixin for implementing [Comparable]:
/// * [Orderable]
///
/// [Comparable] & [Comparator] utilities:
/// * [Comparators]
/// * [min]
/// * [max]
///
/// Deep equality:
/// * [DeepEqualityIterable]
/// * [DeepEqualityMap]
/// * [DeepEqualityMapEntry]
/// * [Equality]
/// * [HashCodes]
///
/// ## Functions & Monads
/// Type definitions for common functions, and monads.
///
/// Function type definitions:
/// * [Callback]
/// * [Consume]
/// * [Predicate]
/// * [Select]
/// * [Supply]
///
/// Monads:
/// * [Result]
///
/// ## Primitives
/// Utilities for manipulating primitive types, i.e. [bool] and [String].
///
/// * [Bools]
/// * [Strings]
///
/// ## Miscellaneous
/// * [NullableObjects]
/// * [Disposable]
/// * [StringBuffers]
library;

import 'package:sugar/src/core/annotations.dart';
import 'package:sugar/src/core/booleans.dart';
import 'package:sugar/src/core/comparables.dart';
import 'package:sugar/src/core/disposable.dart';
import 'package:sugar/src/core/equality.dart';
import 'package:sugar/src/core/functions.dart';
import 'package:sugar/src/core/nullable.dart';
import 'package:sugar/src/core/result.dart';
import 'package:sugar/src/core/string_buffers.dart';
import 'package:sugar/src/core/strings.dart';

export 'src/core/annotations.dart';
export 'src/core/booleans.dart';
export 'src/core/comparables.dart';
export 'src/core/disposable.dart';
export 'src/core/equality.dart';
export 'src/core/functions.dart';
export 'src/core/nullable.dart';
export 'src/core/result.dart';
export 'src/core/string_buffers.dart';
export 'src/core/strings.dart';
