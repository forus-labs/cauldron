import 'package:sugar/core_range.dart';
import 'package:sugar/src/core/range/interval.dart';
import 'package:sugar/src/core/range/range.dart';

/// A [Min] represents a convex (contiguous) portion of a domain bounded on the lower end, i.e. `{ x | value < x }`.
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in a [Range]. Doing so will result in undefined behaviour.
class Min<T extends Comparable<Object?>> extends Range<T> {

  /// The minimum value.
  final T value;
  /// Whether the lower bound is open. That is to say, whether the range excludes [value], i.e. `{ x | value < x }`.
  final bool open;

  /// Creates a [Min] with the given open lower bound. That is to say, this range excludes [value], i.e. `{ x | value < x }`.
  const Min.open(this.value): open = true;

  /// Creates a [Min] with the given closed lower bound. That is to say, this range includes [value], i.e. `{ x | value <= x }`.
  const Min.closed(this.value): open = false;

  @override
  bool contains(T value) => this.value.compareTo(value) <= (closed ? 0 : -1);

  @override
  Iterable<T> iterate({required T Function(T current) by}) sync* {
    for (var current = closed ? value : by(value); contains(current); current = by(current)) {
      yield current;
    }
  }

  @override
  Interval<T>? gap(Range<T> other) {
    if (other is Max<T>) {
      return Gaps.minMax(this, other);

    } else if (other is Interval<T>) {
      return Gaps.minInterval(this, other);

    } else {
      return null;
    }
  }

  @override
  Range<T>? intersection(Range<T> other) {
    if (other is Min<T>) {
      final comparison = value.compareTo(other.value);
      if (comparison < 0) {
        return other.open ? Min.open(other.value) : Min.closed(other.value);

      } else if (comparison > 0) {
        return open ? Min.open(value) : Min.closed(value);

      } else {
        return (open || other.open) ? Min.open(value) : Min.closed(value);
      }

    } else if (other is Interval<T>) {
      return Intersections.minInterval(this, other);

    } else if (other is Max<T>) {
      return Intersections.minMax(this, other);

    } else {
      return null;
    }
  }


  @override
  bool besides(Range<T> other) {
    if (other is Max<T>) {
      return Besides.minMax(this, other);

    } else if (other is Interval<T>) {
      return Besides.minInterval(this, other);

    } else {
      return false;
    }
  }

  @override
  bool encloses(Range<T> other) {
    if (other is Min<T>) {
      final comparison = value.compareTo(other.value);
      return (comparison < 0) || (comparison == 0 && (closed || other.open));

    } else if (other is Interval<T>) {
      final comparison = value.compareTo(other.min);
      return (comparison < 0) || (comparison == 0 && (closed || other.minOpen));

    } else {
      return false;
    }
  }

  @override
  bool intersects(Range<T> other) {
    if (other is Max<T>) {
      return Intersects.minMax(this, other);

    } else if (other is Interval<T>) {
      return Intersects.minInterval(this, other);

    } else {
      return true;
    }
  }

  @override
  bool get empty => false;

  /// Whether the lower bound is closed. That is to say, whether the range includes [value], i.e. `{ x | value <= x }`.
  bool get closed => !open;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Min && runtimeType == other.runtimeType
                && value == other.value && open == other.open;

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode ^ open.hashCode;

  @override
  String toString() => '${open ? '(' : '['}$value..+∞)';

}
