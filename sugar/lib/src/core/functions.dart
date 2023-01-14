import 'dart:async';

import 'package:meta/meta.dart';

/// Ann operation that accepts a single argument and returns nothing.
typedef Consume<T> = void Function(T value);

/// A predicate (boolean-valued function) of one argument.
typedef Predicate<T> = bool Function(T value);

/// A selector of one argument.
typedef Select<T, R> = R Function(T value);

/// A supplier of [T]s.
typedef Supply<T> = T Function();

/// A callback that has no arguments and returns nothing.
typedef Callback = FutureOr<void> Function();


/// A higher-order function that returns another function which destructs a given [MapEntry] and calls the given [function].
///
/// ```dart
/// {1: 1, 2: 3, 4: 5}.entries.where(entry((key, value) => key == value)); // [ MapEntry(1, 1) ]
/// ```
@useResult R Function(MapEntry<K, V>) entry<K, V, R>(R Function(K key, V value) function) => (entry) => function(entry.key, entry.value);
