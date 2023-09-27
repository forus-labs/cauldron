import 'dart:collection';

abstract interface class StringIndexed {

  String get index;

  set index(String index);

}

abstract base class Sil<E> with ListBase<E> {

  final SplayTreeMap<String, E> _map;
  final List<E> _list;

  Sil._(this._map, this._list);


  @override
  void add(E element);

  @override
  void addAll(Iterable<E> iterable);


  @override
  E operator [](Object index) => switch (index) {
    final String index => _map[index]!,
    final int index => _list[index],
    _ => throw ArgumentError('Invalid index: $index, should be either a String or int.'),
  };

  @override
  void operator []=(Object index, E value);

  @override
  int get length => _list.length;

}

