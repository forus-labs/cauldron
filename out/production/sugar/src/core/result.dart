import 'package:meta/meta.dart';

abstract class Result<T, E> {

  Result();

  factory Result.value(T value) => _Value<T, E>(value);

  factory Result.error(E error) => _Error<T, E>(error);


  bool get present;

  bool get notPresent => !present;

  bool contains(T value);

  bool containsError(E error);


  void ifPresent(void Function(T) value);

  void ifError(void Function(E) error);

  T get value;

  E get error;

  T unwrap(T defaultValue);

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


class ResultError extends Error {

  final String message;

  ResultError(this.message);

  @override
  String toString() => message;

}



