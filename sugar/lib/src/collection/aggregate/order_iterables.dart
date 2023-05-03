import 'package:meta/meta.dart';
import 'package:sugar/collection_aggregate.dart';
import 'package:sugar/core.dart';

/// Provides functions for ordering an [Iterable].
///
/// See [AggregateComparableIterable] for working with elements that are [Comparable].
extension OrderableIterable<E> on Iterable<E> {

  /// Returns a [Order] for ordering this iterable's elements.
  ///
  /// ```dart
  /// final iterable = [('b', 1), ('a', 2), ('c', 3)];
  /// final ordered = foo.order(where: (e) => e.$1).toList();
  ///
  /// print(ordered); // [('a', 2), ('b', 1), ('c', 3)]
  /// ```
  @lazy @useResult Order<E, T> order<T extends Comparable<Object>>({required Select<E, T> by}) => Order._(this, by);

}


/// A namespace for functions that order an [Iterable]'s elements.
///
/// To access [Order], call the [OrderableIterable.order] extension method on an iterable.
///
/// See [AggregateComparableIterable] for ordering elements that are [Comparable].
///
/// ## Example
/// ```dart
/// final iterable = [('b', 1), ('a', 2), ('c', 3)];
/// final ordered = foo.order(where: (e) => e.$1).toList();
///
/// print(ordered); // [('a', 2), ('b', 1), ('c', 3)]
/// ```
class Order<E, T extends Comparable<Object>> {

  final Iterable<E> _iterable;
  final Select<E, T> _function;

  Order._(this._iterable, this._function);

  /// A list sorted in ascending order of values returned by this [Order]'s function.
  ///
  /// ## Example
  /// ```dart
  /// final list = [('b', 1), ('a', 2), ('c', 3)];
  /// list.order(by: (e) => e.$1).ascending; // [('a', 2), ('b', 1), ('c', 3)]
  /// ```
  ///
  /// ## Implementation details
  /// This function assumes computing values to be cheap. Hence, the values are recomputed rather than cached.
  @useResult List<E> get ascending => _iterable.toList()..sort((a, b) => _function(a).compareTo(_function(b)));

  /// A list sorted in descending order of values returned by this [Order]'s function.
  ///
  /// ## Example
  /// ```dart
  /// final list = [('b', 1), ('a', 2), ('c', 3)];
  /// list.order(by: (e) => e.$1).ascending; // [('a', 2), ('b', 1), ('c', 3)]
  /// ```
  ///
  /// ## Implementation details
  /// Computing values is assumed to be cheap. Hence, the values are recomputed each time rather than cached.
  @useResult List<E> get descending => _iterable.toList()..sort((a, b) => _function(b).compareTo(_function(a)));

  /// The element with the minimum value returned by this [Order]'s function, or `null` if empty.
  ///
  /// ```dart
  /// final list = [('a', 2), ('b', 1), ('c', 3)];
  /// list.order(by: (foo) => foo.$2).min; // ('b', 1)
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

  /// The element with the maximum value returned by this [Order]'s function, or `null` if empty.
  ///
  /// ```dart
  /// final list = [('a', 2), ('c', 3), ('b', 1)];
  /// list.order(by: (foo) => foo.$2).min; // ('c', 3)
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
