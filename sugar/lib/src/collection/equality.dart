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
/// equal(a, []) // Throws a StackOverflowError
/// ```
@internal bool equal(dynamic a, dynamic b) {
  if (identical(a, b)) {
    return true;

  } else if (a is List && b is List) {
    return _listEqual(a, b);

  } else if (a is Set && b is Set) {
    return _setEqual(a, b);

  } else if (a is Map && b is Map) {

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

bool _setEqual(Set<dynamic> a, Set<dynamic> b) {
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



@internal int hashCode(dynamic value) {
  if (value is Iterable) {
    var hash = 1;
    for (final element in value) {
      hash = 31 * hash + hashCode(element);
    }
    return hash;
  }
}
