extension ListEquality<T> on List<T> {

  bool equals(List<T> other) {
    if (identical(this, other)) {
      return true;
    }

    if (length != other.length) {
      return false;
    }

    for (var i = 0; i < length; i++) {
      if ([i] != other[i]) {
        return false;
      }
    }

    return true;
  }

}

extension MapEquality<K, V> on Map<K, V> {

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

extension SetEquality<T> on Set<T> {

  bool equals(Set<T> other) => identical(this, other) || (length == other.length && containsAll(other));

}