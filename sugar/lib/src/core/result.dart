import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A monad that represents the result of an operation. A result is always either a [Success] or [Failure].
///
/// Results are an alternative error-handling mechanism to Dart's exception-based mechanism. It is highly inspired by functional
/// programming languages, Rust and Swift.
///
/// See [Maybe] for representing a value and the possible absence thereof.
mixin Result<S, F> {

  Result<T, F> map<T>(T Function(S success) function);

  Result<S, T> mapFailure<T>(T Function(F failure) function);


  Result<T, F> bind<T>(Result<T, F> Function(S success) function);

  Result<S, T> bindFailure<T>(Result<S, T> Function(F failure) function);


  Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function);

  Future<Result<S, T>> pipeFailure<T>(Future<Result<S, T>> Function(F failure) function);


  /// The namespace for operations that act on a successful result.
  ///
  /// ```dart
  /// int foo(Result<int, String> result) => result.success.unwrap();
  ///
  /// print(foo(Success(2))); // 4
  /// ```
  Value<S> get success;

  /// The namespace for operations that act on a failing result.
  ///
  /// ```dart
  /// int foo(Result<int, String> result) => result.failure.unwrap();
  ///
  /// print(foo(Failure("f"))); // "f"
  /// ```
  Value<F> get failure;

}

/// Represents a success.
@immutable class Success<S, F> extends _Value<S> with Result<S, F> {

  /// Creates a [Success] with the given value.
  const Success(super.value);

  @override
  Result<T, F> map<T>(T Function(S success) function) => Success(function(_value));

  @override
  Result<S, T> mapFailure<T>(T Function(F failure) function) => Success(_value);

  @override
  Result<T, F> bind<T>(Result<T, F> Function(S success) function) => function(_value);

  @override
  Result<S, T> bindFailure<T>(Result<S, T> Function(F failure) function) => Success(_value);

  @override
  Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function) => function(_value);

  @override
  Future<Result<S, T>> pipeFailure<T>(Future<Result<S, T>> Function(F failure) function) async => Success(_value);

  @override
  Value<S> get success => this;

  @override
  Value<F> get failure => const _Empty();


  @override
  bool operator ==(Object other) => identical(this, other) || other is Success && Equality.deep(_value, other._value);

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Success($_value)';

}

/// Represents a failure.
@immutable class Failure<S, F> extends _Value<F> with Result<S, F> {

  /// Creates a [Failure] with the given value.
  const Failure(super.value);

  @override
  Result<T, F> map<T>(T Function(S success) function) => Failure(_value);

  @override
  Result<S, T> mapFailure<T>(T Function(F failure) function) => Failure(function(_value));

  @override
  Result<T, F> bind<T>(Result<T, F> Function(S success) function) => Failure(_value);

  @override
  Result<S, T> bindFailure<T>(Result<S, T> Function(F failure) function) => function(_value);

  @override
  Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function) async => Failure(_value);

  @override
  Future<Result<S, T>> pipeFailure<T>(Future<Result<S, T>> Function(F failure) function) => function(_value);

  @override
  Value<S> get success => const _Empty();

  @override
  Value<F> get failure => this;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Failure && runtimeType == other.runtimeType;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() => 'Failure($_value)';
}


/// Provides functions for working with [Value] where the value is non-nullable.
extension NonNullableValue<T extends Object> on Value<T> {

  /// If a value is present, returns the value, otherwise returns [None].
  ///
  /// ```dart
  /// final Result<String, int> result = Failure(404);
  /// final foo = result.success.nullable ?? 'value';
  /// print(foo); // 'value'
  /// ```
  T? get nullable => call() ? unwrap() : null;

}

/// This class defines common functions implemented by a [Result] for working with a [Result]'s value. Like [Result],
/// a [Value] is always either a [Success] or [Failure].
@sealed abstract class Value<T> {

  /// Creates a [Value].
  const Value();

  /// Returns true iof this [Value] contains a value.
  ///
  /// See [callable classes](https://dart.dev/guides/language/language-tour#callable-classes) for more information.
  ///
  /// ```dart
  /// print( Success('')()); // true
  /// ```
  bool call();

  /// Returns true if this [Value] contains the give value.
  ///
  /// ```dart
  /// print(Success('something').contains('something')); // true
  /// ```
  bool contains(T value);

  /// If a value is present, returns the value, otherwise throws a [StateError].
  ///
  /// ```dart
  /// final foo = Success('something');
  /// print(foo.success.unwrap()); // 'something'
  ///
  /// final bar = Failure(404);
  /// print(bar.success.unwrap()); // throws a StateError
  /// ```
  @Possible({StateError})
  T unwrap();

}

class _Value<T> extends Value<T> {
  final T _value;

  const _Value(this._value);

  @override
  bool call() => true;

  @override
  bool contains(T value) => Equality.deep(value, _value);

  @override
  T unwrap() => _value;

}

class _Empty<T> extends Value<T> {
  const _Empty();

  @override
  bool call() => false;

  @override
  bool contains(T value) => false;

  @override
  T unwrap() => throw StateError('Value does not exist. Try checking if it exists first.');

}
