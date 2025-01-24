import 'package:meta/meta.dart';

import 'package:sugar/collection_aggregate.dart';
import 'package:sugar/core.dart';

/// Provides aggregate functions, such as [average] and [sum], for [Iterable]s.
extension AggregateIterable<E> on Iterable<E> {
  /// Computes the average of all values. Values are created from this iterable's elements using [select].
  ///
  /// Returns [double.nan] if empty, or if [select] returns [double.nan].
  ///
  /// ## Example
  /// ```dart
  /// final list = [('a', 1), ('b', 3), ('c', 5)];
  /// list.average((e) => e.$2); // 3
  /// ```
  ///
  /// ## Implementation details
  /// Values are computed each time rather than cached as computation is assumed to be cheap.
  @useResult
  double average(Select<E, num> select) => sum(select) / length;

  /// Computes the sum of all values. Values are created from this iterable's elements using [select].
  ///
  /// [initial] defaults to 0 if unspecified. Returns [double.nan] if [select] returns [double.nan].
  ///
  /// ## Example
  /// ```dart
  /// final list = [('a', 2), ('b', 3), ('c', 4)];
  /// list.sum((e) => e.$2, initial: 1); // 10
  /// ```
  ///
  /// ## Implementation details
  /// Computing values is assumed to be cheap. Hence, values are recomputed each time rather than cached.
  @useResult
  R sum<R extends num>(Select<E, num> select, {R? initial}) {
    var sum = initial ?? 0;
    for (final element in this) {
      sum += select(element);
    }

    // Dart is fucking stupid for not allowing implicit conversions between integers and doubles.
    return (R == int ? sum.toInt() : sum.toDouble()) as R;
  }
}

/// Provides ordering functions for [Iterable]s of [Comparable]s.
///
/// See [OrderableIterable] for ordering elements that are not [Comparable].
extension AggregateComparableIterable<E extends Comparable<Object>> on Iterable<E> {
  /// The minimum element, or `null` if empty.
  ///
  /// ```dart
  /// ['b', 'a', 'c'].min; // 'a'
  /// ```
  @useResult
  E? get min {
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

  /// The maximum element, or `null` if empty.
  ///
  /// ```dart
  /// ['a', 'c', 'b'].max; // 'c'
  /// ```
  @useResult
  E? get max {
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

/// Provides aggregate functions, such as [average] and [sum], for [Iterable]s of [num]s.
///
/// This is a specialized implementation of [AggregateIterable] and [AggregateComparableIterable] that handles
/// [double.nan] elements properly.
extension AggregateNumberIterable<E extends num> on Iterable<E> {
  /// The average of all elements in this iterable, or [double.nan] if empty.
  ///
  /// ```dart
  /// [1, 2, 3].average; // 2.0
  /// ```
  @useResult
  double get average => sum / length;

  /// The sum of all elements in this iterable. Returns [double.nan] if it is present.
  ///
  /// ```dart
  /// [1, 2, 3].sum; // 6
  /// ```
  @useResult
  E get sum {
    num sum = 0;
    for (final element in this) {
      sum += element;
    }

    // Dart is fucking stupid for not allowing implicit conversions between integers and doubles.
    return (E == int ? sum.toInt() : sum.toDouble()) as E;
  }

  /// The minimum element, or `null` if empty. Returns [double.nan] if it is present.
  ///
  /// ```dart
  /// [1, 2, 3].min; // 1
  ///
  /// [1, 2, double.nan]; // double.nan
  /// ```
  @useResult
  E? get min {
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

  /// The maximum element, or `null` if empty. Returns [double.nan] if it is present.
  ///
  /// ```dart
  /// [1, 2, 3].max; // 3
  ///
  /// [1, 2, double.nan].max; // double.nan
  /// ```
  @useResult
  E? get max {
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
