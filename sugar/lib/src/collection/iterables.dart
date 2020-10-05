/// Provides additional operations for [Iterable].
extension Iterables<T> on Iterable<T> {

  /// Returns an [Iterable] in which duplicate elements are pruned.
  Iterable<T> distinct() sync* {
    for (final element in toSet()) {
      yield element;
    }
  }

  /// Returns an [Iterable] that, for each element, calls [listen] with the current element.
  Iterable<T> listen(void Function(T) listen) sync* {
    for (final element in this) {
      listen(element);
      yield element;
    }
  }

  /// Returns an [Iterable] that replaces elements that do not satisfy [predicate]
  /// with the new element returned by [replace].
  Iterable<T> mapWhere(bool Function(T) predicate, T Function(T) replace) sync* {
    for (final element in this) {
      if (predicate(element)) {
        yield replace(element);

      } else {
        yield element;
      }
    }
  }


  /// Returns an [Iterable] that indexes each element, start from [initial].
  Iterable<MapEntry<int, T>> indexed({int initial = 0}) sync* {
    for (final element in this) {
      yield MapEntry(initial++, element);
    }
  }


  /// Returns `true` if none of the elements in this [Iterable] match [predicate].
  bool none(bool Function(T) predicate) {
    for (final element in this) {
      if (predicate(element)) {
        return false;
      }
    }

    return true;
  }


  /// Transforms this [Iterable] into map, using [key] and [value] to produce keys and values respectively.
  Map<K, V> toMap<K, V>(K Function(T) key, V Function(T) value) => {
    for (final element in this)
      key(element) : value(element)
  };

}