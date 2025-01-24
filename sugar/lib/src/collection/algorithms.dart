import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// Returns true if [a] and [b] have no common elements.
///
/// ## Example
/// ```dart
/// disjoint([1, 2], [3, 4]); // true
/// disjoint([1, 2], []); // true
///
/// disjoint([1, 2], [2, 3]); // false
/// ```
///
/// ## Implementation details
/// This function assumes that the iterables have efficient length computations, i.e. the length is cached.
@useResult bool disjoint(Iterable<Object?> a, Iterable<Object?> b) {
  if (a.isEmpty || b.isEmpty) {
    return true;
  }

  final (iterable, contains) = switch ((a, b)) {
    (_, _) when a is Set<Object?> || (b is! Set<Object?> && a.length > b.length) => (b, a),
    _ => (a, b),
  };

  for (final element in iterable) {
    if (contains.contains(element)) {
      return false;
    }
  }

  return true;
}

/// Returns a copy of the [list] with its elements separated by those in [by].
///
/// ```dart
/// final original = [ Fi(), Fo(), Fum() ];
/// final list = separate(original, by: [ A(), B() ]);
///
/// print(list); // [ Fi(), A(), B(), Fo(), A(), B(), Fum() ]
/// ```
@useResult List<E> separate<E>(List<E> list, {required List<E> by}) {
  // No errors are thrown if [list] or [by] is empty as it is extremely disruptive to prototyping UIs in Flutter.
  final result = <E>[];
  for (var i = 0; i < list.length; i++) {
    result.add(list[i]);
    if (i < list.length - 1) {
      result.addAll(by);
    }
  }

  return result;
}
