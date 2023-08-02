import 'dart:math' as math;

import 'package:meta/meta.dart';

import 'package:sugar/core.dart';

/// Simplifies implementation of naturally ordered types.
///
/// [Orderable] implements all comparison operators, including [==], using [compareTo]. Implementations should have only
/// one representation for a value. Otherwise [==] will disagree with the ordering.
///
/// A counterexample is [DateTime]. Several `DateTime`s in different timezones may represent the same instant in time.
/// However, two `DateTime`s are only equal if they represent the same instant and share the same timezone.
///
/// Implementations should override only the following:
/// * [compareTo]
/// * [hashValue]
///
/// Objects where [compareTo] is 0 should have the same [hashValue]. A common mistake is to use an unrelated field when
/// computing a `hashValue`.
///
/// Counterexample:
/// ```dart
/// class Foo with Orderable<Foo> {
///   final String key;
///   final int value;
///
///   Foo(String.key, this.value);
///
///   @override
///   int compareTo(Wrong other) => key.compareTo(other.key);
///
///   @override
///   int get hashValue => Object.hash(key, value);
/// }
///
/// Foo('a', 1) == Foo('a', 2); // true
///
/// Foo('a', 1).hashCode == Foo('a', 2).hashCode; // false, violates hash code contract
/// ```
mixin Orderable<T extends Orderable<T>> implements Comparable<T> {

  /// Returns true if this is less than [other].
  @nonVirtual
  @useResult bool operator < (T other) => compareTo(other) < 0;

  /// Returns true if this is more than [other].
  @nonVirtual
  @useResult bool operator > (T other) => compareTo(other) > 0;

  /// Returns true if this is equal to or less than [other].
  @nonVirtual
  @useResult bool operator <= (T other) => compareTo(other) <= 0;

  /// Returns `true` if this is equal to or more than [other].
  @nonVirtual
  @useResult bool operator >= (T other) => compareTo(other) >= 0;

  @override
  @nonVirtual
  @useResult bool operator ==(Object other) =>
      identical(this, other)
      || other is T
      && runtimeType == other.runtimeType
      && compareTo(other) == 0;

  @override
  @nonVirtual
  @useResult int get hashCode => hashValue;

  /// This object's hash.
  ///
  /// Objects where [compareTo] is 0 should have the same [hashValue]. A common mistake is to use an unrelated field when
  /// computing a `hashValue`.
  ///
  /// Counterexample:
  /// ```dart
  /// class Foo with Orderable<Foo> {
  ///   final String key;
  ///   final int value;
  ///
  ///   Foo(String.key, this.value);
  ///
  ///   @override
  ///   int compareTo(Wrong other) => key.compareTo(other.key);
  ///
  ///   @override
  ///   int get hashValue => Object.hash(key, value);
  /// }
  ///
  /// Foo('a', 1) == Foo('a', 2); // true
  ///
  /// Foo('a', 1).hashCode == Foo('a', 2).hashCode; // false, violates hash code contract
  /// ```
  @protected int get hashValue;

}


/// Returns the lesser of [a] and [b].
///
/// If [by] is given, the produced [Comparable] is used. Otherwise [a] and [b] must be `Comparable`s.
///
/// This function is unstable, either [a] or [b] may be returned if both are equal. Unlike [math.min], it works on all
/// `Comparable`s.
///
/// ```dart
/// min(('a', 1), ('a', 2), by: (e) => e.$2); // ('a', 1)
///
/// min(1, 2); // 1
/// ```
///
/// ## [double.nan] values
/// This function and [math.min] handles `double.nan` differently. This function returns the other argument while
/// `math.min` returns `double.nan`.
///
/// ```dart
/// min(1.0, double.nan); // 1.0
///
/// math.min(1.0, double.nan); // double.nan
/// ```
@Possible({TypeError})
@useResult T min<T>(T a, T b, {Select<T, Comparable<Object>>? by}) => switch (by) {
  _? => by(a).compareTo(by(b)) < 0 ? a : b,
  _ => (a as Comparable).compareTo(b) < 0 ? a : b,
};


/// Returns the greater of [a] and [b].
///
/// If [by] is given, the produced [Comparable] is used. Otherwise [a] and [b] must be `Comparable`s.
///
/// This function is unstable, either [a] or [b] may be returned if both are equal. Unlike [math.max], it works on all
/// `Comparable`s.
///
/// ```dart
/// max(('a', 1), ('a', 2), by: (e) => e.$2); // ('a', 2)
///
/// max(1, 2); // 2
/// ```
@Possible({TypeError})
@useResult T max<T>(T a, T b, {Select<T, Comparable<Object>>? by}) => switch (by) {
  _? => by(a).compareTo(by(b)) > 0 ? a : b,
  _ => (a as Comparable).compareTo(b) > 0 ? a : b,
};


/// Provides functions for working with [Comparator]s.
extension Comparators<T> on Comparator<T> {

  /// Returns a [Comparator] that compares two [T]s using the values produced by [select].
  ///
  /// ```dart
  /// final compare = Comparators.by<(String, int)>((e) => e.$2);
  /// compare(('b', 1), MapEntry('a', 2)); // -1
  /// ```
  @useResult static Comparator<T> by<T>(Select<T, Comparable<Object>> select) => (a, b) => select(a).compareTo(select(b));

  /// Reverses the ordering of this `Comparator`.
  ///
  /// ```dart
  /// final Comparator<int> compare = (a, b) => a.compareTo(b);
  ///
  /// compare(1, 2); // -1;
  ///
  /// compare.reverse()(1, 2); // 1
  /// ```
  @useResult Comparator<T> reverse() => (a, b) => this(a, b) * -1;

  /// Returns a [Comparator] that uses [tiebreaker] to break ties.
  ///
  /// ```dart
  /// final Comparator<(int, int)> foo = (a, b) => a.$1.compareTo(b.$1);
  /// foo((1, 1), (1, 2)); // 0
  ///
  /// final bar = foo.and((a, b) => a.$2.compareTo(b.$2));
  /// bar((1, 1), (1, 2)); // -1
  /// ```
  @useResult Comparator<T> and(Comparator<T> tiebreaker) => (a, b) => switch(this(a, b)) {
    0 => tiebreaker(a, b),
    final value => value,
  };

}
