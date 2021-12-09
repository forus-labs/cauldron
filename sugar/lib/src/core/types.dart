/// Provides utilities for comparing and manipulating types.
class Types {

  /// Determines if [unknown] is a subtype of [T].
  static bool isSubtype<T>(dynamic unknown, T type) => unknown is T;

}
