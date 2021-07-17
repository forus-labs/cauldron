/// Provides additional operations for lists.
extension Lists<T> on List<T> {

  /// Separates each element in this list with [value].
  void alternate(T value) {
    for (var i = 1; i < length; i += 2) {
      insert(i, value);
    }
  }

  /// Repeats the contents of this list the given number of times
  void repeat([int times = 1]) {
    final section = [...this];
    for (var i = 0; i < times; i++) {
      addAll(section);
    }
  }

}