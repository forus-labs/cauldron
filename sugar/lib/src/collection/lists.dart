import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Provides functions for working with [List]s.
extension Lists<E> on List<E> {

  /// Swaps the elements at the given indexes.
  ///
  /// ### Example:
  /// ```dart
  /// ['a', 'b', 'c'].swap(0, 2); // ['c', 'b', 'a']
  /// ```
  @Possible({RangeError})
  void swap(int a, int b) {
    RangeError.checkValidIndex(a, this, 'a');
    RangeError.checkValidIndex(b, this, 'b');

    final temporary = this[a];
    this[a] = this[b];
    this[b] = temporary;
  }

  /// Whether this [List] contains all elements of the given [Iterable].
  ///
  /// ### Example:
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
  /// ### Note:
  /// This function's time-complexity is O(n²) if the given [Iterable]'s [contains] function is O(n).
  @useResult bool containsAll(Iterable<Object?> other) {
    for (final element in other) {
      if (!contains(element)) {
        return false;
      }
    }

    return true;
  }

  /// Replaces all elements in this [List] using the given [function]. The given function accepts a [Consume] used to
  /// add replacement(s). An element can be replaced by zero or more elements.
  ///
  /// This function is the equivalent of a mutating [fold].
  ///
  /// ### Example:
  /// ```dart
  /// [1, 2, 3, 4].replaceAll((replace, element) { if (element.isOdd) replace(element * 10); }); // [10, 30]
  /// ```
  ///
  /// ### Contract:
  /// The given [function] should not modify this [List]. A [ConcurrentModificationError] will otherwise be thrown.
  ///
  /// ```dart
  /// final foo = [1];
  /// foo.replaceAll((replace, element) => foo.remove(0)); // throws ConcurrentModificationError
  /// ```
  @Possible({ConcurrentModificationError})
  void replaceAll(void Function(Consume<E> add, E element) function) {
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

  /// Retains only elements in the given [Iterable]. That is to say, remove elements in this [Iterable] that are not in
  /// the given [Iterable].
  ///
  /// ### Example:
  /// ```dart
  /// [1, 2, 3]..retainAll([1, 2, 4]); // [1, 2]
  ///
  /// [1, 2, 3]..retainAll([1, 2, 1]); // [1, 2]
  ///
  /// [1, 2, 1]..retainAll([1, 2]); // [1, 2, 1]
  /// ```
  ///
  /// ### Note:
  /// This function's time-complexity is O(n²) if the given [Iterable]'s [contains] function is O(n).
  void retainAll(Iterable<Object?> other) => removeWhere((e) => !other.contains(e));

  /// Removes all of the elements in given [Iterable].
  ///
  /// ### Example:
  /// ```dart
  /// [1, 2, 3]..removeAll([1, 2, 4]); // [3]
  /// ```
  ///
  /// ### Note:
  /// This function's time-complexity is O(n²) if the given [Iterable]'s [contains] method is O(n). When possible, [clear]
  /// should be used instead.
  void removeAll(Iterable<Object?> other) => removeWhere(other.contains);


  /// Repeats this [List] the give number of times.
  ///
  /// ### Contract:
  /// The given [times] must be a non-negative number. A [RangeError] is otherwise thrown.
  @Possible({RangeError}, when: 'times is negative')
  @useResult List<E> operator *(int times) => [
    for (var i = 0; i < RangeError.checkNotNegative(times, 'times'); i++)
      ...this,
  ];

}

/// Provides functions for working with [List]s of null-nullable elements.
extension NonNullableList<E extends Object> on List<E> {

  /// Adds the [element] to this [List] if not null.
  ///
  /// Returns `true` if the element was added to this [List]. That is to say, if the element was not null. Otherwise, returns
  /// `false`.
  ///
  /// ### Example:
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
