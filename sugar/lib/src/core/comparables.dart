/// Provides functions for working with [Comparable]s.
extension Comparables<T> on Comparable<T> {

  /// Returns the lesser of two [Comparable]s.
  static T min<T extends Comparable>(T a, T b) => a.compareTo(b) == -1 ? a : b;

  /// Returns the greater of two [Comparable]s.
  static T max<T extends Comparable>(T a, T b) => a.compareTo(b) == 1 ? a : b;

}
