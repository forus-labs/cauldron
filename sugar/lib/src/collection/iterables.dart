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
  /// final map = [Foo('A'), Foo('B'), Foo('C')].associate(by: (foo) => foo.id);
  /// print(map); // { 'A': Foo('A'), 'B': Foo('B'), 'C': Foo('C') }
  /// ```
  Map<R, E> associate<R>({required R Function(E element) by}) => { for (final element in this) by(element): element };

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


/// Provides functions for working with nested [Iterable]s.
extension IterableIterable<E> on Iterable<Iterable<E>> {

  /// Returns a [Iterable] which contains elements in all nested [Iterable]s in this [Iterable].
  ///
  /// ```dart
  /// final list = [[1, 2], [3, 4], [5]].flatten().toList();
  /// print(list); // [1, 2, 3, 4, 5];
  /// ```
  @lazy Iterable<E> flatten() sync* {
    for (final iterable in this) {
      for (final element in iterable) {
        yield element;
      }
    }
  }

}
