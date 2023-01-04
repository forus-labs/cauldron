/// Provides functions for working with [Comparable]s.
extension Comparators on Never {

  static T min<T extends Comparable<Object>>(T a, T b) => a.compareTo(b) < 0 ? a : b;

  static T max<T extends Comparable<Object>>(T a, T b) => a.compareTo(b) > 0 ? a : b;

}

/// Provides comparison operator overloads, i.e. `<=`, for [DateTime]s.
///
/// Unlike [DateTime.isBefore] and other related methods, the provided operator overloads require compared [DateTime]s
/// to be in the same timezone. Comparing [DateTime]s in different timezones will always return `false`. This is to
/// ensure that the operator overloads are compatible with [DateTime.==].
///
/// ```dart
/// DateTime.now() > DateTime(1970); // true
///
/// DateTime.now() > DateTime.utc(1970); // false
/// ```
///
/// See [DateTime.isBefore] and other related methods for comparing [DateTime]s independent of timezones.
extension ComparableDateTimes<T extends DateTime> on T {

  /// Returns `true` if this [DateTime] and [other] are in the same timezone and this [DateTime] occurs before [other].
  ///
  /// ```dart
  /// DateTime(1970) < DateTime(1980); // true
  ///
  /// DateTime(1980) < DateTime(1970); // false
  ///
  /// DateTime(1970) < DateTime.utc(1980); // false
  /// ```
  ///
  /// See [DateTime.isBefore] for comparing [DateTime]s independent of timezones.
  bool operator < (T other) => timeZoneName == other.timeZoneName && isBefore(other);

  /// Returns `true` if this [DateTime] and [other] are in the same timezone and this [DateTime] occurs after [other].
  ///
  /// ```dart
  /// DateTime(1980) > DateTime(1970); // true
  ///
  /// DateTime(1970) > DateTime(1980); // false
  ///
  /// DateTime(1980) > DateTime.utc(1970); // false
  /// ```
  ///
  /// See [DateTime.isAfter] for comparing [DateTime]s independent of timezones.
  bool operator > (T other) => other < this;

  /// Returns `true` if this [DateTime] and [other] are in the same timezone, and this [DateTime] occurs before or at [other].
  ///
  /// ```dart
  /// DateTime(1970) <= DateTime(1980); // true
  ///
  /// DateTime(1980) <= DateTime(1970); // false
  ///
  /// DateTime(1970) <= DateTime.utc(1980); // false
  /// ```
  ///
  /// See [DateTime.isBefore] and [DateTime.isAtSameMomentAs] for comparing [DateTime]s independent of timezones.
  bool operator <= (T other) => !(this > other);

  /// Returns `true` if this [DateTime] and [other] are in the same timezone and this [DateTime] occurs after or at [other].
  ///
  /// ```dart
  /// DateTime(1980) >= DateTime(1970); // true
  ///
  /// DateTime(1970) >= DateTime(1980); // false
  ///
  /// DateTime(1980) >= DateTime.utc(1970); // false
  /// ```
  ///
  /// See [DateTime.isAfter] and [DateTime.isAtSameMomentAs] for comparing [DateTime]s independent of timezones.
  bool operator >= (T other) => !(this < other);

}
