import 'dart:async';

import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// A [Maybe] monad that may or may not contain a [T].
///
/// _All nullable types are `Maybe` monads_. Leveraging on the type system, this implementation is not an explicit container.
///
/// Assuming:
/// ```
/// Maybe(T) = Some(T) | None()
/// ```
///
/// It can be represented in the type system as:
/// ```
/// T? = T | null
/// ```
///
/// Example:
/// ```dart
/// String foo(int? bar) { // int? is a Maybe(int) monad.
///   return bar.where((e) => e == 1).map((e) => e.toString())!;
/// }
/// ```
///
/// ## [Maybe] and collections
/// It is recommended to use an empty collection to represent `None()`. Thus, most of [Maybe]'s functions deliberately
/// do not work on collections.
///
/// **Good:**
/// ```dart
/// List<String> foo() {
///   if (notFound) return [];
/// }
/// ```
///
/// **Bad**:
/// ```dart
/// List<String>? foo() {
///   if (notFound) return null;
/// }
/// ```
///
/// See:
/// * [FutureMaybe] for working with asynchronous `Maybe`s.
/// * [Result] for representing successes and failures.
@Deprecated('This extension was originally designed before the release of Dart 3 & pattern matching. It has been became clear that pattern matching is a superior alternative to this. It will be removed in Sugar 3.3.0')
extension Maybe<T extends Object> on T? {

  /// Returns this if it is not null and satisfies [predicate]. Otherwise returns `null`.
  ///
  /// ```dart
  /// String? foo = 'value';
  ///
  /// foo.where((v) => v == 'value'); // 'value'
  ///
  /// foo.where((v) => v == 'other'); // null
  ///
  ///
  /// String? bar = null;
  ///
  /// bar.where((e) => e == 'value'); // null
  /// ```
  @useResult T? where(Predicate<T> predicate) => this != null && predicate(this!) ? this : null;

  /// Returns [R?] produced by [function] if this is not null. Otherwise returns `null`.
  ///
  /// This function is similar to [map] except that it returns [R?] instead of [R].
  ///
  /// ```dart
  /// String? foo = 'value';
  ///
  /// foo.bind((v) => 'other value'); // 'other value';
  ///
  /// foo.bind((v) => null); // null;
  ///
  ///
  /// String? bar = null;
  ///
  /// bar.bind((v) => 'other value'); // null
  /// ```
  @useResult R? bind<R>(R? Function(T value) function) => this == null ? null : function(this!);

  /// Returns [R] if this is not null. Otherwise returns null.
  ///
  /// This function is similar to [bind] except that it returns [R] instead of [R?]
  ///
  /// ```dart
  /// String? foo = 'value';
  /// foo.map((v) => 'other value'); // 'other value'
  ///
  /// String? bar = null;
  /// bar.map((v) => 'other value'); // null
  /// ```
  @useResult R? map<R extends Object>(R Function(T value) function) => this == null ? null : function(this!);

}

/// Provides functions for working with asynchronous `Maybe`s.
extension FutureMaybe<T extends Object> on Future<T?> {

  /// Returns a [Future<R?>] if this `Future` does not complete as null. Otherwise returns a `Future` that completes as
  /// null.
  ///
  /// Example:
  /// ```dart
  /// Future<int?> computeAsync<T>(T value) async => 1;
  ///
  /// Future<String?> foo = Future.value('value');
  /// foo.pipe(computeAsync); // Future(1)
  ///
  /// Future<String?> bar = null;
  /// bar.pipe(computeAsync); // Future(null)
  /// ```
  ///
  /// Chaining this function:
  /// ```dart
  /// Future<int?> addAsync<T>(T value) async => value + 1;
  ///
  /// Future<int?> one = Future.value(1);
  ///
  /// one.pipe(addAsync).pipe(addAsync); // Future(3)
  /// ```
  @useResult Future<R?> pipe<R>(FutureOr<R?> Function(T value) function) async {
    final value = await this;
    return value == null ? null : function(value);
  }

}
