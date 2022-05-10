import 'package:sugar/core.dart';
import 'package:sugar/src/collection/equality.dart';

/// Provides functions for working with lists.
extension Lists<E> on List<E> {

  /// Inserts this list between the given values.
  void between(E first, {required E and}) => this..insert(0, first)..add(and);

  /// Inserts the given value between each element in this list.
  void space({required E by}) {
    for (var i = 1; i < length; i += 2) {
      insert(i, by);
    }
  }

  /// Swaps the elements at the given indexes.
  @Throws({RangeError}, when: 'Either a or b is < 0 or >= length')
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


  /// Replaces elements that satisfy the given [predicate]. Elements are replaced with the values returned by [replace].
  /// An element is removed (without replacement) if [replace] returns `null`.
  ///
  /// **Notes: **
  /// * The list must be growable.
  /// * [E] must be non-nullable.
  void replaceWhere(bool Function(E) predicate, E? Function(E) replace) {
    final list = <E>[];
    var modified = false;

    for (final element in this) {
      if (!predicate(element)) {
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

  /// Determines if this list and [other] are deeply equal.
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
  bool equals(List<E> other) => equal(this, other);

  /// Computes the hash-code of this list using the the contained elements.
  ///
  /// This method is provided as an alternative to a [List]'s default identity-based `hashCode` implementation.
  ///
  /// **Contract: **:
  /// This list may not contain itself. Doing so will result in a [StackOverflowError].
  /// ```dart
  /// final a = [];
  /// a.add(a);
  ///
  /// a.hash // Throws a StackOverflowError
  /// ```
  int get hash => hashCode(this);

}
