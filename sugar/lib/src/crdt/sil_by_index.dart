part of 'sil.dart';

/// A SIL view for manipulating elements by their integer index.
///
/// All changes to this view are reflected in the underlying SIL.
class SilByIndex<E> extends Iterable<E> {
  final SplayTreeMap<StringIndex, E> _map;
  final HashMap<E, StringIndex> _inverse;
  final List<E> _list;
  final bool Function(E, E) _equals;

  SilByIndex._(
    this._map,
    this._inverse,
    this._list,
    this._equals,
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
  @useResult int indexOf(E element) => _list.indexWhere((e) => _equals(element, e));

  /// Returns the index of the first element in this SIL that satisfies the [predicate], or -1 if no such element was not
  /// found.
  ///
  /// Searches the list from index [start] to the end of this SIL.
  ///
  /// ```dart
  /// final sil = Sil.list(['a', 'b', 'c', bd']).byIndex;
  ///
  /// final first = sil.indexWhere((e) => e.startsWith('b')); // 1
  ///
  /// final second = sil.indexWhere((e) => e.startsWith('b'), 2); // 3
  ///
  /// final invalid = sil.indexWhere((e) => e.startsWith('f')); // -1
  /// ```
  @useResult int indexWhere(bool Function(E) predicate, [int start = 0]) => _list.indexWhere(predicate, start);

  /// Returns the index of the last element in this SIL that satisfies the [predicate], or -1 if no such element was not
  /// found.
  ///
  /// Searches the list from index [end] to the start of this SIL.
  ///
  /// ```dart
  /// final sil = Sil.list(['a', 'b', 'c', 'bd']).byIndex;
  ///
  /// final first = sil.lastIndexWhere((e) => e.startsWith('b')); // 3
  ///
  /// final second = sil.lastIndexWhere((e) => e.startsWith('b'), 2); // 1
  ///
  /// final invalid = sil.lastIndexWhere((e) => e.startsWith('f')); // -1
  /// ```
  @useResult int lastIndexWhere(bool Function(E) predicate, [int end = 0]) => _list.lastIndexWhere(predicate, end);


  /// Inserts all the given [elements] at [index] if they are not yet in the SIL, shifting all elements at and after
  /// [index] towards the end of the SIL.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `index < 0` or `length < index`.
  ///
  /// ## Example
  /// ```dart
  /// final sil = Sil.list(['A', 'B', 'C']).byIndex;
  ///
  ///  sil.insert(1, ['D', 'E']); // ['A', 'D', 'E', 'B', 'C'];
  /// ```
  void insertAll(int index, Iterable<E> elements) {
    RangeError.checkValidRange(0, index, length);
    for (final element in elements) {
      _insert(index, element);
    }
  }

  /// Inserts [element] at [index] if it not in this SIL, shifting all elements at and after [index] towards the end of
  /// the SIL. Does nothing otherwise.
  ///
  /// Returns `true` if [element] was not in this SIL.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `index < 0` or `length < index`.
  ///
  /// ## Example
  /// ```dart
  /// final sil = Sil.list(['A', 'B', 'C']).byIndex;
  ///
  /// sil.insert(1, 'D'); // ['A', 'D', 'B', 'C'];
  /// ```
  bool insert(int index, E element) {
    RangeError.checkValidRange(0, index, length);
    return _insert(index, element);
  }

  bool _insert(int index, E element) {
    if (_inverse.containsKey(element)) {
      return false;
    }

    final string = StringIndex.between(
      min: index <= 0 ? StringIndex.min : _inverse[_list[index - 1]]!,
      max: _inverse[_list[index]]!,
    );

    _map[string] = element;
    _inverse[element] = string;
    _list.insert(index, element);

    return true;
  }


  /// Removes and returns the element at the given [index].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `index < 0` or `length <= index`.
  ///
  /// ## Example
  /// ```dart
  /// final sil = Sil.list(['A', 'B', 'C']).byIndex;
  ///
  /// sil.removeAt(1); // ['A', 'C'];
  /// ```
  E removeAt(int index) {
    final element = _list.removeAt(index);
    final string = _inverse.remove(element)!;
    _map.remove(string);

    return element;
  }


  /// Returns the element at the given [index].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `index < 0` or `length <= index`.
  @useResult E operator [] (int index) => _list[index];

  /// Sets the value at the given [index] to [element] if it is not yet in this SIL.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `index < 0` or `length <= index`.
  void operator []= (int index, E element) {
    RangeError.checkValidRange(0, index, length);
    if (_inverse.containsKey(element)) {
      return;
    }

    final old = _list[index];
    final string = _inverse.remove(old)!;

    _map[string] = element;
    _inverse[element] = string;
    _list[index] = element;
  }

  @override
  @useResult E elementAt(int index) => _list.elementAt(index);

  @override
  @useResult Iterator<E> get iterator => _list.iterator;
}
