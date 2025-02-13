import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// Provides functions for working with [List]s.
///
/// Most functions modify a list in-place rather than produce a new list.
extension Lists<E> on List<E> {
  /// Appends [element] at the end if it is not in this list. Otherwise removes all [element]s from this list.
  ///
  /// ```dart
  /// [1, 2, 3]..toggleAll(4); // [1, 2, 3, 4]
  ///
  /// [1, 2, 4, 3, 4]..toggleAll(4); // [1, 2, 3]
  /// ```
  void toggleAll(E element) {
    final initial = length;
    removeWhere((e) => e == element);
    if (initial == length) {
      add(element);
    }
  }

  /// Returns true if this list contains all of [other]'s elements.
  ///
  /// The time-complexity is O(n²) if [other]'s [contains] is O(n).
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
  @useResult
  bool containsAll(Iterable<Object?> other) {
    for (final element in other) {
      if (!contains(element)) {
        return false;
      }
    }

    return true;
  }

  /// Replaces elements using [function].
  ///
  /// [function] accepts a [Consume] for specifying an element's zero or more replacement(s). It is an in-place 1:N [map]
  /// function.
  ///
  /// ## Contract
  /// A [ConcurrentModificationError] is thrown if [function] directly modifies this list.
  ///
  /// ```dart
  /// final foo = [1];
  /// foo.replaceAll((_, _) => foo.remove(0)); // throws ConcurrentModificationError
  /// ```
  ///
  /// ## Example
  /// ```dart
  /// void multiplyOdd(Consume<int> replace, int element) {
  ///   if (element.isOdd)
  ///     replace(element * 10);
  /// }
  ///
  /// [1, 2, 3, 4].replaceAll(multiplyOdd); // [10, 30]
  /// ```
  ///
  @Possible({ConcurrentModificationError})
  void replaceAll(void Function(Consume<E> replace, E element) function) {
    final retained = <E>[];
    final length = this.length;

    for (final element in this) {
      function(retained.add, element);

      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }

    clear();
    addAll(retained);
  }

  /// Retains all elements that are present in both this list and [other].
  ///
  /// The time-complexity is O(n²) if [other]'s [contains] function is O(n).
  ///
  /// ```dart
  /// [1, 2, 3]..retainAll([1, 2, 4]); // [1, 2]
  ///
  /// [1, 2, 3]..retainAll([1, 2, 1]); // [1, 2]
  ///
  /// [1, 2, 1]..retainAll([1, 2]); // [1, 2, 1]
  /// ```
  void retainAll(Iterable<Object?> other) => retainWhere(other.contains);

  /// Removes all elements that are present in both this list and [other].
  ///
  /// The time-complexity is O(n²) if [other]'s [contains] method is O(n). [clear] should be used when possible.
  ///
  /// ```dart
  /// [1, 2, 3]..removeAll([1, 2, 4]); // [3]
  /// ```
  void removeAll(Iterable<Object?> other) => removeWhere(other.contains);

  /// Repeats this list the give number of times.
  ///
  /// ## Contract
  /// A [RangeError] is thrown if [times] is negative.
  @Possible({RangeError})
  @useResult
  List<E> operator *(int times) {
    RangeError.checkNotNegative(times, 'times');
    return [for (var i = 0; i < times; i++) ...this];
  }
}

/// Provides functions for working with [List]s of null-nullable elements.
extension NonNullableList<E extends Object> on List<E> {
  /// Adds the [element] to this list and returns `true` if it is not null.
  ///
  /// ```dart
  /// [].addIfNonNull(1); // [1], true
  ///
  /// [].addIfNonNull(null); // [], false
  /// ```
  bool addIfNonNull(E? element) {
    final result = element != null;
    if (result) {
      add(element);
    }
    return result;
  }
}
