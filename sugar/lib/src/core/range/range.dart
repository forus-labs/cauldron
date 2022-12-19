import 'package:meta/meta.dart';
import 'package:sugar/core_range.dart';

/// A [Range] is a convex (contiguous) portion of a domain. Ranges may extend to infinity, for example, `x > 3`.
@sealed abstract class Range<T extends Comparable<Object?>> {

  const Range();

  bool contains(T value);

  bool containsAll(Iterable<T> values) => values.every(contains);


  Iterable<T> iterate({required T Function(T current) by});


  bool besides(Range<T> other);

  bool encloses(Range<T> other);

  bool intersects(Range<T> other);


  bool get empty;

}

/// Provides functions for determining whether two [Range]s are besides each other.
@internal extension Besides on Never {

  static bool minMax<T extends Comparable<Object?>>(Min<T> min, Max<T> max) => min.open == max.closed && min.value == max.value;

  static bool minInterval<T extends Comparable<Object?>>(Min<T> min, Interval<T> interval) => min.open == interval.maxClosed && min.value == interval.max;

  static bool maxInterval<T extends Comparable<Object?>> (Max<T> max, Interval<T> interval) => max.open == interval.minClosed && max.value == interval.min;

}

/// Provides functions for determining whether two [Range]s intersect.
@internal extension Intersects on Never {

  static bool minMax<T extends Comparable<Object?>>(Min<T> min, Max<T> max) {
    final comparison = min.value.compareTo(max.value);
    return (comparison > 0) || (comparison == 0 && min.closed && max.closed);
  }

  static bool minInterval<T extends Comparable<Object?>>(Min<T> min, Interval<T> interval) {
    final comparison = min.value.compareTo(interval.max);
    return (comparison > 0) || (comparison == 0 && min.closed && interval.maxClosed);
  }

  static bool maxInterval<T extends Comparable<Object?>>(Max<T> max, Interval<T> interval) {
    final comparison = interval.min.compareTo(max.value);
    return (comparison > 0) || (comparison == 0 && interval.minClosed && max.closed);
  }

  static bool within<T extends Comparable<Object?>>(Interval<T> interval, T point, {required bool closed}) {
    final minimum = interval.min.compareTo(point);
    if (minimum > 0 || (minimum == 0 && interval.minOpen && closed)) {
      return false;
    }

    final maximum = interval.max.compareTo(point);
    if (maximum < 0 || (maximum == 0 && interval.maxOpen && closed)) {
      return false;
    }

    return true;
  }

}

