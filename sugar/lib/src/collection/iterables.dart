import 'package:sugar/collection.dart';
import 'package:sugar/src/core/annotations.dart';

/// Returns true if the given [Iterable]s have no elements in common.
bool disjoint(Iterable<dynamic> a, Iterable<dynamic> b) {
  // This implementation is borrowed from Java's Collections.disjoint(...) method. It assumes that the given iterables
  // have efficient length computations, i.e. the length is cached. This is true for most standard library collections.
  var iterable = a;
  var contains = b;

  if (a is Set<dynamic>) {
    iterable = b;
    contains = a;

  } else if (b is! Set<dynamic>) {
    final aLength = a.length;
    final bLength = b.length;
    if (aLength == 0 || bLength == 0) {
      return true;
    }

    if (aLength > bLength) {
      iterable = b;
      contains = a;
    }
  }

  for (final element in iterable) {
    if (contains.contains(element)) {
      return false;
    }
  }

  return true;
}

/// Provides functions for working with [Iterable]s.
extension Iterables<E> on Iterable<E> {

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

  /// Transforms this [Iterable] into map, using [key] and [value] to produce keys and values respectively.
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
extension ComparableIterables<T> on Iterable<Comparable<T>> {

}

/// Provides functions for working with nested [Iterable]s.
extension IterableIterables<T> on Iterable<Iterable<T>> {

  /// Creates a [Iterable] that contains elements in all nested [Iterable]s in this [Iterable].
  ///
  /// ```dart
  /// final list = [['a', 'b'], ['c', 'd'], ['e']].flatten().toList();
  /// expect(list, ['a', 'b', 'c', 'd', 'e']);
  /// ```
  @lazy Iterable<T> flatten() sync* {
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
  @lazy Iterable<U> flat<U>({required U Function(T) map}) sync* {
    for (final iterable in this) {
      for (final element in iterable) {
        yield map(element);
      }
    }
  }

}
