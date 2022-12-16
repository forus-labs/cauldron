import 'dart:math';

import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Provides functions for splitting elements in an [Iterable].
///
/// See [Split] for more information.
extension SplittableIterable<E> on Iterable<E> {

  /// A [Split] that used to partition elements in this [Iterable].
  ///
  /// ```dart
  /// [1, 2, 3, 4].split.by(size: 2); // [ [1, 2], [3, 4], [5] ]
  /// ```
  @lazy @useResult Split<E> get split => Split._(this);

}

/// An intermediate operation for partitioning elements in an [Iterable] into chunks.
class Split<E> {

  final Iterable<E> _iterable;

  Split._(this._iterable);

  /// Splits this [Iterable] into [List]s not exceeding the given [size]. Any final elements are emitted at the end.
  ///
  /// ### Contract:
  /// [size] must be greater than 0. A [RangeError] will otherwise be thrown.
  ///
  /// ```dart
  /// final iterable = [1, 2, 3, 4].split.by(size: 2); // [ [1, 2], [3, 4], [5] ]
  /// ```
  @Possible({RangeError})
  @lazy @useResult Iterable<List<E>> by({required int size}) => window(length: size, by: size, partial: true);

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
  @lazy @useResult Iterable<List<E>> before(Predicate<E> predicate) sync* {
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
  @lazy @useResult Iterable<List<E>> after(Predicate<E> predicate) sync* {
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


  /// Returns an [Iterable] where each element is a sliding window of elements in this [Iterable]. A window's length is defined by
  /// [length] while the increment of each window is defined by [by]. Whether partial windows are returned is defined by [partial].
  ///
  /// ### Contract:
  /// Both [length] and [by] must be greater than 0. A [RangeError] will otherwise be thrown.
  ///
  /// ```dart
  /// // Overlapping windows
  /// [1, 2, 3, 4, 5].split.window(length: 3, by: 2); // [ [1, 2, 3], [3, 4, 5] ]
  ///
  /// // Non-overlapping windows
  /// [1, 2, 3, 4, 5].split.window(length: 2, by: 3); // [ [1, 2], [4, 5] ]
  ///
  ///
  /// // No partial windows
  /// [1, 2, 3, 4].split.window(length: 3, by: 2); // [ [1, 2, 3] ]
  ///
  /// // Partial windows
  /// [1, 2, 3, 4].split.window(length: 3, by: 2, partial: true); // [ [1, 2, 3], [3, 4] ]
  /// ```
  @Possible({RangeError})
  @lazy @useResult Iterable<List<E>> window({required int length, int by = 1, bool partial = false}) sync* {
    RangeError.checkValidRange(1, null, length);
    RangeError.checkValidRange(1, null, by);

    final iterator = _iterable.iterator;
    final window = <E>[];
    final overlap = max(0, length - by);
    final skip = max(0, by - length);
    final unused = length - overlap;

    while (true) {
      for (var i = window.length; i < length; i++) {
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
