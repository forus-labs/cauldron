import 'dart:collection';

import 'package:meta/meta.dart';

/// Determines if [a] and [b] are deeply equal.
///
/// **Contract: **:
/// Both [a] and [b] may not contain itself or the other given value. Doing so will result in a [StackOverflowError].
/// ```dart
/// final a = [];
/// a.add(a);
///
/// equal(a, ['some other list']) // Throws a StackOverflowError
/// ```
@internal bool equal(dynamic a, dynamic b) {
  if (identical(a, b)) {
    return true;

  } else if (a is List && b is List) {
    return _listEqual(a, b);

  } else if (a is Set && b is Set) {
    return _unorderedEqual(a, b);

  } else if (a is Map && b is Map) {
    return _unorderedEqual(a.entries, b.entries);

  } else if (a is MapEntry && b is MapEntry) {
    return equal(a.key, b.key) && equal(a.value, b.value);

  } else {
    return a == b;
  }
}

bool _listEqual(List<dynamic> a, List<dynamic> b) {
  if (a.length != b.length) {
    return false;
  }

  for (var i = 0; i < a.length; i++) {
    if (!equal(a[i], b[i])) {
      return false;
    }
  }

  return true;
}

bool _unorderedEqual(Iterable<dynamic> a, Iterable<dynamic> b) {
  if (a.length != b.length) {
    return false;
  }

  final counts = HashMap<dynamic, int>(equals: equal, hashCode: hashCode);
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


/// Computes a deep hash code for the given [value].
///
/// **Contract: **:
/// [value] may not contain itself. Doing so will result in a [StackOverflowError].
/// ```dart
/// final a = [];
/// a.add(a);
///
/// hashCode(a) // Throws a StackOverflowError
/// ```
@internal int hashCode(dynamic value) {
  if (value is List || value is Set) {
    return _iterableHashCode(value);

  } else if (value is Map) {
    return _iterableHashCode(value.entries);

  } else if (value is MapEntry) {
    return Object.hash(value.key, value.value);
    
  } else {
    return value.hashCode;
  }
}

int _iterableHashCode(Iterable<dynamic> iterable) {
  var hash = 1;
  for (final element in iterable) {
    hash = 31 * hash + hashCode(element);
  }
  return hash;
}
