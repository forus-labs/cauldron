import 'dart:collection';

import 'package:sugar/sugar.dart';

class Sil<E> extends Iterable<E> {
  final SplayTreeMap<String, E> _map;
  final HashMap<E, String> _inverse;
  final List<E> _list;
  final bool Function(E, E) _equals;
  final int Function(E) _hash;

  Sil._(
    this._map,
    this._inverse,
    this._list,
    this._equals,
    this._hash,
  );

  /// Adds the [value] to the end of the list if it is not yet in this SIL.
  ///
  /// Returns `true` if [value] (or an equal value) was not yet in this SIL. Otherwise returns `false` and the SIL is not
  /// changed.
  ///
  /// ```dart
  /// final sil = Sil<String>();
  /// print(sil.add("A")); // true, ["A"]
  /// print(sil.add("A")); // false, ["A"]
  /// ```
  bool add(E value) {
    if (!_inverse.containsKey(value)) {
      final index = StringIndex.between(min: _map.lastKey() ?? StringIndex.min);
      _map[index] = value;
      _inverse[value] = index;
      _list.add(value);
      return true;

    } else {
      return false;
    }
  }

  /// Removes [value] from this SIL.
  ///
  /// Returns `true` if [value] was in the SIL, and `false` if not. The method has no effect if [value] was not in the SIL.
  ///
  /// ```dart
  /// final sil = Sil<String>();
  ///
  /// sil.add("A");
  /// print(sil.remove("A")); // true, []
  ///
  /// sil.add("B");
  /// print(sil.add("C")); // false, ["B"]
  /// ```
  bool remove(Object? value) {
    final index = _inverse.remove(value);
    if (index != null) {
      _map.remove(index);
      _list.remove(value);
      return true;

    } else {
      return false;
    }
  }

  @override
  bool contains(Object? value) => _inverse.containsKey(value);

  @override
  E elementAt(int index) => _list.elementAt(index);

  @override
  Iterator<E> get iterator => _list.iterator;
}

class SilList<E> extends Iterable<E> {
  final SplayTreeMap<String, E> _map;
  final HashMap<E, String> _inverse;
  final List<E> _list;
  final bool Function(E, E) _equals;
  final int Function(E) _hash;

  SilList._(
    this._map,
    this._inverse,
    this._list,
    this._equals,
    this._hash,
  );

  int indexOf(E element) => _list.indexOf(element);

  void operator []= (int index, E element) {
    if (_inverse.containsKey(element)) {
      return;
    }

    final old = _list[index];
    final string = _inverse.remove(old)!;

    _map[string] = element;
    _inverse[element] = string;
    _list[index] = element;
  }

  E operator [] (int index) => _list[index];

  @override
  Iterator<E> get iterator => _list.iterator;
}
