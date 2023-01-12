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

/// Provides functions for working with [Comparable]s.
extension Comparables on Never {

  /// Returns the greater of [a] and [b] as defined by [Comparable.compareTo]. Either may be returned if [a] is ordered the same as [b].
  ///
  /// Either may be returned if [a] is ordered the same as [b].
  ///
  /// This is an alternative to [math.min] that works on all [Comparable]s.
  ///
  /// ### Note:
  /// The result of [min] and [math.min] differs when comparing numbers and either argument is [double.nan].
  /// [min] will always return the other numeric argument while [math.min] will always return [double.nan].
  ///
  /// ```dart
  /// Compare.min(1.0, double.nan); // 1.0
  ///
  /// min(1.0, double.nan); // double.nan
  /// ```
  @useResult static T min<T extends Comparable<Object>>(T a, T b) => a.compareTo(b) < 0 ? a : b;

  /// Returns the greater of [a] and [b] as defined by [Comparable.compareTo]. Either may be returned if [a] is ordered the same as [b].
  ///
  /// This is an alternative to [math.max] that works on all [Comparable]s.
  ///
  /// ```dart
  /// Compare.min(10, 20); // 10
  /// ```
  @useResult static T max<T extends Comparable<Object>>(T a, T b) => a.compareTo(b) > 0 ? a : b;

}

/// Provides functions for working with [Comparator]s.
extension Compare<T> on Never {

  /// Returns a [Comparator] that compares two [T]s using the values produced by [function].
  ///
  /// ```dart
  /// class Box {
  ///   final int value;
  ///
  ///   Box( this.value);
  /// }
  ///
  /// final compare = Compare.by<Box>((b) => b.value);
  /// compare(Box(1), Box(2)); // -1
  /// ```
  @useResult static Comparator<T> by<T extends Object>(Selector<T, Comparable<Object>> function) => (a, b) => function(a).compareTo(function(b));


  @useResult static Comparator<T> reverse<T extends Object>(Comparator<T> comparator) => (a, b) => comparator(a, b) * -1;

  @useResult static Comparator<T> combine(Comparator<T> first, Comparator<T> second) => (a, b) {
    final comparison = first(a, b);
    return comparison != 0 ? comparison : second(a, b);
  };


  @useResult static T min<T>(T a, T b, {required Selector<T, Comparable<Object>> by}) => by(a).compareTo(by(b)) < 0 ? a : b;

  @useResult static T max<T>(T a, T b, {required Selector<T, Comparable<Object>> by}) => by(a).compareTo(by(b)) < 0 ? b : a;

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
