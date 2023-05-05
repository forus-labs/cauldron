/// An operation that accepts a single argument and returns nothing.
typedef Consume<T> = void Function(T value);

/// A predicate (boolean-valued function) of one argument.
typedef Predicate<T> = bool Function(T value);

/// A selector of one argument.
typedef Select<T, R> = R Function(T value);

/// A supplier of [T]s.
typedef Supply<T> = T Function();

/// A callback that has no arguments and returns nothing.
typedef Callback = void Function();
