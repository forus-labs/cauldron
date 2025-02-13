part of 'range.dart';

/// A [Max] represents a convex (contiguous) portion of a domain bounded on the upper end, i.e. `{ x |  x < value }`.
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in a [Max]. Doing so will result in undefined behaviour.
final class Max<T extends Comparable<Object?>> extends IterableRange<T> {
  /// The maximum value.
  final T value;

  /// Whether the upper bound is open.
  ///
  /// In other words, whether the range excludes [value], i.e. `{ x | x < value }`.
  final bool open;

  /// Creates a [Max] with the open upper bound.
  ///
  /// In other words, this range excludes [value], i.e. `{ x | x < value }`.
  const Max.open(this.value) : open = true;

  /// Creates a [Max] with the closed upper bound.
  ///
  /// In other words, this range includes [value], i.e. `{ x | x <= value }`.
  const Max.closed(this.value) : open = false;

  @override
  @useResult
  bool contains(T value) => this.value.compareTo(value) >= (closed ? 0 : 1);

  @override
  @useResult
  Iterable<T> iterate({required T Function(T current) by}) sync* {
    for (var current = closed ? value : by(value); contains(current); current = by(current)) {
      yield current;
    }
  }

  @override
  @useResult
  Interval<T>? gap(Range<T> other) => switch (other) {
    Min<T> _ => Gaps.minMax(other, this),
    Interval<T> _ => Gaps.maxInterval(this, other),
    _ => null,
  };

  @override
  @useResult
  Range<T>? intersection(Range<T> other) => switch (other) {
    Max<T> _ => switch (value.compareTo(other.value)) {
      < 0 when open => Max.open(value),
      < 0 when closed => Max.closed(value),
      > 0 when other.open => Max.open(other.value),
      > 0 when other.closed => Max.closed(other.value),
      _ when open || other.open => Max.open(value),
      _ => Max.closed(other.value),
    },
    Interval<T> _ => Intersections.maxInterval(this, other),
    Min<T> _ => Intersections.minMax(other, this),
    Unbound<T> _ => this,
  };

  @override
  @useResult
  bool besides(Range<T> other) => switch (other) {
    Min<T> _ => Besides.minMax(other, this),
    Interval<T> _ => Besides.maxInterval(this, other),
    _ => false,
  };

  @override
  @useResult
  bool encloses(Range<T> other) {
    switch (other) {
      case Max<T> _:
        final comparison = other.value.compareTo(value);
        return (comparison < 0) || (comparison == 0 && (closed || other.open));

      case Interval<T> _:
        final comparison = other.max.value.compareTo(value);
        return (comparison < 0) || (comparison == 0 && (closed || other.max.open));

      default:
        return false;
    }
  }

  @override
  @useResult
  bool intersects(Range<T> other) => switch (other) {
    Min<T> _ => Intersects.minMax(other, this),
    Interval<T> _ => Intersects.maxInterval(this, other),
    _ => true,
  };

  @override
  bool get empty => false;

  /// Whether the upper bound is closed.
  ///
  /// In other words, whether the range includes [value], i.e. `{ x | x <= value }`.
  bool get closed => !open;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Max && runtimeType == other.runtimeType && value == other.value && open == other.open;

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode ^ open.hashCode;

  @override
  String toString() => '(-∞..$value${open ? ')' : ']'}';
}
