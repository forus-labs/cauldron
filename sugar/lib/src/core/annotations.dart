import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

/// Denotes that an annotated element may return the given error codes or throw the given exceptions.
///
/// Error codes:
/// ```dart
/// enum HttpCode { notFound }
///
/// @Possible({HttpCode.notFound})
/// HttpCode? foo() => HttpCode.notFound;
/// ```
///
/// Exceptions:
/// ```dart
/// @Possible({ArgumentError})
/// void foo() => throw ArgumentError();
/// ```
// @Target({TargetKind.function, TargetKind.method, TargetKind.field, TargetKind.getter, TargetKind.setter}) See: https://github.com/dart-lang/sdk/issues/47421
@sealed class Possible {
  /// The possible exceptions or error codes.
  final Set<Object> states;
  /// Creates a [Possible].
  const Possible(this.states);
}


/// Denotes that the annotated element is not tested.
///
/// ```dart
/// @NotTested(because: 'result is non-deterministic')
/// int foo() => Random().nextInt(100);
/// ```
@Target({...TargetKind.values})
@sealed class NotTested {
  /// The reason the annotated location is not tested.
  final String because;
  ///  Creates a [NotTested].
  const NotTested({required this.because});
}


/// Denotes that the annotated element is lazy.
///
/// ```dart
/// final list = [1, 2, 3];
/// @lazy final iterable = list.map((e) => e.toString());
/// ```
const lazy = _Lazy();

@Target({TargetKind.type, TargetKind.function, TargetKind.method, TargetKind.getter, TargetKind.setter, TargetKind.field})
class _Lazy {
  const _Lazy();
}
