import 'package:sugar/collection.dart';
import 'package:sugar/core.dart';

/// Provides functions for working with [Iterable]s.
extension Iterables<E> on Iterable<E> {

  /// Returns the smallest element in this [Iterable] or `null` if empty.
  ///
  /// See `ComparableIterables.max(...)` for working with types that extend [Comparable].
  E? min(Comparator<E> comparator) {
    if (isEmpty) {
      return null;
    }

    var min = first;
    for (final element in skip(1)) {
      if (comparator(min, element) > 0) {
        min = element;
      }
    }

    return min;
  }

  /// Returns the largest element in this [Iterable] or `null` if empty.
  ///
  /// See `ComparableIterables.max(...)` for working with types that extend [Comparable].
  E? max(Comparator<E> comparator) {
    if (isEmpty) {
      return null;
    }

    var max = first;
    for (final element in skip(1)) {
      if (comparator(max, element) > 0) {
        max = element;
      }
    }

    return max;
  }

  /// Returns the number of elements in this [Iterable] that matches the given element.
  int count({required E of}) {
    var count = 0;
    for (final element in this) {
      if (element == of) {
        count++;
      }
    }

    return count;
  }

  /// Transforms this [Iterable] into a map, using [key] and [value] to produce keys and values respectively.
  ///
  /// This method is an alternative to Dart's in-built map comprehension. It is recommended to use this method only when
  /// there are multiple steps to producing a key or value that cannot be expressed clearly in a single expression.
  ///
  /// ```dart
  /// ['a', 'b', 'c'].toMap(
  ///   (element) {
  ///     final foo = someFunction(element);
  ///     return someOtherFunction(foo) ?? yetAnotherFunction(foo);
  ///   },
  ///   (element) => element,
  /// );
  /// ```
  Map<K, V> toMap<K, V>(K Function(E) key, V Function(E) value) => {
    for (final element in this)
      key(element) : value(element)
  };

  /// A [Group] which can be used to group elements in this [Iterable].
  ///
  /// ```dart
  /// final aggregate = ['a', 'b', 'aa', 'bb', 'cc'].group.lists(by: (string) => string.length);
  /// expect(aggregate, {1: ['a', 'b'], 2: ['aa', 'bb', 'cc']});
  /// ```
  ///
  /// See [Groups] for more information.
  Group<E> get group => () => this;

  /// The first element, or `null` if this [Iterable] is empty.
  E? get firstOrNull => isNotEmpty ? first : null;

  /// The last element, or `null` if this [Iterable] is empty.
  E? get lastOrNull => isNotEmpty ? last : null;

  /// The single element of this [Iterable] , or `null`.
  E? get singleOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      final result = iterator.current;
      if (!iterator.moveNext()) {
        return result;
      }
    }
    return null;
  }

}

/// Provides functions for working with [Iterable]s of [Comparable]s.
extension ComparableIterables<E extends Comparable<Object>> on Iterable<E> {

  /// Returns the smallest element in this [Iterable] or `null` if empty. Comparison is done using [comparator] if provided.
  ///
  /// See `Iterables.min(...)` for working with types that don't extend [Comparable].
  E? min([Comparator<E> comparator = Comparable.compare]) {
    if (isEmpty) {
      return null;
    }

    var min = first;
    for (final element in skip(1)) {
      if (comparator(min, element) > 0) {
        min = element;
      }
    }

    return min;
  }

  /// Returns the largest element in this [Iterable] or `null` if empty. Comparison is done using [comparator] if provided.
  ///
  /// See `Iterables.max(...)` for working with types that don't extend [Comparable].
  E? max([Comparator<E> comparator = Comparable.compare]) {
    if (isEmpty) {
      return null;
    }

    var max = first;
    for (final element in skip(1)) {
      if (comparator(max, element) < 0) {
        max = element;
      }
    }

    return max;
  }

}

/// Provides functions for working with nested [Iterable]s.
extension IterableIterables<E> on Iterable<Iterable<E>> {

  /// Creates a [Iterable] that contains elements in all nested [Iterable]s in this [Iterable].
  ///
  /// ```dart
  /// final list = [['a', 'b'], ['c', 'd'], ['e']].flatten().toList();
  /// expect(list, ['a', 'b', 'c', 'd', 'e']);
  /// ```
  @lazy Iterable<E> flatten() sync* {
    for (final iterable in this) {
      for (final element in iterable) {
        yield element;
      }
    }
  }

  /// Creates a [Iterable] which contains elements in all nested [Iterable]s in this [Iterable], that have been mapped
  /// using the given [map] function.
  ///
  /// ```dart
  /// final list = [[1, 2], [3, 4], [5]].flat(map: (val) => val.String()).toList();
  /// expect(list, ['1', '2', '3', '4', '5']);
  /// ```
  @lazy Iterable<U> flat<U>({required U Function(E) map}) sync* {
    for (final iterable in this) {
      for (final element in iterable) {
        yield map(element);
      }
    }
  }

}
