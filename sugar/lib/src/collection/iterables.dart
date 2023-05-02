import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sugar/collection_aggregate.dart';
import 'package:sugar/core.dart';

/// Adds functions for transforming [Iterable]s to other collections.
///
/// Functions that rely on the ordering of elements are non-deterministic if an iterable is unordered, i.e. [HashSet].
extension Iterables<E> on Iterable<E> {

  /// Returns a lazy iterable with only distinct elements.
  ///
  /// Two elements are distinct if the values returned by [by] are not equal according to [==]. Earlier elements are
  /// replaced by later elements if their values are equal.
  ///
  /// This function is non-deterministic when this iterable is unordered, i.e. [HashSet].
  ///
  /// See [toSet] for creating a distinct [Iterable] by comparing elements.
  ///
  /// ```dart
  /// final set = {('a', 1), ('b', 1), ('c', 2)};
  /// final unordered = set.distinct(by: (e) => e.$2);
  ///
  /// print(unordered); // [('a', 1), ('c', 2)] or [('b', 1), ('c', 2)]
  /// ```
  @lazy @useResult Iterable<E> distinct({required Select<E, Object?> by}) sync* {
    final existing = <Object?>{};
    for (final element in this) {
      if (existing.add(by(element))) {
        yield element;
      }
    }
  }

  /// Returns a lazy iterable with records that contain an iteration index and element.
  ///
  /// This function is non-deterministic when this iterable is unordered, i.e. [HashSet].
  ///
  /// ```dart
  /// ['a', 'b', 'c'].indexed(); // [(1, 'a'), (2, 'b'), (3, 'c')]
  /// ```
  @lazy @useResult Iterable<MapEntry<int, E>> indexed() sync* { // TODO: Dart 3 records
    var count = 0;
    for (final element in this) {
      yield MapEntry(count++, element);
    }
  }


  /// Returns a map that associates values returned by [by] with elements in this iterable.
  ///
  /// Earlier entries are replaced by later entries if they contain the same key.
  ///
  /// This function is a convenience function similar to [Map.fromIterable] and map comprehension. It is intended for
  /// 1:1 mappings. See [Group] for aggregating several elements by the same key (1:N).
  ///
  /// This function is non-deterministic when this iterable is unordered, i.e. [HashSet].
  ///
  /// ```dart
  /// final list = [('A'), ('B'), ('C')];
  /// final map = list.associate(by: (foo) => foo.$1);
  ///
  /// print(map); // { 'A': ('A'), 'B': ('B'), 'C': ('C') }
  /// ```
  @useResult Map<R, E> associate<R>({required Select<E, R> by}) => { for (final element in this) by(element): element };

  /// Returns a modifiable map using [create] to produce entries from elements in this iterable.
  ///
  /// Earlier entries are replaced by later entries if they contain the same key.
  ///
  /// This function is an alternative to map comprehension when there are multiple steps in producing entries that
  /// cannot be expressed in a single expression.
  ///
  /// This function is non-deterministic when this iterable is unordered, i.e. [HashSet].
  ///
  /// See [toUnmodifiableMap] for creating a unmodifiable [Map].
  ///
  /// ```dart
  /// ['a', 'b', 'c'].toMap((element) {
  ///   final foo = someFunction(element);
  ///   return someOtherFunction(foo) ?? yetAnotherFunction(foo);
  /// });
  /// ```
  @useResult Map<K, V> toMap<K, V>(MapEntry<K, V> Function(E element) create) => { // TODO: Dart 3 records
    for (final entry in map((e) => create(e)))
      entry.key: entry.value,
  };


  /// Transforms this iterable into an unmodifiable [List].
  ///
  /// This function is non-deterministic when this iterable is unordered, i.e. [HashSet].
  ///
  /// See [toList] for creating a modifiable [List].
  ///
  /// ```dart
  /// [1, 2, 3].toUnmodifiableList(); //  [1, 2, 3]
  /// ```
  @useResult List<E> toUnmodifiableList() => List.unmodifiable(this);

  /// Transforms this iterable into an unmodifiable [Set].
  ///
  /// See [toSet] for creating a modifiable [Set].
  ///
  /// ```dart
  /// {1, 2, 3}.toUnmodifiableSet(); //  {1, 2, 3}
  /// ```
  @useResult Set<E> toUnmodifiableSet() => Set.unmodifiable(this);

  /// Returns an unmodifiable map using [create] to produce entries from elements in this iterable.
  ///
  /// Earlier entries are replaced by later entries if they contain the same key. It is an alternative to map
  /// comprehension when there are multiple steps in producing entries that cannot be expressed in a single expression.
  ///
  /// This function is non-deterministic when this iterable is unordered, i.e. [HashSet].
  ///
  /// See [toMap] for creating a modifiable [Map].
  ///
  /// ```dart
  /// ['a', 'b', 'c'].toUnmodifiableMap(
  ///   final foo = someFunction(element);
  ///   return someOtherFunction(foo) ?? yetAnotherFunction(foo);
  /// );
  /// ```
  @useResult Map<K, V> toUnmodifiableMap<K, V>(MapEntry<K, V> Function(E element) create) => Map.unmodifiable({
    // TODO: Dart 3 records
    for (final entry in map((e) => create(e)))
      entry.key: entry.value,
  });

}

/// Provides functions for working with nested iterables.
///
/// Functions that rely on the ordering of elements are non-deterministic if an iterable is unordered, i.e. [HashSet].
extension IterableIterable<E> on Iterable<Iterable<E>> {

  /// Returns a lazy iterable that flattens all nested iterables in this iterable.
  ///
  /// This function is non-deterministic when this iterable or its nested iterables are unordered, i.e. [HashSet].
  ///
  /// ```dart
  /// final nested = [[1, 2], [3, 4], [5]];
  /// print(nested.flatten()); // [1, 2, 3, 4, 5]
  /// ```
  @lazy @useResult Iterable<E> flatten() sync* {
    for (final iterable in this) {
      for (final element in iterable) {
        yield element;
      }
    }
  }

}
