import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A monad that represents a union type.
abstract class Union<L, R> with Equality {

  /// Creates a [Union].
  Union();

  /// Creates a [Union] with the given value of type [L].
  factory Union.left(L left) => _Left(left);

  /// Creates a [Union] with the given value of type [R].
  factory Union.right(R right) => _Right(right);

  /// Maps the value of this [Union] using [left] if the value is of type [L], or
  /// [right] if the value is of type [R].
  T map<T>(T Function(L) left, T Function(R) right);

  /// The value of this [Union].
  dynamic get value;

  /// Returns `true` if this [Union] contains a value which type is [L].
  bool get left;

  /// Returns `true` if this [Union] contains a value which type is [R].
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