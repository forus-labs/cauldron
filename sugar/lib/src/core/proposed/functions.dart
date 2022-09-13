// Collection of commonly used functions.

T identity<T>(T value) => value;

bool nonNull(Object? value) => value != null;

// void a() {
//   [].
//   [].where(not(nullable));
// }

// indexed() function that returns a function transforms input into index + input <- will not work

// distinct(optional by) ->

// not

// identity

// nullable

// between

// function for breaking down Function(MapEntry<int, T>) to Function(int, T), function that returns function.

R Function(MapEntry<int, E>) entry<R, E>(R Function(int, E) func) => (entry) => func(entry.key, entry.value);