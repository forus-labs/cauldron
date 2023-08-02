import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// A [Result] represents the result of an operation. It is a [Success] or [Failure].
///
/// Results are an alternative error-handling mechanism to exceptions. It is inspired by other languages such as Rust
/// and Swift.
///
/// To represent a success:
/// ```dart
/// Result<String, int> httpGet() {
///   if (successful) return Success('HTTP body in plain text');
/// }
///```
///
/// To represent a failure:
/// ```dart
/// Result<String, int> httpGet() {
///   if (notFound) return Failure(404);
/// }
/// ```
///
/// You can also perform pattern matching on a `Result`.
/// ```dart
/// void handle() {
///   switch (httpGet()) {
///     case Success(:final success):
///       // handle success
///     case Failure(:final failure):
///       // handle failure
///   }
/// }
/// ```
sealed class Result<S extends Object, F extends Object> {

  static void _nothing(Object? value) {}

  /// Wraps [throwing], which may throw an exception, in a [Result].
  ///
  /// Returns a [Success] if [throwing] executes successfully. Otherwise returns a [Failure] that contains the exception
  /// thrown.
  ///
  /// Errors are intentionally uncaught since they represent programmatic errors.
  ///
  /// ```dart
  /// Result.of(() => 1)); // Success(1);
  ///
  /// Result.of(() => throws FooException())); // Failure(FooException());
  /// ```
  static Result<S, F> of<S extends Object, F extends Exception>(Supply<S> throwing) {
    try {
      return Success(throwing());

    } on F catch (e) {
      return Failure(e);
    }
  }

  const Result._();


  /// If this is a `Success`, maps [S] to [T], otherwise returns [F] untouched.
  ///
  /// ```dart
  /// Success(1).map((v) => v.toString()); // Success('1')
  ///
  /// Failure(2).map((v) => v.toString()); // Failure(2)
  /// ```
  @useResult Result<T, F> map<T extends Object>(T Function(S success) function);

  /// If this is a `Failure`, maps [F] to [T], otherwise returns [S] untouched.
  ///
  /// ```dart
  /// Success(1).mapFailure((v) => v.toString()); // Success(1)
  ///
  /// Failure(2).mapFailure((v) => v.toString()); // Failure('2')
  /// ```
  @useResult Result<S, T> mapFailure<T extends Object>(T Function(F failure) function);


  /// If this is a `Success`, maps [S] to [Result], otherwise returns [F] untouched.
  ///
  /// See [pipe] for an asynchronous variant of this function.
  ///
  /// ```dart
  /// Success(1).bind((v) => Failure(v.toString())); // Failure('1')
  ///
  /// Failure(2).bind((v) => Failure(v.toString())); // Failure(2)
  /// ```
  @useResult Result<T, F> bind<T extends Object>(Result<T, F> Function(S success) function);

  /// If this is a `Failure`, maps [F] to [Result], otherwise returns [S] untouched.
  ///
  /// See [pipeFailure] for an asynchronous variant of this function.
  ///
  /// ```dart
  /// Success(1).bindFailure((v) => Failure(v.toString())); // Success(1)
  ///
  /// Failure(2).bindFailure((v) => Success(v.toString())); // Success('2')
  /// ```
  @useResult Result<S, T> bindFailure<T extends Object>(Result<S, T> Function(F failure) function);

  /// If this is a `Success`, asynchronously maps [S] to [Result], otherwise returns [F] untouched.
  ///
  /// See [bind] for a synchronous variant of this function.
  ///
  /// ```dart
  /// Future<String> stringifyAsync(int value) async => Failure(v.toString());
  ///
  /// Success(1).pipe(stringifyAsync); // Failure('1')
  ///
  /// Failure(2).pipe(stringifyAsync); // Failure(2)
  /// ```
  @useResult Future<Result<T, F>> pipe<T extends Object>(Future<Result<T, F>> Function(S success) function);

  /// If this is a `Failure`, asynchronously maps [F] to [Result], otherwise returns [S] untouched.
  ///
  /// See [bindFailure] for a synchronous variant of this function.
  ///
  /// ```dart
  /// Future<String> stringifyAsync(int value) async => Success(v.toString());
  ///
  /// Success(1).pipeFailure(stringifyAsync); // Success(1)
  ///
  /// Failure(2).pipeFailure(stringifyAsync); // Success('2')
  /// ```
  @useResult Future<Result<S, T>> pipeFailure<T extends Object>(Future<Result<S, T>> Function(F failure) function);


  /// Calls [success] if this is a `Success`, or [failure] if this is a `Failure`.
  ///
  /// ```dart
  /// Success('s').when(success: print); // 's'
  ///
  /// Failure('f').when(success: print); // nothing
  /// ```
  void when({Consume<S> success = _nothing, Consume<F> failure = _nothing});


  /// The value if this is a `Success` or `null` otherwise.
  ///
  /// ```dart
  /// Success(2).success; // 2
  ///
  /// Failure(2).success; // null
  /// ```
  @useResult S? get success;

  /// The value if this is a `Failure` or `null` otherwise.
  ///
  /// ```dart
  /// Success(2).failure; // null
  ///
  /// Failure(2).failure; // 2
  /// ```
  @useResult F? get failure;

}

/// Represents a success.
final class Success<S extends Object, F extends Object> extends Result<S, F> {

  @override
  final S success;

  /// Creates a [Success].
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
final class Failure<S extends Object, F extends Object> extends Result<S, F> {

  @override
  final F failure;

  /// Creates a [Failure].
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
