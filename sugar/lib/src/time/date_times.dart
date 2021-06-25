import 'package:meta/meta.dart';
import 'package:sugar/time.dart';

/// An immutable temporal.
mixin Temporal<T extends Temporal<T>> implements DateTime {

  T? _tomorrow;
  T? _yesterday;


  /// Returns a [DateTime] that represents this [DateTime] with the given duration added.
  T operator + (Duration duration);

  /// Returns a [DateTime] that represents this [DateTime] with the given duration subtracted.
  T operator - (Duration duration) => this + -duration;

  /// Returns a [DateTime] that represents the day after this [DateTime].
  T get tomorrow => _tomorrow ??= this + const Duration(days: 1);

  /// Returns a [DateTime] that represents the day before this [DateTime].
  T get yesterday => _yesterday ??= this - const Duration(days: 1);

}

/// The default implementation for [Temporal].
extension DefaultTemporal on DateTime {

  /// Returns a [DateTime] that represents this [DateTime] with the given duration added.
  DateTime operator + (Duration duration) => DateTime.fromMicrosecondsSinceEpoch(microsecondsSinceEpoch + duration.inMicroseconds, isUtc: isUtc);

  /// Returns a [DateTime] that represents this [DateTime] with the given duration subtracted.
  DateTime operator - (Duration duration) => this + -duration;

  /// Returns a [DateTime] that represents the day after this [DateTime].
  DateTime get tomorrow => this + const Duration(days: 1);

  /// Returns a [DateTime] that represents the day before this [DateTime].
  DateTime get yesterday => this - const Duration(days: 1);

}

/// Provides operations to allow [DateTime]s to be chronologically compared using
/// the comparison operators.
extension Chronological on DateTime {

  /// Determines if this [DateTime] is after the current date-time.
  bool get isFuture => DateTime.now() < this;

  /// Determines if this [DateTime] is before the current date-time.
  bool get isPast => DateTime.now() > this;

  /// Determines if this [DateTime] is before [other].
  bool operator < (DateTime other) => compareTo(other) < 0;

  /// Determines if this [DateTime] is after [other].
  bool operator > (DateTime other) => other < this;

  /// Determines if this [DateTime] is before or the same moment as [other].
  bool operator <= (DateTime other) => !(this > other);

  /// Determines if this [DateTime] is after or the same moment as [other].
  bool operator >= (DateTime other) => !(this < other);

}

/// Represents a [DateTime] which date and time can be individually extracted.
mixin MultiPart implements DateTime {

  /// The date part of this [DateTime].
  @protected Date? datePart;
  /// The time part of this [DateTime].
  @protected Time? timePart;

  /// The date of this [DateTime].
  Date get date => datePart ??= Date(year, month, day);

  /// The time of this [DateTime].
  Time get time => timePart ??= Time(hour, minute, second, millisecond, microsecond);

}

