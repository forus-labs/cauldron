import 'dart:collection';
import 'dart:math' as math;
// reverse

// by value

/// Provides overloads for comparison operators, i.e. `<`.
///
/// ### Contract:
/// It is expected that the extended comparable, [T], overrides the equality operator.
extension OverloadedComparables<T extends Comparable<Object>> on T {

  /// Returns `true` if this [T] is less than [other].
  bool operator < (T other) => compareTo(other) < 0;

  /// Returns `true` if this [T] is more than [other].
  bool operator > (T other) => other < this;

  /// Returns `true` if this [T] is equal to or less than [other].
  bool operator <= (T other) => !(this > other);

  /// Returns `true` if this [T] is equal to or more than [other].
  bool operator >= (T other) => !(this < other);

}

// Make range comparable
