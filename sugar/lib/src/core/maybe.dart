import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// A [Maybe] monad that may or may not contain a [T].
///
/// See [Result] for representing either of two possible values.
///
/// **Implementation details: **
/// This implementation leverages on Dart's type system, foregoing any explicit container types. Assuming that [T] is a
/// value, then `Maybe(T) = Some(T) | None()` can be represented as `T? = T | null` in Dart's type system.
///
/// This makes:
/// ```dart
/// String foo(int? bar) {
///   return bar.where((e) => e == 1).map((e) => e.toString())!;
/// }
/// ```
///
/// the equivalent of:
/// ```dart
/// String foo(Maybe<int> bar) {
///   return bar.where((e) => e == 1).map((e) => e.toString()).unwrap();
/// }
/// ```
///
/// Leveraging on Dart's type system has the downside where most methods will not work with collection types due to
/// conflicting method names. However, it is believed to be an acceptable tradeoff since `None` should be represented
/// by an empty collection instead.
extension Maybe<T extends Object> on T? {

  /// If this is not null and satisfies the given [predicate], return this, otherwise returns `null`.
  ///
  /// ```dart
  /// String? value = 'value';
  ///
  /// value.where((string) => string == 'value'); // 'value'
  ///
  /// value.where((string) => string == 'other'); // null
  ///
  ///
  /// String? value = null;
  ///
  /// value.where((string) => string == 'value'); // null
  /// ```
  @useResult T? where(Predicate<T> predicate) => this != null && predicate(this!) ? this : null;

  /// If this is not null, returns the [R] produced by [map], otherwise returns null.
  ///
  /// This method is similar to [bind] except that the given function returns a [T] instead of `T?`.
  ///
  /// ```dart
  /// String? value = 'value';
  /// value.map((value) => 'other value'); // 'other value'
  ///
  /// String? value = null;
  /// value.map((value) => 'other value'); // null
  /// ```
  @useResult R? map<R extends Object>(R Function(T value) function) => this == null ? null : function(this!);

  /// If this is not null, returns the `R?` produced by [function], otherwise returns null.
  ///
  /// This method is similar to [map] except that the given function returns a `T?` instead of [T].
  ///
  /// ```dart
  /// String? value = 'value';
  ///
  /// value.bind((value) => 'other value'); // 'other value';
  ///
  /// value.bind((value) => null); // null;
  ///
  ///
  /// String? value = null;
  ///
  /// value.bind((value) => 'other value'); // null
  /// ```
  @useResult R? bind<R>(R? Function(T value) function) => this == null ? null : function(this!);

  /// If this is not null, returns the [Future] produced by [function], otherwise returns null.
  ///
  /// This method is similar to [bind] except that the given function asynchronously computes a [Future].
  ///
  /// ```dart
  /// Future<int?> computeAsync<T>(T value) async => 1;
  ///
  /// String? value = 'value';
  /// 'value'.pipe(computeAsync); // Future(1)
  ///
  /// String? value = null;
  /// value.pipe(computeAsync); // Future(null)
  /// ```
  Future<R?> pipe<R>(Future<R> Function(T value) function) async => this == null ? null : function(this!);

}
