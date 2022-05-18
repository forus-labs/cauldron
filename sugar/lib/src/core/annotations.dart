import 'package:meta/meta.dart';

/// Signifies that the annotated type is used as an annotation.
@sealed class Annotation {
  /// The syntactic locations that the annotated type may be applied to.
  final Set<Kind> on;
  /// Whether the annotated type may be applied to a syntactic location more than once.
  final bool repeats;

  /// Creates an [Annotation].
  const Annotation({this.on = const {...Kind.values}, this.repeats = false});
}

/// The syntactic locations that an annotation may be applied to.
enum Kind {
  /// Annotation type declaration.
  annotation,
  /// Class, mixin, extension or enum declaration.
  type,
  /// Field declaration.
  field,
  /// Constructor declaration.
  constructor,
  /// Function declaration,
  function,
  /// Local variable declaration.
  localVariable,
  /// Parameter declaration, i.e.
  /// ```dart
  /// const foo = '';
  ///
  /// void bar(@foo String a) {}
  /// ```
  parameter,
  /// Type Parameter declaration, i.e.
  /// ```dart
  /// const foo = '';
  ///
  /// class Bar<@Foo T> {}
  /// ```
  typeParameter,
}


/// Denotes the annotated constructor or function throws the given errors and exceptions.
@Annotation(on: {Kind.constructor, Kind.function}, repeats: true)
@sealed class Throws {
  /// The thrown exceptions.
  final Set<Type> exceptions;
  /// The conditions under which [exceptions] is thrown.
  final String when;

  /// Creates a [Throws].
  const Throws(this.exceptions, {this.when = ''});
}

/// Denotes that the annotated location cannot be tested.
@Annotation(on: {Kind.type, Kind.field, Kind.constructor, Kind.function})
@sealed class Untestable {
  /// The reason the annotated location cannot be tested.
  final String because;
  ///  Creates a [Untestable].
  const Untestable({required this.because});
}

/// Denotes that the annotated field/function is lazily evaluated.
@Annotation(on: {Kind.field, Kind.function})
const lazy = Object();

enum A {

  b('');

  final String a;

  const A(this.a);

}
