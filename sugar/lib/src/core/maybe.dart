import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// A monad that may or may not contain a [T]. Every [Maybe] is either [Some] and contains a value, or [None] and does not.
///
/// A [Maybe] is especially useful for representing an absence of value when [T] is nullable.
@sealed abstract class Maybe<T> {

  /// Creates a [Maybe].
  const Maybe();

  /// Returns true if this [Maybe] contains the given [value].
  ///
  /// This [Maybe]'s value and the given [value] are considered equal if [Equality.deep] returns true.
  bool contains(T value);


  /// If a value is present, and the value satisfies the given [predicate], return this [Maybe], otherwise returns [None].
  ///
  /// ```dart
  /// final foo = Some('value').filter((string) => string == 'value');
  /// print(foo); // Some('value')
  ///
  /// final bar = Some('value').filter((string) => string == 'other');
  /// print(bar); // None()
  ///
  /// final none = None().filter((string) => string == 'value');
  /// print(none); // None()
  /// ```
  Maybe<T> filter(Predicate<T> predicate);

  /// If a value is present, returns the [Maybe] produced by [map], otherwise returns [None].
  ///
  /// This method is similar to [Maybe.map] except that the given function returns a [Maybe] instead of [T].
  ///
  /// ```dart
  /// final foo = Some('value').flat(map: (value) => Some('other value'));
  /// print(foo); // Some('other value')
  ///
  /// final bar = None().flat(map: (value) => Some('other value'));
  /// print(bar); // None()
  /// ```
  Maybe<T> flat({required Maybe<T> Function(T value) map});

  /// If a value is present, returns the value produced by [map] wrapped in a [Some], otherwise returns [None].
  ///
  /// This method is similar to [Maybe.flat] except that the given function returns a [T] instead of [Maybe].
  ///
  /// ```dart
  /// final foo = Some('value').map((value) => Some('other value'));
  /// print(foo); // Some('other value')
  ///
  /// final bar = None().map((value) => Some('other value'));
  /// print(bar); // None()
  /// ```
  Maybe<T> map(T Function(T value) function);

  /// If a value is present, returns the value, otherwise throws a [StateError].
  ///
  /// ```dart
  /// final foo = Some('value');
  /// print(foo.unwrap()); // 'value'
  ///
  /// final bar = None();
  /// print(bar.unwrap()); // throws a StateError
  /// ```
  @Possible({StateError})
  T unwrap();


  /// Whether a value is present.
  ///
  /// ```dart
  /// final foo = Some('value');
  /// print(foo.exists); // true
  ///
  /// final bar = None();
  /// print(bar.exists); // false
  /// ```
  bool get exists;

}

/// Provides functions for working with [Maybe] where the value is non-nullable.
extension NonNullableMaybe<T extends Object> on Maybe<T> {

  /// If a value is present, returns the value, otherwise returns [None].
  ///
  /// ```dart
  /// final foo = const None().nullable ?? 'value';
  /// print(foo); // 'value'
  /// ```
  @Possible({StateError})
  T? get nullable => exists ? unwrap() : null;

}


/// Represents some value of [T].
class Some<T> extends Maybe<T> {

  final T _value;

  /// Creates [Some] with the given value.
  const Some(this._value);

  @override
  bool contains(T value) => Equality.deep(_value, value);


  @override
  Maybe<T> filter(Predicate<T> predicate) => predicate(_value) ? this : None<T>();

  @override
  Maybe<T> flat({required Maybe<T> Function(T value) map}) => map(_value);

  @override
  Maybe<T> map(T Function(T value) function) => Some(function(_value));

  @override
  T unwrap() => _value;

  @override
  bool get exists => true;


  @override
  bool operator ==(Object other) => identical(this, other) || other is Some && runtimeType == other.runtimeType && Equality.deep(_value, other._value);

  @override
  int get hashCode => HashCodes.deep(_value);

  @override
  String toString() => 'Some{_value: $_value}';

}


/// Represents no value.
class None<T> extends Maybe<T> {

  /// Creates a [None].
  const None();

  @override
  bool contains(T value) => false;


  @override
  Maybe<T> filter(Predicate<T> predicate) => const None();

  @override
  Maybe<T> flat({required Maybe<T> Function(T value) map}) => const None();

  @override
  Maybe<T> map(T Function(T value) function) => const None();

  @override
  T unwrap() => throw StateError('Maybe<$T> does not contain a value, try checking if it contains a value via `Maybe.exists` first.');

  @override
  bool get exists => false;


  @override
  bool operator ==(Object other) => identical(this, other) || other is None && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  @override
  String toString() => 'None{}';

}