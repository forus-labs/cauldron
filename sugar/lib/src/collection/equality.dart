/// Utilities for comparison of the contents of lists.
extension ListEquality<T> on List<T> {

  /// Determines if the contents of this list and [other] are equal.
  bool equals(List<T> other) {
    if (identical(this, other)) {
      return true;
    }

    if (length != other.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }

    return true;
  }

}

/// Utilities for comparison of the contents of maps.
extension MapEquality<K, V> on Map<K, V> {

  /// Determines if the contents of this map and [other] are equal.
  bool equals(Map<K, V> other) {
    if (identical(this, other)) {
      return true;
    }

    if (length != other.length) {
      return false;
    }

    for (final entry in entries) {
      if (entry.value != other[entry.key]) {
        return false;
      }
    }

    return true;
  }

}

/// Utilities for comparison of the contents of sets.
extension SetEquality<T> on Set<T> {

  /// Determines if the contents of this set and [other] are equal.
  bool equals(Set<T> other) => identical(this, other) || (length == other.length && containsAll(other));

}
