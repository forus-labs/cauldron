/// Returns true if the given [Iterable]s have no elements in common.
bool disjoint<E>(Iterable<E> a, Iterable<E> b) {
  // This implementation is borrowed from Java's Collections.disjoint(...) method. It assumes that the given iterables
  // have efficient length computations, i.e. the length is cached. This is true for most standard library collections.
  var iterable = a;
  var contains = b;

  if (a is Set<E>) {
    iterable = b;
    contains = a;

  } else if (b is! Set<E>) {
    final aLength = a.length;
    final bLength = b.length;
    if (aLength == 0 || bLength == 0) {
      return true;
    }

    if (aLength > bLength) {
      iterable = b;
      contains = a;
    }
  }

  for (final element in iterable) {
    if (contains.contains(element)) {
      return false;
    }
  }

  return true;
}