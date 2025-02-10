import 'package:meta/meta.dart';

import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/src/time/zone/timezone.dart';

/// A [Timezone] that uses the universal timezone database.
class EmbeddedTimezone extends Timezone {
  /// Create a new [EmbeddedTimezone] with the given values.
  const EmbeddedTimezone(super.name, this._spans, this._dstRules)
      : super.from();

  final List<TimezoneSpan> _spans;
  final DSTRules? _dstRules;

  @override
  EpochMicroseconds convert(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    final local = DateTime.utc(
            year, month, day, hour, minute, second, millisecond, microsecond)
        .microsecondsSinceEpoch;
    // Adapted from https://github.com/JodaOrg/joda-time/blob/main/src/main/java/org/joda/time/DateTimeZone.java#L951
    // Get the offset at local (first estimate).
    final localInstant = local;
    final localSpan = _getSpan(localInstant);
    final localOffset = localSpan.offset;

    // Adjust localInstant using the estimate and recalculate the offset.
    final adjustedInstant = localInstant - localOffset.inMicroseconds;
    final adjustedSpan = _getSpan(adjustedInstant);
    final adjustedOffset = adjustedSpan.offset;

    var microseconds = localInstant - adjustedOffset.inMicroseconds;

    // If the offsets differ, we must be near a DST boundary
    if (localOffset != adjustedOffset) {
      // We need to ensure that time is always after the DST gap
      // this happens naturally for positive offsets, but not for negative.
      // If we just use adjustedOffset then the time is pushed back before the
      // transition, whereas it should be on or after the transition
      if (localOffset.inMicroseconds - adjustedOffset.inMicroseconds < 0 &&
          adjustedOffset != _getSpan(microseconds).offset) {
        microseconds = adjustedInstant;
      }
    } else {
      final previousSpan = adjustedSpan.start == TimezoneSpan.minTime
          ? adjustedSpan
          : _getSpan(adjustedSpan.start - 1);
      if (previousSpan.start < adjustedInstant) {
        final previousOffset = previousSpan.offset;
        final difference =
            previousOffset.inMicroseconds - localOffset.inMicroseconds;
        if (adjustedInstant - adjustedSpan.start < difference) {
          microseconds = localInstant - previousOffset.inMicroseconds;
        }
      }
    }
    return microseconds;
  }

  @override
  Offset offset({required EpochMicroseconds at}) => _getSpan(at).offset;

  /// Get the span for the given time.
  TimezoneSpan _getSpan(int microsecondsSinceEpoch) {
    final span = _spans.firstWhere(
      (element) =>
          microsecondsSinceEpoch >= element.start &&
          microsecondsSinceEpoch < element.end,
    );
    // If the timezone is not at the end of our database,
    // or we don't have a DST rule, then we can return the span as is.
    if (_dstRules == null || !span.isLast) {
      return span;
    }

    final currentYear = DateTime.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpoch,
      isUtc: true,
    ).year;
    final (firstRule, secondRule) = _dstRules.spansForYear(currentYear);
    if (microsecondsSinceEpoch >= firstRule.start &&
        microsecondsSinceEpoch < secondRule.start) {
      return TimezoneSpan(
        offset: firstRule.offset,
        start: firstRule.start,
        end: secondRule.start,
      );
    } else {
      if (microsecondsSinceEpoch < firstRule.start) {
        final (_, lastYearSecondRule) = _dstRules.spansForYear(currentYear - 1);
        return TimezoneSpan(
          offset: lastYearSecondRule.offset,
          start: lastYearSecondRule.start,
          end: firstRule.start,
        );
      } else {
        final (nextYearFirstRule, _) = _dstRules.spansForYear(currentYear + 1);
        return TimezoneSpan(
          offset: secondRule.offset,
          start: secondRule.start,
          end: nextYearFirstRule.start,
        );
      }
    }
  }

  /// The 1st year that a transition occurs.
  /// If the timezone is fixed, this will be null.
  /// For instance, New York has a transition in 1883.
  ///
  /// This is exposed for testing purposes and should not be used
  @visibleForTesting
  int? get firstYear {
    if (_spans.first.isLast) {
      return null;
    }
    return DateTime.fromMicrosecondsSinceEpoch(_spans.first.end, isUtc: true)
        .year;
  }

  /// The last year that a transition occurs.
  /// If the timezone is fixed, this will be null.
  /// This would be the year 2100 for New York.
  ///
  /// This is exposed for testing purposes and should not be used
  @visibleForTesting
  int? get lastYear {
    if (_spans.last.isFirst) {
      return null;
    }
    return DateTime.fromMicrosecondsSinceEpoch(_spans.last.start, isUtc: true)
        .year;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is EmbeddedTimezone && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

/// There are many possible offsets for each timezone
/// depending on the time of year. This [TimezoneSpan] class
/// represents a span of time where a single offset is applied.
class TimezoneSpan {
  /// When this span starts.
  /// This is inclusive, so a time that is equal to [start]
  /// will be in this span.
  final EpochMicroseconds start;

  /// When this span ends.
  /// This is exclusive, so a time that is equal to [end]
  /// will not be in this span.
  final EpochMicroseconds end;

  /// The offset that should be applied during this span.
  final Offset offset;

  /// Create a new [TimezoneSpan] with the given values.
  TimezoneSpan({required this.start, required this.end, required this.offset});

  /// Check if this span is the last span in the timezone.
  bool get isLast => end == maxTime;

  /// Check if this span is the first span in the timezone.
  bool get isFirst => start == minTime;

  /// The maximum time that can be represented in microseconds since epoch.
  static const EpochMicroseconds maxTime = 8640000000000000000;

  /// The minimum time that can be represented in microseconds since epoch.
  static const EpochMicroseconds minTime = -maxTime;
}

/// The daylight/standard time rules for a timezone.
class DSTRules {
  /// The standard time rule.
  final DSTRule std;

  /// The daylight saving time rule.
  final DSTRule dst;
  DSTRules._({required this.std, required this.dst});

  /// Create a new DST rules from the
  /// rules as it appears in the TZDB
  factory DSTRules(
      {required Offset std, required Offset dstOffset, required String rules}) {
    final parts = rules.split(',');
    return DSTRules._(
      std: DSTRule(
        rule: parts[1],
        std: std,
        dstOffset: dstOffset,
        isDst: false,
      ),
      dst: DSTRule(
        rule: parts[0],
        std: std,
        dstOffset: dstOffset,
        isDst: true,
      ),
    );
  }

  /// Get the DST spans for a given year.
  ///
  /// The spans are returned in the order they occur.
  (DSTSpan, DSTSpan) spansForYear(int year) {
    final spanA = DSTSpan(
      start: std._transitionForYear(year),
      offset: std.save.add(std.std.toDuration()),
    );
    final spanB = DSTSpan(
      start: dst._transitionForYear(year),
      offset: dst.save.add(dst.std.toDuration()),
    );
    if (spanA.start < spanB.start) {
      return (spanA, spanB);
    } else {
      return (spanB, spanA);
    }
  }
}

/// A [DSTSpan] is similar to a [TimezoneSpan] however
/// it does not contain an end time.
///
/// The primary difference is that a [DSTSpan] generated
/// by using the rules in the TZDB. (e.g "last Sunday in March")
///
/// However, a [TimezoneSpan] is are created directly from the TZDB,
/// which contains the exact start and end times with the offsets.
class DSTSpan {
  /// The time that this span starts.
  final EpochMicroseconds start;

  /// The offset that should be applied during this span.
  final Offset offset;

  /// Create a new [DSTSpan] with the given values.
  DSTSpan({required this.start, required this.offset});
}

/// A single DST rule.
///
/// This is used to calculate the time when the DST rule is applied
/// for years outside the range of the timezone database.
class DSTRule {
  /// The offset from GTM during standard time.
  ///
  /// For example, New York is -5 hours from GTM.
  final Offset std;

  /// If this rule is for daylight saving time, this is the
  /// offset from standard time.
  /// Otherwise this will be 0.
  ///
  /// For instance, this will be 1 hour for Eastern Daylight Time.
  /// However, it will be 0 for Eastern Standard Time.
  final Offset dstOffset;

  /// The following fields have been reverse
  /// engineered from tubular_time project
  final int startyear;
  // ignore: public_member_api_docs
  final int month;
  // ignore: public_member_api_docs
  final int dayOfMonth;
  // ignore: public_member_api_docs
  final int dayOfWeek;
  // ignore: public_member_api_docs
  final int atHour;
  // ignore: public_member_api_docs
  final int atMinute;
  // ignore: public_member_api_docs
  final int atType;

  /// When this rule is applied, the standard time
  /// is offset by this amount.
  final Offset save;

  const DSTRule._(
      {required this.std,
      required this.dstOffset,
      required this.startyear,
      required this.month,
      required this.dayOfMonth,
      required this.dayOfWeek,
      required this.atHour,
      required this.atMinute,
      required this.atType,
      required this.save});

  /// Create a new DST rules from the
  /// rule as it appears in the TZDB
  factory DSTRule(
      {required Offset std,
      required Offset dstOffset,
      required String rule,
      required bool isDst}) {
    final parts = rule.split(RegExp('[ :]'));
    return DSTRule._(
      std: std,
      // dstOffset is set to 0 if this rule is for standard time.
      dstOffset: isDst ? dstOffset : Offset(),
      startyear: int.parse(parts[0]),
      month: int.parse(parts[1]),
      dayOfMonth: int.parse(parts[2]),
      dayOfWeek: int.parse(parts[3]),
      atHour: int.parse(parts[4]),
      atMinute: int.parse(parts[5]),
      atType: int.parse(parts[6]),
      save: Offset.fromMicroseconds(
        int.parse(parts[7]) * 60 * Duration.microsecondsPerSecond,
      ),
    );
  }

  /// Get the time this rule is applied to in microseconds since epoch
  /// for a given year.
  ///
  /// For instance, if this rule was for Eastern Daylight Time, then
  /// this would return March 8th for year 2025.
  ///
  /// The following code has been reverse engineered from tubular_time project
  EpochMicroseconds _transitionForYear(int year) {
    int micros;
    if (dayOfWeek >= 0 && dayOfMonth != 0) {
      // dayOfMonth refers to the earliest date that this transition can happen.
      // We then find the next dayOfWeek after that date.
      var tempDate = DateTime.utc(year, month, dayOfMonth.abs());
      // dayOfWeek is 0-indexed starting from Sunday.
      // However we need to convert it to 1-indexed starting from Monday.
      var effectiveDayOfWeek = dayOfWeek - 1;
      effectiveDayOfWeek = effectiveDayOfWeek == 0 ? 7 : effectiveDayOfWeek;

      // Find the next dayOfWeek after the dayOfMonth.
      while (tempDate.weekday != effectiveDayOfWeek) {
        if (dayOfMonth < 0) {
          tempDate = tempDate.subtract(const Duration(days: 1));
        } else {
          tempDate = tempDate.add(const Duration(days: 1));
        }
      }

      micros = DateTime.utc(year, month, tempDate.day, atHour, atMinute)
          .microsecondsSinceEpoch;
    } else if (dayOfWeek >= 0) {
      /// Find the last day of the month that is the dayOfWeek.
      var effectiveDayOfWeek = dayOfWeek - 1;
      effectiveDayOfWeek = effectiveDayOfWeek == 0 ? 7 : effectiveDayOfWeek;

      // Start from the last day of the month and go backwards until we find
      // the dayOfWeek.
      var tempDate =
          DateTime.utc(year, month + 1).subtract(const Duration(days: 1));
      while (tempDate.weekday != effectiveDayOfWeek) {
        tempDate = tempDate.subtract(const Duration(days: 1));
      }
      micros = DateTime.utc(year, month, tempDate.day, atHour, atMinute)
          .microsecondsSinceEpoch;
    } else {
      // If dayOfWeek is negative, then dayOfMonth
      // represents the actuall day of the month.
      micros = DateTime.utc(year, month, dayOfMonth, atHour, atMinute)
          .microsecondsSinceEpoch;
    }

    // There are 2 different types of atType.
    // CLOCK_TYPE_WALL (0) & CLOCK_TYPE_STD (1)
    if (atType == 0) {
      micros -= std.inMicroseconds + dstOffset.inMicroseconds;
    } else if (atType == 1) {
      micros -= std.inMicroseconds;
    }
    return micros;
  }
}
