import 'package:meta/meta.dart';

/// Thrown when an exceptional arithmetic condition has occurred.
class ArithmeticException implements Exception {

  /// The message.
  final String message;

  /// Creates a [ArithmeticException] with an optional message.
  ArithmeticException([this.message = "''"]);

  @override
  @useResult String toString() => 'ArithmeticException: $message';

}
