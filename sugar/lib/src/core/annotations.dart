import 'package:meta/meta.dart';
import 'package:meta/meta_meta.dart';

/// Denotes that the annotated constructor/function may throw the given errors or return the given error codes.
///
/// Exceptions:
/// ### Example:
/// ```dart
/// @Possible({ArgumentError}, when: 'function is called')
/// void foo() => throw ArgumentError();
/// ```
///
/// Error codes:
/// ### Example:
/// ```dart
/// enum ErrorCode {
///   invalidArgument,
///   invalidRange,
/// }
///
/// @Possible({ErrorCode.invalidArgument}, when: 'function is called')
/// ErrorCode? foo() => ErrorCode.invalidArgument;
/// ```
// @Target({TargetKind.function, TargetKind.method, TargetKind.field, TargetKind.getter, TargetKind.setter}) See: https://github.com/dart-lang/sdk/issues/47421
@sealed class Possible {

  /// The possible thrown exceptions or returned error codes.
  final Set<Object> states;

  /// Creates a [Possible] with the given parameters.
  const Possible(this.states);

}


/// Denotes that the annotated location is not tested.
///
/// ### Note:
/// It is recommended to use this annotation sparingly. The annotated location should always be tested instead if possible.
///
/// ### Example:
/// ```dart
/// @NotTested(because: 'function is non-deterministic')
/// int foo() => Random().nextInt(100);
/// ```
@Target({...TargetKind.values})
@sealed class NotTested {
  /// The reason the annotated location is not tested.
  final String because;
  ///  Creates a [NotTested].
  const NotTested({required this.because});
}


/// Denotes that the annotated field/function/type is lazy.
///
/// ### Example:
/// ```dart
/// final list = [1, 2, 3];
/// @lazy final iterable = list.map((e) => e.toString());
///
/// print(iterable); ['1', '2', '3'];
///
/// list.add(4);
///
/// print(iterable); ['1', '2', '3', '4'];
/// ```
const lazy = _Lazy();

@Target({TargetKind.type, TargetKind.function, TargetKind.method, TargetKind.getter, TargetKind.setter, TargetKind.field})
class _Lazy {
  const _Lazy();
}


/// Denotes that the annotated function parameter is mutated by the function.
///
/// ### Example:
/// ```dart
/// void shuffle(@mutated List<Object> list) {
///   // shuffle the given list
/// }
/// ```
const mutated = _Mutated();

@Target({TargetKind.parameter})
class _Mutated {
  const _Mutated();
}
