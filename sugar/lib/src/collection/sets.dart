import 'package:sugar/core.dart';

/// Provides functions for working with [Set]s.
extension Sets<E> on Set<E> {
  /// Adds the [element] to this set if it is not in this set. Otherwise removes the [element] from this set.
  ///
  /// ```dart
  /// {1}.toggle(1); // {}
  /// {}.toggle(1); // {1}
  /// ```
  void toggle(E element) {
    if (!remove(element)) {
      add(element);
    }
  }

  /// Replaces all elements using [function].
  ///
  /// [function] accepts a [Consume] used to specify an element's zero or more replacements. This function is an in-place
  /// 1:N [map] function.
  ///
  /// ## Contract
  /// A [ConcurrentModificationError] is thrown if [function] directly modifies this set.
  ///
  /// ```dart
  /// final foo = {1};
  /// foo.replaceAll((_, _) => foo.remove(0)); // throws ConcurrentModificationError
  /// ```
  ///
  /// ## Example
  /// ```dart
  /// void multiplyOdd(Consume<int> replace, int element) {
  ///   if (element.isOdd)
  ///     replace(element * 10);
  /// }
  ///
  /// {1, 2, 3, 4}.replaceAll(multiplyOdd); // {10, 30}
  /// ```
  ///
  @Possible({ConcurrentModificationError})
  void replaceAll(void Function(bool Function(E element) replace, E element) function) {
    final retained = <E>{};
    final length = this.length;

    for (final element in this) {
      function(retained.add, element);

      if (length != this.length) {
        throw ConcurrentModificationError(this);
      }
    }

    clear();
    addAll(retained);
  }
}

/// Provides functions for working with [Set]s of null-nullable elements.
extension NonNullableSet<E extends Object> on Set<E> {
  /// Adds the [element] to this set and returns `true` if not null.
  ///
  /// ```dart
  /// {}.addIfNonNull(1); // {1}, true
  ///
  /// {}.addIfNonNull(null); // {}, false
  /// ```
  bool addIfNonNull(E? element) => element != null && add(element);
}
