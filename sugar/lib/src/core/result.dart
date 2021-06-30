import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A monad that represents the result of an operation which may contain a value
/// if successful, or an error otherwise.
abstract class Result<T, E> {

  /// Creates a [Result].
  Result();

  /// Creates a [Result] that represents success.
  factory Result.value(T value) => _Value<T, E>(value);

  /// Creates a [Result] that represents failure.
  factory Result.error(E error) => _Error<T, E>(error);


  /// Returns `true` if this [Result] is successful.
  bool get successful;

  /// Returns `true` if this [Result] is not successful.
  bool get failure => !successful;

  /// Returns `true` if this [Result] contains [value].
  bool contains(T value);

  /// Returns `true` if this [Result] contains [error].
  bool containsError(E error);


  /// Calls the given function if this [Result] contains a value.
  void ifSuccessful(void Function(T) value);

  /// Calls the given function if this [Result] contains an error.
  void ifFailure(void Function(E) error);

  /// Returns the value of this [Result]. A [ResultError] is throw if this [Result]
  /// does not contain a value.
  @Throws([ResultError])
  T get value;

  /// Returns the error of this [Result]. A [ResultError] is throw if this [Result]
  /// does not contain an error.
  @Throws([ResultError])
  E get error;

  /// Returns the value of this [Result], or [defaultValue] if [Result] does not
  /// contain a value.
  T unwrap(T defaultValue);

  /// Returns the error of this [Result], or [defaultError] if [Result] does not
  /// contain an error.
  E unwrapError(E defaultError);

}

@immutable class _Value<T, E> extends Result<T, E> {

  @override
  final T value;

  _Value(this.value);


  @override
  bool get successful => true;

  @override
  bool contains(T value) => this.value == value;

  @override
  bool containsError(dynamic error) => false;


  @override
  void ifSuccessful(void Function(T) value) => value(this.value);

  @override
  void ifFailure(void Function(E) error) {}


  @override
  E get error => throw ResultError('Result does not contain an error');

  @override
  T unwrap(T defaultValue) => value;

  @override
  E unwrapError(E defaultError) => defaultError;

}

@immutable class _Error<T, E> extends Result<T, E> {

  @override
  final E error;

  _Error(this.error);


  @override
  bool get successful => false;

  @override
  bool contains(T value) => false;

  @override
  bool containsError(E error) => this.error == error;


  @override
  void ifSuccessful(void Function(T) value) {}

  @override
  void ifFailure(void Function(E) error) => error(this.error);


  @override
  T get value => throw ResultError('Result does not contain a value');

  @override
  T unwrap(T defaultValue) => defaultValue;

  @override
  E unwrapError(E defaultError) => error;

}


/// Signals that an error has occurred while manipulating a [Result].
class ResultError extends Error {

  /// The message.
  final String message;

  /// Creates a [ResultError] with the given message.
  ResultError(this.message);

  @override
  String toString() => message;

}