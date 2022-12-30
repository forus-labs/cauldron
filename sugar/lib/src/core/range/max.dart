import 'package:sugar/core_range.dart';
import 'package:sugar/src/core/range/range.dart';

/// A [Max] represents a convex (contiguous) portion of a domain bounded on the upper end, i.e. `{ x |  x < value }`.
///
/// [T] is expected to be immutable. If [T] is mutable, the value produced by [Comparable.compare] must not change when
/// used in a [Range]. Doing so will result in undefined behaviour.
class Max<T extends Comparable<Object?>> extends Range<T> {

  /// The maximum value.
  final T value;
  /// Whether the lower bound is open. That is to say, whether the range excludes [value], i.e. `{ x | x < value }`.
  final bool open;

  /// Creates a [Max] with the given open upper bound. That is to say, this range excludes [value], i.e. `{ x | x < value }`.
  const Max.open(this.value): open = true;

  /// Creates a [Max] with the given closed upper bound. That is to say, this range includes [value], i.e. `{ x | x <= value }`.
  const Max.closed(this.value): open = false;

  @override
  bool contains(T value) => this.value.compareTo(value) >= (closed ? 0 : 1);

  @override
  Iterable<T> iterate({required T Function(T current) by}) sync* {
    for (var current = closed ? value : by(value); contains(current); current = by(current)) {
      yield current;
    }
  }

  @override
  bool besides(Range<T> other) {
    if (other is Min<T>) {
      return Besides.minMax(other, this);

    } else if (other is Interval<T>) {
      return Besides.maxInterval(this, other);

    } else {
      return false;
    }
  }

  @override
  bool encloses(Range<T> other) {
    if (other is Max<T>) {
      final comparison = other.value.compareTo(value);
      return (comparison < 0) || (comparison == 0 && (closed || other.open));

    } else if (other is Interval<T>) {
      final comparison = other.max.compareTo(value);
      return (comparison < 0) || (comparison == 0 && (closed || other.maxOpen));

    } else {
      return false;
    }
  }

  @override
  bool intersects(Range<T> other) {
    if (other is Min<T>) {
      return Intersects.minMax(other, this);

    } else if (other is Interval<T>) {
      return Intersects.maxInterval(this, other);

    } else {
      return true;
    }
  }

  @override
  bool get empty => false;

  /// Whether the upper bound is closed. That is to say, whether the range includes [value], i.e. `{ x | x <= value }`.
  bool get closed => !open;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Max && runtimeType == other.runtimeType
                && value == other.value && open == other.open;

  @override
  int get hashCode => runtimeType.hashCode ^ value.hashCode ^ open.hashCode;

  @override
  String toString() => '(-∞..$value${open ? ')' : ']'}';
}