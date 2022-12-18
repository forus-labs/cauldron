import 'package:sugar/core_range.dart';
import 'package:sugar/src/core/range/range_collision.dart';

class Interval<T extends Comparable<Object?>> extends Range<T> {

  static void _precondition<T extends Comparable<Object?>>(String start, T min, T max, String end) {
    if (min.compareTo(max) > 0) {
      throw RangeError("Invalid range: $start$min...$max$end, minimum must be less than maximum. To fix, try swapping the values of 'min' and 'max'.");
    }
  }

  final T min;
  final bool minOpen;
  final T max;
  final bool maxOpen;

  Interval.closedOpen(this.min, this.max): minOpen = false, maxOpen = true { _precondition('[', min, max, ')'); }

  Interval.closed(this.min, this.max): minOpen = false, maxOpen = false { _precondition('[', min, max, ']'); }

  Interval.openClosed(this.min, this.max): minOpen = true, maxOpen = false { _precondition('(', min, max, ']'); }

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
      return min.compareTo(other.min) <= (minClosed ? 0 : -1)
          && max.compareTo(other.max) >= (maxClosed ? 0 : 1);

    } else {
      return false;
    }
  }

  @override
  bool intersects(Range<T> other) {
    // TODO: implement intersects
    throw UnimplementedError();
  }

  @override
  bool get empty => minOpen == maxClosed && min == max;

  bool get minClosed => !minOpen;

  bool get maxClosed => !maxOpen;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Interval && runtimeType == other.runtimeType
                                 && min == other.min && minOpen == other.minOpen
                                 && max == other.max && maxOpen == other.maxOpen;

  @override
  int get hashCode => min.hashCode ^ minOpen.hashCode ^ max.hashCode ^ maxOpen.hashCode;

  @override
  String toString() {
    final start = minOpen ? '(' : '[';
    final end = maxOpen ? ')' : ']';
    return '$start$min..$max$end';
  }
}
