/// Provides additional operations for [Iterable].
extension Iterables<T> on Iterable<T> {

  /// Returns an [Iterable] that, for each element, calls [listen] with the current element.
  Iterable<T> listen(void Function(T) listen) sync* {
    for (final element in this) {
      listen(element);
      yield element;
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

}
