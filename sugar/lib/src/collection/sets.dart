import 'package:sugar/core.dart';

/// Provides functions for working with [Set]s.
extension Sets<E> on Set<E> {

  /// Replaces all elements in this [Set] using the given function. The given function accepts another function used to
  /// add replacement(s). An element can be replaced by zero or more elements.
  ///
  /// This function is the equivalent of a mutating [fold].
  ///
  /// ### Example:
  /// ```dart
  /// {1, 2, 3, 4}.replaceAll((replace, element) { if (element.isOdd) replace(element * 10); }); // [10, 30]
  /// ```
  ///
  /// ### Contract:
  /// The given [function] should not modify this [Set]. A [ConcurrentModificationError] will otherwise be thrown.
  ///
  /// ```dart
  /// final foo = {1};
  /// foo.replaceAll((replace, element) => foo.remove(0)); // throws ConcurrentModificationError
  /// ```
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

  /// Adds the [element] to this [Set] if not null.
  ///
  /// Returns `true` if the element was added to this [Set]. That is to say, if the element was not null and this [Set] did not
  /// already contain the element. Otherwise, returns `false`.
  ///
  /// ### Example:
  /// ```dart
  /// {}.addIfNonNull(1); // {1}, true
  ///
  /// {1}.addIfNonNull(1); // {1}, false
  ///
  /// {}}.addIfNonNull(null); // {}, false
  /// ```
  bool addIfNonNull(E? element) => element != null && add(element);

}
