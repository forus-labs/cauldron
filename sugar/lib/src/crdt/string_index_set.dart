import 'dart:collection';

import 'package:sugar/sugar.dart';

class StringIndexSet<E> extends Iterable<E> {

  /// Whether to strictly validate a string index's format. True by default.
  final bool strict;

  final SplayTreeMap<String, E> _map;
  final HashMap<E, String> _inverse;
  final List<E> _list;
  final bool Function(E, E) _equals;
  final int Function(E) _hash;

  StringIndexSet._(
    this._map,
    this._inverse,
    this._list,
    this._equals,
    this._hash, {
    required this.strict,
  });


  void operator []= (Object index, E element) {
    if (_inverse.containsKey(element)) {
      return;
    }

    switch (index) {
      case final String index:
        if (_map.firstValueAfter(index) case final after?) {
          _list.insert(_list.indexWhere((e) => _equals(e, after)), element);

        } else {
          _list.add(element);
        }

        _map[index] = element;
        _inverse[element] = index;

        // Different semantics between map and list
      case final int index when index < _list.length:
        final min = _inverse[_list.elementAtOrNull(index - 1)] ?? StringIndex.min;
        final max = _inverse[_list.elementAtOrNull(index + 1)] ?? StringIndex.max;
        final string = StringIndex.between(min: min, max: max, strict: strict);
        _list.insert(index, element);

    }
  }


  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  E get first => _list.first;

  set first(E first) {

  }

}
