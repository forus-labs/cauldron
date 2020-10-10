/// Provides additional operations for lists.
extension Lists<T> on List<T> {

  /// Separates each element in this list with [value].
  void separate(T value) {
    for (int i = 1; i < length; i += 2) {
      insert(i, value);
    }
  }

}