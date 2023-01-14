import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Signifies that the implementing type has an intrinsic ordering. An [Orderable] implements all comparison operators,
/// including `==`, using [compareTo]. In most cases, [T] is the implementing type.
///
/// Unlike [Comparable], [Orderable] **requires** that its ordering agree with its operator [==] equality. Hence, overriding
/// the provided [==] implementation is not recommended.
///
/// Implementing types need to override only the following:
/// * [compareTo]
/// * [hashCode]
mixin Orderable<T extends Orderable<T>> implements Comparable<T> {

  /// Returns `true` if this [T] is less than [other].
  @useResult bool operator < (T other) => compareTo(other) < 0;
  //
  /// Returns `true` if this [T] is more than [other].
  @useResult bool operator > (T other) => compareTo(other) > 0;

  /// Returns `true` if this [T] is equal to or less than [other].
  @useResult bool operator <= (T other) => compareTo(other) <= 0;

  /// Returns `true` if this [T] is equal to or more than [other].
  @useResult bool operator >= (T other) => compareTo(other) >= 0;

  @override
  @nonVirtual
  @useResult bool operator ==(Object other) =>
      identical(this, other)
      || other is T
      && runtimeType == other.runtimeType
      && compareTo(other) == 0;

  /// Throws an [UnimplementedError]. [hashCode] should always be overridden by the implementing type.
  // TODO: add @mustBeOverridden in Dart 2.19
  @override
  int get hashCode => throw UnimplementedError('Since Orderable overrides --, hashCode should be overridden too. However, $runtimeType does not override hashCode. See https://dart-lang.github.io/linter/lints/hash_and_equals.html.');

}


/// Returns the lesser of [a] and [b] as defined by [Comparable.compareTo]. If [by] is given, the [Comparable] produced
/// by [by] is used. Otherwise, [T] must be a [Comparable].
///
/// This function is unstable, either [a] or [b] may be returned if both are equal.
///
/// ```dart
/// min(MapEntry(1, 'a'), MapEntry(2, 'a'), by: (e) => e.key); // MapEntry(1, 'a')
///
/// min(1, 2); // 1
///
/// max(MapEntry(1, 'a'), MapEntry(1, 'b'), by: (e) => e.key); // Either MapEntry(1, 'a') or MapEntry(1, 'b')
/// ```
///
/// ### Note:
/// The result of [min] and [math.min] differs when comparing numbers and either argument is [double.nan].
/// [min] will always return the other numeric argument while [math.min] will always return [double.nan].
///
/// ```dart
/// min(1.0, double.nan); // 1.0
///
/// math.min(1.0, double.nan); // double.nan
/// ```
///
/// This is an alternative to [math.min] that works on all [Comparable]s.
@useResult T min<T>(T a, T b, {Select<T, Comparable<Object>>? by}) {
  if (by != null) {
    return by(a).compareTo(by(b)) < 0 ? a : b;

  } else {
    return (a as Comparable).compareTo(b) < 0 ? a : b;
  }
}


/// Returns the greater of [a] and [b] as defined by [Comparable.compareTo]. If [by] is given, the [Comparable] produced
/// by [by] is used. Otherwise, [T] must be a [Comparable].
///
/// This function is unstable, either [a] or [b] may be returned if both are equal.
///
/// ```dart
/// max(MapEntry(1, 'a'), MapEntry(2, 'a'), by: (e) => e.key); // MapEntry(2, 'a')
///
/// max(1, 2); // 2
///
/// max(MapEntry(1, 'a'), MapEntry(1, 'b'), by: (e) => e.key); // Either MapEntry(1, 'a') or MapEntry(1, 'b')
/// ```
///
/// This is an alternative to [math.max] that works on all [Comparable]s.
@useResult T max<T>(T a, T b, {Select<T, Comparable<Object>>? by}) {
  if (by != null) {
    return by(a).compareTo(by(b)) > 0 ? a : b;

  } else {
    return (a as Comparable).compareTo(b) > 0 ? a : b;
  }
}


/// Provides functions for working with [Comparator]s.
extension Comparators<T> on Comparator<T> {

  /// Returns a [Comparator] that compares two [T]s using the values produced by [select].
  ///
  /// ```dart
  /// final compare = Comparators.by<MapEntry<int, String>>((e) => e.key);
  /// compare(MapEntry(1, 'b'), MapEntry(2, 'a')); // -1
  /// ```
  @useResult static Comparator<T> by<T>(Select<T, Comparable<Object>> select) => (a, b) => select(a).compareTo(select(b));


  @useResult Comparator<T> reverse() => (a, b) => this(a, b) * -1;

  @useResult Comparator<T> and(Comparator<T> other) => (a, b) {
    final comparison = this(a, b);
    return comparison != 0 ? comparison : other(a, b);
  };

}


/// Provides comparison operator overloads, i.e. `<=`, for [DateTime]s.
///
/// Unlike [DateTime.isBefore] and other related methods, the provided comparison operators require compared [DateTime]s
/// to be in the same timezone. Comparing [DateTime]s in different timezones will always return `false`. This is to
/// to ensure that comparison operators agree with [DateTime]'s [==].
///
/// ```dart
/// DateTime.now() > DateTime(1970); // true
///
/// DateTime.now() > DateTime.utc(1970); // false
/// ```
///
/// See [DateTime.isBefore] and other related methods for comparing [DateTime]s independent of timezones.
extension ComparableDateTimes<T extends DateTime> on T {

  /// Returns `true` if this [DateTime] and [other] are in the same timezone and this [DateTime] occurs before [other].
  ///
  /// ```dart
  /// DateTime(1970) < DateTime(1980); // true
  ///
  /// DateTime(1980) < DateTime(1970); // false
  ///
  /// DateTime(1970) < DateTime.utc(1980); // false
  /// ```
  ///
  /// See [DateTime.isBefore] for comparing [DateTime]s independent of timezones.
  @useResult bool operator < (T other) => timeZoneName == other.timeZoneName && isBefore(other);

  /// Returns `true` if this [DateTime] and [other] are in the same timezone and this [DateTime] occurs after [other].
  ///
  /// ```dart
  /// DateTime(1980) > DateTime(1970); // true
  ///
  /// DateTime(1970) > DateTime(1980); // false
  ///
  /// DateTime(1980) > DateTime.utc(1970); // false
  /// ```
  ///
  /// See [DateTime.isAfter] for comparing [DateTime]s independent of timezones.
  @useResult bool operator > (T other) => other < this;

  /// Returns `true` if this [DateTime] and [other] are in the same timezone, and this [DateTime] occurs before or at [other].
  ///
  /// ```dart
  /// DateTime(1970) <= DateTime(1980); // true
  ///
  /// DateTime(1980) <= DateTime(1970); // false
  ///
  /// DateTime(1970) <= DateTime.utc(1980); // false
  /// ```
  ///
  /// See [DateTime.isBefore] and [DateTime.isAtSameMomentAs] for comparing [DateTime]s independent of timezones.
  @useResult bool operator <= (T other) => !(this > other);

  /// Returns `true` if this [DateTime] and [other] are in the same timezone and this [DateTime] occurs after or at [other].
  ///
  /// ```dart
  /// DateTime(1980) >= DateTime(1970); // true
  ///
  /// DateTime(1970) >= DateTime(1980); // false
  ///
  /// DateTime(1980) >= DateTime.utc(1970); // false
  /// ```
  ///
  /// See [DateTime.isAfter] and [DateTime.isAtSameMomentAs] for comparing [DateTime]s independent of timezones.
  @useResult bool operator >= (T other) => !(this < other);

}
