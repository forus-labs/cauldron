import 'package:meta/meta.dart';
import 'package:sugar/core_range.dart';

/// Provides functions for determining whether two [Range]s are besides each other.
@internal extension Besides on Never {

  static bool minMax<T extends Comparable<Object?>>(Min<T> min, Max<T> max) => min.open == max.closed && min.value == max.value;

  static bool minInterval<T extends Comparable<Object?>>(Min<T> min, Interval<T> interval) => min.open == interval.maxClosed && min.value == interval.max;

  static bool maxInterval<T extends Comparable<Object?>> (Max<T> max, Interval<T> interval) => max.open == interval.minClosed && max.value == interval.min;

}

@internal extension Encloses on Never {

}