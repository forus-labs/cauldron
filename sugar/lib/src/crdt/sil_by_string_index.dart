part of 'sil.dart';

/// A view for manipulating elements in an SIL by their string index.
///
/// All changes to this view are reflected in the underlying SIL.
/// See [Sil] for more information.
extension type SilByStringIndex<E>._(Sil<E> _sil) implements Iterable<E> {

  /// Returns the index of the first element after the [index], or `null` if there is no element after [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A', 'b': 'B"}).byStringIndex;
  /// 
  /// sil.firstIndexAfter('a'); // 'b'
  /// 
  /// sil.firstIndexAfter('b'); // null
  /// ```
  String? firstIndexAfter(StringIndex index) => _sil._map.firstKeyAfter(index);

  /// Returns the first element after the [index], or `null` if there is no element after [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A', 'b': 'B"}).byStringIndex;
  /// 
  /// sil.firstElementAfter('a'); // 'B'
  /// 
  /// sil.firstElementAfter('b'); // null
  /// ```
  E? firstElementAfter(StringIndex index) => _sil._map.firstValueAfter(index);

  /// Returns the index of the last element before the [index], or `null` if there is no element before [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A', 'b': 'B"}).byStringIndex;
  /// 
  /// sil.lastIndexBefore('b'); // 'a'
  /// 
  /// sil.lastIndexBefore('a'); // null
  /// ```
  String? lastIndexBefore(StringIndex index) => _sil._map.lastKeyBefore(index);

  /// Returns the last element before the [index], or `null` if there is no element before [index].
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A', 'b': 'B"}).byStringIndex;
  /// 
  /// sil.lastElementBefore('b'); // 'A'
  /// 
  /// sil.lastElementBefore('a'); // null
  /// ```
  E? lastElementBefore(StringIndex index) => _sil._map.lastValueBefore(index);


  /// Returns the index of [element] in this SIL, or null if [element] was not found.
  ///
  /// ```dart
  /// final sil = Sil.map({'a': 'A'}).byStringIndex;
  ///
  /// sil.byIndex.indexOf('A'); // 'a'
  ///
  /// sil.byIndex.indexOf('B'); // null
  /// ```
  @useResult StringIndex? indexOf(E element) => _sil._inverse[element];

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
    for (final MapEntry(:key, :value) in _sil._map.entries) {
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
    for (final element in _sil._list.reversed) {
      final index = _sil._inverse[element]!;
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
    final element = _sil._map.remove(index);
    if (element != null) {
      _sil._inverse.remove(element);
      _sil._list.removeWhere((e) => _sil._equals(element, e));
    }

    return element;
  }


  /// Returns the element at the given [index], or `null` if no element at the [index] exists.
  @useResult E? operator [] (Object? index) => _sil._map[index];

  /// Sets the value at the given [index] to [element] if [element] is not yet in this SIL.
  void operator []= (StringIndex index, E element) {
    if (_sil._inverse.containsKey(element)) {
      return;
    }

    final removed = _sil._map.remove(index);
    _sil._map[index] = element;

    if (removed == null) {
      final after = _sil._map.firstValueAfter(index);
      _sil._inverse[element] = index;
      // We need to use indexWhere since the SIl might have custom equality.
      _sil._list.insert(after == null ? _sil._list.length : _sil._list.indexWhere((element) => identical(after, element)), element);

    } else {
      _sil._inverse.remove(removed);
      _sil._inverse[element] = index;
      // We need to use indexWhere since the SIl might have custom equality.
      _sil._list[_sil._list.indexWhere((element) => identical(removed, element))] = element;
    }
  }


  /// The elements and their associated string indexes.
  Iterable<(StringIndex, E)> get indexed sync* {
    for (final MapEntry(:key, :value) in _sil._map.entries) {
      yield (key, value);
    }
  }

}
