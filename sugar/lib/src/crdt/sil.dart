import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sugar/sugar.dart';

part 'sil_by_index.dart';
part 'sil_by_string_index.dart';

/// A String Index List (SIL) allows elements to be manipulated using a [StringIndex] and int index. Elements in a SIL
/// must be unique.
///
/// It is a Sequence Conflict-Free Replicated Data Type (CRDT), inspired by Logoot, developed in-house by Forus Labs.
/// Each element contains a string index that is compared lexicographically to determine order.
///
/// Intuitively, we (try to) always allow an element to be inserted between two other elements. Given two elements,
/// x and z, such that x < z, then x = 'a' and z = 'b'. To insert a element, y, between x and z such that x < y < z,
/// then a possible value for y is `af`. In this case, `f` can also be substituted for any other allowed character in a
/// string index. Each character in a string index is one of the allowed 64 characters, `+, -, [0-9], [A-Z] and [a-z]`.
///
/// See [StringIndex] for more information on string indexes.
///
/// ## Contract
/// If no equality and hashcode function is supplied, [E]s `==` and `hashCode` cannot change once it is inserted into this
/// [Sil]""".
///
/// ## Motivation
/// There are many benefits to representing an index as a string instead of a list of integers like in Logoot:
/// * Serialization and deserialization trivial.
/// * Sorting is trivial, elements can be compared lexicographically without any complicated logic, i.e. `ORDER BY` in SQL.
/// * String storage and manipulation is almost always provided out-of-the-box by programming languages and databases.
///
/// ## Caveats
/// Similar to Logoot, it is possible for two equivalent indexes without any empty space in-between to be generated,
/// i.e. x = 'a' and z = 'a'.
///
/// To avoid such cases, we have the following:
///
/// The `insert(min, max)` function guarantees that the space between:
/// * The last positions of `min` and `new index` is not empty.
/// * The last positions of `new index` and `max` is not empty.
///
/// Non-existent positions due to differences in length are treated as implicit `+`s (the first allowed character).
///
/// In both cases, a new character is appended to the new index until the space between said index and each boundary is
/// not empty.
///
/// It is still possible for two indexes to be generated without an empty space in-between concurrently. It is impossible
/// to prevent such situations from occurring. Therefore, such situations need to be handled during merging. This can be
/// accomplished by adding a `updated_at` timestamp to each element. Subsequently, the less recent element should be
/// reinserted.
class Sil<E> extends Iterable<E> {

  static bool _equality(Object? a, Object? b) => a == b;
  static int _hashCode(Object? e) => e.hashCode;

  final SplayTreeMap<StringIndex, E> _map;
  final HashMap<E, StringIndex> _inverse;
  final List<E> _list;
  final bool Function(E, E) _equals;

  /// Creates a [Sil] from the given [map] that uses the [equals] and [hash] function to determine the equality and
  /// hashcode of elements.
  ///
  /// [E]'s `==` and `hashCode` is used by default.
  ///
  /// Elements in the given map are ignored if they are already in this SIL with a smaller string index.
  ///
  /// ```dart
  /// Sil.map({StringIndex('a'): 'A', StringIndex('d'): 'B', StringIndex('b'): 'B'}); // {'a': 'A', 'b': 'B'}
  /// ```
  factory Sil.map(Map<StringIndex, E> map, {bool Function(E, E) equals = _equality, int Function(E) hash = _hashCode}) {
    final sil = Sil(equals: equals, hash: hash);
    for (final MapEntry(:key, :value) in map.entries.order(by: (e) => e.key).ascending) {
      if (!sil._inverse.containsKey(value)) {
        sil._map[key] = value;
        sil._inverse[value] = key;
        sil._list.add(value);
      }
    }

    return sil;
  }

  /// Creates a [Sil] from the given [list] that uses the [equals] and [hash] function to determine the equality and
  /// hashcode of elements.
  ///
  /// [E]'s `==` and `hashCode` is used by default.
  ///
  /// Elements in the given list are ignored if they are already in this SIL with a smaller string index.
  ///
  /// ```dart
  /// final sil = Sil.list(['A', 'B', 'C', 'B']); // ['A', 'B', 'C']
  /// ```
  factory Sil.list(List<E> list, {bool Function(E, E) equals = _equality, int Function(E) hash = _hashCode}) =>
    Sil<E>(equals: equals, hash: hash)..addAll(list);

  /// Creates a [Sil] that uses the [equals] and [hash] function to determine the equality and hashcode of elements in
  /// this SIL.
  ///
  /// [E]'s `==` and `hashCode` is used by default.
  Sil({bool Function(E, E) equals = _equality, int Function(E) hash = _hashCode}):
    _map = SplayTreeMap(),
    _inverse = HashMap(equals: equals, hashCode: hash),
    _list = [],
    _equals = equals;


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
  @useResult SilByIndex<E> get byIndex => SilByIndex._(this);

  /// A view that allows the elements to be manipulated using their string indexes.
  @useResult SilByStringIndex<E> get byStringIndex => SilByStringIndex._(this);


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
  @useResult String toString() => '[${_list.map((e) => '(${_inverse[e]}: $e)').join(', ')}]';

}
