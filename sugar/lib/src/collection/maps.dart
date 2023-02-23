import 'package:meta/meta.dart';

/// Provides functions for working with maps.
extension Maps<K, V> on Map<K, V> {

  /// Merges [a] and [b], using the given [ifConflicts] function to resolve conflicting entries.
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2, 'c': 3};
  /// final bar = {'a': 1, 'b': 3, 'c': 2};
  ///
  /// Maps.merge(foo, bar, ifConflicts: (k, v1, v2) => min(v1, v2)); // {'a': 1, 'b': 3, 'c': 3}
  /// ```
  ///
  /// See [putAll] for merging maps in-place.
  @useResult
  static Map<K, V> merge<K, V>(Map<K, V> a, Map<K, V> b, {required V Function(K key, V a, V b) ifConflicts}) {
    final result = Map.of(a);
    for (final entry in b.entries) {
      final existing = a[entry.key];
      result[entry.key] = existing == null ? entry.value : ifConflicts(entry.key, existing, entry.value);
    }

    return result;
  }


  /// Adds all entries in [other] to this [Map], using the given [ifExists] function to resolve conflicting entries.
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2, 'c': 3};
  /// final bar = {'a': 1, 'b': 3, 'c': 2};
  ///
  /// foo.merge(bar, ifConflicts: (k, v1, v2) => min(v1, v2)); // {'a': 1, 'b': 3, 'c': 3}
  /// ```
  ///
  /// See [merge] for merging maps without mutating this map.
  void putAll(Map<K, V> other, {required V Function(K key, V existing, V other) ifExists}) {
    for (final entry in other.entries) {
      final existing = this[entry.key];
      this[entry.key] = existing == null ? entry.value : ifExists(entry.key, existing, entry.value);
    }
  }

  /// Retains all entries of this map that satisfy the given [predicate].
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2, 'c': 3};
  /// foo.retainWhere((k, v) => v < 3); // {'a': 1, 'b': 2}
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


  /// Returns a [Map] where each entry is inverted, with the key becoming the value and the value becoming the key.
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2, 'c': 3, 'd': 3};
  /// final bar = foo.inverse(); //  {1: ['a'], 2: ['b'], 3: ['c', 'd']}
  /// ```
  @useResult
  Map<V, List<K>> inverse() {
    final result = <V, List<K>>{};
    for (final entry in entries) {
      (result[entry.value] ??= []).add(entry.key);
    }

    return result;
  }

  /// Returns a [Map] that contains only entries that satisfy the given predicate.
  ///
  /// ### Note:
  /// This function is eager. That is to say, the resulting [Map] is immediately computed.
  ///
  /// ```dart
  /// final foo = {'a': 1, 'b': 2, 'c': 3};
  /// final bar = foo.where((k, v) => k == 'a' || v == 2); // {'a': 1, 'b': 2}
  /// ```
  @useResult
  Map<K, V> where(bool Function(K key, V value) predicate) => {
    for (final entry in entries)
      if (predicate(entry.key, entry.value))
        entry.key: entry.value
  };

  /// Returns a [Map] that contains this [Map]'s [keys] transformed using the given [convert] function associated with
  /// the same [values].
  ///
  /// ### Contract:
  /// [convert] should produce unique keys. Earlier entries may be overridden by newer entries if [convert] produces
  /// duplicate keys.
  ///
  /// ```dart
  /// final foo = {1: 1, 2: 2, 3: 3};
  /// final bar = foo.rekey((k) => k.toString()); // {'1': 1, '2': 2, '3': 3}
  /// ```
  /// See [revalue] for converting values only.
  /// See [map] for converting both keys and entries.
  @useResult
  Map<K1, V> rekey<K1>(K1 Function(K key) convert) => { for (final entry in entries) convert(entry.key): entry.value };

  /// Returns a [Map] that contains this [Map]'s [keys] associated with its [values] transformed using the given [convert]
  /// function.
  ///
  /// ```dart
  /// final foo = {1: 1, 2: 2, 3: 3};
  /// final bar = foo.revalue((v) => v.toString()); // {1: '1', 2: '2', 3: '3'}
  /// ```
  ///
  /// See [rekey] for converting values only.
  /// See [map] for converting both keys and entries.
  @useResult
  Map<K, V1> revalue<V1>(V1 Function(V value) convert) => { for (final entry in entries) entry.key: convert(entry.value) };

}

/// Provides functions for working with [Map]s of null-nullable entries.
extension NonNullableMap<K extends Object, V extends Object> on Map<K, V> {

  /// Associates the [key] with the given [value] if neither is null.
  ///
  /// Returns `true` if the [key] was associated with the given [value]. That is to say, if neither was null. Otherwise,
  /// returns `false`.
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
