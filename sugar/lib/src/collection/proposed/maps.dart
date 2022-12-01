/// Provides functions for working with maps.
extension Maps<K, V> on Map<K, V> {

  /// rekey

  /// Returns a new map where all values are converted
  Map<K, V1> revalue<V1>(V1 Function(V) convert) => { for (final entry in entries) entry.key: convert(entry.value) };

  /// Merges this map with the [other] given map with [ifExists], which is used to resolve conflicts; that is to say, if
  /// both this map and [other] contain the same key.
  void merge(Map<K, V> other, {required V Function(K key, V existing, V value) ifExists}) { // should be static
    for (final entry in other.entries) {
      final existing = this[entry.key];
      this[entry.key] = existing == null ? entry.value : ifExists(entry.key, existing, entry.value);
    }
  }

  // General idea: provide functions that immediately apply to a map.

  wherekey

  wherevalue

  void inverse()


  putIfNonNull

}

// remove until


