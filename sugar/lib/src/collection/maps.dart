import 'package:meta/meta.dart';

/// Provides functions for working with [Map]s.
extension Maps<K, V> on Map<K, V> {

  /// Merges [a] and [b], using [resolve] to resolve conflicting entries.
  ///
  /// See [putAll] for merging maps in-place.
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2};
  /// final bar = {'a': 1, 'b': 3};
  ///
  /// final merged = Maps.merge(foo, bar, resolve: (k, v1, v2) => min(v1, v2));
  ///
  /// print(merged); // {'a': 1, 'b': 2}
  /// ```
  @useResult static Map<K, V> merge<K, V>(Map<K, V> a, Map<K, V> b, {required V Function(K key, V a, V b) resolve}) {
    final result = Map.of(a);
    for (final entry in b.entries) {
      final existing = a[entry.key];
      result[entry.key] = existing == null ? entry.value : resolve(entry.key, existing, entry.value);
    }

    return result;
  }


  /// Adds all entries in [other] to this map, using [resolve] to resolve conflicting entries.
  ///
  /// See [merge] for merging maps without mutating this map.
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2};
  /// final bar = {'a': 1, 'b': 3};
  ///
  /// foo.merge(bar, resolve: (k, v1, v2) => min(v1, v2));
  ///
  /// print(foo); // {'a': 1, 'b': 2}
  /// ```
  void putAll(Map<K, V> other, {required V Function(K key, V existing, V other) resolve}) {
    for (final entry in other.entries) {
      final existing = this[entry.key];
      this[entry.key] = existing == null ? entry.value : resolve(entry.key, existing, entry.value);
    }
  }

  /// Retains all entries that satisfy the given [predicate].
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2};
  /// foo.retainWhere((k, v) => v < 2); // {'b': 2}
  /// ```
  void retainWhere(bool Function(K key, V value) predicate) {
    final removed = <K>[];
    for (final entry in entries) {
      if (!predicate(entry.key, entry.value)) {
        removed.add(entry.key);
      }
    }

    removed.forEach(remove);
  }


  /// Inverts this map with keys becoming values and vice versa.
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2, 'c': 2};
  /// foo.inverse(); //  {1: ['a'], 2: ['b', 'c']}
  /// ```
  @useResult Map<V, List<K>> inverse() {
    final result = <V, List<K>>{};
    for (final entry in entries) {
      (result[entry.value] ??= []).add(entry.key);
    }

    return result;
  }

  /// Eagerly returns a map with only entries that satisfy the given predicate.
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2, 'c': 3};
  /// final bar = foo.where((k, v) => k == 'a' || v == 2); // {'a': 1, 'b': 2}
  /// ```
  @useResult Map<K, V> where(bool Function(K key, V value) predicate) => {
    for (final entry in entries)
      if (predicate(entry.key, entry.value))
        entry.key: entry.value
  };

  /// Returns a copy of this map with its keys transformed using [convert].
  ///
  /// ## Contract
  /// [convert] should always return distinct keys. Earlier entries may be replaced by later entries with the same key
  /// otherwise.
  ///
  /// ## Example
  /// ```dart
  /// final foo = {1: 1, 2: 2};
  /// final bar = foo.rekey((k) => '$k'); // {'1': 1, '2': 2}
  /// ```
  ///
  /// See [revalue] for converting values and [map] for converting entries.
  @useResult Map<K1, V> rekey<K1>(K1 Function(K key) convert) => { for (final entry in entries) convert(entry.key): entry.value };

  /// Returns a copy of this map with its values transformed using [convert].
  ///
  /// ```dart
  /// final foo = {1: 1, 2: 2};
  /// final bar = foo.revalue((v) => '$v'); // {1: '1', 2: '2'}
  /// ```
  ///
  /// See [rekey] for converting values and [map] for converting entries.
  @useResult
  Map<K, V1> revalue<V1>(V1 Function(V value) convert) => { for (final entry in entries) entry.key: convert(entry.value) };

}

/// Provides functions for working with [Map]s with null-nullable entries.
extension NonNullableMap<K extends Object, V extends Object> on Map<K, V> {

  /// Associates the [key] with the given [value], and returns true, if neither is null.
  ///
  /// Replaces an entry if it already exists.
  ///
  /// ```dart
  /// <String, int>{}.putIfNotNull('a', 1); // true, {'a': 1}
  ///
  /// <String, int>{'a': 0}.putIfNotNull('a', 1); // true, {'a': 1}
  ///
  /// <String, int>{}.putIfNotNull('a', null); // false, {}
  ///
  /// <String, int>{}.putIfNotNull(null, 1); // false, {}
  /// ```
  bool putIfNotNull(K? key, V? value) {
    final result = key != null && value != null;
    if (result) {
      this[key] = value;
    }

    return result;
  }

}
