import 'package:sugar/src/collection/equality.dart';

/// Provides useful functions for working with lists.
extension Lists<T> on List<T> {

  /// Inserts this list between the given values.
  void between(T first, {required T and}) => this..insert(0, first)..add(and);

  /// Inserts the given value between each element in this list.
  void space({required T by}) {
    for (var i = 1; i < length; i += 2) {
      insert(i, by);
    }
  }

  /// Creates a list that contains this list, repeated the given number of times.
  List<T> operator *(int times) => [
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
  bool equals(List<T> other) => equal(this, other);

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
