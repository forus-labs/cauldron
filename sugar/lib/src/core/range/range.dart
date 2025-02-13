import 'package:meta/meta.dart';

import 'package:sugar/sugar.dart';

part 'unbound.dart';
part 'interval.dart';
part 'max.dart';
part 'min.dart';

/// A [Range] represents a convex (contiguous) portion of a domain.
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in a [Range]. Doing so will result in undefined behaviour.
///
/// See:
/// * [Unbound] for a range that is unbound on both ends.
/// * [Min] and [Max] for a range that is bound on one end.
/// * [Interval] for a range that is bound on both ends.
sealed class Range<T extends Comparable<Object?>> {
  /// Creates a [Range].
  const Range();

  /// Returns `true` if this contains [value].
  ///
  /// ```dart
  /// final min = Min.open(0);
  ///
  /// min.contains(1); // true
  /// min.contains(-1); // false
  /// ```
  @useResult
  bool contains(T value);

  /// Returns `true` if this contains all [values].
  ///
  /// ```dart
  /// final min = Min.open(0);
  ///
  /// min.containsAll([1, 2, 3]); // true
  /// min.containsAll([-1, 2, 3]); // false
  /// ```
  @useResult
  @nonVirtual
  bool containsAll(Iterable<T> values) => values.every(contains);

  /// If this does not intersect [other], returns the gap in between. Otherwise returns `null`.
  ///
  /// ```dart
  /// final foo = Interval.open(1, 5);
  /// final bar = Interval.closed(7, 9);
  ///
  /// foo.gap(bar); // { x | 5 <= x < 7 }
  ///
  ///
  /// Min.closed(7).gap(Max.open(5)); // { x | 5 <= x < 7 }
  ///
  /// Max.closed(5).gap(Interval.open(7, 9)); // { x | 5 < x <= 7 }
  ///
  /// Interval.open(1, 5).gap(Interval.closed(3, 7)); // null
  /// ```
  @useResult
  Interval<T>? gap(Range<T> other);

  /// If this intersects [other], returns the intersection. Otherwise returns `null`.
  ///
  /// See [intersects] for determining if two ranges intersect.
  ///
  /// ```dart
  /// final foo = Interval.open(1, 5);
  /// final bar = Interval.closed(3, 7);
  ///
  /// foo.intersection(bar); // [3..5), { x | 3 <= x < 5 }
  ///
  ///
  /// Min.open(5).intersection(Min.closed(7)); // [7..+∞)
  ///
  /// Max.open(5).intersection(Max.closed(7)); // (-∞..5)
  ///
  /// Interval.open(1, 5).intersection(Interval.open(7, 9)); // null
  /// ```
  @useResult
  Range<T>? intersection(Range<T> other);

  /// Returns `true` if an empty range exists between this and [other].
  ///
  /// Discrete ranges are not considered to be besides each other even though there are no elements "between them",
  /// i.e. `[1..4]` is not beside `[5..7]`.
  ///
  /// This function is reflexive and symmetric.
  ///
  /// ## Examples
  /// ```dart
  /// final a = Interval.closedOpen(1, 3);
  /// final b = Interval.closedOpen(3, 5);
  ///
  /// a.besides(b); // true, [1..3) is beside [3..5)
  ///```
  ///
  /// ```dart
  /// final a = Interval.closed(1, 3);
  /// final b = Interval.open(3, 5);
  ///
  /// a.besides(b); // true, [1..3] is beside (3..5)
  /// ```
  ///
  /// ```dart
  /// final a = Interval.closed(1, 5);
  /// final b = Interval.open(3, 7);
  ///
  /// a.besides(b); // false, [1..5] is not beside (3..7)
  /// ```
  ///
  /// ```dart
  /// final a = Interval.closed(1, 3);
  /// final b = Interval.open(5, 7);
  ///
  /// a.besides(b); // false, [1..3] is not beside (5..7)
  /// ```
  ///
  /// ```dart
  /// final a = Interval.closed(1, 4);
  /// final b = Interval.closed(5, 7);
  ///
  /// a.besides(b); // false, [1..4] is not beside [5..7], discrete range
  /// ```
  @useResult
  bool besides(Range<T> other);

  /// Returns `true` if [other]'s bounds do not extend outside this bounds.
  ///
  /// It is not possible for an [Interval] to enclose a [Min] or [Max]. Neither is it possible for a `Min` to enclose a
  /// `Max` and vice versa.
  ///
  /// A discrete range is not considered to be enclosed by another under certain circumstances, i.e. `[4..5]` does not
  /// enclose `(3..6)`.
  ///
  /// A [Range] that [encloses] another `Range` always [intersects].
  ///
  /// This method is reflexive, anti-symmetric and transitive.
  ///
  /// ## Examples
  /// ```dart
  /// final a = Interval.closed(1, 4);
  /// final b = Interval.closedOpen(2, 3);
  ///
  /// a.encloses(b); // true, [1..4] encloses [2..3]
  /// ```
  ///
  /// ```dart
  /// final a = Interval.open(1, 4);
  /// final b = Interval.open(1, 4);
  ///
  /// a.encloses(b); // true, (1..4) encloses (1..4)
  /// ```
  ///
  /// ```dart
  /// final a = Interval.open(1, 4);
  /// final b = Interval.closedOpen(2, 2);
  ///
  /// a.encloses(b); // true, (1..4) encloses [2..2)
  /// ```
  ///
  /// ```dart
  /// final a = Interval.openClosed(3, 6);
  /// final b = Interval.openClosed(2, 8);
  ///
  /// a.encloses(b); // false, (3..6] does not enclose (2..8]
  /// ```
  ///
  /// ```dart
  /// final a = Interval.openClosed(3, 6);
  /// final b = Interval.closed(3, 6);
  ///
  /// a.encloses(b); // false, (3..6] does not enclose [3..6]
  /// ```
  ///
  /// ```dart
  /// final a = Interval.closed(4, 5);
  /// final b = Interval.open(3, 6);
  ///
  /// a.encloses(b); // false, [4..5] does not enclose (3..6), discrete range
  /// ```
  ///
  /// ```dart
  /// final a = Interval.openClosed(3, 6);
  /// final b = Interval.closedOpen(1, 1);
  ///
  /// a.encloses(b); // false, (3..6] does not enclose (1..1]
  /// ```
  @useResult
  bool encloses(Range<T> other);

  /// Returns `true` if a non-empty range exists between this and [other].
  ///
  /// See [intersection] for computing the intersection of two ranges.
  ///
  /// This method is reflexive and symmetric.
  ///
  /// ## Examples
  /// ```dart
  /// final a = Interval.closed(1, 4);
  /// final b = Interval.closed(1, 4);
  ///
  /// a.intersects(b); // true, [1..4] intersects [1..4]
  /// ```
  ///
  /// ```dart
  /// final a = Interval.closed(1, 4);
  /// final b = Interval.closedOpen(2, 3);
  ///
  /// a.intersects(b); // true, [1..4] intersects [2..3]
  /// ```
  ///
  /// ```dart
  /// final a = Interval.openClosed(3, 6);
  /// final b = Interval.openClosed(2, 8);
  ///
  /// a.intersects(b); // true, (3..6] intersects (4..8]
  /// ```
  ///
  /// ```dart
  /// final a = Interval.openClosed(3, 6);
  /// final b = Interval.closedOpen(1, 2);
  ///
  /// a.intersects(b); // false, (3..6] does not intersect (1..2]
  /// ```
  ///
  /// ```dart
  /// final a = Interval.closedOpen(1, 3);
  /// final b = Interval.closedOpen(3, 5);
  ///
  /// a.besides(b); // false, [1..3) does not intersect [3..5)
  /// ```
  @useResult
  bool intersects(Range<T> other);

  /// Return `true` if this is empty, i.e. `[a..a)`.
  ///
  /// Only a range with bounds at both ends, i.e. [Interval], can be empty.
  ///
  /// ```dart
  /// final interval = Interval.openClosed(1, 1);
  ///
  /// print(interval.empty); // true
  ///```
  @useResult
  bool get empty;
}

/// A [Range] that is also iterable.
///
/// It is possible to iterate over a [Range] using [iterate].
sealed class IterableRange<T extends Comparable<Object?>> extends Range<T> {
  /// Creates an [IterableRange].
  const IterableRange();

  /// Returns a lazy `Iterable` by stepping through this range using [by].
  ///
  /// The returned [Iterable] is lazy and potentially infinite.
  ///
  /// ```dart
  /// final range = Interval.closedOpen(0, 5);
  /// range.iterate(by: (e) => e + 1).toList(); // [0, 1, 2, 3, 4]
  /// ```
  @useResult
  @lazy
  Iterable<T> iterate({required T Function(T current) by});
}

/// A convenience alias for [Comparable].
@internal
typedef C = Comparable<Object?>;

/// Provides functions for determining whether two [Range]s intersect.
@internal
extension Intersects on Never {
  /// Returns `true` if the given [min] and [max] intersect.
  static bool minMax<T extends C>(Min<T> min, Max<T> max) {
    final comparison = min.value.compareTo(max.value);
    return (comparison < 0) || (comparison == 0 && min.closed && max.closed);
  }

  /// Returns `true` if the given [min] and [interval] intersect.
  static bool minInterval<T extends C>(Min<T> min, Interval<T> interval) {
    final comparison = min.value.compareTo(interval.max.value);
    return (comparison < 0) || (comparison == 0 && min.closed && !interval.max.open);
  }

  /// Returns `true` if the given [max] and [interval] intersect.
  static bool maxInterval<T extends C>(Max<T> max, Interval<T> interval) {
    final comparison = interval.min.value.compareTo(max.value);
    return (comparison < 0) || (comparison == 0 && !interval.min.open && max.closed);
  }

  /// Returns `true` if [a] intersects [b].
  static bool intervalInterval<T extends C>(Interval<T> a, Interval<T> b) =>
      within(a, b.min) || within(a, b.max) || within(b, a.min) || within(b, a.max);

  /// Returns `true` if the given [interval] contains the given [bound].
  static bool within<T extends C>(Interval<T> interval, ({T value, bool open}) bound) {
    final (:value, :open) = bound;
    final minimum = interval.min.value.compareTo(value);
    if (minimum > 0 || (minimum == 0 && (interval.min.open || open))) {
      return false;
    }

    final maximum = interval.max.value.compareTo(value);
    if (maximum < 0 || (maximum == 0 && (interval.max.open || open))) {
      return false;
    }

    return true;
  }
}

/// Provides functions for determining whether two [Range]s are besides each other.
@internal
extension Besides on Never {
  /// Returns `true` if the given [min] and [max] are beside each other.
  static bool minMax<T extends C>(Min<T> min, Max<T> max) => min.open == max.closed && min.value == max.value;

  /// Returns `true` if the given [min] and [interval] are beside each other.
  static bool minInterval<T extends C>(Min<T> min, Interval<T> interval) =>
      min.open == !interval.max.open && min.value == interval.max.value;

  /// Returns `true` if the given [max] and [interval] are beside each other.
  static bool maxInterval<T extends C>(Max<T> max, Interval<T> interval) =>
      max.open == !interval.min.open && max.value == interval.min.value;
}
