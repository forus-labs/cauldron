import 'package:meta/meta.dart';

import 'package:sugar/core.dart';
import 'package:sugar/core.dart' as math show hash;
import 'package:sugar/time.dart';

/// Utilities for calculating the length of a period of [DateTime].
extension DateTimePeriod on Period<DateTime> {

  /// The length of this [Period].
  Duration get length => end.difference(start);

}

/// Utilities for calculating the length of a period of time.
extension TimePeriod on Period<Time> {

  /// The length of this [Period].
  Duration get length => end.difference(start);

}

/// Utilities for calculating the length of the period of numbers.
extension NumericalPeriod on Period<num> {

  /// The length of this [Period].
  num get length => end - start;

}

/// Represents a length of time between a start and end.
///
/// The precedence of a [Period] is determined by both its start and end. A [Period]
/// that starts first has higher precedence. If several [Period]s share the same start,
/// the [Period] that ends first has higher precedence.
///
/// In addition, a [Period] may optionally contain a [priority] to determine the precedence
/// of [Period]s that have the same start and end; higher priority indicates higher precedence.
class Period<T extends Comparable<T>> with Relatable<Period<T>> {

  /// The start of this [Period].
  final T start;
  /// The end of this [Period].
  final T end;
  /// The priority for this [Period] used to determine precedence when several [Period]s
  /// share the same start and end.
  final int priority;
  int _hash;

  /// Creates a [Period] with the given start and end time, and priority.
  Period(this.start, [T end, this.priority = 0]): end = end ?? start;

  @override
  int compareTo(Period<T> other) {
    if (identical(this, other)) {
      return 0;
    }

    var comparison = start.compareTo(other.start);
    if (comparison != 0) {
      return comparison;
    }

    comparison = end.compareTo(other.end);
    if (comparison != 0) {
      return comparison;
    }

    return other.priority.compareTo(priority);
  }

  @override
  @protected int get hash => _hash ??= math.hash([start, end, priority]);

  @override
  String toString() => 'Period{range: $start - $end, priority: $priority}';

}