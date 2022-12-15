import 'package:meta/meta.dart';
import 'package:sugar/collection.dart';

/// Provides aggregate functions for [Iterable]s.
extension AggregateIterable<E> on Iterable<E> {

  /// Computes the average of all values returned by the given [function]. [double.nan] will always be returned if this
  /// [Iterable] is empty, or [double.nan] is present.
  ///
  /// ```dart
  /// class Foo {
  ///   final int value;
  ///
  ///   Foo(this.value);
  /// }
  ///
  /// [Foo(1), Foo(2), Foo(3)].average((foo) => foo.value); // 2
  /// ```
  ///
  /// ### Implementation details:
  /// This implementation assumes that computing each number is inexpensive. Under this assumption, it is more beneficial
  /// to recompute each value than maintain a map/list of numbers.
  @useResult double average(num Function(E element) function) => sum(function) / length;

  /// Computes the sum of values returned by the given [function], starting with the given initial value. The initial value
  /// is 0 if unspecified. [double.nan] will always be returned if present.
  ///
  /// ```dart
  /// class Foo {
  ///   final int value;
  ///
  ///   Foo(this.value);
  /// }
  ///
  /// [Foo(1), Foo(2), Foo(3)].sum((foo) => foo.value, initial: 5); // 11
  /// ```
  ///
  /// ### Implementation details:
  /// This implementation assumes that computing each [R] is inexpensive. Under this assumption, it is more beneficial
  /// to recompute each value than maintain a map/list of [R]s.
  @useResult R sum<R extends num>(R Function(E element) function, {R? initial}) {
    var sum = initial ?? 0;
    for (final element in this) {
      sum += function(element);
    }

    // Dart is fucking stupid for not allowing implicit conversions between integers and doubles.
    return (R == int ? sum.toInt() : sum.toDouble()) as R;
  }

}


/// Provides aggregate functions for [Iterable]s of [Comparable]s.
///
/// See also [OrderableIterable] for ordering types that don't extend [Comparable].
extension AggregateComparableIterable<E extends Comparable<Object>> on Iterable<E> {

  /// The smallest element in this [Iterable] or `null` if empty.
  ///
  /// ```dart
  /// ['a', 'b', 'c'].min; // 'a'
  /// ```
  @useResult E? get min {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }

    var min = iterator.current;
    while (iterator.moveNext()) {
      final element = iterator.current;
      if (min.compareTo(element) > 0) {
        min = element;
      }
    }

    return min;
  }

  /// The largest element in this [Iterable] or `null` if empty.
  ///
  /// ```dart
  /// ['a', 'b', 'c'].min; // 'c'
  /// ```
  @useResult E? get max {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }

    var max = iterator.current;
    while (iterator.moveNext()) {
      final element = iterator.current;
      if (max.compareTo(element) < 0) {
        max = element;
      }
    }

    return max;
  }

}

/// Provides aggregate functions for [Iterable]s of [num]s.
///
/// This is a specialized version of [AggregateIterable] since [num]s require special handling of [double.nan].
extension AggregateNumberIterable<E extends num> on Iterable<E> {

  /// The average of all elements in this [Iterable], or [double.nan] if empty.
  ///
  /// ```dart
  /// [1, 2, 3].average; // 2.0
  /// ```
  @useResult double get average => sum / length;

  /// The sum of all elements in this [Iterable]. [double.nan] will always be returned if present in this [Iterable].
  ///
  /// ```dart
  /// [1, 2, 3].sum; // 6
  /// ```
  @useResult E get sum {
    num sum = 0;
    for (final element in this) {
      sum += element;
    }

    // Dart is fucking stupid for not allowing implicit conversions between integers and doubles.
    return (E == int ? sum.toInt() : sum.toDouble()) as E;
  }


  /// The smallest element in this [Iterable] or `null` if empty. [double.nan] will always be returned if present in this
  /// [Iterable].
  ///
  /// ```dart
  /// [1, 2, 3].min; // 1
  ///
  /// [1, 2, double.nan]; // double.nan
  /// ```
  @useResult E? get min {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }

    var min = iterator.current;
    if (min.isNaN) {
      return min;
    }

    while (iterator.moveNext()) {
      final element = iterator.current;
      if (element.isNaN) {
        return element;
      }

      if (min.compareTo(element) > 0) {
        min = element;
      }
    }

    return min;
  }

  /// The smallest element in this [Iterable] or `null` if empty. [double.nan] will always be returned if present in this
  /// [Iterable].
  ///
  /// ```dart
  /// [1, 2, 3].max; // 3
  ///
  /// [1, 2, double.nan].max; // double.nan
  /// ```
  @useResult E? get max {
    final iterator = this.iterator;
    if (!iterator.moveNext()) {
      return null;
    }

    var max = iterator.current;
    if (max.isNaN) {
      return max;
    }

    while (iterator.moveNext()) {
      final element = iterator.current;
      if (element.isNaN) {
        return element;
      }

      if (max.compareTo(element) < 0) {
        max = element;
      }
    }

    return max;
  }

}
