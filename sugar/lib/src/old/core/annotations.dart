
import 'package:meta/meta.dart';

/// Denotes that the annotated type is an annotation.
@annotation
const String annotation = 'annotation';

/// Denotes that the annotated type/method is untestable.
@annotation
const String untestable = 'untestable';

/// Denotes that the annotated method throws an exception.
@annotation
const String throws = 'throws';

/// Denotes that an annotated method throws the given exceptions.
@annotation
@sealed class Throws {
  /// Creates a [Throws] with the given exceptions.
  const Throws(List<Type> thrown); // ignore: avoid_unused_constructor_parameters
}

/// Denotes that an annotated type is platform dependent
@annotation
class PlatformDependent {
  /// Creates a [PlatformDependent] with the given platforms.
  const PlatformDependent(String platforms); // ignore: avoid_unused_constructor_parameters
}

/// Denotes that an annotated function returns a union type. A union type represents
/// a subset of possible values.
@annotation
@sealed class Subset<T> {
  /// Creates a [Subset] with the given possible values.
  const Subset(List<T> values); // ignore: avoid_unused_constructor_parameters
}

BiIterable
