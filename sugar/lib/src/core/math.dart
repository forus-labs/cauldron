/// Utilities for rounding a number.
extension RoundableNumber<T extends num> on T {

  /// Rounds this number to the nearest [value].
  T roundTo(num value) => round(this, value);

  /// Ceils this number to the nearest [value].
  T ceilTo(num value) => ceil(this, value);

  /// Floors this number to the nearest [value].
  T floorTo(num value) => floor(this, value);

}


/// Rounds [value] to the nearest [nearest].
T round<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).round() * nearest;

/// Ceils [value] to the nearest [nearest].
T ceil<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).ceil() * nearest;

/// Floors [value] to the nearest [nearest].
T floor<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).floor() * nearest;

extension Integers on int {

  // Dart2Js has a smaller range of values compared to the VM. Integers should
  // not exceed the range in order to be platform independent.
  static const max = 9007199254740991;
  static const min = -9007199254740991;

  bool addOverflows(int other) => ((other > 0) && (this > max - other))
                               || ((other < 0) && (this < min - other));

  bool subtractOverflows(int other) => ((other < 0) && (this > max + other))
                                    || ((other > 0) && (this < min + other));

}

///Returns the smaller of two [Comparable]s.
T min<T extends Comparable<T>>(T a, T b) => a.compareTo(b) < 0 ? a : b;

///Returns the larger of two [Comparable]s.
T max<T extends Comparable<T>>(T a, T b) => a.compareTo(b) < 0 ? b : a;

/// Creates a hash using [values].
int hash(Iterable<dynamic> values) {
  var hash = 17;
  for (final value in values) {
    hash = 37 * hash + value.hashCode;
  }

  return hash;
}