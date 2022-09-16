import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Returns true if the given [Iterable]s have no elements in common.
///
/// **Implementation details: **
/// This implementation assumes that the given iterables have efficient length computations, i.e. the length is cached.
/// This is true for most standard library collections.
bool disjoint<E>(Iterable<E> a, Iterable<E> b) {
  // This implementation is borrowed from Java's Collections.disjoint(...) method.
  var iterable = a;
  var contains = b;

  if (a is Set<E>) {
    iterable = b;
    contains = a;

  } else if (b is! Set<E>) {
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

/// Returns a copy of the given [list] with elements separated by all elements in [by].
///
/// ```dart
/// final column = Column(
///   children: separate([
///     Widget(),
///     Widget(),
///     Widget(),
///   ], by: [
///     Divider(),
///     Space(),
///   ]),
/// );
///
/// print(column);
/// // Column(
/// //   children: [
/// //     Widget(),
/// //     Divider(),
/// //     Space(),
/// //     Widget(),
/// //     Divider(),
/// //     Space(),
/// //     Widget(),
/// //   ],
/// // );
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

/// Reverses a list, or a part of a list, in-place.
///
/// **Contract: **
/// 0 <= [start] < [end] <= [list] length. A [RangeError] will otherwise be thrown
/// 
/// ```dart
/// final list = [0, 1, 2, 3, 4];
/// reverse(list, 1, 4);
/// print(list); // [0, 3, 2, 1, 4]
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
