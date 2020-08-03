extension FluentIterable<T> on Iterable<T> {

  Iterable<T> distinct() sync* {
    for (final element in toSet()) {
      yield element;
    }
  }

  Iterable<T> listen(void Function(T) listen) sync* {
    for (final element in this) {
      listen(element);
      yield element;
    }
  }

  Iterable<T> mapWhere(bool Function(T) predicate, T Function(T) replace) sync* {
    for (final element in this) {
      if (predicate(element)) {
        yield replace(element);

      } else {
        yield element;
      }
    }
  }


  Iterable<MapEntry<int, T>> indexed({int initial = 0}) sync* {
    for (final element in this) {
      yield MapEntry(initial++, element);
    }
  }


  bool none(bool Function(T) predicate) {
    for (final element in this) {
      if (predicate(element)) {
        return false;
      }
    }

    return true;
  }


  Map<K, V> toMap<K, V>(K Function(T) key, V Function(T) value) => {
    for (final element in this)
      key(element) : value(element)
  };

}