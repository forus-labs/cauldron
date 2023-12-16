part of 'sil.dart';

class SilByStringIndex<E> extends Iterable<E> {

  final SplayTreeMap<String, E> _map;
  final HashMap<E, String> _inverse;
  final List<E> _list;
  final bool Function(E, E) _equals;
  final int Function(E) _hash;

  SilByStringIndex._(
    this._map,
    this._inverse,
    this._list,
    this._equals,
    this._hash,
  );


  /// Returns the index of [element] in this SIL, or -1 if [element] was not found.
  ///
  /// ```dart
  /// final sil = Sil.list(['A', 'B']);
  ///
  /// sil.byIndex.indexOf('B'); // 1
  ///
  /// sil.byIndex.indexOf('C'); // -1
  /// ```
  @useResult String? indexOf(E element) => _inverse[element];


  /// Returns the element at the given [index].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `index < 0` or `length <= index`.
  @useResult E? operator [] (String index) => _map[index];

  /// Sets the value at the given [index] to [element] if it is not yet in this SIL.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `index < 0` or `length <= index`.
  void operator []= (String index, E element) {
    if (_inverse.containsKey(element)) {
      return;
    }

    final removed = _map.remove(index);
    if (removed == null) {
      final after = _map.firstValueAfter(index);
      _map[index] = element;
      _inverse[element] = index;
      _list.insert(after == null ? _list.length : _list.indexWhere((element) => _equals(after, element)), element);

    } else {
      _map[index] = element;
      _inverse.remove(removed);
      _inverse[element] = index;
      _list[_list.indexWhere((element) => _equals(removed, element))] = element;
    }
  }


  Iterable<(String, E)> get indexed sync* {
    for (final MapEntry(:key, :value) in _map.entries) {
      yield (key, value);
    }
  }

  @override
  @useResult E elementAt(int index) => _list.elementAt(index);

  @override
  @useResult Iterator<E> get iterator => _list.iterator;

}
