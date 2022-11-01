/// Provides functions for working with [List]s.
extension Lists<E> on List<E> {

  /// Whether this [List] contains all elements of the given [Iterable].
  ///
  /// ```dart
  /// [1, 2, 3].containsAll([1, 2]); // true
  ///
  /// [1, 2].containsAll([1, 2, 3]); // false
  ///
  ///
  /// [1, 2, 1].containsAll([1, 2]); // true
  ///
  /// [1, 2].containsAll([1, 2, 1]); // true
  ///
  ///
  /// [1].containsAll([]); // true
  ///
  /// [].containsAll([]); // true
  /// ```
  ///
  /// **Note: **
  /// This function's time-complexity is O(n²) if the given [Iterable]'s [contains] function is O(n).
  bool containsAll(Iterable<Object?> other) {
    for (final element in other) {
      if (!contains(element)) {
        return false;
      }
    }

    return true;
  }

  /// Retains only elements in the given [Iterable]. That is to say, remove elements in this [Iterable] that are not in
  /// the given [Iterable].
  ///
  /// ```dart
  /// [1, 2, 3]..retainAll([1, 2, 4]); // [1, 2]
  /// ```
  ///
  /// **Note: **
  /// This function's time-complexity is O(n²) if the given [Iterable]'s [contains] function is O(n).
  void retainAll(Iterable<Object?> other) => removeWhere((e) => !other.contains(e));

  /// Removes all of the elements in given [Iterable].
  ///
  /// ```dart
  /// [1, 2, 3]..removeAll([1, 2, 4]); // [3]
  /// ```
  ///
  /// **Note: **
  /// This function's time-complexity is O(n²) if the given [Iterable]'s [contains] method is O(n). When possible, [clear]
  /// should be used instead.
  void removeAll(Iterable<Object?> other) => removeWhere(other.contains);

}
