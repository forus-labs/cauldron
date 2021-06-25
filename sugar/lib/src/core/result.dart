import 'package:meta/meta.dart';

/// A monad that represents the result of an operation which may contain a value
/// if successful, or an error otherwise.
abstract class Result<T, E> {

  /// Creates a [Result].
  Result();

  /// Creates a [Result] that represents success.
  factory Result.value(T value) => _Value<T, E>(value);

  /// Creates a [Result] that represents an error.
  factory Result.error(E error) => _Error<T, E>(error);


  /// Returns `true` if this [Result] contains a value.
  bool get present;

  /// Returns `true` if this [Result] does not contain a value.
  bool get notPresent => !present;

  /// Returns `true` if this [Result] contains [value].
  bool contains(T value);

  /// Returns `true` if this [Result] contains [error].
  bool containsError(E error);


  /// Calls the given function if this [Result] contains a value.
  void ifPresent(void Function(T) value);

  /// Calls the given function if this [Result] contains an error.
  void ifError(void Function(E) error);

  /// Returns the value of this [Result]. A [ResultError] is throw if this [Result]
  /// does not contain a value.
  T get value;

  /// Returns the error of this [Result]. A [ResultError] is throw if this [Result]
  /// does not contain an error.
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
  bool get present => true;

  @override
  bool contains(T value) => this.value == value;

  @override
  bool containsError(dynamic error) => false;


  @override
  void ifPresent(void Function(T) value) => value(this.value);

  @override
  void ifError(void Function(E) error) {}


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
  bool get present => false;

  @override
  bool contains(T value) => false;

  @override
  bool containsError(E error) => this.error == error;


  @override
  void ifPresent(void Function(T) value) {}

  @override
  void ifError(void Function(E) error) => error(this.error);


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