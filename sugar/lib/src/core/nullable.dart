/// Provides functions for casting nullable [Object]s.
extension NullableObjects on Object? {
  /// Casts `this` to [T] if it is a [T], and returns `null` otherwise.
  ///
  /// ```dart
  /// final num foo = 1;
  /// foo.as<int>(); // 1
  ///
  /// 'string'.as<int>(); // null
  /// null.as<int>(); // null
  /// ```
  T? as<T extends Object>() {
    final self = this;
    return self is T ? self : null;
  }
}
