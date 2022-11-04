import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A monad that may or may not contain a [T]. A [Maybe] is either [Some] and contains a value, or [None] and does not.
///
/// A [Maybe] is especially useful for representing an absence of value when [T] is nullable. Two values are equal if the
/// values returned by [unwrap] are equal according to [Equality.deep].
///
/// See [Result] for representing either of two possible values.
@sealed abstract class Maybe<T> {

  static void _exists(Object? value) {}

  static void _empty() {}

  /// Creates a [Maybe].
  const Maybe._();

  /// Returns true if this [Maybe] contains the given [value].
  ///
  /// This [Maybe]'s value and the given [value] are considered equal if [Equality.deep] returns true.
  @useResult bool contains(T value);


  /// If a value is present and satisfies the given [predicate], return this [Maybe], otherwise returns [None].
  ///
  /// ```dart
  /// Some('value').where((string) => string == 'value'); // Some('value')
  ///
  /// Some('value').where((string) => string == 'other'); // None()
  ///
  /// None().where((string) => string == 'value'); // None()
  /// ```
  @useResult Maybe<T> where(Predicate<T> predicate);

  /// If a value is present, returns the [Maybe] produced by [function], otherwise returns [None].
  ///
  /// This method is similar to [Maybe.map] except that the given function returns a [Maybe] instead of [T].
  ///
  /// ```dart
  /// Some('value').bind((value) => Some('other value')); // Some('other value')
  ///
  /// None().bind((value) => Some('other value')); // None()
  /// ```
  @useResult Maybe<R> bind<R>(Maybe<R> Function(T value) function);

  /// If a value is present, returns the value produced by [map] wrapped in a [Some], otherwise returns [None].
  ///
  /// This method is similar to [Maybe.bind] except that the given function returns a [T] instead of [Maybe].
  ///
  /// ```dart
  /// Some('value').map((value) => 'other value'); // Some('other value')
  ///
  /// None().map((value) => 'other value'); // None()
  /// ```
  @useResult Maybe<R> map<R>(R Function(T value) function);

  /// If a value is present, returns the [Maybe] produced by [function], otherwise returns [None].
  ///
  /// This method is similar to [Maybe.bind] except that the given function asynchronously computes a [Maybe].
  ///
  /// ```dart
  /// Future<Maybe<int>> computeAsync<T>(T value) async => Some(1);
  ///
  /// Some('value').pipe(computeAsync); // Future(Some(1))
  ///
  /// None().pipe(computeAsync); // Future(None())
  /// ```
  @useResult Future<Maybe<R>> pipe<R>(Future<Maybe<R>> Function(T value) function);


  /// Transforms this [Maybe] into a [Result]. [Some] is mapped to [Success] while [None] is mapped to [Failure] using
  /// the given function.
  ///
  /// ```dart
  /// Some('value').or(() => 1); // Success('value')
  ///
  /// None().or(() => 1); // Failure(1)
  /// ```
  @useResult Result<T, F> or<F>(F Function() failure);

  /// If this [Maybe] contains a value, calls [exists] with the value, otherwise calls [empty]. By default, [exists] and [empty]
  /// does nothing.
  ///
  /// ```dart
  /// Some('value').when(exists: print, empty: () => print('empty')); // 'value'
  ///
  /// None().when(exists: print, empty: () => print('empty')); // 'empty'
  /// ```
  void when({Consumer<T> exists = _exists, void Function() empty = _empty});

  /// If a value is present, returns the value, otherwise throws a [StateError].
  ///
  /// ```dart
  /// Some('value').unwrap(); // 'value'
  ///
  /// None().unwrap(); // throws a StateError
  /// ```
  @Possible({StateError})
  @useResult T unwrap();

  /// Whether a value is present.
  ///
  /// ```dart
  /// Some('value').exists; // true
  ///
  /// None().exists; // false
  /// ```
  @useResult bool get exists;

}

/// Provides functions for working with [Maybe] where the value is non-nullable.
extension NonNullableMaybe<T extends Object> on Maybe<T> {

  /// If a value is present, returns the value, otherwise returns `null`.
  ///
  /// ```dart
  /// const None().nullable ?? 'value'; // 'value'
  /// ```
  @useResult T? get nullable => exists ? unwrap() : null;

}


/// Represents some value of [T].
@sealed class Some<T> extends Maybe<T> {

  final T _value;

  /// Creates [Some] with the given value.
  const Some(this._value): super._();

  @override
  @useResult bool contains(T value) => Equality.deep(_value, value);


  @override
  @useResult Maybe<T> where(Predicate<T> predicate) => predicate(_value) ? this : None<T>();

  @override
  @useResult Maybe<R> bind<R>(Maybe<R> Function(T value) function) => function(_value);

  @override
  @useResult Maybe<R> map<R>(R Function(T value) function) => Some(function(_value));

  @override
  @useResult Future<Maybe<R>> pipe<R>(Future<Maybe<R>> Function(T value) function) => function(_value);


  @override
  @useResult Result<T, F> or<F>(F Function() failure) => Success(_value);


  @override
  void when({Consumer<T> exists = Maybe._exists, void Function() empty = Maybe._empty}) => exists(_value);

  @override
  @useResult T unwrap() => _value;

  @override
  @useResult bool get exists => true;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Some && Equality.deep(_value, other._value);

  @override
  int get hashCode => HashCodes.deep(_value);

  @override
  String toString() => 'Some($_value)';

}


/// Represents no value.
@sealed class None<T> extends Maybe<T> {

  /// Creates a [None].
  const None(): super._();

  @override
  @useResult bool contains(T value) => false;


  @override
  @useResult Maybe<T> where(Predicate<T> predicate) => const None();

  @override
  @useResult Maybe<R> bind<R>(Maybe<R> Function(T value) function) => const None();

  @override
  @useResult Maybe<R> map<R>(R Function(T value) function) => const None();

  @override
  @useResult Future<Maybe<R>> pipe<R>(Future<Maybe<R>> Function(T value) function) async => const None();


  @override
  @useResult Result<T, F> or<F>(F Function() failure) => Failure(failure());


  @override
  void when({Consumer<T> exists = Maybe._exists, void Function() empty = Maybe._empty}) => empty();

  @override
  @useResult T unwrap() => throw StateError('Maybe<$T> does not contain a value. Try checking if it contains a value via `Maybe.exists` first.');

  @override
  @useResult bool get exists => false;


  @override
  bool operator ==(Object other) => identical(this, other) || other is None;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'None()';

}