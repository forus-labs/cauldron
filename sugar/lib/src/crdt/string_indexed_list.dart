import 'dart:collection';

import 'package:sugar/sugar.dart';

class Sil<E> extends Iterable<E> {

  /// Whether to strictly validate a string index's format. True by default.
  final bool strict;

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
    this._hash, {
    required this.strict,
  });


  bool put(String index, E element) {
    if (_inverse.containsKey(element)) {
      return false;
    }

    final old = _map[index];
    if (old == null) {
      if (_map.firstValueAfter(index) case final after?) {
        _list.insert(_list.indexWhere((e) => _equals(e, after)), element);

      } else {
        _list.add(element);
      }

      _map[index] = element;
      _inverse[element] = index;

    } else {
      _map[index] = element;
      _inverse.remove(old);
      _inverse[element] = index;
      _list[_list.indexWhere((e) => _equals(e, old))] = element;
    }

    return true;
  }


  int indexOf(E element) => _list.indexOf(element);

  String? stringIndexOf(E element) => _inverse[element];


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
