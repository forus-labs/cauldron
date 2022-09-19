import 'package:sugar/core.dart';

abstract class Result<T, F> {

  factory Result.success(T value) => _Success(value);

  factory Result.failure(F failure) => _Failure(failure);

  const Result();


  Success<T, F> get success;

  Failure<T, F> get failure;

}


mixin Success<T, F> {

  bool call();

  bool contains(T value);


  Result<T, F> flat({required Result<T, F> Function(T value) map});

  Result<T, F> map(T Function(T value) function);

  @Possible({StateError})
  T unwrap();

}


void foo(Result<int, String> result) {
  result.success.map((a) => a + 1);
}

class _EmptySuccess<T, F> with Success<T, F> {

   const _EmptySuccess();

  @override
  bool call() => false;

  @override
  bool contains(T value) => false;


  @override
  Result<T, F> flat({required Result<T, F> Function(T value) map}) {
    // TODO: implement flat
    throw UnimplementedError();
  }

  @override
  Result<T, F> map(T Function(T value) function) => this;

  @override
  T unwrap() => throw StateError('Result<$T, $F> does not contain a value, try checking if it contains a value via `Success.call()` first.');

}


mixin Failure<T, F> {

  bool call();

  bool contains(F failure);


  Result<T, F> flat({required Result<T, F> Function(F failure) map});

  Result<T, F> map(F Function(F failure) function);

  @Possible({StateError})
  F unwrap();

}

class _Failure<T, F> extends Result<T, F> with Failure<T, F> {

  final F _failure;

  const _Failure(this._failure);

}

class _EmptyFailure<T, F> extends Result<T, F> with Failure<T, F> {

}
