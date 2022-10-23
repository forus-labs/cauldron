import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A monad that represents the result of an operation. A result is always either a [Success] or [Failure].
///
/// Results are an alternative error-handling mechanism to Dart's exception-based mechanism. It is highly inspired by functional
/// programming languages, Rust and Swift.
///
/// See [Maybe] for representing a value and the possible absence thereof.
@sealed abstract class Result<S, F> {

  Result<A, F> bind<A>(A Function(S) f);

  Result<S, A> bindFailure<A>(A Function(F) f);



}

/// This class defines common functions implemented by a [Result] for working with a [Result]'s value. Like [Result],
/// a [Value] is always either a [Success] or [Failure].
@sealed abstract class Value<T> {

  /// Returns true iof this [Value] contains a value.
  ///
  /// See [callable classes](https://dart.dev/guides/language/language-tour#callable-classes) for more information.
  ///
  /// ```dart
  /// final Result<String, int> result = Success('');
  /// print(result.success()); // true
  /// ```
  bool call();

  /// Returns true if this [Value] contains the give value.
  ///
  /// ```dart
  /// final result = Success('something');
  /// print(result.success.contains('something'); // true
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

/// Represents a success.
abstract class Success<S, F> extends Value<S> implements Result<S, F> {

  /// Unwraps the given future and creates a [Success] withe the given [future]'s value.
  static Future<Success<S, F>> of<S, F>(Future<S> future) async => Success(await future);

  /// Creates a [Success] which contains the given value.
  factory Success(S success) => _Success(success);

  Success._();

  /// If a [Success], return a [Result] that contains [T]. The returned [Result] is created by applying the given function
  /// on this [Success]'s value. Otherwise returns a [Failure] with its value untouched.
  ///
  /// See [pipe] for an asynchronous alternative to this function.
  ///
  /// ```dart
  /// final foo = Success(1);
  /// final mappedFoo = foo.success.bind((value) => Failure(value.toString()));
  ///
  /// print(mappedFoo.failure.unwrap()); // '1'
  ///
  /// final bar = Failure('something went wrong');
  /// final mappedBar = bar.success.bind((value) => Failure(value.toString()));
  ///
  /// print(mappedFoo.failure.unwrap()); // 'something went wrong'
  /// ```
  Result<T, F> bind<T>(Result<T, F> Function(S success) function);

  /// If a [Success], produces a [Success] that contains [T]. [T] is derived by applying the given function on this [Success]'s value.
  /// Otherwise returns a [Failure] with its value untouched.
  ///
  /// ```dart
  /// final foo = Success(1);
  /// final mappedFoo = foo.success.map((value) => value.toString());
  ///
  /// print(mappedFoo.success.unwrap()); // '1'
  ///
  /// final bar = Failure('something went wrong');
  /// final mappedBar = bar.success.map((value) => value.toString());
  ///
  /// print(mappedBar.success()); // false
  /// print(mappedBar.failure.unwrap()); // 'something went wrong'
  /// ```
  Result<T, F> map<T> (T Function(S success) function);

  /// If a [Success], return a [Result] that contains [T]. The returned [Result] is created by applying the given async function
  /// on this [Success]'s value. Otherwise returns a [Failure] with its value untouched.
  ///
  /// See [bind] for an synchronous alternative to this function.
  ///
  /// ```dart
  /// Future<String> compute(int value) => Future.value(value.toString());
  ///
  /// final foo = Success(1);
  /// final mappedFoo = await foo.success.pipe((value) => Failure(compute(value)));
  ///
  /// print(mappedFoo.failure.unwrap()); // '1'
  ///
  /// final bar = Failure('something went wrong');
  /// final mappedBar = await bar.success.pipe((value) => Failure(compute(value));
  ///
  /// print(mappedFoo.failure.unwrap()); // 'something went wrong'
  /// ```
  Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function);

}

/// Represents a failure.
abstract class Failure<S, F> extends Value<F> implements Result<S, F> {

  /// Unwraps the given future and creates a [Failure] withe the given [future]'s value.
  static Future<Failure<S, F>> of<S, F>(Future<F> future) async => Failure(await future);

  /// Creates a [Failure] which contains the given value.
  factory Failure(F failure) => _Failure(failure);

  Failure._();

  /// If a [Failure], return a [Result] that contains [T]. The returned [Result] is created by applying the given function
  /// on this [Failure]'s value. Otherwise returns a [Success] with its value untouched.
  ///
  /// See [pipe] for an asynchronous alternative to this function.
  ///
  /// ```dart
  /// final foo = Failure(1);
  /// final mappedFoo = foo.failure.bind((value) => Success(value.toString()));
  ///
  /// print(mappedFoo.success.unwrap()); // '1'
  ///
  /// final bar = Success('something went right');
  /// final mappedBar = bar.failure.bind((value) => Success(value.toString()));
  ///
  /// print(mappedFoo.success.unwrap()); // 'something went right'
  /// ```
  Result<S, T> bind<T>(Result<S, T> Function(F failure) function);

  /// If a [Failure], produces a [Failure] that contains [T]. [T] is derived by applying the given function on this [Failure]'s value.
  /// Otherwise returns a [Success] with its value untouched.
  ///
  /// ```dart
  /// final foo = Failure(1);
  /// final mappedFoo = foo.failure.map((value) => value.toString());
  ///
  /// print(mappedFoo.failure.unwrap()); // '1'
  ///
  /// final bar = Success('something went right');
  /// final mappedBar = bar.failure.map((value) => value.toString());
  ///
  /// print(mappedBar.failure()); // false
  /// print(mappedBar.success.unwrap()); // 'something went right'
  /// ```
  Result<S, T> map<T> (T Function(F failure) function);

  /// If a [Failure], return a [Result] that contains [T]. The returned [Result] is created by applying the given async function
  /// on this [Failure]'s value. Otherwise returns a [Success] with its value untouched.
  ///
  /// See [bind] for an synchronous alternative to this function.
  ///
  /// ```dart
  /// Future<String> compute(int value) => Future.value(value.toString());
  ///
  /// final foo = Failure(1);
  /// final mappedFoo = await foo.failure.pipe((value) => Success(compute(value)));
  ///
  /// print(mappedFoo.success.unwrap()); // '1'
  ///
  /// final bar = Success('something went right');
  /// final mappedBar = await bar.failure.pipe((value) => Success(compute(value));
  ///
  /// print(mappedFoo.success.unwrap()); // 'something went right'
  /// ```
  Future<Result<S, T>> pipe<T>(Future<Result<S, T>> Function(F failure) function);

}


class _Success<S, F> extends Success<S, F> {
  final S _value;
  final _EmptyFailure<S, F> _failure;

  _Success(this._value): _failure = _EmptyFailure(), super._() {
    _failure._success = this;
  }

  @override
  bool call() => true;

  @override
  bool contains(S value) => Equality.deep(_value, value);

  @override
  Result<T, F> bind<T>(Result<T, F> Function(S success) function) => function(_value);

  @override
  Result<T, F> map<T>(T Function(S success) function) => _Success(function(_value));

  @override
  Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function) => function(_value);

  @override
  @Possible({StateError})
  S unwrap() => _value;

  @override
  Success<S, F> get success => this;

  @override
  Failure<S, F> get failure => _failure;
}

class _EmptyFailure<S, F> extends Failure<S, F> {
  late final _Success<S, F> _success;

  _EmptyFailure(): super._();

  @override
  bool call() => false;

  @override
  bool contains(F value) => false;

  @override
  Result<S, T> bind<T>(Result<S, T> Function(F failure) function) => _Success(_success._value);

  @override
  Result<S, T> map<T>(T Function(F failure) function) => _Success(_success._value);

  @override
  Future<Result<S, T>> pipe<T>(Future<Result<S, T>> Function(F failure) function) => Future.value(_Success(_success._value));

  @override
  F unwrap() => throw StateError('Result<$S, $F> is not a failure. Try checking if it is a failure first.');

  @override
  Success<S, F> get success => _success;

  @override
  Failure<S, F> get failure => this;

  @override
  bool operator ==(Object other) => identical(this, other) || other is _EmptyFailure && runtimeType == other.runtimeType && _success == other._success;

  @override
  int get hashCode => _success.hashCode;
}


class _Failure<S, F> extends Failure<S, F> {
  final F _value;
  final _EmptySuccess<S, F> _success;

  _Failure(this._value): _success = _EmptySuccess(), super._() {
    _success._failure = this;
  }

  @override
  bool call() => true;

  @override
  bool contains(F value) => Equality.deep(_value, value);

  @override
  Result<S, T> bind<T>(Result<S, T> Function(F failure) function) => function(_value);

  @override
  Result<S, T> map<T>(T Function(F failure) function) => _Failure(function(_value));

  @override
  Future<Result<S, T>> pipe<T>(Future<Result<S, T>> Function(F failure) function) => function(_value);

  @override
  F unwrap() => _value;

  @override
  Success<S, F> get success => _success;

  @override
  Failure<S, F> get failure => this;
}

class _EmptySuccess<S, F> extends Success<S, F> {
  late final _Failure<S, F> _failure;

  _EmptySuccess(): super._();

  @override
  bool call() => false;

  @override
  bool contains(S value) => false;

  @override
  Result<T, F> bind<T>(Result<T, F> Function(S success) function) => _Failure(_failure._value);

  @override
  Result<T, F> map<T>(T Function(S success) function) => _Failure(_failure._value);

  @override
  Future<Result<T, F>> pipe<T>(Future<Result<T, F>> Function(S success) function) => Future.value(_Failure(_failure._value));

  @override
  S unwrap() => throw StateError('Result<$S, $F> is not a success. Try checking if it is a success first.');

  @override
  Success<S, F> get success => this;

  @override
  Failure<S, F> get failure => _failure;
}
