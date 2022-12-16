import 'package:meta/meta.dart';
import 'package:sugar/collection.dart';
import 'package:sugar/core.dart';

/// Provides functions for grouping elements in an [Iterable].
///
/// See [Group] for more information.
extension GroupableIterable<E> on Iterable<E> {

  /// A [Group] that used to group elements in this [Iterable].
  ///
  /// ```dart
  /// final iterable = ['a', 'b', 'aa', 'bb', 'cc'];
  /// final aggregate = iterable.group.lists(by: (string) => string.length);
  ///
  /// print(aggregate); // {1: ['a', 'b'], 2: ['aa', 'bb', 'cc']}
  /// ```
  @lazy @useResult Group<E> get group => Group._(this);

}


/// An intermediate operation for grouping elements in an [Iterable]. Provides functions for grouping elements in an [Iterable].
///
/// These functions are meant for aggregating several elements by the same key, (1:N). It is recommended to use
/// [Iterables.associate] instead if each key is mostly mapped to one element, (1:1).
class Group<E> {

  final Iterable<E> _iterable;

  Group._(this._iterable);

  /// Groups the elements in an [Iterable] by the returned values of the given function. The grouped elements are subsequently
  /// folded using the given [as] function.
  ///
  /// ```dart
  /// final iterable = ['a', 'b', 'aa', 'bb', 'cc'];
  /// final counts = iterable.group.by((string) => string.length, as: (count, string) => (count ?? 0) + 1);
  ///
  /// print(counts); // {1: 2, 2: 3}
  /// ```
  ///
  /// ### Implementation details:
  /// This implementation assumes that computing each [K] is inexpensive. Under this assumption, it is more beneficial to
  /// recompute each [K] than maintain a map/list of [K]s.
  @useResult Map<K, V> by<K, V>(K Function(E element) by, {required V Function(V? previous, E current) as}) {
    final results = <K, V>{};
    for (final element in _iterable) {
      final key = by(element);
      results[key] = as(results[key], element);
    }

    return results;
  }

  /// Groups the elements in an [Iterable] by the returned values of the given function.
  ///
  /// ```dart
  /// final iterable = ['a', 'b', 'aa', 'bb', 'cc'];
  /// final aggregate = iterable.group.lists(by: (string) => string.length);
  ///
  /// print(aggregate); // {1: ['a', 'b'], 2: ['aa', 'bb', 'cc']}
  /// ```
  ///
  /// ### Implementation details:
  /// This implementation assumes that computing each [K] is inexpensive. Under this assumption, it is more beneficial to
  /// recompute each [K] than maintain a map/list of [K]s.
  @useResult Map<K, List<E>> lists<K>({required K Function(E element) by}) {
    final results = <K, List<E>>{};
    for (final element in _iterable) {
      (results[by(element)] ??= []).add(element);
    }

    return results;
  }

  /// Groups the elements in an [Iterable] by the returned values of the given function.
  ///
  /// ```dart
  /// final iterable = ['a', 'b', 'aa', 'bb', 'cc'];
  /// final aggregate = iterable.group.sets(by: (string) => string.length);
  ///
  /// print(aggregate); // {1: {'a', 'b'}, 2: {'aa', 'bb', 'cc'}}
  /// ```
  ///
  /// ### Implementation details:
  /// This implementation assumes that computing each [K] is inexpensive. Under this assumption, it is more beneficial to
  /// recompute each [K] than maintain a map/list of [K]s.
  @useResult Map<K, Set<E>> sets<K>({required K Function(E element) by}) {
    final results = <K, Set<E>>{};
    for (final element in _iterable) {
      (results[by(element)] ??= {}).add(element);
    }

    return results;
  }

}
