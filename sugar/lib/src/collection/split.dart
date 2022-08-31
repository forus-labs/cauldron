import 'dart:math';

import 'package:sugar/core.dart';

/// An intermediate operation for partitioning elements in an [Iterable]. Provides functions for splitting an [Iterable] into chunks.
class Split<E> {

  final Iterable<E> _iterable;

  Split._(this._iterable);

  /// Splits this [Iterable] into [List]s not exceeding the given [size]. Any final elements are emitted at the end.
  ///
  /// **Contract: **
  /// [size] must be greater than 0. A [RangeError] will otherwise be thrown.
  ///
  /// ```dart
  /// final iterable = [1, 2, 3, 4].split.by(size: 2);
  /// print(iterable); // [[1, 2], [3, 4], [5]]
  /// ```
  @Throws({RangeError})
  @lazy Iterable<List<E>> by({required int size}) => window(size: size, by: size, partial: true);

  /// Splits the elements this [Iterable] into [List]s before elements that match the given predicate. Any final elements
  /// are emitted at the end.
  ///
  /// ```dart
  /// final parts = [1, 2, 3, 4, 5, 6, 7, 8, 9].split.before(prime);
  ///
  /// print(parts); // ([1], [2], [3, 4], [5, 6], [7, 8, 9])
  ///                    ^----^----^-------^-------^---------- prime numbers
  /// ```
  ///
  /// See [after] for splitting elements after those that match a given predicate.
  Iterable<List<E>> before(bool Function(E element) test) sync* {
    final iterator = _iterable.iterator;
    if (!iterator.moveNext()) {
      return;
    }

    var chunk = [iterator.current];
    while (iterator.moveNext()) {
      final element = iterator.current;
      if (test(element)) {
        yield chunk;
        chunk = [];
      }

      chunk.add(element);
    }

    yield chunk;
  }

  /// Splits the elements this [Iterable] into [List]s after elements that match the given predicate. Any final elements
  /// are emitted at the end.
  ///
  /// ```dart
  /// final parts = [1, 2, 3, 4, 5, 6, 7, 8, 9].split.after(prime);
  ///
  /// print(parts); // ([1], [2], [3], [4, 5], [6, 7], [8, 9])
  ///                    ^----^----^-------^-------^----------- prime numbers
  /// ```
  ///
  /// See [before] for splitting elements before those that match a given predicate.
  Iterable<List<E>> after(bool Function(E element) test) sync* {
    List<E>? chunk;
    for (final element in _iterable) {
      (chunk ??= []).add(element);
      if (test(element)) {
        yield chunk;
        chunk = null;
      }
    }

    if (chunk != null) {
      yield chunk;
    }
  }


  /// Returns an [Iterable] where each element is a sliding window of elements in this [Iterable]. A window's size is defined by
  /// [size] while the increment of each window is defined by [by]. Whether partial windows are returned is defined by [partial].
  ///
  /// **Contract: **
  /// Both [size] and [by] must be greater than 0. A [RangeError] will otherwise be thrown.
  ///
  /// ```dart
  /// // Overlapping windows
  /// final iterable = [1, 2, 3, 4, 5].split.window(size: 3, by: 2);
  /// print(iterable); // [[1, 2, 3], [3, 4, 5]]
  ///
  /// // Non-overlapping windows
  /// final iterable = [1, 2, 3, 4, 5].split.window(size: 2, by: 3);
  /// print(iterable); // [[1, 2], [4, 5]]
  ///
  ///
  /// // No partial windows
  /// final iterable = [1, 2, 3, 4].split.window(size: 3, by: 2);
  /// print(iterable); // [[1, 2, 3]]
  ///
  /// // Partial windows
  /// final iterable = [1, 2, 3, 4].split.window(size: 3, by: 2, partial: true);
  /// print(iterable); // [[1, 2, 3], [3, 4]]
  /// ```
  @Throws({RangeError})
  @lazy Iterable<List<E>> window({required int size, int by = 1, bool partial = false}) sync* {
    RangeError.checkNotNegative(size, 'size');
    RangeError.checkNotNegative(by, 'by');

    final iterator = _iterable.iterator;
    final window = <E>[];
    final overlap = max<int>(0, size - by);
    final unused = size - overlap;

    while (true) {
      for (var i = window.length; i < size; i++) {
        if (!iterator.moveNext()) {
          if (partial && overlap < window.length) {
            yield [...window];
          }

          return;
        }

        window.add(iterator.current);
      }

      yield [...window];

      window.removeRange(0, unused);
    }
  }

}

/// Provides functions for accessing splitting functions.
extension SplitIterable<E> on Iterable<E> {

  /// A [Split] that used to partition elements in this [Iterable].
  ///
  /// ```dart
  /// final iterable = [1, 2, 3, 4].split.by(size: 2);
  /// print(iterable); // [[1, 2], [3, 4], [5]]
  /// ```
  ///
  /// See [Split] for more information.
  Split<E> get split => Split._(this);

}
