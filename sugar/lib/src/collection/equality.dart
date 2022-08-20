import 'dart:collection';

import 'package:sugar/core.dart';

/// Provides functions for determining the deep equality of [Iterable]s.
extension DeepIterableEquality on Iterable<Object?> {

  /// Determines if this iterable and [other] are deeply equal.
  ///
  /// This method is provided as an alternative to a [List]'s default identity-based `==` implementation.
  ///
  /// **Contract: **:
  /// Both this list and [other] may not contain itself or the other value. Doing so will result in a [StackOverflowError].
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// a.equals([]) // Throws a StackOverflowError
  /// ```
  @Throws({StackOverflowError}, when: 'either a or b contains itself or the other')
  bool equals(Object? other) => DeepEquality.equal(this, other);

  /// The deep hash-code of this list.
  int get hashValue => DeepEquality.hashValue(this);

}

/// Provides functions for determining the deep equality of [Map]s.
extension DeepMapEquality on Map<Object?, Object?> {

  /// Determines if this map and [other] are deeply equal.
  ///
  /// This method is provided as an alternative to a [Map]'s default identity-based `==` implementation.
  ///
  /// **Contract: **:
  /// Both this map and [other] may not contain itself or the other value. Doing so will result in a [StackOverflowError].
  /// ```dart
  /// final a = <int, dynamic>{};
  /// a.add(a);
  ///
  /// a.equals(<int, dynamic>{}) // Throws a StackOverflowError
  /// ```
  @Throws({StackOverflowError}, when: 'either a or b contains itself or the other')
  bool equals(Object? other) => DeepEquality.equal(this, other);

  /// The deep hash-code of this list.
  int get hashValue => DeepEquality.hashValue(this);

}

/// Provides functions for determining the deep equality of collections.
extension DeepEquality on Never {

  /// Determines if [a] and [b] are deeply equal. This function works on lists, maps, sets, iterables and map entries;
  /// iterables are expected to have the same order.
  ///
  /// **Contract: **:
  /// Both [a] and [b] may not contain itself or the other given value. Doing so will result in a [StackOverflowError].
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// DeepEquality.equal(a, ['some other list']) // Throws a StackOverflowError
  /// ```
  ///
  /// **Motivation: **
  /// The default implementations of `==` is identity-based for most Dart collections. This can lead to unintuitive behaviour
  /// when comparing collections. It is natural to expect that two collections with the same elements are equal. However,
  /// using the default identity-based `==` operator, both collections are not equal.
  @Throws({StackOverflowError}, when: 'either a or b contains itself or the other')
  static bool equal(Object? a, Object? b) {
    if (identical(a, b)) {
      return true;

    } else if (a is Set && b is Set) {
      return _unordered(a, b);

    } else if (a is Map && b is Map) {
      return _unordered(a.entries, b.entries);

    } else if (a is Iterable && b is Iterable) {
      return _ordered(a, b);

    } else if (a is MapEntry && b is MapEntry) {
      return equal(a.key, b.key) && equal(a.value, b.value);

    } else {
      return a == b;
    }
  }

  static bool _unordered(Iterable<Object?> a, Iterable<Object?> b) {
    if (a.length != b.length) {
      return false;
    }

    final counts = HashMap<Object?, int>(equals: equal, hashCode: hashValue);
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
      if (!equal(ai.current, bi.current)) {
        return false;
      }
    }

    return true;
  }


  /// Computes a deep hash code for the given [value]. This function works on lists, maps, sets, iterables and map entries.
  ///
  /// **Contract: **:
  /// [value] may not contain itself. Doing so will result in a [StackOverflowError].
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// DeepEquality.hash(a) // Throws a StackOverflowError
  /// ```
  @Throws({StackOverflowError}, when: 'either a or b contains itself or the other')
  static int hashValue(Object? value) {
    if (value is Iterable) {
      return _iterableHashCode(value);

    } else if (value is Map) {
      return _iterableHashCode(value.entries);

    } else if (value is MapEntry) {
      return _iterableHashCode([value.key, value.value]);

    } else {
      return value.hashCode;
    }
  }

  static int _iterableHashCode(Iterable<Object?> iterable) {
    var value = 1;
    for (final element in iterable) {
      value = 31 * value + hashValue(element);
    }
    return value;
  }

}
