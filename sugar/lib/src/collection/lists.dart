extension Lists<T> on List<T> {

  void separate(T value) {
    for (int i = 1; i < length; i += 2) {
      insert(i, value);
    }
  }

}