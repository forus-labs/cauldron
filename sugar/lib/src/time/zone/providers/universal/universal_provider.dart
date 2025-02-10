// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:b/b.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/src/time/zone/timezone.dart';

part 'universal_provider.g.dart';

/// A [Timezone] provider for the universal timezone database.
///
/// This provider uses a bundled timezone database to provide timezone
/// information for all known timezones.
class UniversalTimezoneProvider extends UnmodifiableMapBase<String, Timezone> {
  @override
  Timezone? operator [](Object? key) {
    if (key is String && _tzdb.containsKey(key)) {
      var timezoneData = _tzdb[key]!;

      /// Many timezone are just aliases to other timezones.
      /// For example "Africa/Porto-Novo" is an alias to "Africa/Lagos".
      /// These aliases do not start with a "+" or a "-".
      /// E.G "Africa/Porto-Novo":"Africa/Lagos"
      ///
      /// In addition, some of these aliases are pseudo-aliases
      /// which also contain a leading "!".
      /// E.G "America/Dominica" : "!43e3,AGAIBLDMGDGPKNLCMFMSTTVCVGVI,America/Puerto_Rico"
      /// The pseudo-aliases have additional information that needs to be stripped.
      if (!RegExp('^[+-]').hasMatch(timezoneData)) {
        final aliasName =
            timezoneData.replaceAll(RegExp('^!'), '').split(',').last;
        timezoneData = _tzdb[aliasName]!;
      }
      return UniversalTimezone._fromData(name: key, data: timezoneData);
    }

    return null;
  }

  @override
  Iterable<String> get keys => _tzdb.keys.where(_isTimezoneId);
}

/// Check if a key in the timezone database is an
/// actual timezone or just metadata.
bool _isTimezoneId(String key) => [
      RegExp('^years'),
      RegExp('^version'),
      RegExp('^leapSeconds'),
      RegExp('^deltaTs'),
      RegExp('^_'),
      RegExp('^SystemV/'),
    ].every((k) => !k.hasMatch(key));

/// A [Timezone] that uses the universal timezone database.
class UniversalTimezone extends Timezone {
  /// Create a new [UniversalTimezone] from the provided data.
  ///
  /// The logic for parsing this data is sourced from
  /// the https://github.com/kshetline/tubular_time_tzdb package
  factory UniversalTimezone._fromData({
    required String name,
    required String data,
  }) {
    final parts = data.split(';');
    final basic = _Basic(parts[0]);
    final localTimeTypes = _LocalTimeType.parseList(parts[1]);
    final lttIndex60 = parts
        .elementAtOrNull(2)
        ?.split('')
        .map(_base60Encoder.parseint)
        .toList();
    final transitionDeltas = parts
        .elementAtOrNull(3)
        ?.split(' ')
        .map((e) {
          if (e.isEmpty) {
            return null;
          }
          return _base60Encoder.parseDuration(e);
        })
        .nonNulls
        .toList();
    final dstRule = parts.elementAtOrNull(4);
    return UniversalTimezone._(
      name,
      basic,
      localTimeTypes,
      lttIndex60.nullIfEmpty,
      transitionDeltas.nullIfEmpty,
      dstRule.nullIfBlank,
    );
  }

  UniversalTimezone._(
    super.name,
    this._basic,
    this._localTimeTypes,
    this._lttIndex60,
    this._transitionDeltas,
    this._dstRule,
  ) : super.from();

  /// Some basic information about the timezone.
  final _Basic _basic;

  /// This list contains all the know offsets for the timezone.
  /// The first offset is the initial offset that is found
  /// in the [_basic] class.
  final List<_LocalTimeType> _localTimeTypes;

  /// [_lttIndex60] and [_transitionDeltas] are used together
  /// to find the proper [_localTimeTypes] to use for a given time.
  ///
  /// What is complex is that this is an index of an index.
  /// We use the [_transitionDeltas] list to find the index of the
  /// [_lttIndex60] list. We then use that index in the
  /// [_localTimeTypes] list.
  ///
  /// If this is null, we will use the initial offset.
  ///
  /// Otherwise this list looks something like:
  /// [1,2,1,2]
  ///
  /// Each number in the list is an index of the [_localTimeTypes] list.
  final List<int>? _lttIndex60;

  /// This list contains all the info we need to find what index of
  /// the [_lttIndex60] to use for a given time.
  ///
  /// The first element is the time of the first transition in milliseconds
  /// since epoch. Every subsequent element is the delta in milliseconds
  /// between the previous transition and the current transition.
  ///
  /// If this is null, we will use the initial offset.
  ///
  /// Otherwise the list looks something like:
  /// [-18000000000000, 798795645, 78978948654]
  ///
  /// We start with the 1st number and add the delta until
  /// the provided time is greater than the sum. We'll then
  /// use the index of that delta in the [_lttIndex60] list.
  /// That index is then used to find the proper [_localTimeTypes]
  final List<int>? _transitionDeltas;

  /// The IANA database contains the transition times for a long time, but
  /// not forever (That would be impossible). The IANA database contains
  /// a general rule obout DST to apply for times that we don't have
  /// transition times for.
  ///
  /// Some locations have predictable DST rules, like "DST starts on the 2nd Sunday of March".
  /// However some places have rules that are not predictable,
  /// like only having DST during Ramadan. Those rules are not included in the IANA database.
  final String? _dstRule;

  /// This value is only used for testing purposes and should not be used.
  ///
  /// We would like to test that DST rules are applied correctly
  /// when we transition from using transition deltas to using the DST rules.
  ///
  /// This will expose what year to test for.
  @visibleForTesting
  int? get lastYear {
    if (_transitionDeltas == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(
      _transitionDeltas.fold<int>(
        0,
        (previousValue, element) => previousValue + element,
      ),
      isUtc: true,
    ).year;
  }

  /// This value is only used for testing purposes and should not be used.
  ///
  /// We would like to test that DST rules are applied correctly
  /// when we transition from using transition deltas to using the DST rules.
  ///
  /// This will expose what year to test for.
  @visibleForTesting
  int? get firstYear {
    if (_transitionDeltas == null) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(
      _transitionDeltas.first,
      isUtc: true,
    ).year;
  }

  /// List of all the spans for the timezone.
  ///
  /// Keep in mind that after the final span, more adjustments may be made
  /// by applying the DST rule.
  late final _spans = () sync* {
    /// Some timezones don't have any history and are always the same.
    /// For instance, the timezone "Etc/UTC" is always the same.
    if (_lttIndex60 == null) {
      yield _Span(offset: _localTimeTypes.first.utcOffset60);
    } else {
      // The 1st _transitionDeltas is actually when the first transition happens.
      // we will yield the initial offset which precedes the first transition.
      yield _Span(
        offset: _basic.initialUtcOffset,
        endTime: _transitionDeltas!.first,
      );

      /// We will yield the offsets for each transition.
      var transition = _transitionDeltas.first;
      for (final (index, delta) in _transitionDeltas.indexed.skip(1)) {
        final nextTransition = transition + delta;
        yield _Span(
          startTime: transition,
          endTime: nextTransition,
          offset: _localTimeTypes[_lttIndex60[index - 1]].utcOffset60,
        );
        transition = nextTransition;
      }

      /// We will yield the last offset which is after the last transition.
      yield _Span(
        startTime: transition,
        offset: _localTimeTypes[_lttIndex60.last].utcOffset60,
      );
    }
  }()
      .toList();

  /// Get the span for the given time.
  _Span _getSpan(int microsecondsSinceEpoch) {
    final span = _spans.firstWhere(
      (element) =>
          microsecondsSinceEpoch >= element.startTime &&
          microsecondsSinceEpoch < element.endTime,
    );
    if (_dstRule == null) {
      return span;
    }
    if (!span.isLast) {
      return span;
    }
    final currentYear = DateTime.fromMicrosecondsSinceEpoch(
      microsecondsSinceEpoch,
      isUtc: true,
    ).year;
    final (firstRule, secondRule) = _transitionsFor(currentYear);
    if (microsecondsSinceEpoch >= firstRule.transition &&
        microsecondsSinceEpoch < secondRule.transition) {
      return _Span(
        offset: _basic.currentStdUtcOffset + firstRule.save,
        startTime: firstRule.transition,
        endTime: secondRule.transition,
      );
    } else {
      if (microsecondsSinceEpoch < firstRule.transition) {
        final (_, lastYearSecondRule) = _transitionsFor(currentYear - 1);
        return _Span(
          offset: _basic.currentStdUtcOffset + lastYearSecondRule.save,
          startTime: lastYearSecondRule.transition,
          endTime: firstRule.transition,
        );
      } else {
        final (nextYearFirstRule, _) = _transitionsFor(currentYear + 1);
        return _Span(
          offset: _basic.currentStdUtcOffset + secondRule.save,
          startTime: secondRule.transition,
          endTime: nextYearFirstRule.transition,
        );
      }
    }
  }

  @override
  Offset offset({required EpochMicroseconds at}) =>
      Offset.fromMicroseconds(_getSpan(at).offset);
  @override
  EpochMicroseconds convert({required int local}) {
    // Adapted from https://github.com/JodaOrg/joda-time/blob/main/src/main/java/org/joda/time/DateTimeZone.java#L951

    // Get the offset at local (first estimate).
    final localInstant = local;
    final localSpan = _getSpan(localInstant);
    final localOffset = localSpan.offset;

    // Adjust localInstant using the estimate and recalculate the offset.
    final adjustedInstant = localInstant - localOffset;
    final adjustedSpan = _getSpan(adjustedInstant);
    final adjustedOffset = adjustedSpan.offset;

    var microseconds = localInstant - adjustedOffset;

    // If the offsets differ, we must be near a DST boundary
    if (localOffset != adjustedOffset) {
      // We need to ensure that time is always after the DST gap
      // this happens naturally for positive offsets, but not for negative.
      // If we just use adjustedOffset then the time is pushed back before the
      // transition, whereas it should be on or after the transition
      if (localOffset - adjustedOffset < 0 &&
          adjustedOffset != _getSpan(microseconds).offset) {
        microseconds = adjustedInstant;
      }
    } else {
      final previousSpan = adjustedSpan.startTime == _Span.minTime
          ? adjustedSpan
          : _getSpan(adjustedSpan.startTime - 1);
      if (previousSpan.startTime < adjustedInstant) {
        final previousOffset = previousSpan.offset;
        final difference = previousOffset - localOffset;
        if (adjustedInstant - adjustedSpan.startTime < difference) {
          microseconds = localInstant - previousOffset;
        }
      }
    }
    return microseconds;
  }

  /// Get the DST rules for the given year.
  ///
  /// This function returns a tuple of two DST rules in order
  /// of when they start.
  (_DstRule, _DstRule) _transitionsFor(int year) {
    /// The `_dstRule` contains two parts, the standard time rule and the
    /// daylight saving time rule. The two rules are separated by a comma.
    final parts = _dstRule!.split(',');

    final ruleA = _DstRule(
      currentYear: year,
      rawRule: parts[0],
      stdOffset: _basic.currentStdUtcOffset,
      dstOffset: _basic.currentDstOffset,
    );
    final ruleB = _DstRule(
      currentYear: year,
      rawRule: parts[1],
      stdOffset: _basic.currentStdUtcOffset,
      dstOffset: 0,
    );
    final firstRule = (ruleA.transition < ruleB.transition ? ruleA : ruleB);
    final secondRule = (ruleA.transition > ruleB.transition ? ruleA : ruleB);
    return (firstRule, secondRule);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UniversalTimezone && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

/// A temporary class to hold a span of timezone data.
/// For instance, from March 8th 2020 to November 1st 2020,
/// the timezone is in Eastern Daylight Time.
class _Span {
  _Span({
    required this.offset,
    this.startTime = minTime,
    this.endTime = maxTime,
  });
  static const int maxTime = 8640000000000000000;
  static const int minTime = -maxTime;

  /// The start time of the span in microseconds since epoch.
  final int startTime;

  /// The end time of the span in microseconds since epoch.
  final int endTime;

  /// The offset for the span in microseconds.
  final int offset;

  /// Check if this span is the last span in the timezone.
  bool get isLast => endTime == maxTime;

  /// Check if this span is the first span in the timezone.
  bool get isFirst => startTime == minTime;

  @override
  String toString() => 'Span($startTime, $endTime, $offset)';
}

/// Temporary class to hold a DST rule.
/// Note that the property names don't always reflect reality.
/// (e.g. dayOfWeek could mean something else)
/// This class contains code which  has been reverse engineered
/// from the original javascript code at
/// https://github.com/kshetline/tubular_time/blob/109395d0b2ad17a7b4c6f1b957efd404d7b70644/src/timezone.ts#L90
class _DstRule {
  factory _DstRule({
    required String rawRule,
    required int currentYear,
    required int stdOffset,
    required int dstOffset,
  }) {
    final parts = rawRule.split(RegExp('[ :]'));

    return _DstRule._(
      currentYear: currentYear,
      stdOffset: stdOffset,
      dstOffset: dstOffset,
      startyear: int.parse(parts[0]),
      month: int.parse(parts[1]),
      dayOfMonth: int.parse(parts[2]),
      dayOfWeek: int.parse(parts[3]),
      atHour: int.parse(parts[4]),
      atMinute: int.parse(parts[5]),
      atType: int.parse(parts[6]),
      save: int.parse(parts[7]) * 60 * Duration.microsecondsPerSecond,
    );
  }

  _DstRule._({
    required this.startyear,
    required int month,
    required int dayOfMonth,
    required int dayOfWeek,
    required int atHour,
    required int atMinute,
    required int atType,
    required this.save,
    required int currentYear,
    required int stdOffset,
    required int dstOffset,
  })  : _dstOffset = dstOffset,
        _stdOffset = stdOffset,
        _currentYear = currentYear,
        _atType = atType,
        _atMinute = atMinute,
        _atHour = atHour,
        _dayOfWeek = dayOfWeek,
        _dayOfMonth = dayOfMonth,
        _month = month;
  final int startyear;
  final int _month;
  final int _dayOfMonth;
  final int _dayOfWeek;
  final int _atHour;
  final int _atMinute;
  final int _atType;
  final int save;
  final int _currentYear;
  final int _stdOffset;
  final int _dstOffset;
  late final transition =
      transitionForYear(_currentYear, _stdOffset, _dstOffset);

  /// Get the time this rule is applied to in microseconds since epoch
  /// for a given year. (For example, we can infer from the rule
  /// when we should start Eastern Daylight Time by finding the
  /// second Sunday in March in a given year.)
  int transitionForYear(int year, int stdOffset, int dstOffset) {
    int micros;
    if (_dayOfWeek >= 0 && _dayOfMonth != 0) {
      // dayOfMonth is the earliest date that this transition can happen.
      // We then find the next dayOfWeek after that date.
      var tempDate = DateTime.utc(year, _month, _dayOfMonth.abs());
      // dayOfWeek is 0-indexed starting from Sunday.
      // However we need to convert it to 1-indexed starting from Monday.
      var effectiveDayOfWeek = _dayOfWeek - 1;
      effectiveDayOfWeek = effectiveDayOfWeek == 0 ? 7 : effectiveDayOfWeek;

      // Find the next dayOfWeek after the dayOfMonth.
      while (tempDate.weekday != effectiveDayOfWeek) {
        if (_dayOfMonth < 0) {
          tempDate = tempDate.subtract(const Duration(days: 1));
        } else {
          tempDate = tempDate.add(const Duration(days: 1));
        }
      }

      micros = DateTime.utc(year, _month, tempDate.day, _atHour, _atMinute)
          .microsecondsSinceEpoch;
    } else if (_dayOfWeek >= 0) {
      /// if dayOfMonth is 0, then we find the last day of the month
      /// that is the dayOfWeek.
      var effectiveDayOfWeek = _dayOfWeek - 1;
      effectiveDayOfWeek = effectiveDayOfWeek == 0 ? 7 : effectiveDayOfWeek;

      // Start from the last day of the month and go backwards until we find
      // the dayOfWeek.
      var tempDate =
          DateTime.utc(year, _month + 1).subtract(const Duration(days: 1));
      while (tempDate.weekday != effectiveDayOfWeek) {
        tempDate = tempDate.subtract(const Duration(days: 1));
      }
      micros = DateTime.utc(year, _month, tempDate.day, _atHour, _atMinute)
          .microsecondsSinceEpoch;
    } else {
      // If dayOfWeek is negative, then dayOfMonth actually
      // represents the day of the month.
      micros = DateTime.utc(year, _month, _dayOfMonth, _atHour, _atMinute)
          .microsecondsSinceEpoch;
    }

    // There are 2 different types of atType.
    // CLOCK_TYPE_WALL (0) & CLOCK_TYPE_STD (1)
    // I wish I knew what they meant, but this is how the original
    // code was written.
    if (_atType == 0) {
      micros -= stdOffset + dstOffset;
    } else if (_atType == 1) {
      micros -= stdOffset;
    }
    return micros;
  }
}

/// Basic information about the timezone.
class _Basic {
  factory _Basic(String text) {
    final parts = text.split(' ');
    return _Basic._(
      initialUtcOffset: _parseHHMMorHHMMSS(parts[0]),
      currentStdUtcOffset: _parseHHMMorHHMMSS(parts[1]),
      currentDstOffset: Duration(minutes: int.parse(parts[2])).inMicroseconds,
    );
  }
  _Basic._({
    required this.initialUtcOffset,
    required this.currentStdUtcOffset,
    required this.currentDstOffset,
  });

  /// This contains the 1st known offset of the timezone.
  ///
  /// For instance, in the year 500, timezones were not standardized
  /// and we use LMT (Local Mean Time) as the initial offset.
  ///
  /// This is the offset that will be used if we are before the
  /// first transition.
  ///
  /// This value is in microseconds from the epoch.
  final int initialUtcOffset;

  /// This is what the iana regards as standard time.
  /// Note that there is a big disagreement between the timezone
  /// people what makes a time "daylight" or "standard".
  ///
  /// For instance Africa/Casablanca has permanent DST
  /// of (+1:00), but the iana regards that as standard time.
  ///
  /// This value is in microseconds from UTC.
  final int currentStdUtcOffset;

  /// When the timezone is in DST, this is the offset
  /// which is added to the standard offset.
  ///
  /// For instance, in the timezone America/New_York,
  /// this would be 1 hour.
  ///
  /// This value is in microseconds.
  final int currentDstOffset;
}

/// A timezone can have a bunch of offsets depending on the time of the year.
/// This class represents one of those offsets.
/// See https://github.com/kshetline/tubular_time_tzdb#timezone-descriptions for more information.
class _LocalTimeType {
  factory _LocalTimeType(String text) {
    final parts = text.split('/');
    return _LocalTimeType._(
      utcOffset60: _base60Encoder.parseDuration(parts[0]),
      dstOffset60: _base60Encoder.parseDuration(parts[1]),
      abbreviation: parts.length > 2 ? parts[2] : null,
    );
  }

  _LocalTimeType._({
    required this.utcOffset60,
    required this.dstOffset60,
    required this.abbreviation,
  });

  /// When this class is the current offset, this is the offset from UTC
  /// which is added to the current time to get the local time.
  ///
  /// This value is in microseconds.
  ///
  /// E.G. In the timezone America/New_York, the current offset is -5:00
  final int utcOffset60;

  /// If the timezone is in DST, this is the offset that is added to the
  /// current offset.
  ///
  /// This value is in microseconds.
  ///
  ///  E.G. In the timezone America/New_York, the DST offset is 1:00
  final int dstOffset60;

  /// The abbreviation for the timezone.
  ///
  /// E.G. In the timezone America/New_York, the abbreviation is "EDT"
  /// during "Eastern Daylight Time".
  final String? abbreviation;
  static List<_LocalTimeType> parseList(String text) =>
      text.split(' ').map(_LocalTimeType.new).toList();
}

/// Parse a string in the format -|+HHMM or -|+HHMMSS
///
/// Return the results as microseconds.
/// See https://github.com/kshetline/tubular_time_tzdb#timezone-descriptions for more information.
int _parseHHMMorHHMMSS(String rawInput) {
  var input = rawInput;
  final isNegative = input.startsWith('-');
  if (isNegative) {
    input = input.substring(1);
  }
  if (input.startsWith('+')) {
    input = input.substring(1);
  }
  final Duration result;
  if (input.length == 4) {
    result = Duration(
      hours: int.parse(input.substring(0, 2)),
      minutes: int.parse(input.substring(2)),
    );
  } else if (input.length == 6) {
    result = Duration(
      hours: int.parse(input.substring(0, 2)),
      minutes: int.parse(input.substring(2, 4)),
      seconds: int.parse(input.substring(4)),
    );
  } else {
    throw ArgumentError('Invalid input, $input');
  }
  return (isNegative ? -result : result).inMicroseconds;
}

/// The timezone databases stores integers and durations in base60
/// to save space. This class is used to convert those base60
/// strings to integers.
class _Base60Encoder {
  _Base60Encoder();

  final _base60converter = BaseConversion(
    from: '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWX',
    to: '0123456789',
  );

  /// Parse a base60 (0-9a-zA-X) string to an integer.
  int parseint(String input) => int.parse(_base60converter(input));

  /// Durations are encoded in base60 with a special format.
  /// See https://github.com/kshetline/tubular_time_tzdb for more information.
  ///
  /// The result is in microseconds.
  int parseDuration(String rawInput) {
    var input = rawInput;
    final isNegative = input.startsWith('-');
    if (isNegative) {
      input = input.substring(1);
    }
    if (input.startsWith('+')) {
      input = input.substring(1);
    }
    final int minutes;
    final int seconds;
    if (input.contains('.')) {
      final parts = input.split('.');
      minutes = parseint(parts[0]);
      seconds = parseint(parts[1]);
    } else {
      minutes = parseint(input);
      seconds = 0;
    }
    final result = Duration(minutes: minutes, seconds: seconds);
    return (isNegative ? -result : result).inMicroseconds;
  }
}

final _base60Encoder = _Base60Encoder();

/// Handy extension to convert empty lists to null.
extension _NullIfEmpty<T> on List<T>? {
  List<T>? get nullIfEmpty {
    if (this == null) {
      return null;
    }
    if (this!.isEmpty) {
      return null;
    }
    return this;
  }
}

/// Handy extension to convert empty strings to null.
extension _NullIfBlank on String? {
  String? get nullIfBlank {
    if (this == null) {
      return null;
    }
    if (this!.isEmpty) {
      return null;
    }
    return this;
  }
}
