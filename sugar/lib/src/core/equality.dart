import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Provides functions for determining the deep equality of [Iterable]s.
///
///
extension DeepEqualityIterable on Iterable<Object?> {

  /// Determines if this and [other] are deeply equal.
  ///
  /// A list is only equal to another list if they contain the same elements in the same order. All other iterables only
  /// need to contain the same elements to be equal.
  ///
  /// This function is unlike [Iterable.==] which is identity-based.
  ///
  /// ## Contract
  /// A [StackOverflowError] is thrown if this or [other] contain themselves.
  ///
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// a.equals([]); // Throws StackOverflowError
  /// ```
  @Possible({StackOverflowError})
  @useResult bool equals(Object? other) => Equality.deep(this, other);

  /// The deep hash-code.
  @useResult int get hashValue => HashCodes.deep(this);

}

/// Provides functions for determining the deep equality of [Map]s.
extension DeepEqualityMap on Map<Object?, Object?> {

  /// Determines if this and [other] are deeply equal.
  ///
  /// This function is unlike [Map.==] which is identity-based.
  ///
  /// ## Contract
  /// A [StackOverflowError] is thrown if this or [other] contain themselves.
  ///
  /// ```dart
  /// final a = <int, dynamic>{};
  /// a.add(a);
  ///
  /// a.equals(<int, dynamic>{}) // Throws StackOverflowError
  /// ```
  @Possible({StackOverflowError})
  @useResult bool equals(Object? other) => Equality.deep(this, other);

  /// The deep hash-code.
  @useResult int get hashValue => HashCodes.deep(this);

}

/// Provides functions for determining the deep equality of [MapEntry]s.
extension DeepEqualityMapEntry on MapEntry<Object?, Object?> {

  /// Determines if this and [other] are deeply equal.
  ///
  /// This function is unlike [MapEntry.==] which is identity-based.
  ///
  /// ## Contract
  /// A [StackOverflowError] is thrown if this or [other] contain themselves.
  @Possible({StackOverflowError})
  @useResult bool equals(Object? other) => Equality.deep(this, other);

  /// The deep hash-code.
  @useResult int get hashValue => HashCodes.deep(this);

}

/// Provides functions that determine the deep equality of objects.
extension Equality on Never {

  /// Determines if [a] and [b] are deeply equal.
  ///
  /// This function handles lists, maps, sets, iterables and map entries specially. A list is only equal to another list
  /// if they contain the same elements in the same order. All other iterables only need to contain the same elements to
  /// be equal.
  ///
  /// Where possible, [DeepEqualityIterable.equals] and [DeepEqualityMap.equals] are preferred.
  ///
  /// ## Contract
  /// A [StackOverflowError] is thrown if [a] or [b] contain themselves.
  ///
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// Equality.deep(a, ['some other list']) // Throws StackOverflowError
  /// ```
  @Possible({StackOverflowError})
  @useResult static bool deep(Object? a, Object? b) => switch ((a, b)) {
    (_, _) when identical(a, b) => true,
    (final List a, final List b) =>  _ordered(a, b),
    (final Iterable a, final Iterable b) => _unordered(a, b),
    (Map(entries: final a), Map(entries: final b)) => _unordered(a, b),
    (final MapEntry a, final MapEntry b) => deep(a.key, b.key) && deep(a.value, b.value),
    _ => a == b,
  };

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

/// Provides functions that compute the deep hashcodes of objects.
extension HashCodes on Never {

  static const Type _list = List;
  static const Type _set = Set;
  static const Type _iterable = Iterable;
  static const Type _map = Map;
  static const Type _entry = MapEntry;

  /// Computes [value]'s a deep hash code.
  ///
  /// This function handles lists, maps, sets, iterables and map entries specially.
  ///
  /// Where possible, [DeepEqualityIterable.hashValue] and [DeepEqualityMap.hashValue] are preferred.
  ///
  /// ## Contract
  /// A [StackOverflowError] is thrown if [value] contains itself.
  ///
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// HashCodes.deep(a) // Throws a StackOverflowError
  /// ```
  @Possible({StackOverflowError})
  @useResult static int deep(Object? value) => switch (value) {
    List _ => _ordered(_list, value),
    Set _ => _unordered(_set, value),
    Iterable _ => _unordered(_iterable, value),
    Map(:final entries) => _unordered(_map, entries),
    MapEntry(:final key, :final value) => _ordered(_entry, [key, value]),
    _ => value.hashCode,
  };

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
