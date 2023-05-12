part of 'range.dart';

/// An [Interval] represents a convex (contiguous) portion of a domain bounded on both ends, i.e. `{ x | min < x < max }`.
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in an `Interval`. Doing so will result in undefined behaviour.
final class Interval<T extends Comparable<Object?>> extends Range<T> with IterableRange<T> {

  static void _precondition<T extends Comparable<Object?>>(String start, T min, T max, String end) {
    if (min.compareTo(max) > 0) {
      throw RangeError("Invalid range: $start$min...$max$end, minimum must be less than or equal to maximum. To fix, try swapping the values of 'min' and 'max'.");
    }
  }

  /// The minimum value and whether the lower bound is open.
  ///
  /// In other words, whether this interval excludes [min], i.e. `{ x | min < x }`.
  final ({T value, bool open}) min;

  /// The maximum value and whether the upper bound is open.
  ///
  /// In other words, whether this interval excludes [max], i.e. `{ x | x < max }`.
  final ({T value, bool open}) max;

  /// Creates an [Interval] with the closed lower bound and open upper bound.
  ///
  /// In other words, this interval includes [min] and excludes [max], i.e. `{ x | min <= x < max }`.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `min >= max`.
  @Possible({RangeError})
  Interval.closedOpen(T min, T max): min = (value: min, open: false), max = (value: max, open: true) {
    _precondition('[', min, max, ')');
  }

  /// Creates an [Interval] with the closed lower and upper bounds.
  ///
  /// In other words, this interval includes both [min] and [max], i.e. `{ x | min <= x <= max }`.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `min > max`.
  @Possible({RangeError})
  Interval.closed(T min, T max): min = (value: min, open: false), max = (value: max, open: false) {
    _precondition('[', min, max, ']');
  }

  /// Creates an [Interval] with the open lower bound and closed upper bound.
  ///
  /// In other words, this interval excludes [min] and includes [max], i.e. `{ x | min < x <= max }`.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `min >= max`.
  @Possible({RangeError})
  Interval.openClosed(T min, T max): min = (value: min, open: true), max = (value: max, open: true) {
    _precondition('(', min, max, ']');
  }

  /// Creates an [Interval] with the open lower and upper bounds.
  ///
  /// In other words, this interval excludes both [min] and [max], i.e. `{ x | min < x < max }`.
  ///
  /// ## Contract
  /// Throws a [RangeError] if `min >= max`.
  @Possible({RangeError})
  Interval.open(T min, T max): min = (value: min, open: true), max = (value: max, open: true) {
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

  /// Creates an empty [Interval] with [value], i.e. `{ x | value <= x < value }`.
  ///
  /// This is an alias for [Interval.closedOpen].
  const Interval.empty(T value): min = (value: value, open: false), max = (value: value, open: true);

  const Interval._(this.min, this.minOpen, this.max, this.maxOpen);


  @override
  @useResult bool contains(T value) => min.compareTo(value) <= (minClosed ? 0 : -1)
                         && max.compareTo(value) >= (maxClosed ? 0 : 1);

  @override
  @useResult Iterable<T> iterate({required T Function(T current) by, bool ascending = true}) sync* {
    final initial = ascending ? (minClosed ? min : by(min)) : (maxClosed ? max : by(max));
    for (var current = initial; contains(current); current = by(current)) {
      yield current;
    }
  }

  @override
  @useResult Interval<T>? gap(Range<T> other) {
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
  @useResult Interval<T>? intersection(Range<T> other) {
    if (other is Min<T>) {
      return Intersections.minInterval(other, this);

    } else if (other is Interval<T>) {
      return Intersections.intervalInterval(this, other);

    } else if (other is Max<T>) {
      return Intersections.maxInterval(other, this);

    } else if (other is Unbound<T>) {
      return this;

    } else {
      return null;
    }
  }

  @override
  @useResult bool besides(Range<T> other) {
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
  @useResult bool encloses(Range<T> other) {
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
  @useResult bool intersects(Range<T> other) {
    if (other is Min<T>) {
      return Intersects.minInterval(other, this);

    } else if (other is Max<T>) {
      return Intersects.maxInterval(other, this);

    } else if (other is Interval<T>) {
      return Intersects.intervalInterval(this, other);

    } else {
      return true;
    }
  }

  @override
  bool get empty => minOpen == maxClosed && min == max;

  /// Whether the lower bound is closed.
  ///
  /// In other words, whether this interval includes [min], i.e. `{ x | min <= x }`.
  bool get minClosed => !minOpen;

  /// Whether the upper bound is closed.
  ///
  /// In other words, whether this interval includes [max], i.e. `{ x | x <= max }`.
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

  @useResult static Interval<T>? gap<T extends Comparable<Object?>>(Range<T> a, Range<T> b) => switch ((a, b)) {
    (final Min<T> a, final Max<T> b)
  };

  /// If [min] does not intersect [max], return the gap in between. Otherwise returns `null`.
  @useResult static Interval<T>? minMax<T extends C>(Min<T> min, Max<T> max) => Intersects.minMax(min, max) ? null : Interval._(max.value, !max.open, min.value, !min.open);

  /// If [min] does not intersect [interval], return the gap in between. Otherwise returns `null`.
  @useResult static Interval<T>? minInterval<T extends C>(Min<T> min, Interval<T> interval) => Intersects.minInterval(min, interval) ? null : Interval._(interval.max, !interval.maxOpen, min.value, !min.open);

  /// If max does not intersect [interval], return the gap in between. Otherwise returns `null`.
  @useResult static Interval<T>? maxInterval<T extends C>(Max<T> max, Interval<T> interval) => Intersects.maxInterval(max, interval) ? null : Interval._(max.value, !max.open, interval.min, !interval.minOpen);

  /// If [a] does not intersect [b], return the gap in between. Otherwise returns `null`.
  @useResult static Interval<T>? intervalInterval<T extends C>(Interval<T> a, Interval<T> b) {
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
