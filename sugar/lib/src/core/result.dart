import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A monad that represents the result of an operation. A result is always either a [Success] or [Failure].
///
/// Results are an alternative error-handling mechanism to Dart's exception-based mechanism. It is highly inspired by functional
/// programming languages, Rust and Swift.
///
/// See [Maybe] for representing a value and the possible absence thereof.
@sealed abstract class Result<S extends Object, F extends Object> {

  static void _nothing(Object? value) {}

  /// Creates a [Result] by executing the given function that may throw an exception.
  ///
  /// If the function executes successfully, creates a [Success] that contains the function's [S].
  /// Otherwise returns a [Failure] that contains the [Exception] thrown by the given function.
  ///
  /// Conversion of thrown [Error]s into [Result]s is intentionally avoided. This is because an [Error]
  /// represent a failure that the programmer should have avoided.
  ///
  /// ```dart
  /// Result.of(throwing: () => 1)); // Success(1);
  ///
  /// Result.of(throwing: () => throws ArgumentError)); // Failure(ArgumentError);
  /// ```
  static Result<S, F> of<S extends Object, F extends Exception>({required Supply<S> throwing}) {
    try {
      return Success(throwing());

    } on F catch (e) {
      return Failure(e);
    }
  }

  const Result._();


  /// If this [Result] is a [Success], produces a [Success] that contains a [T]. Otherwise returns a [Failure] with its [F]
  /// untouched.
  ///
  /// A [T] is produced by applying the given function on this [Result]'s [S].
  ///
  /// ```dart
  /// Success(1).map((value) => value.toString()); // Success('1')
  ///
  /// Failure(2).map((value) => value.toString()); // Failure(2)
  /// ```
  @useResult Result<T, F> map<T extends Object>(T Function(S success) function);

  /// If this [Result] is a [Failure], produces a [Failure] that contains a [T]. Otherwise returns a [Success] with its [S]
  /// untouched.
  ///
  /// A [T] is produced by applying the given function on this [Result]'s [F].
  ///
  /// ```dart
  /// Success(1).mapFailure((value) => value.toString()); // Success(1)
  ///
  /// Failure(2).mapFailure((value) => value.toString()); // Failure('2')
  /// ```
  @useResult Result<S, T> mapFailure<T extends Object>(T Function(F failure) function);


  /// If this [Result] is a [Success], return a [Result] produced by the give function. Otherwise returns a [Failure] with
  /// its [F] untouched.
  ///
  /// See [pipe] for an asynchronous variant of this function.
  ///
  /// ```dart
  /// Success(1).bind((value) => Failure(value.toString())); // Failure('1')
  ///
  /// Failure(2).bind((value) => Failure(value.toString())); // Failure(2)
  /// ```
  @useResult Result<T, F> bind<T extends Object>(Result<T, F> Function(S success) function);

  /// If this [Result] is a [Failure], return a [Result] produced by the give function. Otherwise returns a [Success] with
  /// its [S] untouched.
  ///
  /// See [pipeFailure] for an asynchronous variant of this function.
  ///
  /// ```dart
  /// Success(1).bindFailure((value) => Failure(value.toString())); // Success(1)
  ///
  /// Failure(2).bindFailure((value) => Success(value.toString())); // Success('2')
  /// ```
  @useResult Result<S, T> bindFailure<T extends Object>(Result<S, T> Function(F failure) function);

  /// If this [Result] is a [Success], return a [Result] produced by the give function. Otherwise returns a [Failure] with
  /// its [F] untouched.
  ///
  /// See [bind] for a synchronous variant of this function.
  ///
  /// ```dart
  /// Success(1).pipe((value) async => Failure(value.toString())); // Failure('1')
  ///
  /// Failure(2).pipe((value) async => Failure(value.toString())); // Failure(2)
  /// ```
  @useResult Future<Result<T, F>> pipe<T extends Object>(Future<Result<T, F>> Function(S success) function);

  /// If this [Result] is a [Failure], return a [Result] produced by the give function. Otherwise returns a [Success] with
  /// its [S] untouched.
  ///
  /// See [bindFailure] for a synchronous variant of this function.
  ///
  /// ```dart
  /// Success(1).pipeFailure((value) async => Failure(value.toString())); // Success(1)
  ///
  /// Failure(2).pipeFailure((value) async => Success(value.toString())); // Success('2')
  /// ```
  @useResult Future<Result<S, T>> pipeFailure<T extends Object>(Future<Result<S, T>> Function(F failure) function);


  /// If this [Result] is a [Success], calls [success], otherwise calls [failure]. By default, [success] and [failure]
  /// does nothing.
  ///
  /// ```dart
  /// Success('s').when(success: print, failure: print); // 's'
  ///
  /// Failure('f').when(success: print, failure: print); // 'f'
  /// ```
  void when({Consume<S> success = _nothing, Consume<F> failure = _nothing});


  /// Transforms this [Result] into a [Maybe]. [Success] is mapped to non-nullable [S], while [Failure] is mapped to `null`.
  ///
  /// ```dart
  /// int foo(Result<int, String> result) => result.success!;
  ///
  /// foo(2); // 4
  /// ```
  @useResult S? get success;

  /// Transforms this [Result] into a [Maybe]. [Failure] is mapped to a non-nullable [F], while [Success] is mapped to `null`.
  ///
  /// ```dart
  /// int foo(Result<int, String> result) => result.failure!;
  ///
  /// foo('f'); // 'f'
  /// ```
  @useResult F? get failure;

}

/// Represents a success.
class Success<S extends Object, F extends Object> extends Result<S, F> {

  @override
  final S success;

  /// Creates a [Success] with the given value.
  const Success(this.success): super._();


  @override
  @useResult Result<T, F> map<T extends Object>(T Function(S success) function) => Success(function(success));

  @override
  @useResult Result<S, T> mapFailure<T extends Object>(T Function(F failure) function) => Success(success);

  @override
  @useResult Result<T, F> bind<T extends Object>(Result<T, F> Function(S success) function) => function(success);

  @override
  @useResult Result<S, T> bindFailure<T extends Object>(Result<S, T> Function(F failure) function) => Success(success);

  @override
  @useResult Future<Result<T, F>> pipe<T extends Object>(Future<Result<T, F>> Function(S success) function) => function(success);

  @override
  @useResult Future<Result<S, T>> pipeFailure<T extends Object>(Future<Result<S, T>> Function(F failure) function) async => Success(success);


  @override
  void when({Consume<S> success = Result._nothing, Consume<F> failure = Result._nothing}) => success(this.success);

  @override
  @useResult Null get failure => null;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Success && Equality.deep(success, other.success);

  @override
  int get hashCode => HashCodes.deep(success);

  @override
  String toString() => 'Success($success)';

}

/// Represents a failure.
class Failure<S extends Object, F extends Object> extends Result<S, F> {

  @override
  final F failure;

  /// Creates a [Failure] with the given value.
  const Failure(this.failure): super._();


  @override
  @useResult Result<T, F> map<T extends Object>(T Function(S success) function) => Failure(failure);

  @override
  @useResult Result<S, T> mapFailure<T extends Object>(T Function(F failure) function) => Failure(function(failure));

  @override
  @useResult Result<T, F> bind<T extends Object>(Result<T, F> Function(S success) function) => Failure(failure);

  @override
  @useResult Result<S, T> bindFailure<T extends Object>(Result<S, T> Function(F failure) function) => function(failure);

  @override
  @useResult Future<Result<T, F>> pipe<T extends Object>(Future<Result<T, F>> Function(S success) function) async => Failure(failure);

  @override
  @useResult Future<Result<S, T>> pipeFailure<T extends Object>(Future<Result<S, T>> Function(F failure) function) => function(failure);


  @override
  void when({Consume<S> success = Result._nothing, Consume<F> failure = Result._nothing}) => failure(this.failure);

  @override
  @useResult Null get success => null;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Failure && Equality.deep(failure, other.failure);

  @override
  int get hashCode => HashCodes.deep(failure);

  @override
  String toString() => 'Failure($failure)';

}
