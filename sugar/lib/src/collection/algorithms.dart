import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Returns true if [a] and [b] have no common elements.
///
/// ## Example
/// ```dart
/// print(disjoint([1, 2], [3, 4])); // true
/// print(disjoint([1, 2], [])); // true
///
/// print(disjoint([1, 2], [2, 3])); // false
/// ```
///
/// ## Implementation details
/// This function assumes that the iterables have efficient length computations, i.e. the length is cached. This is true
/// for most standard library collections.
@useResult bool disjoint(Iterable<Object?> a, Iterable<Object?> b) {
  // This implementation is borrowed from Java's Collections.disjoint(...) method.
  var iterable = a;
  var contains = b;

  if (a is Set<Object?>) {
    iterable = b;
    contains = a;

  } else if (b is! Set<Object?>) {
    final aLength = a.length;
    final bLength = b.length;
    if (aLength == 0 || bLength == 0) {
      return true;
    }

    if (aLength > bLength) {
      iterable = b;
      contains = a;
    }
  }

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

/// Reverses a list, or part of between [start], inclusive and [end], exclusive, in-place.
///
/// ## Contract
/// 0 <= [start] < [end] <= [list] length. Throws a [RangeError] otherwise.
/// 
/// ## Example
/// ```dart
/// final list = [0, 1, 2, 3, 4];
/// reverse(list, 1, 5);
/// 
/// print(list); // [0, 4, 3, 2, 1]
/// ```
@Possible({RangeError})
void reverse(@mutated List<Object?> list, [int start = 0, int? end]) {
  end = RangeError.checkValidRange(start, end, list.length);
  for (var i = start, j = end - 1; i < j; i++, j--) {
    final element = list[i];
    list[i] = list[j];
    list[j] = element;
  }
}
