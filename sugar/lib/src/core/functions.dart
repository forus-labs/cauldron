/// Represents an operation that accepts a single argument.
typedef Consumer<T> = void Function(T);

/// Represents a predicate (boolean-valued function) of one argument.
typedef Predicate<T> = bool Function(T);

/// Represents a supplier of [T]s.
typedef Supplier<T> = T Function();


/// A higher-order function that returns another function that destructs a given [MapEntry] and calls the given [function].
///
/// ```dart
/// final entries = {1: 1, 2: 3, 4: 5}.entries.where(entry((key, value) => key == value));
/// print(entries); // [MapEntry(1, 1)]
/// ```
R Function(MapEntry<K, V>) entry<K, V, R>(R Function(K key, V value) function) => (entry) => function(entry.key, entry.value);