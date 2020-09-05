import 'package:meta/meta.dart';

import 'package:sugar/core.dart';
import 'package:sugar/core.dart' as math show hash;
import 'package:sugar/time.dart';

extension DateTimePeriod on Period<DateTime> {

  Duration get length => end.difference(start);

}

extension TimePeriod on Period<Time> {

  Duration get length => end.difference(start);

}

extension NumericalPeriod on Period<num> {

  num get length => end - start;

}

class Period<T extends Comparable<T>> with Relatable<Period<T>> {

  final T start;
  final T end;
  final int priority;
  int _hash;

  Period(this.start, [this.end, this.priority = 0]);

  @override
  int compareTo(Period<T> other) {
    if (this == other) {
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

}