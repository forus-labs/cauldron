extension FilterIterable<E> on Iterable<E> {

  void transform(bool Function(E) Function() supplier) {
    [].map(indexed((a, b) => ...))
  }

}

// indexed & distinct built on top of transform (PENDING) function, apply?

// function for breaking down Function(MapEntry<int, T>) to Function(int, T), function that returns function.

// delegate to function that accepts an interable and returns another iterable.

// drain(to: collection) ?

// distinct
// indexed

// filter not good name