import 'dart:collection';

class StringIndexSet<E> extends Iterable<E> {

  /// Whether to strictly validate a string index's format. True by default.
  final bool strict;

  final SplayTreeMap<String, E> _map;
  final HashMap<E, String> _inverse;
  final List<E> _list;


  final bool Function(E, E)? _equality;
  final int Function(E)? _hash;

  StringIndexSet._(
    this._map,
    this._inverse,
    this._list,
    this._equality,
    this._hash, {
    required this.strict,
  });

  @override
  Iterator<E> get iterator => _list.iterator;

  @override
  E get first => _list.first;

  set first(E first) {

  }

}
