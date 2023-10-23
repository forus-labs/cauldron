import 'dart:collection';

/// Provides functions for working [SplayTreeMap]s.
extension SplayTreeMaps<K, V> on SplayTreeMap<K, V> {

  /// Returns the value associated with the first key after [key], or null if there are no keys after [key].
  ///
  /// ```dart
  /// final map = SplayTreeMap.of({1: 'A', 2: 'B', 3: 'C'});
  ///
  /// print(map.firstValueAfter(1)); // 'B'
  /// print(map.firstValueAfter(3)); // null
  /// ```
  V? firstValueAfter(K key) => switch (firstKeyAfter(key)) {
    null => null,
    final key => this[key],
  };

  /// Returns the value associated with the last key before [key], or null if there are no keys before [key].
  ///
  /// ```dart
  /// final map = SplayTreeMap.of({1: 'A', 2: 'B', 3: 'C'});
  ///
  /// print(map.lastValueBefore(3)); // 'B'
  /// print(map.lastValueBefore(1)); // null
  /// ```
  V? lastValueBefore(K key) => switch (lastKeyBefore(key)) {
    null => null,
    final key => this[key],
  };

}
