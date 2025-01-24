import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// Provides functions for splitting an [Iterable] into parts.
///
/// See [Split] for more information.
extension SplittableIterable<E> on Iterable<E> {
  /// A [Split] used to split this iterable's elements.
  ///
  /// ```dart
  /// [1, 2, 3, 4].split.by(size: 2); // [ [1, 2], [3, 4], [5] ]
  /// ```
  @lazy
  @useResult
  Split<E> get split => Split._(this);
}

/// A namespace for functions that split an [Iterable]'s elements.
///
/// To access [Split], call the [SplittableIterable.split] extension getter on an iterable.
///
/// ## Example
/// ```dart
/// [1, 2, 3, 4].split.by(size: 2); // [ [1, 2], [3, 4], [5] ]
/// ```
extension type Split<E>._(Iterable<E> _iterable) {
  /// Splits this iterable into lists of the given [size].
  ///
  /// ## Contract
  /// Throws a [RangeError] if `size <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// [1, 2, 3, 4, 5].split.by(size: 2); // [[1, 2], [3, 4], [5]]
  /// ```
  @Possible({RangeError})
  @lazy
  @useResult
  Iterable<List<E>> by({required int size}) => window(size: size, by: size, partial: true);

  /// Splits this iterable's elements into lists before those that satisfy [predicate].
  ///
  /// See [after] for splitting elements after those that satisfy [predicate].
  ///
  /// ```dart
  /// final parts = [1, 2, 3, 4, 5, 6, 7, 8, 9].split.before(primeNumber);
  ///
  /// print(parts); // [[1], [2], [3, 4], [5, 6], [7, 8, 9]]
  /// //                 ^----^----^-------^-------^---------- prime numbers
  /// ```
  @lazy
  @useResult
  Iterable<List<E>> before(Predicate<E> predicate) sync* {
    final iterator = _iterable.iterator;
    if (!iterator.moveNext()) {
      return;
    }

    var chunk = [iterator.current];
    while (iterator.moveNext()) {
      final element = iterator.current;
      if (predicate(element)) {
        yield chunk;
        chunk = [];
      }

      chunk.add(element);
    }

    yield chunk;
  }

  /// Splits this iterable's elements into lists after those that satisfy [predicate].
  ///
  /// See [before] for splitting elements before those that satisfy [predicate].
  ///
  /// ```dart
  /// final parts = [1, 2, 3, 4, 5, 6, 7, 8, 9].split.after(primeNumber);
  ///
  /// print(parts); // ([1], [2], [3], [4, 5], [6, 7], [8, 9])
  /// //                 ^----^----^-------^-------^----------- prime numbers
  /// ```
  @lazy
  @useResult
  Iterable<List<E>> after(Predicate<E> predicate) sync* {
    List<E>? chunk;
    for (final element in _iterable) {
      (chunk ??= []).add(element);
      if (predicate(element)) {
        yield chunk;
        chunk = null;
      }
    }

    if (chunk != null) {
      yield chunk;
    }
  }

  /// Split this iterable using a sliding window.
  ///
  /// The window's size is controlled by [size] while [by] controls the amount by which to increase the window's starting
  /// index. [partial] controls whether partial windows smaller than [size] at the end are emitted.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `size <= 0` or `by <= 0`.
  ///
  /// ## Example
  /// ```dart
  /// // Overlapping windows
  /// [1, 2, 3, 4, 5].split.window(size: 3, by: 2); // [[1, 2, 3], [3, 4, 5]]
  ///
  /// // Non-overlapping windows
  /// [1, 2, 3, 4, 5].split.window(size: 2, by: 3); // [[1, 2], [4, 5]]
  ///
  ///
  /// // No partial windows
  /// [1, 2, 3, 4].split.window(size: 3, by: 2); // [[1, 2, 3]]
  ///
  /// // Partial windows
  /// [1, 2, 3, 4].split.window(size: 3, by: 2, partial: true); // [[1, 2, 3], [3, 4]]
  /// ```
  @Possible({RangeError})
  @lazy
  @useResult
  Iterable<List<E>> window({required int size, int by = 1, bool partial = false}) sync* {
    RangeError.checkValidRange(1, null, size);
    RangeError.checkValidRange(1, null, by);

    final iterator = _iterable.iterator;
    final window = <E>[];
    final overlap = max(0, size - by);
    final skip = max(0, by - size);
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

      for (var i = 0; i < skip; i++) {
        if (!iterator.moveNext()) {
          return;
        }
      }
    }
  }
}
