part of 'range.dart';

/// An [Interval] represents a convex (contiguous) portion of a domain bounded on both ends, i.e. `{ x | min < x < max }`.
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in an `Interval`. Doing so will result in undefined behaviour.
final class Interval<T extends Comparable<Object?>> extends IterableRange<T> {

  static void _precondition<T extends Comparable<Object?>>(String start, T min, T max, String end) {
    if (min.compareTo(max) > 0) {
      throw RangeError("Invalid range: $start$min...$max$end, minimum should be less than or equal to maximum. To fix, try swapping the values of 'min' and 'max'.");
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
  Interval.openClosed(T min, T max): min = (value: min, open: true), max = (value: max, open: false) {
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
      throw RangeError('Invalid range: ($min...$max), minimum should be less than maximum. To represent an empty range, create an closed-open/open-closed range instead.');

    } else {
      throw RangeError("Invalid range: ($min...$max), minimum should be less than maximum. To fix, try swapping the values of 'min' and 'max'.");
    }
  }

  /// Creates an empty [Interval] with [value], i.e. `{ x | value <= x < value }`.
  ///
  /// This is an alias for [Interval.closedOpen].
  const Interval.empty(T value): min = (value: value, open: false), max = (value: value, open: true);

  const Interval._(this.min, this.max);


  @override
  @useResult bool contains(T value) => min.value.compareTo(value) <= (min.open ? -1 : 0)
                                    && max.value.compareTo(value) >= (max.open ? 1 : 0);

  @override
  @useResult Iterable<T> iterate({required T Function(T current) by, bool ascending = true}) sync* {
    final initial = ascending ? (min.open ? by(min.value) : min.value) : (max.open ? by(max.value) : max.value);
    for (var current = initial; contains(current); current = by(current)) {
      yield current;
    }
  }

  @override
  @useResult Interval<T>? gap(Range<T> other) => switch (other) {
    Min<T> _ => Gaps.minInterval(other, this),
    Interval<T> _ => Gaps.intervalInterval(this, other),
    Max<T> _ => Gaps.maxInterval(other, this),
    Unbound<T> _ => null,
  };

  @override
  @useResult Interval<T>? intersection(Range<T> other) => switch (other) {
    Min<T> _ => Intersections.minInterval(other, this),
    Interval<T> _ => Intersections.intervalInterval(this, other),
    Max<T> _ => Intersections.maxInterval(other, this),
    Unbound<T> _ => this,
  };

  @override
  @useResult bool besides(Range<T> other) => switch (other) {
    Min<T> _ => Besides.minInterval(other, this),
    Max<T> _ => Besides.maxInterval(other, this),
    Interval<T>(:final min, : final max) => (this.min.open == !max.open && this.min.value == max.value)
                                         || (this.max.open == !min.open && this.max.value == min.value),
    Unbound<T> _ => false,
  };

  @override
  @useResult bool encloses(Range<T> other) {
    switch (other) {
      case Interval<T> _:
        final minimum =  min.value.compareTo(other.min.value);
        if (minimum > 0 || (minimum == 0 && min.open && !other.min.open)) {
          return false;
        }

        final maximum =  max.value.compareTo(other.max.value);
        if (maximum < 0 || (maximum == 0 && max.open && !other.max.open)) {
          return false;
        }

        return true;

      default:
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
  bool get empty => min.open == !max.open && min.value == max.value;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Interval && runtimeType == other.runtimeType
                                 && min == other.min && max == other.max;

  @override
  int get hashCode => runtimeType.hashCode ^ min.hashCode ^ max.hashCode;

  @override
  String toString() {
    final start = min.open ? '(' : '[';
    final end = max.open ? ')' : ']';
    return '$start${min.value}..${max.value}$end';
  }

}

/// Provides functions for computing the gap between two [Range]s.
@internal extension Gaps on Never {

  /// If [min] does not intersect [max], return the gap in between. Otherwise returns `null`.
  @useResult static Interval<T>? minMax<T extends C>(Min<T> min, Max<T> max) => Intersects.minMax(min, max) ? null : Interval._(
    (value: max.value, open: !max.open),
    (value: min.value, open: !min.open),
  );

  /// If [min] does not intersect [interval], return the gap in between. Otherwise returns `null`.
  @useResult static Interval<T>? minInterval<T extends C>(Min<T> min, Interval<T> interval) => Intersects.minInterval(min, interval) ? null : Interval._(
    (value: interval.max.value, open: !interval.max.open),
    (value: min.value, open: !min.open),
  );

  /// If max does not intersect [interval], return the gap in between. Otherwise returns `null`.
  @useResult static Interval<T>? maxInterval<T extends C>(Max<T> max, Interval<T> interval) => Intersects.maxInterval(max, interval) ? null : Interval._(
    (value: max.value, open: !max.open),
    (value: interval.min.value, open: !interval.min.open),
  );

  /// If [a] does not intersect [b], return the gap in between. Otherwise returns `null`.
  @useResult static Interval<T>? intervalInterval<T extends C>(Interval<T> a, Interval<T> b) {
    if (Intersects.intervalInterval(a, b)) {
      return null;
    }

    final comparison = a.min.value.compareTo(b.min.value);
    return Interval._(
      switch (comparison) {
        < 0 => (value: a.max.value, open: !a.max.open),
        > 0 => (value: b.max.value, open: !b.max.open),
        _ => (value: a.max.value, open: !(a.max.open || b.max.open)),
      },
      switch (comparison) {
        < 0 => (value: b.min.value, open: !b.min.open),
        > 0 => (value: a.min.value, open: !a.min.open),
        _ => (value: a.min.value, open: !(a.min.open || b.min.open)),
      },
    );
  }

}

/// Provides functions for computing the intersection of two [Range]s.
@internal extension Intersections on Never {

  /// If [min] intersects [max], returns the intersection. Otherwise returns `null`.
  static Interval<T>? minMax<T extends C>(Min<T> min, Max<T> max) => Intersects.minMax(min, max) ? Interval._(
    (value: min.value, open: min.open),
    (value: max.value, open: max.open),
  ) : null;

  /// If [min] intersects [interval], returns the intersection. Otherwise returns `null`.
  static Interval<T>? minInterval<T extends C>(Min<T> min, Interval<T> interval) => Intersects.minInterval(min, interval) ? Interval._(
    (value: min.value, open: min.open),
    interval.max,
  ) : null;

  /// If [max] intersects [interval], returns the intersection. Otherwise returns `null`.
  static Interval<T>? maxInterval<T extends C>(Max<T> max, Interval<T> interval) => Intersects.maxInterval(max, interval) ? Interval._(
    interval.min,
    (value: max.value, open: max.open),
  ) : null;

  /// If [a] intersects [b], returns the intersection. Otherwise returns `null`.
  static Interval<T>? intervalInterval<T extends C>(Interval<T> a, Interval<T> b) {
    if (!Intersects.intervalInterval(a, b)) {
      return null;
    }

    final comparison = a.min.value.compareTo(b.min.value);
    return Interval._(
      switch (comparison) {
        < 0 => b.min,
        > 0 => a.min,
        _ => (value: a.min.value, open: a.min.open || b.min.open),
      },
      switch (comparison) {
        < 0 => a.max,
        > 0 => b.max,
        _ => (value: a.max.value, open: a.max.open || b.max.open),
      },
    );
  }

}
