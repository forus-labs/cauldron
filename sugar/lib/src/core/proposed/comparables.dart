import 'dart:collection';
import 'dart:math' as math;

/// Returns the lesser of two [Comparable]s.
T min<T extends Comparable<Object>>(T a, T b) => a is num ? math.min(a, b as num) as T : a.compareTo(b) == -1 ? a : b;

/// Returns the greater of two [Comparable]s.
T max<T extends Comparable<Object>>(T a, T b) => a is num ? math.max(a, b as num ) as T : a.compareTo(b) == 1 ? a : b;

/// Provides overloads for comparison operators, i.e. `<`.
///
/// **Contract: **
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


/// Provides overloads for comparison operators, i.e. `<`.
///
/// **Contract: **
/// Both [T]s must be in either UTC or the same local timezones. An [ArgumentError] is thrown if the timezones of two compared
/// [T]s are different.
///
/// This is provided in the same file rather than a separate library to prevent projects that rely on DateTimes to accidentally use
/// OverloadedComparable instead
extension OverloadedDateTime<T extends DateTime> on T {

}
