import 'package:meta/meta.dart';
import 'package:sugar/core.dart';
import 'package:sugar/src/core/range/range.dart';

/// A [Interval] represents a convex (contiguous) portion of a domain bounded on both ends, i.e. `{ x | min < x < max }`.
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in a [Range]. Doing so will result in undefined behaviour.
class Interval<T extends Comparable<Object?>> extends Range<T> {

  static void _precondition<T extends Comparable<Object?>>(String start, T min, T max, String end) {
    if (min.compareTo(max) > 0) {
      throw RangeError("Invalid range: $start$min...$max$end, minimum must be less than or equal to maximum. To fix, try swapping the values of 'min' and 'max'.");
    }
  }

  /// The minimum value.
  final T min;
  /// Whether the lower bound is open. That is to say, whether the range excludes [min], i.e. `{ x | min < x }`.
  final bool minOpen;
  /// The maximum value.
  final T max;
  /// Whether the lower bound is open. That is to say, whether the range excludes [max], i.e. `{ x | x < max }`.
  final bool maxOpen;

  /// Creates an [Interval] with the given closed lower bound and open upper bound. That is to say, this range includes [min]
  /// and excludes [max], i.e. `{ x | min <= x < max }`.
  ///
  /// ### Contract:
  /// [min] must be equal to or less than [max]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Interval.closedOpen(this.min, this.max): minOpen = false, maxOpen = true { _precondition('[', min, max, ')'); }

  /// Creates an [Interval] with the given closed lower and upper bounds. That is to say, this range includes both [min] and [max],
  /// i.e. `{ x | min <= x <= max }`.
  ///
  /// ### Contract:
  /// [min] must be equal to or less than [max]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Interval.closed(this.min, this.max): minOpen = false, maxOpen = false { _precondition('[', min, max, ']'); }

  /// Creates an [Interval] with the given open lower bound and closed upper bound. That is to say, this range excludes [min]
  /// and includes [max], i.e. `{ x | min < x <= max }`.
  ///
  /// ### Contract:
  /// [min] must be equal to or less than [max]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Interval.openClosed(this.min, this.max): minOpen = true, maxOpen = false { _precondition('(', min, max, ']'); }

  /// Creates an [Interval] with the given open lower and upper bounds. That is to say, this range excludes both [min] and [max],
  /// i.e. `{ x | min < x < max }`.
  ///
  /// ### Contract:
  /// [min] must be less than [max]. A [RangeError] will otherwise be thrown.
  @Possible({RangeError})
  Interval.open(this.min, this.max): minOpen = true, maxOpen = true {
    final value = min.compareTo(max);
    if (value < 0) {
      return;
    }

    if (value == 0) {
      throw RangeError('Invalid range: ($min...$max), minimum must be less than maximum. To represent an empty range, create an closed-open/open-closed range instead.');

    } else {
      throw RangeError("Invalid range: ($min...$max), minimum must be less than maximum. To fix, try swapping the values of 'min' and 'max'.");
    }
  }

  Interval._(this.min, this.minOpen, this.max, this.maxOpen);


  @override
  bool contains(T value) => min.compareTo(value) <= (minClosed ? 0 : -1)
                         && max.compareTo(value) >= (maxClosed ? 0 : 1);

  @override
  Iterable<T> iterate({required T Function(T current) by, bool ascending = true}) sync* {
    final initial = ascending ? (minClosed ? min : by(min)) : (maxClosed ? max : by(max));
    for (var current = initial; contains(current); current = by(current)) {
      yield current;
    }
  }

  @override
  Interval<T>? gap(Range<T> other) {
    if (other is Min<T>) {
      return Gaps.minInterval(other, this);

    } else if (other is Interval<T>) {
      return Gaps.intervalInterval(this, other);

    } else if (other is Max<T>) {
      return Gaps.maxInterval(other, this);

    } else {
      return null;
    }
  }

  @override
  Range<T>? intersection(Range<T> other) {
    if (other is Min<T>) {
      return Intersections.minInterval(other, this);

    } else if (other is Interval<T>) {
      return Intersections.intervalInterval(this, other);

    } else if (other is Max<T>) {
      return Intersections.maxInterval(other, this);

    } else {
      return null;
    }
  }

  @override
  bool besides(Range<T> other) {
    if (other is Min<T>) {
      return Besides.minInterval(other, this);

    } else if (other is Max<T>) {
      return Besides.maxInterval(other, this);

    } else if (other is Interval<T>) {
      return (minOpen == other.maxClosed && min == other.max)
          || (maxOpen == other.minClosed && max == other.min);

    } else {
      return false;
    }
  }

  @override
  bool encloses(Range<T> other) {
    if (other is Interval<T>) {
      final minimum =  min.compareTo(other.min);
      if (minimum > 0 || (minimum == 0 && minOpen && other.minClosed)) {
        return false;
      }

      final maximum =  max.compareTo(other.max);
      if (maximum < 0 || (maximum == 0 && maxOpen && other.maxClosed)) {
        return false;
      }

      return true;

    } else {
      return false;
    }
  }

  @override
  bool intersects(Range<T> other) {
    if (other is Min<T>) {
      return Intersects.minInterval(other, this);

    } else if (other is Max<T>) {
      return Intersects.maxInterval(other, this);

    } else if (other is Interval<T>) {
      return Intersects.intervalInterval(this, other);

    } else {
      return false;
    }
  }

  @override
  bool get empty => minOpen == maxClosed && min == max;

  /// Whether the lower bound is closed. That is to say, whether the range includes [min], i.e. `{ x | min <= x }`.
  bool get minClosed => !minOpen;

  /// Whether the upper bound is closed. That is to say, whether the range includes [max], i.e. `{ x | x <= max }`.
  bool get maxClosed => !maxOpen;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Interval && runtimeType == other.runtimeType
                                 && min == other.min && minOpen == other.minOpen
                                 && max == other.max && maxOpen == other.maxOpen;

  @override
  int get hashCode => runtimeType.hashCode ^ min.hashCode ^ minOpen.hashCode ^ max.hashCode ^ maxOpen.hashCode;

  @override
  String toString() {
    final start = minOpen ? '(' : '[';
    final end = maxOpen ? ')' : ']';
    return '$start$min..$max$end';
  }

}

/// Provides functions for computing the gap between two [Range]s.
@internal extension Gaps on Never {

  /// If [min] does not intersect [max], return the gap in between. Otherwise returns `null`.
  static Interval<T>? minMax<T extends C>(Min<T> min, Max<T> max) => Intersects.minMax(min, max) ? null : Interval._(max.value, !max.open, min.value, !min.open);

  /// If [min] does not intersect [interval], return the gap in between. Otherwise returns `null`.
  static Interval<T>? minInterval<T extends C>(Min<T> min, Interval<T> interval) => Intersects.minInterval(min, interval) ? null : Interval._(interval.max, !interval.maxOpen, min.value, !min.open);

  /// If max does not intersect [interval], return the gap in between. Otherwise returns `null`.
  static Interval<T>? maxInterval<T extends C>(Max<T> max, Interval<T> interval) => Intersects.maxInterval(max, interval) ? null : Interval._(max.value, !max.open, interval.min, !interval.minOpen);

  /// If [a] does not intersect [b], return the gap in between. Otherwise returns `null`.
  static Interval<T>? intervalInterval<T extends C>(Interval<T> a, Interval<T> b) {
    if (Intersects.intervalInterval(a, b)) {
      return null;
    }

    final lower = a.min.compareTo(b.min); // Always choose smaller max.
    final T min;
    final bool minOpen;

    if (lower < 0) {
      min = a.max;
      minOpen = a.maxOpen;

    } else if (lower > 0) {
      min = b.max;
      minOpen = b.maxOpen;

    } else {
      min = a.max;
      minOpen = a.maxOpen || b.maxOpen;
    }

    final upper = a.min.compareTo(b.min); // Always choose larger min.
    final T max;
    final bool maxOpen;

    if (upper < 0) {
      max = b.min;
      maxOpen = b.minOpen;

    } else if (upper > 0) {
      max = a.min;
      maxOpen = a.minOpen;

    } else {
      max = a.min;
      maxOpen = a.minOpen || b.minOpen;
    }

    return Interval._(min, !minOpen, max, !maxOpen);
  }

}

/// Provides functions for computing the intersection of two [Range]s.
@internal extension Intersections on Never {

  /// If [min] intersects [max], returns the intersection. Otherwise returns `null`.
  static Interval<T>? minMax<T extends C>(Min<T> min, Max<T> max) => Intersects.minMax(min, max) ? Interval._(min.value, min.open, max.value, max.open) : null;

  /// If [min] intersects [interval], returns the intersection. Otherwise returns `null`.
  static Interval<T>? minInterval<T extends C>(Min<T> min, Interval<T> interval) => Intersects.minInterval(min, interval) ? Interval._(min.value, min.open, interval.max, interval.maxOpen) : null;

  /// If [max] intersects [interval], returns the intersection. Otherwise returns `null`.
  static Interval<T>? maxInterval<T extends C>(Max<T> max, Interval<T> interval) => Intersects.maxInterval(max, interval) ? Interval._(interval.min, interval.minOpen, max.value, max.open) : null;

  /// If [a] intersects [b], returns the intersection. Otherwise returns `null`.
  static Interval<T>? intervalInterval<T extends C>(Interval<T> a, Interval<T> b) {
    if (!Intersects.intervalInterval(a, b)) {
      return null;
    }

    final lower = a.min.compareTo(b.min); // Always choose larger min.
    final T min;
    final bool minOpen;

    if (lower < 0) {
      min = b.min;
      minOpen = b.minOpen;

    } else if (lower > 0) {
      min = a.min;
      minOpen = a.minOpen;

    } else {
      min = a.min;
      minOpen = a.minOpen || b.minOpen;
    }

    final upper = a.min.compareTo(b.min); // Always choose smaller max.
    final T max;
    final bool maxOpen;

    if (upper < 0) {
      max = a.max;
      maxOpen = a.maxOpen;

    } else if (upper > 0) {
      max = b.max;
      maxOpen = b.maxOpen;

    } else {
      max = a.max;
      maxOpen = a.maxOpen || b.maxOpen;
    }

    return Interval._(min, minOpen, max, maxOpen);
  }

}
