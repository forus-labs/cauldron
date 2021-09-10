/// Represents an operation with no arguments.
typedef Call = void Function();

/// Represents an operation that accepts a single argument.
typedef Consumer<T> = void Function(T);

/// Maps a value of type [T] to [R].
typedef Mapper<T, R> = R Function(T);

/// Represents a predicate (boolean-valued function) of one argument.
typedef Predicate<T> = bool Function(T);

/// Represents a supplier of results.
typedef Supplier<T> = T Function();

/// Contains functions for composing [Call]s and other operations.
extension Calls on Call {

  /// Returns a composed [Call] that calls this [Call] followed by [next].
  Call then(Call next) => () {
    this();
    next();
  };

}

/// Contains functions for composing `Consumer`s.
extension Consumers<T> on Consumer<T> {

  /// Returns a composed [Consumer] that calls this [Consumer] followed by [next].
  Consumer<T> then(Consumer<T> next) => (value) {
   this(value);
   next(value);
  };

}

/// Contains functions for composing [Mapper]s and other operations.
extension Mappers<T, R> on Mapper<T, R> {

  /// Returns a composed [Mapper] that calls this [Mapper] and applies the result to [next].
  Mapper<T, R1> map<R1>(Mapper<R, R1> next) => (value) => next(this(value));

  /// Returns a composed [Mapper] that calls this [Mapper] and applies the result to [consumer].
  Consumer<T> pipe(Consumer<R> consumer) => (value) => consumer(this(value));

  /// Returns a composed [Mapper] that calls this [Mapper] and applies the result to [predicate].
  Predicate<T> test(Predicate<R> predicate) => (value) => predicate(this(value));

}

/// Contains functions for composing [Predicate]s and other operations.
extension Predicates<T> on Predicate<T> {

  /// Returns a composed [Predicate] that represents a short-circuiting logical AND of this [Predicate] and [other].
  Predicate<T> and(Predicate<T> other) => (value) => this(value) && other(value);

  /// Returns a composed [Predicate] that represents a short-circuiting logical OR of this [Predicate] and [other].
  Predicate<T> or(Predicate<T> other) => (value) => this(value) || other(value);

  /// Returns a [Predicate] that represents a negation of this [Predicate].
  Predicate<T> negate() => (value) => !this(value);

  /// Returns a composed [Mapper] that calls this [Predicate] and applies the result to [next].
  Mapper<T, R> map<R>(Mapper<bool, R> next) => (value) => next(this(value));

  /// Returns a composed [Mapper] that calls this [Predicate] and applies the result to [consumer].
  Consumer<T> pipe(Consumer<bool> consumer) => (value) => consumer(this(value));

}

/// Contains functions for composing [Supplier]s and other operations.
extension Suppliers<T> on Supplier<T> {

  /// Returns a composed [Supplier] that calls this [Supplier] and applies the result to [next].
  Supplier<R> map<R>(Mapper<T, R> next) => () => next(this());

  /// Returns a composed [Call] that calls this [Supplier] and applies the result to [consumer].
  Call pipe(Consumer<T> consumer) => () => consumer(this());

  /// Returns a composed [Supplier] that calls this [Supplier] and applies the result to [predicate].
  Supplier<bool> test(Predicate<T> predicate) => () => predicate(this());

}