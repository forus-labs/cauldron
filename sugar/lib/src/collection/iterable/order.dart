import 'package:meta/meta.dart';
import 'package:sugar/collection.dart';
import 'package:sugar/core.dart';

/// Provides functions for ordering an [Iterable].
///
/// See [AggregateComparableIterable] for working with types that extend [Comparable].
extension OrderableIterable<E> on Iterable<E> {

  /// Creates an ordering on this [Iterable] using the given function.
  @lazy @useResult Order<E, T> order<T extends Comparable<Object>>({required T Function(E element) by}) => Order(this, by);

}


/// An intermediate operation used in the ordering an [Iterable].
///
/// See [AggregateComparableIterable] for directly ordering types that extend [Comparable].
class Order<E, T extends Comparable<Object>> {

  final Iterable<E> _iterable;
  final T Function(E) _function;

  /// Creates an [Order] on the given iterable using the given function.
  Order(this._iterable, this._function);

  /// A list sorted according to the values returned by this [Order]'s function, in ascending order.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// [ Foo('B'), Foo('A'), Foo('C') ].order(by: (foo) => foo.id).ascending; // [ Foo('A'), Foo('B'), Foo('C') ]
  /// ```
  ///
  /// **Implementation details: **
  /// This implementation assumes that computing each value for comparison is inexpensive. Under this assumption, it is
  /// more beneficial to recompute each value than maintain a map/list of entries.
  @useResult List<E> get ascending => _iterable.toList()..sort((a, b) => _function(a).compareTo(_function(b)));

  /// A list sorted according to the values returned by this [Order]'s function, in descending order.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// [ Foo('B'), Foo('A'), Foo('C') ].order(by: (foo) => foo.id).descending; // [ Foo('C'), Foo('B'), Foo('A') ]
  /// ```
  /// **Implementation details: **
  /// This implementation assumes that computing each value for comparison is inexpensive. Under this assumption, it is
  /// more beneficial to recompute each value than maintain a map/list of entries.
  @useResult List<E> get descending => _iterable.toList()..sort((a, b) => _function(b).compareTo(_function(a)));

  /// The element with the minimum value returned by this [Order]'s function, or `null` if the [Iterable] is empty.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// [ Foo('B'), Foo('A'), Foo('C') ].order(by: (foo) => foo.id).min; // Foo('A')
  /// ```
  @useResult E? get min {
    final iterator = _iterable.iterator;
    if (!iterator.moveNext()) {
      return null;
    }

    var min = iterator.current;
    var minValue = _function(min);

    while (iterator.moveNext()) {
      final value = _function(iterator.current);
      if (minValue.compareTo(value) > 0) {
        min = iterator.current;
        minValue = value;
      }
    }

    return min;
  }

  /// The element with the maximum value returned by this [Order]'s function, or `null` if the [Iterable] is empty.
  ///
  /// ```dart
  /// class Foo {
  ///   final String id;
  ///
  ///   Foo(this.id);
  /// }
  ///
  /// [Foo('B'), Foo('A'), Foo('C')].order(by: (foo) => foo.id).max; // Foo('C')
  /// ```
  @useResult E? get max {
    final iterator = _iterable.iterator;
    if (!iterator.moveNext()) {
      return null;
    }

    var max = iterator.current;
    var maxValue = _function(max);

    while (iterator.moveNext()) {
      final value = _function(iterator.current);
      if (maxValue.compareTo(value) < 0) {
        max = iterator.current;
        maxValue = value;
      }
    }

    return max;
  }

}