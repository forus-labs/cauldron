import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Provides functions for accessing moving functions.
///
/// See [ListMove] for more information.
extension MovableList<E> on List<E> {

  /// A [ListMove] that is used to move elements from this [List] tp various collections.
  ///
  /// ### Example:
  /// ```dart
  /// final foo = [1, 2, 3, 4, 5];
  /// final bar = foo.move(where: (e) => e.isOdd).toList();
  /// ```
  @lazy @useResult ListMove<E> move({required Predicate<E> where}) => ListMove(this, where);

}

/// An intermediate operation for moving elements in a [List] to other collections.
///
/// ### Contract:
/// The given predicate should not modify the underlying [List]. A [ConcurrentModificationError] will otherwise be thrown.
///
/// ### Example:
/// ```dart
/// final foo = [1, 2, 3, 4, 5];
/// foo.move(where: (e) => foo.remove(e)).toList(); // throws ConcurrentModificationError
/// ```
///
/// See [SetMove] for moving elements in a [Set].
class ListMove<E> {

  final List<E> _list;
  final Predicate<E> _predicate;

  /// Creates a [ListMove] with the given backing list and predicate.
  ListMove(this._list, this._predicate);

  /// Move elements this [List] into another [List]. The ordering of elements in the returned list is the same as this [List].
  ///
  /// ### Example:
  /// ```dart
  /// final foo = [1, 2, 3, 4, 5];
  /// final bar = foo.move(where: (e) => e.isOdd).toList();
  ///
  /// print(foo); // [2, 4]
  /// print(bar); // [1, 3, 5]
  /// ```
  @Possible({ConcurrentModificationError}, when: 'predicate directly modifies underlying list')
  @useResult List<E> toList() {
    final moved = <E>[];
    collect(moved.add);
    return moved;
  }

  /// Moves elements in this [List] to a [Set]. The ordering of elements in the returned set is not guaranteed.
  ///
  /// ### Example:
  /// ```dart
  /// final foo = [1, 2, 3, 4, 5];
  /// final bar = foo.move(where: (e) => e.isOdd).toSet();
  ///
  /// print(foo); // [2, 4]
  /// print(bar); // {1, 3, 5}
  /// ```
  @Possible({ConcurrentModificationError}, when: 'predicate directly modifies underlying list')
  @useResult Set<E> toSet() {
    final moved = <E>{};
    collect(moved.add);
    return moved;
  }

  /// Moves elements in this [List] to the given [consume]. The elements are passed to the [consume] according to their
  /// order in this [List].
  ///
  /// ### Contract:
  /// The given [consume] should not modify this [List]. A [ConcurrentModificationError] will otherwise be thrown.
  ///
  /// ### Example:
  /// ```dart
  /// final foo = [1, 2, 3, 4, 5];
  /// final bar = [];
  ///
  /// foo.move(where: (e) => e.isOdd).collect(bar.add);
  ///
  /// print(foo); // [2, 4]
  /// print(bar); // [1, 3, 5]
  /// ```
  @Possible({ConcurrentModificationError}, when: 'predicate or consumer directly modifies underlying list')
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

/// Provides functions for accessing moving functions.
///
/// See [SetMove] for more information.
extension MovableSet<E> on Set<E> {

  /// A [SetMove] that is used to move elements from this [Set] to various collections.
  ///
  /// ### Example:
  /// ```dart
  /// final foo = {1, 2, 3, 4, 5};
  /// final bar = foo.move(where: (e) => e.isOdd).toSet();
  /// ```
  @lazy @useResult SetMove<E> move({required Predicate<E> where}) => SetMove(this, where);

}

/// An intermediate operation for moving elements in a [Set] to various collections.
///
/// ### Contract:
/// The given predicate should not modify the underlying [Set]. A [ConcurrentModificationError] will otherwise be thrown.
///
/// ### Example:
/// ```dart
/// final foo = {1, 2, 3, 4, 5};
/// foo.move(where: (e) => foo.remove(e)); // throws ConcurrentModificationError
/// ```
///
/// See [ListMove] for moving elements in a [List].
class SetMove<E> {

  final Set<E> _set;
  final Predicate<E> _predicate;

  /// Creates a [SetMove] with the given backing set and predicate.
  SetMove(this._set, this._predicate);

  /// Moves elements in this this [Set] to another [Set]. The ordering of elements in the returned set is not guaranteed.
  ///
  /// ### Example:
  /// ```dart
  /// final foo = {1, 2, 3, 4, 5};
  /// final bar = foo.move(where: (e) => e.isOdd).toSet();
  ///
  /// print(foo); // {2, 4}
  /// print(bar); // {1, 3, 5}
  /// ```
  @Possible({ConcurrentModificationError}, when: 'predicate modifies underlying set')
  @useResult Set<E> toSet() {
    final moved = <E>{};
    collect(moved.add);
    return moved;
  }

  /// Moves elements in this [Set] to the given [consume]. The ordering of elements in the return set is not guaranteed.
  ///
  /// ### Contract:
  /// The given [consume] should not modify this [Set]. A [ConcurrentModificationError] will otherwise be thrown.
  ///
  /// ### Example:
  /// ```dart
  /// final foo = {1, 2, 3, 4, 5};
  /// final bar = {};
  ///
  /// foo.move(where: (e) => e.isOdd).collect(bar.add);
  ///
  /// print(foo); // {2, 4}
  /// print(bar); // {1, 3, 5}
  /// ```
  @Possible({ConcurrentModificationError}, when: 'predicate or consumer modifies underlying set')
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
