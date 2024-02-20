part of 'sil.dart';

class SilByStringIndex<E> extends Iterable<E> {

  final SplayTreeMap<StringIndex, E> _map;
  final HashMap<E, StringIndex> _inverse;
  final List<E> _list;
  final bool Function(E, E) _equals;

  SilByStringIndex._(
    this._map,
    this._inverse,
    this._list,
    this._equals,
  );


  /// Returns the index of the first element after the [index], or `null` if there is no element after [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A', 'b': 'B"}).byStringIndex;
  /// 
  /// sil.firstIndexAfter('a'); // 'b'
  /// 
  /// sil.firstIndexAfter('b'); // null
  /// ```
  String? firstIndexAfter(StringIndex index) => _map.firstKeyAfter(index);

  /// Returns the first element after the [index], or `null` if there is no element after [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A', 'b': 'B"}).byStringIndex;
  /// 
  /// sil.firstElementAfter('a'); // 'B'
  /// 
  /// sil.firstElementAfter('b'); // null
  /// ```
  E? firstElementAfter(StringIndex index) => _map.firstValueAfter(index);

  /// Returns the index of the last element before the [index], or `null` if there is no element before [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A', 'b': 'B"}).byStringIndex;
  /// 
  /// sil.lastIndexBefore('b'); // 'a'
  /// 
  /// sil.lastIndexBefore('a'); // null
  /// ```
  String? lastIndexBefore(StringIndex index) => _map.lastKeyBefore(index);

  /// Returns the last element before the [index], or `null` if there is no element before [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A', 'b': 'B"}).byStringIndex;
  /// 
  /// sil.lastElementBefore('b'); // 'A'
  /// 
  /// sil.lastElementBefore('a'); // null
  /// ```
  E? lastElementBefore(StringIndex index) => _map.lastValueBefore(index);


  /// Returns the index of [element] in this SIL, or null if [element] was not found.
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A'}).byStringIndex;
  ///
  /// sil.byIndex.indexOf('A'); // 'a'
  ///
  /// sil.byIndex.indexOf('B'); // null
  /// ```
  @useResult StringIndex? indexOf(E element) => _inverse[element];

  /// Returns the index of the first element in this SIL that satisfies the [predicate], or `null` if no such element was
  /// not found.
  ///
  /// Searches the list from index [start] to the end of this SIL.
  ///
  /// ```dart
  /// final sil = Sil.map(['a': 'A', 'b': 'B', 'c': 'C', 'd': 'bd']).byStringIndex;
  ///
  /// final first = sil.indexWhere((e) => e.startsWith('B')); // 'b'
  ///
  /// final second = sil.indexWhere((e) => e.startsWith('B'), 2); // 'd'
  ///
  /// final invalid = sil.indexWhere((e) => e.startsWith('F')); // null
  /// ```
  @useResult String? indexWhere(bool Function(E) predicate, [String? start]) {
    for (final MapEntry(:key, :value) in _map.entries) {
      if (start != null && key < start) {
        continue;
      }

      if (predicate(value)) {
        return key;
      }
    }

    return null;
  }

  /// Returns the index of the last element in this SIL that satisfies the [predicate],  or `null` if no such element was
  /// not found.
  ///
  /// Searches the list from index [end] to the start of this SIL.
  ///
  /// ```dart
  /// final sil = Sil.map(['a': 'A', 'b': 'B', 'c': 'C', 'd': 'bd']).byStringIndex;
  ///
  /// final first = sil.lastIndexWhere((e) => e.startsWith('B')); // 3
  ///
  /// final second = sil.lastIndexWhere((e) => e.startsWith('B'), 2); // 1
  ///
  /// final invalid = sil.lastIndexWhere((e) => e.startsWith('F')); // -1
  /// ```
  @useResult String? lastIndexWhere(bool Function(E) predicate, [String? end]) {
    for (final element in _list.reversed) {
      final index = _inverse[element]!;
      if (end != null && end < index) {
        continue;
      }

      if (predicate(element)) {
        return index;
      }
    }

    return null;
  }


  /// Removes and returns the element at the given [index], or `null` if there is no element associated with [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A'}).byStringIndex;
  ///
  /// sil.removeAt('a'); // {}
  ///
  /// sil.removeAt('b'); // {'a': 'A'}
  /// ```
  E? removeAt(String index) {
    final element = _map.remove(index);
    if (element != null) {
      _inverse.remove(element);
      _list.removeWhere((e) => _equals(element, e));
    }

    return element;
  }


  /// Returns the element at the given [index], or `null` if no element at the [index] exists.
  @useResult E? operator [] (Object? index) => _map[index];

  /// Sets the value at the given [index] to [element] if [element] is not yet in this SIL.
  ///
  /// ## Contract
  /// Throws an [ArgumentError] if the index is not a valid string index.
  void operator []= (StringIndex index, E element) {
    if (!index.matches(StringIndex.format)) {
      throw ArgumentError('$index is not a valid string index.');
    }

    if (_inverse.containsKey(element)) {
      return;
    }

    final removed = _map.remove(index);
    _map[index] = element;

    if (removed == null) {
      final after = _map.firstValueAfter(index);
      _inverse[element] = index;
      _list.insert(after == null ? _list.length : _list.indexWhere((element) => _equals(after, element)), element);

    } else {
      _inverse.remove(removed);
      _inverse[element] = index;
      _list[_list.indexWhere((element) => _equals(removed, element))] = element;
    }
  }


  /// The elements and their associated string indexes.
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
