part of 'range.dart';

/// A [Min] represents a convex (contiguous) portion of a domain bounded on the lower end, i.e. `{ x | value < x }`.
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in a [Min]. Doing so will result in undefined behaviour.
final class Min<T extends Comparable<Object?>> extends IterableRange<T> {

  /// The minimum value.
  final T value;
  /// Whether the lower bound is open.
  ///
  /// In other words, whether this range excludes [value], i.e. `{ x | value < x }`.
  final bool open;

  /// Creates a [Min] with the open lower bound.
  ///
  /// In other words, this range excludes [value], i.e. `{ x | value < x }`.
  const Min.open(this.value): open = true;

  /// Creates a [Min] with the closed lower bound.
  ///
  /// In other words, this range includes [value], i.e. `{ x | value <= x }`.
  const Min.closed(this.value): open = false;

  @override
  @useResult bool contains(T value) => this.value.compareTo(value) <= (closed ? 0 : -1);

  @override
  @useResult Iterable<T> iterate({required T Function(T current) by}) sync* {
    for (var current = closed ? value : by(value); contains(current); current = by(current)) {
      yield current;
    }
  }

  @override
  @useResult Interval<T>? gap(Range<T> other) => switch (other) {
    Max<T> _ => Gaps.minMax(this, other),
    Interval<T> _ => Gaps.minInterval(this, other),
    _ => null,
  };

  @override
  @useResult Range<T>? intersection(Range<T> other) => switch (other) {
    Min<T> _ => switch (value.compareTo(other.value)) {
      < 0 when other.open => Min.open(other.value),
      < 0 when other.closed => Min.closed(other.value),
      > 0 when open => Min.open(value),
      > 0 when closed => Min.closed(value),
      _ when open || other.open => Min.open(value),
      _ => Min.closed(value),
    },
    Interval<T> _ => Intersections.minInterval(this, other),
    Max<T> _ => Intersections.minMax(this, other),
    Unbound<T> _ => this,
  };

  @override
  @useResult bool besides(Range<T> other) => switch (other) {
    Max<T> _ => Besides.minMax(this, other),
    Interval<T> _ => Besides.minInterval(this, other),
    _ => false,
  };

  @override
  @useResult bool encloses(Range<T> other) {
    switch (other) {
      case Min<T> _:
        final comparison = value.compareTo(other.value);
        return (comparison < 0) || (comparison == 0 && (closed || other.open));

      case Interval<T> _:
        final comparison = value.compareTo(other.min.value);
        return (comparison < 0) || (comparison == 0 && (closed || other.min.open));

      default:
        return false;
    }
  }

  @override
  @useResult bool intersects(Range<T> other) => switch (other) {
    Max<T> _ => Intersects.minMax(this, other),
    Interval<T> _ => Intersects.minInterval(this, other),
    _ => true,
  };

  @override
  bool get empty => false;

  /// Whether the lower bound is closed.
  ///
  /// In other words, whether this range includes [value], i.e. `{ x | value <= x }`.
  bool get closed => !open;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Min && runtimeType == other.runtimeType
                && value == other.value && open == other.open;

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode ^ open.hashCode;

  @override
  String toString() => '${open ? '(' : '['}$value..+∞)';

}
