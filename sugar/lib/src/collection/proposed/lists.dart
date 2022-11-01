import 'package:sugar/core.dart';
import 'package:sugar/src/core/equality.dart';

/// Provides functions for working with lists.
extension Lists<E> on List<E> {

  /// Determines whether this list contains an element at the given [index].
  bool has({required int index}) => 0 <= index && index < length;
  /// Swaps the elements at the given indexes.
  void swap(int a, int b) {
    if (a < 0 || length <= a) {
      throw RangeError.index(a, this);
    }

    if (b < 0 || length <= b) {
      throw RangeError.index(b, this);
    }

    final element = this[a];
    this[a] = this[b];
    this[b] = element;
  }


  /// Replaces elements that satisfy the given [where] predicate. Elements are replaced with the elements returned by [replace].
  /// An element is removed (without replacement) if [replace] returns `null`.
  ///
  /// ```dart
  /// final list = [1, 2, 3]..replace(where: (val) => 1 < val, (val) => val + 1);
  /// expect(list, [1, 3, 4]);
  /// ```
  ///
  /// **Notes: **
  /// * The list must be growable.
  /// * [E] must be non-nullable.
  void replace(E? Function(E) replace, {required Predicate<E> where}) {
    final list = <E>[];
    var modified = false;

    for (final element in this) {
      if (!where(element)) {
        list.add(element);
        continue;
      }

      final replacement = replace(element);
      if (replacement != null) {
        list.add(replacement);
      }

      modified = true;
    }

    if (modified) {
      setRange(0, list.length, list);
      length = list.length;
    }
  }

  /// Creates a list that contains this list, repeated the given number of times.
  List<E> operator *(int times) => [
    for (var i = 0; i < times; i++)
      ...this,
  ];

}
