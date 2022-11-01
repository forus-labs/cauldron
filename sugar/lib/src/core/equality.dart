import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Provides functions for determining the deep equality of [Iterable]s.
extension DeepEqualityIterable on Iterable<Object?> {

  /// Determines if this iterable and [other] are deeply equal. A list is only always equal to a list. Likewise for sets.
  /// To be equal, all other iterables must have the same order.
  ///
  /// This method is provided as an alternative to a [Iterable]'s default identity-based `==` implementation.
  ///
  /// **Contract: **:
  /// Both this list and [other] may not contain itself or the other value. Doing so will result in a [StackOverflowError].
  ///
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// a.equals([]) // Throws a StackOverflowError
  /// ```
  @Possible({StackOverflowError}, when: 'either a or b contains itself or the other')
  @useResult bool equals(Object? other) => Equality.deep(this, other);

  /// The deep hash-code of this list.
  @useResult int get hashValue => HashCodes.deep(this);

}

/// Provides functions for determining the deep equality of [Map]s.
extension DeepEqualityMap on Map<Object?, Object?> {

  /// Determines if this map and [other] are deeply equal.
  ///
  /// This method is provided as an alternative to a [Map]'s default identity-based `==` implementation.
  ///
  /// **Contract: **:
  /// Both this map and [other] may not contain itself or the other value. Doing so will result in a [StackOverflowError].
  ///
  /// ```dart
  /// final a = <int, dynamic>{};
  /// a.add(a);
  ///
  /// a.equals(<int, dynamic>{}) // Throws a StackOverflowError
  /// ```
  @Possible({StackOverflowError}, when: 'either a or b contains itself or the other')
  @useResult bool equals(Object? other) => Equality.deep(this, other);

  /// The deep hash-code of this list.
  @useResult int get hashValue => HashCodes.deep(this);

}

/// Provides functions for determining the deep equality of [MapEntry]s.
extension DeepEqualityMapEntry on MapEntry<Object?, Object?> {

  /// Determines if this map entry and [other] are deeply equal.
  ///
  /// This method is provided as an alternative to a [MapEntry]'s default identity-based `==` implementation.
  ///
  /// **Contract: **:
  /// Both this entry and [other] may not contain itself or the other value. Doing so will result in a [StackOverflowError].
  @Possible({StackOverflowError}, when: 'either a or b contains itself or the other')
  @useResult bool equals(Object? other) => Equality.deep(this, other);

  /// The deep hash-code of this list.
  @useResult int get hashValue => HashCodes.deep(this);

}

/// Provides functions for determining the equality of objects.
extension Equality on Never {

  /// Determines if [a] and [b] are deeply equal. This function works on lists, maps, sets, iterables and map entries.
  /// A list is only always equal to a list. To be equal, all other iterables must have the same order.
  ///
  /// [DeepEqualityIterable.equals] and [DeepEqualityMap.equals] should be preferred when working directly with collections.
  ///
  /// **Contract: **:
  /// Both [a] and [b] may not contain itself or the other given value. Doing so will result in a [StackOverflowError].
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// Equality.deep(a, ['some other list']) // Throws a StackOverflowError
  /// ```
  ///
  /// **Motivation: **
  /// The default implementations of `==` is identity-based for most Dart collections. This can lead to unintuitive behaviour
  /// when comparing collections. It is natural to expect that two collections with the same elements are equal. However,
  /// using the default identity-based `==` operator, both collections are not equal.
  @Possible({StackOverflowError}, when: 'either a or b contains itself or the other')
  @useResult static bool deep(Object? a, Object? b) {
    if (identical(a, b)) {
      return true;

    } else if (a is Set && b is Set) {
      return _unordered(a, b);

    } else if (a is Map && b is Map) {
      return _unordered(a.entries, b.entries);

    } else if ((a is List == b is List) && a is Iterable && b is Iterable) { // This should only be called when both objects, or neither objects are lists.
      return _ordered(a, b);

    } else if (a is MapEntry && b is MapEntry) {
      return deep(a.key, b.key) && deep(a.value, b.value);

    } else {
      return a == b;
    }
  }

  static bool _unordered(Iterable<Object?> a, Iterable<Object?> b) {
    if (a.length != b.length) {
      return false;
    }

    final counts = HashMap<Object?, int>(equals: deep, hashCode: HashCodes.deep);
    for (final element in a) {
      counts[element] = (counts[element] ?? 0) + 1;
    }

    for (final element in b) {
      final count = counts[element] ?? 0;
      if (count == 0) {
        return false;
      }

      counts[element] = count - 1;
    }

    return true;
  }

  static bool _ordered(Iterable<Object?> a, Iterable<Object?> b) {
    if (a.length != b.length) {
      return false;
    }

    final ai = a.iterator;
    final bi = b.iterator;

    while (ai.moveNext() && bi.moveNext()) {
      if (!deep(ai.current, bi.current)) {
        return false;
      }
    }

    return true;
  }

}

/// Provides functions for computing the hashcodes of objects.
extension HashCodes on Never {

  static const Type _list = List;
  static const Type _set = Set;
  static const Type _iterable = Iterable;
  static const Type _map = Map;
  static const Type _entry = MapEntry;

  /// Computes a deep hash code for the given [value]. This function works on lists, maps, sets, iterables and map entries.
  ///
  /// [DeepEqualityIterable.hashValue] and [DeepEqualityMap.hashValue] should be preferred when working directly with collections.
  ///
  /// **Contract: **:
  /// [value] may not contain itself. Doing so will result in a [StackOverflowError].
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// HashCodes.deep(a) // Throws a StackOverflowError
  /// ```
  @Possible({StackOverflowError}, when: 'either a or b contains itself or the other')
  @useResult static int deep(Object? value) {
    if (value is List) {
      return _ordered(_list, value);

    } else if (value is Set) {
      return _unordered(_set, value);

    } else if (value is Iterable) {
      return _unordered(_iterable, value);

    } else if (value is Map) {
      return _unordered(_map, value.entries);

    } else if (value is MapEntry) {
      return _ordered(_entry, [value.key, value.value]);

    } else {
      return value.hashCode;
    }
  }

  static int _ordered(Type type, Iterable<Object?> iterable) {
    var value = type.hashCode; // This is to reduce hash collisions between different types.
    for (final element in iterable) {
      value = 31 * value + deep(element);
    }
    return value;
  }

  static int _unordered(Type type, Iterable<Object?> iterable) {
    var value = type.hashCode; // This is to reduce hash collisions between different types.
    for (final element in iterable) {
      value += deep(element); // This computation needs to be commutative for it to work with unordered collections.
    }
    return value;
  }

}
