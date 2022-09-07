/// Provides aggregate functions for [Iterable]s.
extension AggregateIterable<E> on Iterable<E> {


  double average(num Function(E element) function) => sum(function) / length;

  /// Computes the sum of values by applying given [function] on all elements, starting with the given initial value,
  /// or 0 if unspecified.
  R sum<R extends num>(R Function(E element) function, {R? initial}) {
    var sum = initial ?? 0;
    for (final element in this) {
      sum += function(element);
    }

    return sum as R;
  }

}


/// Provides aggregate functions for [Iterable]s of [Comparable]s.
///
/// See `OrderableIterable` for working with types that don't extend [Comparable].
extension AggregateComparableIterable<E extends Comparable<Object>> on Iterable<E> {

  /// The smallest element in this [Iterable] or `null` if empty.
  ///
  /// ```dart
  /// print(['a', 'b', 'c'].min); // 'a'
  /// ```
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

  /// The largest element in this [Iterable] or `null` if empty.
  ///
  /// ```dart
  /// print(['a', 'b', 'c'].min); // 'c'
  /// ```
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

/// Provides aggregate functions for [Iterable]s of [num]s.
///
/// This is a specialized version of [AggregateIterable] since [num]s require special handling of [double.nan].
extension AggregateNumberIterable<E extends num> on Iterable<E> {

  /// The average of all elements in this [Iterable].
  ///
  /// ```dart
  /// print([1, 2, 3].average)); // 2.0
  /// ```
  double get average => sum / length;

  /// The sum of all elements in this [Iterable].
  ///
  /// ```dart
  /// print([1, 2, 3].sum); // 6
  /// ```
  E get sum {
    num sum = 0;
    for (final element in this) {
      sum += element;
    }

    return sum as E;
  }


  /// The smallest element in this [Iterable] or `null` if empty. [double.nan] will always be returned if present in this
  /// [Iterable].
  ///
  /// ```dart
  /// print([1, 2, 3].min); // 1
  ///
  /// print([1, 2, double.nan]); // double.nan
  /// ```
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

  /// The smallest element in this [Iterable] or `null` if empty. [double.nan] will always be returned if present in this
  /// [Iterable].
  ///
  /// ```dart
  /// print([1, 2, 3].max); // 3
  ///
  /// print([1, 2, double.nan]); // double.nan
  /// ```
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
