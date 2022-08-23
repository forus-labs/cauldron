/// Represents the preimage of applying a function on a domain.
///
/// This is an intermediate type for manipulating a domain based on a preimage. That is to say, manipulate the elements
/// of an iterable based on the values produced by a function on said elements.
///
/// See https://en.wikipedia.org/wiki/Function_(mathematics)#Image_and_preimage
class Preimage<T, R> {

  final Iterable<T> _domain;
  final R Function(T) _function;

  /// Creates a [Preimage] using the given domain and function.
  Preimage(this._domain, this._function);

  /// Creates a map that associates the value of the function on an element to the element. If duplicate value-element entries
  /// exist, the earlier entry will be overridden by a newer entry.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final map = [Foo('A'), Foo('B'), Foo('C')].preimage((foo) => foo.id).toMap();
  /// print(map); // { 'A': Foo('A'), 'B': Foo('B'), 'C': Foo('C') }
  /// ```
  Map<R, T> toMap() => { for (final element in _domain) _function(element): element };

}

/// Provides additional preimage related functions for working with [Comparable]s.
extension ComparablePreimage<T, R extends Comparable<Object?>> on Preimage<T, R> {

  /// Returns a list sorted by the values of the function on elements, in ascending order.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final list = [Foo('B'), Foo('A'), Foo('C')].preimage((foo) => foo.id).ascending();
  /// print(list); // [ Foo('A'), Foo('B'), Foo('C') ]
  /// ```
  List<T> ascending() => _domain.toList()..sort((a, b) => _function(a).compareTo(_function(b)));

  /// Returns a list sorted by the values of the function on elements, in descending order.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final list = [Foo('B'), Foo('A'), Foo('C')].preimage((foo) => foo.id).descending();
  /// print(list); // [ Foo('C'), Foo('B'), Foo('A') ]
  /// ```
  List<T> descending() => _domain.toList()..sort((a, b) => _function(a).compareTo(_function(b)));


  /// The element with the minimum value of the function on all elements; otherwise returns `null` if empty.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// final min = [Foo('B'), Foo('A'), Foo('C')].preimage((foo) => foo.id).min;
  /// print(min); // Foo('A')
  /// ```
  T? get min {
    if (_domain.isEmpty) {
      return null;
    }

    var min = _domain.first;
    for (final element in _domain.skip(1)) {
      if (_function(min).compareTo(_function(element)) > 0) {
        min = element;
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
  /// final min = [Foo('B'), Foo('A'), Foo('C')].preimage((foo) => foo.id).max;
  /// print(min); // Foo('C')
  /// ```
  T? get max {
    if (_domain.isEmpty) {
      return null;
    }

    var max = _domain.first;
    for (final element in _domain.skip(1)) {
      if (_function(max).compareTo(_function(element)) < 0) {
        max = element;
      }
    }

    return max;
  }

}


/// Provides functions for manipulating a [Iterable] based on its domain.
extension PreimageIterable<E> on Iterable<E> {

  /// Creates a codomain using the given function and this [Iterable] as the domain.
  Preimage<E, R> preimage<R>(R Function(E element) function) => Preimage(this, function);

}

void foo() {
  ['1', '2', '3', '4'].preimage((s) => int.tryParse(s) ?? 0).ascending();
}

class Foo {
   final String id;

   Foo(this.id);
}

void a() {
  final map = [Foo('A'), Foo('B'), Foo('C')].preimage((foo) => foo.id).max;
}
