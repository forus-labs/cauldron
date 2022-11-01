import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sugar/collection.dart';
import 'package:sugar/core.dart';

/// Provides functions for working with iterables.
extension Iterables<E> on Iterable<E> {

  /// Returns a lazy [Iterable] that contains only distinct elements.
  ///
  /// Two elements are considered distinct if the values returned by [by] are not equal according to [==].
  ///
  /// **Note: **
  /// When this [Iterable] contains multiple elements with the same value, only the first element is returned.
  /// Thus, this operation is not idempotent if this [Iterable] is unordered, i.e. [HashSet].
  ///
  /// This means to say, a different element with the same value may be returned each time the returned [Iterable] is
  /// iterated over.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///   final int value;
  ///
  ///   Foo(this.id, this.value);
  /// }
  ///
  /// [Foo('a', 1), Foo('b', 1), Foo('c', 1), Foo('a', 2)].distinct(by: (foo) => foo.id); // [Foo('a', 1), Foo('b', 1), Foo('c', 1)]
  ///
  /// final set = HashSet()..addAll({Foo('a', 1), Foo('b', 1), Foo('c', 1), Foo('a', 2)});
  /// final distinct = set.distinct(by: (foo) => foo.id);
  /// print(distinct); // Either {Foo('a', 1), Foo('b', 1), Foo('c', 1)} or {Foo('a', 2), Foo('b', 1), Foo('c', 1)}
  /// ```
  ///
  /// See [Iterable.toSet] for creating a distinct [Iterable] by comparing elements.
  @lazy @useResult Iterable<E> distinct({required Object? Function(E element) by}) sync* {
    final existing = <Object?>{};
    for (final element in this) {
      if (existing.add(by(element))) {
        yield element;
      }
    }
  }

  /// Returns a lazy [Iterable] that contains this [Iterable]'s elements' indexes and elements.
  ///
  /// ```dart
  /// ['a', 'b', 'c'].indexed(); // [MapEntry(1, 'a'), MapEntry(2, 'b'), MapEntry(3, 'c')];
  /// ```
  ///
  /// See [entry] for destructing a [MapEntry] into two separate parameters.
  @lazy @useResult Iterable<MapEntry<int, E>> indexed() sync* {
    var count = 0;
    for (final element in this) {
      yield MapEntry(count++, element);
    }
  }


  /// Creates a map that associates a value returned by the given function with an element in this iterable. An earlier
  /// association will be overridden by a newer association if duplicate keys exist.
  ///
  /// This function is meant for mapping a single key to a single element in this iterable, (1:1). For aggregating several
  /// elements by the same key, (1:N), it is recommended to use the functions in [Group] instead.
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
  @useResult Map<R, E> associate<R>({required R Function(E element) by}) => { for (final element in this) by(element): element };

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
  @useResult Map<K, V> toMap<K, V>(K Function(E element) key, V Function(E element) value) => { for (final element in this) key(element): value(element) };


  /// The first element, or `null` if this [Iterable] is empty.
  ///
  /// ```dart
  /// ['a', 'b'].firstOrNull ?? 'something'; // `a`
  ///
  /// [].firstOrNull ?? 'something'; // 'something'
  /// ```
  @useResult E? get firstOrNull => isNotEmpty ? first : null;

  /// The last element, or `null` if this [Iterable] is empty.
  ///
  /// ```dart
  /// ['a', 'b'].lastOrNull ?? 'something'; // `b`
  ///
  /// [].lastOrNull ?? 'something; // 'something'
  /// ```
  @useResult E? get lastOrNull => isNotEmpty ? last : null;

  /// The single element of this [Iterable] , or `null`.
  ///
  /// ```dart
  /// ['a'].singleOrNull ?? 'something'; // `a`
  ///
  /// [].singleOrNull ?? 'something'; // 'something'
  /// ```
  @useResult E? get singleOrNull {
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

  /// Returns a lazy [Iterable] which contains elements in all nested [Iterable]s in this [Iterable].
  ///
  /// ```dart
  /// [[1, 2], [3, 4], [5]].flatten().toList(); // [1, 2, 3, 4, 5]
  /// ```
  @lazy @useResult Iterable<E> flatten() sync* {
    for (final iterable in this) {
      for (final element in iterable) {
        yield element;
      }
    }
  }

}
