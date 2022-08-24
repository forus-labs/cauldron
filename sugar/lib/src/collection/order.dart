/// Represents an intermediate operation used in the ordering an [Iterable].
///
/// This class contains several ordering-related functions that may be subsequently chained.
class Order<E, T extends Comparable<Object>> {

  final Iterable<E> _iterable;
  final T Function(E) _function;

  /// Creates an [Order] on the given iterable using the given function.
  Order(this._iterable, this._function);

  /// Returns a list sorted by the values of the function on elements, in ascending order.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final list = [Foo('B'), Foo('A'), Foo('C')].order(by: (foo) => foo.id).ascending();
  /// print(list); // [ Foo('A'), Foo('B'), Foo('C') ]
  /// ```
  ///
  /// **Implementation details: **
  /// This implementation assumes that computing each value for comparison is inexpensive. Under this assumption, it is
  /// more beneficial to recompute each value than maintain a map/list of entries.
  List<E> ascending() => _iterable.toList()..sort((a, b) => _function(a).compareTo(_function(b)));

  /// Returns a list sorted by the values of the function on elements, in descending order.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final list = [Foo('B'), Foo('A'), Foo('C')].order(by: (foo) => foo.id).descending();
  /// print(list); // [ Foo('C'), Foo('B'), Foo('A') ]
  /// ```
  /// **Implementation details: **
  /// This implementation assumes that computing each value for comparison is inexpensive. Under this assumption, it is
  /// more beneficial to recompute each value than maintain a map/list of entries.
  List<E> descending() => _iterable.toList()..sort((a, b) => _function(b).compareTo(_function(a)));

  /// The element with the minimum value of the function on all elements; otherwise returns `null` if empty.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final min = [Foo('B'), Foo('A'), Foo('C')].order(by: (foo) => foo.id).min;
  /// print(min); // Foo('A')
  /// ```
  E? get min {
    if (_iterable.isEmpty) {
      return null;
    }

    var min = _iterable.first;
    var minValue = _function(min);

    for (final element in _iterable.skip(1)) {
      final value = _function(element);
      if (minValue.compareTo(value) > 0) {
        min = element;
        minValue = value;
      }
    }

    return min;
  }

  /// The element with the maximum value of the function on all elements; otherwise returns `null` if empty.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final min = [Foo('B'), Foo('A'), Foo('C')].order(by: (foo) => foo.id).max;
  /// print(min); // Foo('C')
  /// ```
  E? get max {
    if (_iterable.isEmpty) {
      return null;
    }

    var max = _iterable.first;
    var maxValue = _function(max);

    for (final element in _iterable.skip(1)) {
      final value = _function(element);
      if (maxValue.compareTo(value) < 0) {
        max = element;
        maxValue = value;
      }
    }

    return max;
  }

}

/// Provides functions for ordering an [Iterable].
extension OrderableIterable<E> on Iterable<E> {

  /// Creates an ordering on this [Iterable] using the given function.
  Order<E, T> order<T extends Comparable<Object>>({required T Function(E element) by}) => Order(this, by);

}



class Foo {
  final String id;

  Foo(this.id);
}

void a() {
  final map = [Foo('A'), Foo('B'), Foo('C')].order(by: (foo) => foo.id).max;
}
