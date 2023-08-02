import 'dart:collection';

import 'package:meta/meta.dart';

import 'package:sugar/collection.dart';
import 'package:sugar/core.dart';

/// Provides functions for grouping an [Iterable]'s elements.
///
/// See [Group] for more information.
extension GroupableIterable<E> on Iterable<E> {

  /// A [Group] used to group this [Iterable]'s elements.
  ///
  /// ```dart
  /// final iterable = [('a', 1), ('a', 2), ('b', 3)];
  /// final aggregate = iterable.group.lists(by: (e) => e.$1);
  ///
  /// print(aggregate); // {'a': [('a', 1), ('a', 2)], 'b': [('b', 3)]}
  /// ```
  @lazy @useResult Group<E> get group => Group._(this);

}


/// A namespace for functions that group an [Iterable]'s elements.
///
/// To access [Group], call the [GroupableIterable.group] extension getter on an iterable.
///
/// These functions are intended for 1:N mappings. See [Iterables.associate] for associating one key with one element (1:1).
///
/// ## Example
/// ```dart
/// final iterable = [('a', 1), ('a', 2), ('b', 3)];
/// final aggregate = iterable.group.lists(by: (e) => e.$1);
///
/// print(aggregate); // {'a': [('a', 1), ('a', 2)], 'b': [('b', 3)]}
/// ```
class Group<E> {

  final Iterable<E> _iterable;

  Group._(this._iterable);

  /// Groups the iterable's elements by keys returned by [by] before being folded using [as].
  ///
  /// The order of elements passed to [as] is non-deterministic when the iterable is unordered, e.g. [HashSet].
  ///
  /// ## Example
  /// ```dart
  /// final list = [('a', 1), ('a', 2), ('b', 4)];
  /// final counts = list.group.by((e) => e.$1, as: (count, e) => (count ?? 0) + e.$2);
  ///
  /// print(counts); // {'a': 3, 'b': 4}
  /// ```
  ///
  /// ## Implementation details
  /// Computing [K] is assumed to be cheap. Hence, [K]s are recomputed each time rather than cached.
  @useResult Map<K, V> by<K, V>(Select<E, K> by, {required V Function(V? previous, E current) as}) {
    final results = <K, V>{};
    for (final element in _iterable) {
      final key = by(element);
      results[key] = as(results[key], element);
    }

    return results;
  }

  /// Groups the iterable's elements in lists by keys returned by [by].
  ///
  /// The order of elements grouped in a list is non-deterministic when the iterable is unordered, i.e. [HashSet].
  ///
  /// ## Example
  /// ```dart
  /// final list = [('a', 1), ('a', 2), ('b', 4)];
  /// final aggregate = list.group.lists(by: (e) => e.$1);
  ///
  /// print(aggregate); // {'a': [('a', 1), ('a', 2)], 'b': [('b', 4)]}
  /// ```
  ///
  /// ## Implementation details
  /// Computing [K] is assumed to be cheap. Hence, [K]s are recomputed each time rather than cached.
  @useResult Map<K, List<E>> lists<K>({required Select<E, K> by}) {
    final results = <K, List<E>>{};
    for (final element in _iterable) {
      (results[by(element)] ??= []).add(element);
    }

    return results;
  }

  /// Groups the iterable's elements in sets by keys returned by [by].
  ///
  /// ## Example
  /// ```dart
  /// final list = [('a', 1), ('a', 2), ('b', 4)];
  /// final aggregate = list.group.sets(by: (e) => e.$1);
  ///
  /// print(aggregate); // {'a': {('a', 1), ('a', 2)}, 'b': {('b', 4)}}
  /// ```
  ///
  /// ## Implementation details
  /// Computing [K] is assumed to be cheap. Hence, [K]s are recomputed each time rather than cached.
  @useResult Map<K, Set<E>> sets<K>({required Select<E, K> by}) {
    final results = <K, Set<E>>{};
    for (final element in _iterable) {
      (results[by(element)] ??= {}).add(element);
    }

    return results;
  }

}
