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
      return (Intersects.within(this, other.min, closed: other.minClosed)
           && Intersects.within(this, other.max, closed: other.maxClosed))
           || (Intersects.within(other, min, closed: minClosed)
            && Intersects.within(other, max, closed: maxClosed));

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
