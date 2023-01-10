import 'package:meta/meta.dart';

/// Thrown when an exceptional arithmetic condition has occurred. For example, an [ArithmeticException] is thrown when
/// an integer overflow occurs in certain operations in `sugar.math`.
class ArithmeticException implements Exception {

  /// The message.
  final String message;

  /// Creates a [ArithmeticException] with an optional message.
  ArithmeticException([this.message = "''"]);

  @override
  @useResult String toString() => 'ArithmeticException: $message';

}
