extension Lists<T> on List<T> {

  void separator(T value) {
    for (int i = 1; i < length; i += 2) {
      insert(i, value);
    }
  }

}