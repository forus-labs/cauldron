import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

abstract class Union<L, R> with Equality {

  Union();

  factory Union.left(L left) => _Left(left);

  factory Union.right(R right) => _Right(right);

  T map<T>(T Function(L) left, T Function(R) right);

  dynamic get value;

  bool get left;

  bool get right;

  @override
  @protected List<dynamic> get fields => [value];

}

@immutable class _Left<L, R> extends Union<L, R> {

  @override
  final L value;

  _Left(this.value);

  @override
  T map<T>(T Function(L) left, T Function(R) right) => left(value);

  @override
  bool get left => true;

  @override
  bool get right => false;

}

@immutable class _Right<L, R> extends Union<L, R> {

  @override
  final R value;

  _Right(this.value);

  @override
  T map<T>(T Function(L) left, T Function(R) right) => right(value);

  @override
  bool get left => false;

  @override
  bool get right => true;

}