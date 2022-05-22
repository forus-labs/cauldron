/// Provides functions for working with maps.
extension Maps<K, V> on Map<K, V> {

  /// Merges this map with the [other] given map with [ifExists], which is used to resolve conflicts; that is to say, if
  /// both this map and [other] contain the same key.
  void merge(Map<K, V> other, {required V Function(K key, V existing, V value) ifExists}) {
    for (final entry in other.entries) {
      final existing = this[entry.key];
      this[entry.key] = existing == null ? entry.value : ifExists(entry.key, existing, entry.value);
    }
  }

  void replace() {

  }

}
