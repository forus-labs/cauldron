import 'dart:collection';

import 'package:meta/meta.dart';

import 'package:sugar/collection_aggregate.dart';
import 'package:sugar/core.dart';

/// Provides functions for filtering and transforming [Iterable]s into other collections.
///
/// The provided functions are non-deterministic if this iterable is unordered, e.g. [HashSet].
///
/// ```dart
/// final foo = {1, 2, 3}.toUnmodifiableList();
///
/// print(foo); // Any of [1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2] or [3, 2, 1].
/// ```
extension Iterables<E> on Iterable<E> {
  /// Returns a lazy iterable with only distinct elements.
  ///
  /// Two elements are distinct if the values produced by [by] are not equal according to [==]. Later elements are ignored
  /// if their values are equal to earlier elements.
  ///
  /// This function is non-deterministic if this iterable is unordered, e.g. [HashSet].
  ///
  /// See [toSet] for creating a distinct [Iterable] by comparing elements.
  ///
  /// ```dart
  /// final set = {('a', 1), ('b', 1), ('c', 2)};
  /// final unordered = set.distinct(by: (e) => e.$2);
  ///
  /// print(unordered); // [('a', 1), ('c', 2)] or [('b', 1), ('c', 2)]
  /// ```
  @lazy
  @useResult
  Iterable<E> distinct({required Select<E, Object?> by}) sync* {
    final existing = <Object?>{};
    for (final element in this) {
      if (existing.add(by(element))) {
        yield element;
      }
    }
  }

  /// Associates the keys returned by [by] with this iterable's elements.
  ///
  /// Earlier entries are replaced by later entries if they share the same key.
  ///
  /// This function is similar to [Map.fromIterable] and map comprehension. It is intended for 1:1 mappings. See [Group]
  /// for grouping multiple elements by the same key (1:N).
  ///
  /// This function is non-deterministic if this iterable is unordered, e.g. [HashSet].
  ///
  /// ```dart
  /// final list = [('A'), ('B'), ('C')];
  /// final map = list.associate(by: (foo) => foo.$1);
  ///
  /// print(map); // { 'A': ('A'), 'B': ('B'), 'C': ('C') }
  /// ```
  @useResult
  Map<K, E> associate<K>({required Select<E, K> by}) => {for (final element in this) by(element): element};

  /// Returns a modifiable map, using [create] to produce entries from this iterable's elements.
  ///
  /// Earlier entries are replaced by later entries if they share the same key.
  ///
  /// It is an alternative to map comprehension when producing an entry cannot be expressed in a single expression.
  ///
  /// This function is non-deterministic if the this iterable is unordered, e.g. [HashSet].
  ///
  /// See [toUnmodifiableMap] for creating an unmodifiable [Map].
  ///
  /// ```dart
  /// ['a', 'b', 'c'].toMap((element) {
  ///   final foo = someFunction(element);
  ///   return someOtherFunction(foo) ?? yetAnotherFunction(foo);
  /// });
  /// ```
  @useResult
  Map<K, V> toMap<K, V>((K, V) Function(E element) create) => {for (final (key, value) in map(create)) key: value};

  /// Transforms this iterable into an unmodifiable [List].
  ///
  /// This function is non-deterministic if this iterable is unordered, e.g. [HashSet].
  ///
  /// See [toList] for creating a modifiable [List].
  ///
  /// ```dart
  /// [1, 2, 3].toUnmodifiableList(); //  [1, 2, 3]
  /// ```
  @useResult
  List<E> toUnmodifiableList() => List.unmodifiable(this);

  /// Transforms this iterable into an unmodifiable [Set].
  ///
  /// See [toSet] for creating a modifiable [Set].
  ///
  /// ```dart
  /// {1, 2, 3}.toUnmodifiableSet(); //  {1, 2, 3}
  /// ```
  @useResult
  Set<E> toUnmodifiableSet() => Set.unmodifiable(this);

  /// Returns an unmodifiable map, using [create] to produce entries from this iterable's elements.
  ///
  /// Earlier entries are replaced by later entries if they share the same key. It is an alternative to map
  /// comprehension when producing an entry cannot be expressed in a single expression.
  ///
  /// This function is non-deterministic when this iterable is unordered, e.g. [HashSet].
  ///
  /// See [toMap] for creating a modifiable [Map].
  ///
  /// ```dart
  /// ['a', 'b', 'c'].toUnmodifiableMap(
  ///   final foo = someFunction(element);
  ///   return someOtherFunction(foo) ?? yetAnotherFunction(foo);
  /// );
  /// ```
  @useResult
  Map<K, V> toUnmodifiableMap<K, V>((K, V) Function(E element) create) =>
      Map.unmodifiable({for (final (key, value) in map((e) => create(e))) key: value});
}
