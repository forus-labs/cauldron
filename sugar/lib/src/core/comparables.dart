import 'dart:math' as math;

import 'package:meta/meta.dart';
import 'package:sugar/core.dart';

/// Signifies that the implementing type has an intrinsic ordering. An [Orderable] implements all comparison operators,
/// including [==], using [compareTo]. In most cases, [T] is the implementing type.
///
/// Implementing types should override the following:
/// * [compareTo]
/// * [hash]
///
/// Overriding [==] is not recommended as [Orderable] requires that its ordering agree with its operator [==] equality.
///
/// It is important that [hash] follows the contract defined in [Object.hashCode]. In particular, hash codes must be the
/// same for [Orderable]s that are equal to each other according to [==]. The following code snippet illustrates  a common mistake.
///
/// ```dart
/// class Wrong with Orderable<Wrong> {
///   final int key;
///   final int value;
///
///   Wrong(this.key, [this.value = 0]);
///
///   @override
///   int compareTo(Wrong other) => key.compareTo(other.key);
///
///   @override
///   int get hashValue => Object.hash(key, value); // wrong hashCode implementation
/// }
///
/// Wrong(1, 1) == Wrong(1, 2); // true
/// Wrong(1, 1).hashCode == Wrong(1, 2).hashCode // false, violates hashCode contract
/// ```
mixin Orderable<T extends Orderable<T>> implements Comparable<T> {

  /// Returns `true` if this [T] is less than [other].
  @nonVirtual
  @useResult bool operator < (T other) => compareTo(other) < 0;
  //
  /// Returns `true` if this [T] is more than [other].
  @nonVirtual
  @useResult bool operator > (T other) => compareTo(other) > 0;

  /// Returns `true` if this [T] is equal to or less than [other].
  @nonVirtual
  @useResult bool operator <= (T other) => compareTo(other) <= 0;

  /// Returns `true` if this [T] is equal to or more than [other].
  @nonVirtual
  @useResult bool operator >= (T other) => compareTo(other) >= 0;

  @override
  @nonVirtual
  @useResult bool operator ==(Object other) =>
      identical(this, other)
      || other is T
      && runtimeType == other.runtimeType
      && compareTo(other) == 0;

  /// The hash code for this object. Hash computation is delegated to [hashValue].
  ///
  /// ### Implementation details:
  /// This is done to enforce overriding of hash computation and prevent a bad interaction between annotating [==]
  /// with @[nonVirtual] and the `hash_and_equals` lint rule.
  @override
  @nonVirtual
  @useResult int get hashCode => hashValue;

  /// The hash code for this object. Implementations must follow the [hashCode] contract. See [Orderable]'s documentation
  /// for more information.
  @protected int get hashValue;

}


/// Returns the lesser of [a] and [b] using [Comparable.compareTo]. If [by] is specified, the [Comparable] produced is used.
/// Otherwise, [T] must be a [Comparable].
///
/// This function is unstable, either [a] or [b] may be returned if both are equal.
///
/// ```dart
/// min(MapEntry(1, 'a'), MapEntry(2, 'a'), by: (e) => e.key); // MapEntry(1, 'a')
///
/// min(1, 2); // 1
///
/// max(MapEntry(1, 'a'), MapEntry(1, 'b'), by: (e) => e.key); // MapEntry(1, 'a') or MapEntry(1, 'b')
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
@Possible({TypeError})
@useResult T min<T>(T a, T b, {Select<T, Comparable<Object>>? by}) {
  if (by != null) {
    return by(a).compareTo(by(b)) < 0 ? a : b;

  } else {
    return (a as Comparable).compareTo(b) < 0 ? a : b;
  }
}


/// Returns the greater of [a] and [b] using [Comparable.compareTo]. If [by] is specified, the [Comparable] produced is used.
/// Otherwise, [T] must be a [Comparable].
///
/// This function is unstable, either [a] or [b] may be returned if both are equal.
///
/// ```dart
/// max(MapEntry(1, 'a'), MapEntry(2, 'a'), by: (e) => e.key); // MapEntry(2, 'a')
///
/// max(1, 2); // 2
///
/// max(MapEntry(1, 'a'), MapEntry(1, 'b'), by: (e) => e.key); // MapEntry(1, 'a') or MapEntry(1, 'b')
/// ```
///
/// This is an alternative to [math.max] that works on all [Comparable]s.
@Possible({TypeError})
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

  /// Returns a [Comparator] that reverses the ordering produced by this [Comparator].
  ///
  /// ```dart
  /// final Comparator<int> compare = (a, b) => a.compareTo(b);
  ///
  /// compare(1, 2); // -1;
  ///
  /// compare.reverse()(1, 2); // 1
  /// ```
  @useResult Comparator<T> reverse() => (a, b) => this(a, b) * -1;

  /// Returns a [Comparator] that uses [tiebreaker] to break ties when this [Comparator] considers two elements to be equal,
  /// i.e. `comparator(a, b) == 0`.
  ///
  /// ```
  /// final Comparator<MapEntry<int, int>> foo = (a, b) => a.key.compareTo(b.key);
  /// foo(MapEntry(1, 1), MapEntry(1, 2)); // 0
  ///
  /// final bar = foo.and((a, b) => a.value.compareTo(b.value));
  /// bar(MapEntry(1, 1), MapEntry(1, 2)); // -1
  /// ```
  @useResult Comparator<T> and(Comparator<T> tiebreaker) => (a, b) {
    final comparison = this(a, b);
    return comparison != 0 ? comparison : tiebreaker(a, b);
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
  @useResult bool operator > (T other) => timeZoneName == other.timeZoneName && isAfter(other);

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
  @useResult bool operator <= (T other) => timeZoneName == other.timeZoneName && (isBefore(other) || isAtSameMomentAs(other));

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
  @useResult bool operator >= (T other) => timeZoneName == other.timeZoneName && (isAfter(other) || isAtSameMomentAs(other));

}
