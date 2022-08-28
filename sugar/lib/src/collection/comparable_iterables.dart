/// Provides functions for working with [Iterable]s of [Comparable]s.
///
/// See `OrderableIterable` for working with types that don't extend [Comparable].
extension ComparableIterables<E extends Comparable<Object>> on Iterable<E> {

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

/// Provides functions for working with [Iterable]s of [num]s.
///
/// This is a specialized version of [ComparableIterables] since [num]s require special handling of [double.nan].
extension NumberIterables<E extends num> on Iterable<E> {

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
