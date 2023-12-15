import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sugar/sugar.dart';

part 'sil_by_index.dart';

class Sil<E> extends Iterable<E> {

  static bool _equality(Object? a, Object? b) => a == b;

  static int _hashCode(Object? e) => e.hashCode;

  final SplayTreeMap<String, E> _map;
  final HashMap<E, String> _inverse;
  final List<E> _list;
  final bool Function(E, E) _equals;
  final int Function(E) _hash;
  SilByIndex<E>? _byIndex;


  factory Sil.list(List<E> elements, {bool Function(E, E) equals = _equality, int Function(E) hash = _hashCode}) =>
    Sil<E>(equals: equals, hash: hash)..addAll(elements);

  /// Creates a [Sil] that uses the [equals] and [hash] function to determine the equality and hashcode of elements in
  /// this SIL.
  ///
  /// [E]'s `==` and `hashCode` is used by default.
  Sil({bool Function(E, E) equals = _equality, int Function(E) hash = _hashCode}):
    _map = SplayTreeMap(),
    _inverse = HashMap(equals: equals, hashCode: hash),
    _list = [],
    _equals = equals,
    _hash = hash;


  /// Adds the given [elements] to the end of this SIL if they are not yet in this SIL.
  ///
  /// ```dart
  /// final sil = Sil.list(['A', 'B']);
  /// sil.addAll(['B', 'C']); // ['A', 'B', 'C']
  /// ```
  void addAll(Iterable<E> elements) => elements.forEach(add);

  /// Adds the [element] to the end of the list if it is not yet in this SIL.
  ///
  /// Returns `true` if [element] (or an equal value) was not yet in this SIL. Otherwise returns `false` and the SIL is not
  /// changed.
  ///
  /// ```dart
  /// final sil = Sil();
  ///
  /// sil.add('A'); // true, ['A']
  ///
  /// sil.add('A'); // false, ['A']
  /// ```
  bool add(E element) {
    if (!_inverse.containsKey(element)) {
      final index = StringIndex.between(min: _map.lastKey() ?? StringIndex.min);
      _map[index] = element;
      _inverse[element] = index;
      _list.add(element);
      return true;

    } else {
      return false;
    }
  }


  /// Removes the given [elements] from this SIL.
  ///
  /// ```dart
  /// final sil = Sil.list(['A', 'B']);
  /// sil.removeAll(['B', 'C']); // ['A']
  /// ```
  void removeAll(Iterable<E> elements) => elements.forEach(remove);

  /// Removes the last element from this SIL. Returns the element that was removed.
  ///
  /// ## Contract
  /// Throws a [RangeError] if the SIL is empty.
  ///
  /// ## Example
  /// ```dart
  /// final sil = Sil.list(['A', 'B']);
  /// sil.removeLast(); // ['A']
  /// ```
  E removeLast() {
    final element = _list.removeLast();
    final index = _inverse.remove(element);
    _map.remove(index);

    return element;
  }

  /// Removes [element] from this SIL.
  ///
  /// Returns `true` if [element] was in the SIL, and `false` if not. The method has no effect if [element] was not in the SIL.
  ///
  /// ```dart
  /// final sil = Sil();
  ///
  /// sil.add('A');
  /// sil.remove('A'); // true, []
  ///
  /// sil.add('B');
  /// sil.add('C'); // false, ['B']
  /// ```
  bool remove(Object? element) {
    final index = _inverse.remove(element);
    if (index != null) {
      _map.remove(index);
      _list.remove(element);
      return true;

    } else {
      return false;
    }
  }


  /// Removes elements which satisfy [predicate] from this SIL.
  ///
  /// ```dart
  /// final sil = Sil.list(['A', 'B']);
  /// sil.removeWhere(e => e == 'B'); // ['A']
  /// ```
  ///
  /// See [retainWhere].
  void removeWhere(bool Function(E) predicate) {
    _list.removeWhere((element) {
      if (predicate(element)) {
        _map.remove(_inverse.remove(element));
        return true;

      } else {
        return false;
      }
    });
  }

  /// Retains elements which satisfy [predicate] in this SIL.
  ///
  /// ```dart
  /// final sil = Sil.list(['A', 'B']);
  /// sil.retainWhere(e => e == 'B'); // ['B']
  /// ```
  ///
  /// See [removeWhere].
  void retainWhere(bool Function(E) predicate) {
    _list.retainWhere((element) {
      if (predicate(element)) {
        return true;

      } else {
        _map.remove(_inverse.remove(element));
        return false;
      }
    });
  }


  /// Removes all elements from this SIL.
  ///
  /// ```dart
  /// final sil = Sil.list(['A', 'B']);
  ///
  /// sil.clear(); // []
  /// ```
  void clear() {
    _map.clear();
    _inverse.clear();
    _list.clear();
  }


  @override
  @useResult bool contains(Object? value) => _inverse.containsKey(value);

  @override
  @useResult E elementAt(int index) => _list.elementAt(index);

  @override
  @useResult Iterator<E> get iterator => _list.iterator;

  /// A view that allows the elements to be manipulated using their int indexes.
  @useResult SilByIndex<E> get byIndex => _byIndex ??= SilByIndex._(_map, _inverse, _list, _equals, _hash);


  set first(E element) {
    final old = _list.first;
    final index = _inverse.remove(old)!;

    _list.first = element;
    _inverse[element] = index;
    _map[index] = element;
  }

  set last(E element) {
    final old = _list.last;
    final index = _inverse.remove(old)!;

    _list.last = element;
    _inverse[element] = index;
    _map[index] = element;
  }


  @override
  String toString() => '[${_list.map((e) => '(${_inverse[e]}: $e)').join(', ')}]';

}
