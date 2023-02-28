import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A [Range] represents a convex (contiguous) portion of a domain.
///
/// It is possible to iterate over a [Range] using [iterate].
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in a [Range]. Doing so will result in undefined behaviour.
///
/// See [Min] and [Max] for a range that is bound on one end.
/// See [Interval] for a range that is bound on both ends.
@sealed abstract class Range<T extends Comparable<Object?>> {

  /// Creates a [Range].
  const Range();

  /// Returns `true` if  this [Range] contains the given value.
  ///
  /// ### Example:
  /// ```dart
  /// final min = Min.open(0);
  ///
  /// min.contains(1); // true
  /// min.contains(-1); // false
  /// ```
  @useResult bool contains(T value);

  /// Returns `true` if this [Range] contains all of the given value.
  ///
  /// ### Example:
  /// ```dart
  /// final min = Min.open(0);
  ///
  /// min.containsAll([1, 2, 3]); // true
  /// min.containsAll([-1, 2, 3]); // false
  /// ```
  @useResult @nonVirtual bool containsAll(Iterable<T> values) => values.every(contains);

  /// Creates a lazy [Iterable] over this [Range]. The given function produces a value in the returned [Iterable] using
  /// the previous value for each iteration.
  ///
  /// Note: The returned [Iterable] is lazy and potentially infinite.
  ///
  /// ### Example:
  /// ```dart
  /// final range = Interval.closedOpen(0, 5);
  /// range.iterate(by: (e) => e + 1).toList(); // [0, 1, 2, 3, 4]
  /// ```
  @useResult @lazy Iterable<T> iterate({required T Function(T current) by});

  /// If this [Range] does not intersect [other], returns the gap in between. Otherwise returns `null`.
  ///
  /// ### Example:
  /// ```dart
  /// Interval.open(1, 5).gap(Interval.closed(7, 9)); // [5..7), { x | 5 <= x < 7 }
  ///
  /// Min.closed(7).gap(Max.open(5)); // [5..7)
  ///
  /// Max.closed(5).gap(Interval.open(7, 9)); // (5..7]
  ///
  /// Interval.open(1, 5).gap(Interval.closed(3, 7)); // null
  /// ```
  @useResult Interval<T>? gap(Range<T> other);

  /// If this [Range] intersects [other], returns the intersection. Otherwise returns `null`.
  ///
  /// ### Example:
  /// ```dart
  /// Interval.open(1, 5).intersection(Interval.closed(3, 7)); // [3..5), { x | 3 <= x < 5 }
  ///
  /// Min.open(5).intersection(Min.closed(7)); // [7..+∞)
  ///
  /// Max.open(5).intersection(Max.closed(7)); // (-∞..5)
  ///
  /// Interval.open(1, 5).intersection(Interval.open(7, 9)); // null
  /// ```
  ///
  /// See [intersects] for determining if two ranges intersect.
  @useResult Range<T>? intersection(Range<T> other);


  /// Returns `true` if an empty range exists between this [Range] and [other].
  ///
  /// This method is reflexive and symmetric.
  ///
  /// Note: Discrete ranges are not considered to be besides each other even though there are no elements "between them",
  /// i.e. `[1..4]` is not beside `[5..7]`.
  ///
  /// ### Example:
  /// ```dart
  /// Interval.closedOpen(1, 3).besides(Interval.closedOpen(3, 5)); // true, [1..3) is beside [3..5)
  ///
  /// Interval.closed(1, 3).besides(Interval.open(3, 5)); // true, [1..3] is beside (3..5)
  ///
  ///
  /// Interval.closed(1, 5).besides(Interval.open(3, 7)); // false, [1..5] is not beside (3..7)
  ///
  /// Interval.closed(1, 3).besides(Interval.open(5, 7)); // false, [1..3] is not beside (5..7)
  ///
  /// Interval.closed(1, 4).besides(Interval.closed(5, 7)); // false, [1..4] is not beside [5..7], discrete range
  /// ```
  @useResult bool besides(Range<T> other);

  /// Returns `true` if [other]'s bounds do not extend outside this [Range]'s bounds.
  ///
  /// This method is reflexive, anti-symmetric and transitive.
  ///
  /// It is not possible for an [Interval] to enclose a [Min] or [Max]. Neither is it possible for a [Min] to enclose a
  /// [Max] or vice versa.
  ///
  /// Note: A discrete range is not considered to be enclosed by another under certain circumstances, i.e. `[4..5]` does
  /// not enclose `(3..6)`.
  ///
  /// ### Example:
  /// ```dart
  /// Interval.closed(1, 4).encloses(Interval.closedOpen(2, 3)); // true, [1..4] encloses [2..3]
  ///
  /// Interval.open(1, 4).encloses(Interval.open(1, 4)); // true, (1..4) encloses (1..4)
  ///
  /// Interval.open(1, 4).encloses(Interval.closedOpen(2, 2)); // true, (1..4) encloses [2..2)
  ///
  ///
  /// Interval.openClosed(3, 6).encloses(Interval.openClosed(2, 8)); // false, (3..6] does not enclose (2..8]
  ///
  /// Interval.openClosed(3, 6).encloses(Interval.closed(3, 6)); // false, (3..6] does not enclose [3..6]
  ///
  /// Interval.closed(4, 5).encloses(Interval.open(3, 6)); // false, [4..5] does not enclose (3..6), discrete range
  ///
  /// Interval.openClosed(3, 6).encloses(Interval.closedOpen(1, 1)); // false, (3..6] does not enclose (1..1]
  /// ```
  ///
  /// A [Range] that [encloses] another [Range] always [intersects].
  @useResult bool encloses(Range<T> other);

  /// Returns `true` if a non-empty range exists between this [Range] and [other].
  ///
  /// This method is reflexive and symmetric.
  ///
  /// ### Example:
  /// ```dart
  /// Interval.closed(1, 4).intersects(Interval.closed(1, 4)); // true, [1..4] intersects [1..4]
  ///
  /// Interval.closed(1, 4).intersects(Interval.closedOpen(2, 3)); // true, [1..4] intersects [2..3]
  ///
  /// Interval.openClosed(3, 6).intersects(Interval.openClosed(2, 8)); // true, (3..6] intersects (4..8]
  ///
  ///
  /// Interval.openClosed(3, 6).intersects(Interval.closedOpen(1, 2)); // false, (3..6] does not intersect (1..2]
  ///
  /// Interval.closedOpen(1, 3).besides(Interval.closedOpen(3, 5)); // false, [1..3) does not intersect [3..5)
  /// ```
  ///
  /// See [intersection] for computing the intersection of two ranges.
  @useResult bool intersects(Range<T> other);

  /// Whether this [Range] is empty, i.e. `[a..a)`.
  ///
  /// Only a range with bounds at both ends, i.e. [Interval], can be empty.
  ///
  /// ### Example:
  /// ```dart
  /// final interval = Interval.openClosed(1, 1);
  /// interval.empty; // true
  ///```
  @useResult bool get empty;

}

/// A convenience alias for [Comparable].
@internal typedef C = Comparable<Object?>;

/// Provides functions for determining whether two [Range]s are besides each other.
@internal extension Besides on Never {

  /// Returns `true` if the given [min] and [max] are beside each other.
  static bool minMax<T extends C>(Min<T> min, Max<T> max) => min.open == max.closed && min.value == max.value;

  /// Returns `true` if the given [min] and [interval] are beside each other.
  static bool minInterval<T extends C>(Min<T> min, Interval<T> interval) => min.open == interval.maxClosed && min.value == interval.max;

  /// Returns `true` if the given [max] and [interval] are beside each other.
  static bool maxInterval<T extends C> (Max<T> max, Interval<T> interval) => max.open == interval.minClosed && max.value == interval.min;

}

/// Provides functions for determining whether two [Range]s intersect.
@internal extension Intersects on Never {

  /// Returns `true` if the given [min] and [max] intersect.
  static bool minMax<T extends C>(Min<T> min, Max<T> max) {
    final comparison = min.value.compareTo(max.value);
    return (comparison < 0) || (comparison == 0 && min.closed && max.closed);
  }

  /// Returns `true` if the given [min] and [interval] intersect.
  static bool minInterval<T extends C>(Min<T> min, Interval<T> interval) {
    final comparison = min.value.compareTo(interval.max);
    return (comparison < 0) || (comparison == 0 && min.closed && interval.maxClosed);
  }

  /// Returns `true` if the given [max] and [interval] intersect.
  static bool maxInterval<T extends C>(Max<T> max, Interval<T> interval) {
    final comparison = interval.min.compareTo(max.value);
    return (comparison < 0) || (comparison == 0 && interval.minClosed && max.closed);
  }

  /// Returns `true` if [a] intersects [b].
  static bool intervalInterval<T extends C>(Interval<T> a, Interval<T> b) =>
      within(a, b.min, closed: b.minClosed) || within(a, b.max, closed: b.maxClosed) ||
      within(b, a.min, closed: a.minClosed) || within(b, a.max, closed: a.maxClosed);

  /// Returns `true` if the given [interval] contains the given [point].
  static bool within<T extends C>(Interval<T> interval, T point, {required bool closed}) {
    final minimum = interval.min.compareTo(point);
    if (minimum > 0 || (minimum == 0 && !(interval.minClosed && closed))) {
      return false;
    }

    final maximum = interval.max.compareTo(point);
    if (maximum < 0 || (maximum == 0 && !(interval.maxClosed && closed))) {
      return false;
    }

    return true;
  }

}
