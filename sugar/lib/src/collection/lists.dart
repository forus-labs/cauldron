extension Lists<T> on List<T> {

  void separate(T value) {
    for (var i = 1; i < length; i += 2) {
      insert(i, value);
    }
  }

}