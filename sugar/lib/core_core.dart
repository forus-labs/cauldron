/// General purpose utilities for every Dart program.
///
/// This library provides the following:
///
/// ## Annotations
/// Annotations that express intent, similar to those in `package:meta`.
/// * [Possible]
/// * [NotTested]
/// * [lazy]
/// * [mutated]
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
/// ## Primitives
/// Utilities for primitive types, i.e. [bool] and [String].
/// * [Bools]
/// * [Strings]
library sugar.core.core;

import 'package:sugar/src/core/annotations.dart';
import 'package:sugar/src/core/booleans.dart';
import 'package:sugar/src/core/functions.dart';
import 'package:sugar/src/core/maybe.dart';
import 'package:sugar/src/core/result.dart';
import 'package:sugar/src/core/strings.dart';

export 'src/core/annotations.dart';
export 'src/core/booleans.dart';
export 'src/core/comparables.dart';
export 'src/core/disposable.dart';
export 'src/core/equality.dart';
export 'src/core/functions.dart';
export 'src/core/maybe.dart';
export 'src/core/result.dart';
export 'src/core/string_buffers.dart';
export 'src/core/strings.dart';
