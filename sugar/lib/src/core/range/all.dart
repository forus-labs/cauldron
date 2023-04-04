import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// An [All] represents a convex (contiguous) portion of a domain unbounded on both ends, i.e. `{ x | x }`.
@internal class All<T extends Comparable<Object?>> extends Range<T> {
  @override
  bool besides(Range<T> other) => false;

  @override
  bool contains(T value) => true;

  @override
  bool encloses(Range<T> other) => true;

  @override
  Interval<T>? gap(Range<T> other) => null;

  @override
  Range<T>? intersection(Range<T> other) => other;

  @override
  bool intersects(Range<T> other) => true;

  @override
  bool get empty => false;

  @override
  bool operator ==(Object other) => identical(this, other) || other is All && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => '(-∞..+∞)';
}
