import 'package:sugar/core.dart';

/// Provides functions for working with iterables.
extension Iterables<E> on Iterable<E> {

  /// Creates a map that associates a value returned by the given function with an element in this iterable. An earlier
  /// association will be overridden by a newer association if duplicate keys exist.
  ///
  /// This function is meant for mapping a single key to a single element in this iterable, (1:1). For aggregating several
  /// elements by the same key, (1:N), it is recommended to use the functions in `Group` instead.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final map = [Foo('A'), Foo('B'), Foo('C')].preimage((foo) => foo.id);
  /// print(map); // { 'A': Foo('A'), 'B': Foo('B'), 'C': Foo('C') }
  /// ```
  Map<R, E> preimage<R>(R Function(E element) function) => { for (final element in this) function(element): element };

  /// Transforms this [Iterable] into a map, using [key] and [value] to produce keys and values respectively. An entry
  /// may be replaced by a later entry if they both contain the same key.
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
  Map<K, V> toMap<K, V>(K Function(E element) key, V Function(E element) value) => { for (final element in this) key(element): value(element) };


  /// The first element, or `null` if this [Iterable] is empty.
  ///
  /// ```dart
  /// print(['a', 'b'].firstOrNull ?? 'something'); // `a`
  ///
  /// print([].firstOrNull ?? 'something'); // 'something'
  /// ```
  E? get firstOrNull => isNotEmpty ? first : null;

  /// The last element, or `null` if this [Iterable] is empty.
  ///
  /// ```dart
  /// print(['a', 'b'].lastOrNull ?? 'something'); // `b`
  ///
  /// print([].lastOrNull ?? 'something); // 'something'
  /// ```
  E? get lastOrNull => isNotEmpty ? last : null;

  /// The single element of this [Iterable] , or `null`.
  ///
  /// ```dart
  /// print(['a'].singleOrNull ?? 'something'); // `a`
  ///
  /// print([].singleOrNull ?? 'something'); // 'something'
  /// ```
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
///
/// See `OrderableIterable` for working with types that don't extend [Comparable].
extension ComparableIterables<E extends Comparable<Object>> on Iterable<E> {

  /// Returns the smallest element in this [Iterable] or `null` if empty.
  ///
  /// ```dart
  /// print([1, 2, 3].min); // 1
  /// ```
  E? get min {
    if (isEmpty) {
      return null;
    }

    var min = first;
    for (final element in skip(1)) {
      if (min.compareTo(element) > 0) {
        min = element;
      }
    }

    return min;
  }

  /// Returns the largest element in this [Iterable] or `null` if empty.
  ///
  /// ```dart
  /// print([1, 2, 3].max); // 3
  /// ```
  E? get max {
    if (isEmpty) {
      return null;
    }

    var max = first;
    for (final element in skip(1)) {
      if (max.compareTo(element) < 0) {
        max = element;
      }
    }

    return max;
  }

}


/// Provides functions for working with nested [Iterable]s.
extension IterableIterables<E> on Iterable<Iterable<E>> {

  /// Creates a [Iterable] which contains elements in all nested [Iterable]s in this [Iterable], that have been mapped
  /// using the given [map] function.
  ///
  /// ```dart
  /// final list = [[1, 2], [3, 4], [5]].flat(map: (e) => e.String()).toList();
  /// print(list); // ['1', '2', '3', '4', '5'];
  /// ```
  @lazy Iterable<U> flat<U>({required U Function(E) map}) sync* {
    for (final iterable in this) {
      for (final element in iterable) {
        yield map(element);
      }
    }
  }

}
