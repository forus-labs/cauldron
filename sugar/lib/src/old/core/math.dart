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
T round<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).round() * nearest as T;

/// Ceils [value] to the nearest [nearest].
T ceil<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).ceil() * nearest as T;

/// Floors [value] to the nearest [nearest].
T floor<T extends num>(T value, num nearest) =>  nearest == 1 ? value : (value / nearest).floor() * nearest as T;

/// Utilities for handling overflows.
extension Integers on int {

  /// Returns `1` if the given [value] is true. Otherwise returns `0`.
  static int from(bool value) => value ? 1 : 0; // ignore: avoid_positional_boolean_parameters

  // Dart2Js has a smaller range of values compared to the VM. Integers should
  // not exceed the range in order to be platform independent.

  /// The maximum platform-independent value.
  static const max = 9007199254740991;
  /// The minimum platform-independent value.
  static const min = -9007199254740991;

  /// Returns true if this integer is greater than 0. Otherwise returns false.
  bool toBool() => this > 0;

}
