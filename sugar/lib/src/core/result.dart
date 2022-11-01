import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A monad that represents the result of an operation. A result is always either a [Success] or [Failure].
///
/// Results are an alternative error-handling mechanism to Dart's exception-based mechanism. It is highly inspired by functional
/// programming languages, Rust and Swift.
///
/// See [Maybe] for representing a value and the possible absence thereof.
@sealed abstract class Result<S, F> {

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
  @useResult Result<T, F> map<T>(T Function(S success) function);

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
  @useResult Result<S, T> mapFailure<T>(T Function(F failure) function);


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
  @useResult Result<T, F> bind<T>(Result<T, F> Function(S success) function);

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
  @useResult Result<S, T> bindFailure<T>(Result<S, T> Function(F failure) function);

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
  @useResult Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function);

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
  @useResult Future<Result<S, T>> pipeFailure<T>(Future<Result<S, T>> Function(F failure) function);


  /// Transforms this [Result] into a [Maybe]. [Success] is mapped to [Some], while [Failure] is mapped to [None].
  ///
  /// ```dart
  /// int foo(Result<int, String> result) => result.success.unwrap();
  ///
  /// foo(Success(2)); // 4
  /// ```
  @useResult Maybe<S> get success;

  /// Transforms this [Result] into a [Maybe]. [Failure] is mapped to [Some], while [Success] is mapped to [None].
  ///
  /// ```dart
  /// int foo(Result<int, String> result) => result.failure.unwrap();
  ///
  /// foo(Failure("f")); // "f"
  /// ```
  @useResult Maybe<F> get failure;

}

/// Represents a success.
class Success<S, F> extends Result<S, F> {

  final S _value;
  Maybe<S>? _maybe;

  /// Creates a [Success] with the given value.
  Success(this._value): super._();


  @override
  @useResult Result<T, F> map<T>(T Function(S success) function) => Success(function(_value));

  @override
  @useResult Result<S, T> mapFailure<T>(T Function(F failure) function) => Success(_value);

  @override
  @useResult Result<T, F> bind<T>(Result<T, F> Function(S success) function) => function(_value);

  @override
  @useResult Result<S, T> bindFailure<T>(Result<S, T> Function(F failure) function) => Success(_value);

  @override
  @useResult Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function) => function(_value);

  @override
  @useResult Future<Result<S, T>> pipeFailure<T>(Future<Result<S, T>> Function(F failure) function) async => Success(_value);


  @override
  @useResult Maybe<S> get success => _maybe ??= Some(_value);

  @override
  @useResult Maybe<F> get failure => const None();


  @override
  bool operator ==(Object other) => identical(this, other) || other is Success && Equality.deep(_value, other._value);

  @override
  int get hashCode => HashCodes.deep(_value);

  @override
  String toString() => 'Success($_value)';

}

/// Represents a failure.
class Failure<S, F> extends Result<S, F> {

  final F _value;
  Maybe<F>? _maybe;

  /// Creates a [Failure] with the given value.
  Failure(this._value): super._();


  @override
  @useResult Result<T, F> map<T>(T Function(S success) function) => Failure(_value);

  @override
  @useResult Result<S, T> mapFailure<T>(T Function(F failure) function) => Failure(function(_value));

  @override
  @useResult Result<T, F> bind<T>(Result<T, F> Function(S success) function) => Failure(_value);

  @override
  @useResult Result<S, T> bindFailure<T>(Result<S, T> Function(F failure) function) => function(_value);

  @override
  @useResult Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function) async => Failure(_value);

  @override
  @useResult Future<Result<S, T>> pipeFailure<T>(Future<Result<S, T>> Function(F failure) function) => function(_value);


  @override
  @useResult Maybe<S> get success => const None();

  @override
  @useResult Maybe<F> get failure => _maybe ??= Some(_value);


  @override
  bool operator ==(Object other) => identical(this, other) || other is Failure && Equality.deep(_value, other._value);

  @override
  int get hashCode => HashCodes.deep(_value);

  @override
  String toString() => 'Failure($_value)';

}
