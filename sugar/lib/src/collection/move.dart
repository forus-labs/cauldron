import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// Provides functions for moving a list's elements to other collections.
///
/// See [ListMove] for more information.
extension MovableList<E> on List<E> {

  /// Returns a [ListMove] used to move elements that satisfy [where] from this list to other collections.
  ///
  /// ```dart
  /// final foo = [1, 2, 3, 4, 5];
  /// final bar = foo.move(where: (e) => e.isEven).toList();
  ///
  /// print(foo); // [1, 3, 5]
  /// print(bar); // [2, 4]
  /// ```
  @lazy @useResult ListMove<E> move({required Predicate<E> where}) => ListMove._(this, where);

}

/// A namespace for functions that move a [List]'s elements to other collections.
///
/// To access [ListMove], call the [MovableList.move] extension method on a list.
///
/// ## Contract
/// A [ConcurrentModificationError] is thrown if a predicate modifies the list.
///
/// ```dart
/// final foo = [1, 2, 3, 4, 5];
/// foo.move(where: foo.remove).toList(); // throws ConcurrentModificationError
/// ```
///
/// See [SetMove] for moving a [Set]'s elements.
class ListMove<E> {

  final List<E> _list;
  final Predicate<E> _predicate;

  ListMove._(this._list, this._predicate);

  /// Move the list's elements that satisfy the predicate to another [List].
  ///
  /// The returned list is ordered the same as the list.
  ///
  /// ## Contract
  /// A [ConcurrentModificationError] is thrown if the predicate modifies the list.
  ///
  /// ## Example
  /// ```dart
  /// final foo = [1, 2, 3, 4, 5];
  /// final bar = foo.move(where: (e) => e.isEven).toList();
  ///
  /// print(foo); // [1, 3, 5]
  /// print(bar); // [2, 4]
  /// ```
  @Possible({ConcurrentModificationError})
  @useResult List<E> toList() {
    final moved = <E>[];
    collect(moved.add);
    return moved;
  }

  /// Move the list's elements that satisfy the predicate to a [Set].
  ///
  /// The returned set's order is undefined.
  ///
  /// ## Contract
  /// A [ConcurrentModificationError] is thrown if the predicate modifies the list.
  ///
  /// ```dart
  /// final foo = [1, 2, 3, 4, 5];
  /// final bar = foo.move(where: (e) => e.isEven).toSet();
  ///
  /// print(foo); // [1, 3, 5]
  /// print(bar); // {2, 4}
  /// ```
  @Possible({ConcurrentModificationError})
  @useResult Set<E> toSet() {
    final moved = <E>{};
    collect(moved.add);
    return moved;
  }

  /// Moves the list's elements that satisfy the predicate to [consume].
  ///
  /// The elements are passed to [consume] in the same order as in the list.
  ///
  /// ## Contract
  /// A [ConcurrentModificationError] is thrown if [consume] modifies the list.
  ///
  /// ## Example
  /// ```dart
  /// final foo = [1, 2, 3, 4, 5];
  /// final bar = [];
  ///
  /// foo.move(where: (e) => e.isEven).collect(bar.add);
  ///
  /// print(foo); // [1, 3, 5]
  /// print(bar); // [2, 4]
  /// ```
  @Possible({ConcurrentModificationError})
  void collect(Consume<E> consume) {
    final retained = <E>[];
    final length = _list.length;

    for (final element in _list) {
      if (_predicate(element)) {
        consume(element);

      } else {
        retained.add(element);
      }

      if (length != _list.length) {
        throw ConcurrentModificationError(_list);
      }
    }

    if (retained.length != _list.length) {
      _list..setRange(0, retained.length, retained)..length = retained.length;
    }
  }

}

/// Provides functions for moving a set's elements to other collections.
///
/// See [SetMove] for more information.
extension MovableSet<E> on Set<E> {

  /// Returns a [SetMove] used to move elements that satisfy [where] from this [Set] to other collections.
  ///
  /// ## Example
  /// ```dart
  /// final foo = {1, 2, 3, 4, 5};
  /// final bar = foo.move(where: (e) => e.isEven).toSet();
  /// 
  /// print(foo); // {1, 3, 5}
  /// print(bar); // {2, 4}
  /// ```
  @lazy @useResult SetMove<E> move({required Predicate<E> where}) => SetMove._(this, where);

}

/// A namespace for functions that move a [Set]'s elements to other collections.
///
/// To access [SetMove], call the [MovableSet.move] extension method on a set.
///
/// ## Contract
/// A [ConcurrentModificationError] is thrown if a predicate modifies the list.
///
/// ```dart
/// final foo = {1, 2, 3, 4, 5};
/// foo.move(where: foo.remove).toSet(); // throws ConcurrentModificationError
/// ```
///
/// See [ListMove] for moving a [List]'s elements.
class SetMove<E> {

  final Set<E> _set;
  final Predicate<E> _predicate;

  SetMove._(this._set, this._predicate);

  /// Move the set's elements that satisfy the predicate to another [Set].
  ///
  /// ## Contract
  /// A [ConcurrentModificationError] is thrown if the predicate modifies the set.
  ///
  /// ## Example
  /// ```dart
  /// final foo = {1, 2, 3, 4, 5};
  /// final bar = foo.move(where: (e) => e.isEven).toSet();
  ///
  /// print(foo); // {1, 3, 5}
  /// print(bar); // {2, 4}
  /// ```
  @Possible({ConcurrentModificationError})
  @useResult Set<E> toSet() {
    final moved = <E>{};
    collect(moved.add);
    return moved;
  }

  /// Moves the set's elements that satisfy the predicate to [consume].
  ///
  /// ## Contract
  /// A [ConcurrentModificationError] is thrown if [consume] modifies the set.
  ///
  /// ## Example
  /// ```dart
  /// final foo = {1, 2, 3, 4, 5};
  /// final bar = [];
  ///
  /// foo.move(where: (e) => e.isEven).collect(bar.add);
  ///
  /// print(foo); // {1, 3, 5}
  /// print(bar); // [2, 4]
  /// ```
  @Possible({ConcurrentModificationError})
  void collect(Consume<E> consume) {
    final removed = <E>[];
    for (final element in _set) {
      if (_predicate(element)) {
        consume(element);
        removed.add(element);
      }
    }

    _set.removeAll(removed);
  }

}
