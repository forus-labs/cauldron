import 'package:meta/meta.dart';
import 'package:sugar/src/time/zone/providers/embedded/embedded_timezone.dart';
import 'package:b/b.dart';
import 'package:sugar/src/time/zone/providers/embedded/embedded_timezone_span.dart';
import 'package:sugar/sugar.dart';

part 'tzdb.g.dart';

/// Parse the raw timezone data from the TZDB.
/// If the timezone is not found, null is returned.
///
/// The following has been reverse engineered from tubular_time project
@internal
EmbeddedTimezone? parseTimezone({required String name}) {
  var data = _tzdb[name];
  if (data == null) {
    return null;
  }

  /// If the data is an alias, we will replace it with the actual data.
  if (!RegExp('^[+-]').hasMatch(data)) {
    data = _tzdb[data]!;
  }

  /// The timezone data is separated into
  /// sections by a semicolon.
  final parts = data.split(';');

  /// The 1st part contains the standard and daylight
  /// savings time offsets.
  final basicParts = parts[0].split(' ');

  /// The offset that should be applied during standard time.
  /// For instance, New York is -5 hours from GTM.
  final std = Offset.fromMicroseconds(_parseHHMMorHHMMSS(basicParts[1]));

  /// The offset that is applied on top of std during daylight saving time.
  /// For instance, Eastern Daylight Time is 1 hour ahead of Eastern Standard Time.
  final dstOffset = Offset.fromSeconds(int.parse(basicParts[2]) * 60);

  /// The next 3 parts of the data contains the information we need to
  /// create the [_Span]s for the timezone.
  ///
  /// The 1st part contains the offset data for the timezone.
  /// This list has 3 pieces of information for each offset.
  /// 1. The offset (e.g -5 hours)
  /// 2. The offset which is applied during daylight saving time. (e.g 1 hour)
  /// 3. The abbreviation for the offset (e.g EST)
  ///
  /// For instance America/New_York only has five possible offsets that can be applied.
  /// 0. −04:56 (LMT, Before 1883)
  /// 1. -5 hours (Eastern Standard Time)
  /// 2. -4 hours (Eastern Daylight Time)
  /// 3. −4 hours (EWT, Eastern War Time)
  /// 4. −4 hours (EPT, Eastern Peace Time)
  ///
  /// When the abbreviation is "%z", the abbreviation is the offset itself.
  /// See https://en.wikipedia.org/wiki/ISO_8601#Time_offsets_from_UTC for more information.
  final offsetsData =
      parts[1].split(' ').map((offsetString) {
        final parts = offsetString.split('/');
        final utcOffset = Offset.fromMicroseconds(_base60Encoder.parseDuration(parts[0]));
        final dstOffset = _base60Encoder.parseDuration(parts[1]);
        final isDst = dstOffset != 0;
        String? abbr = parts.length > 2 ? parts[2] : null;
        if (abbr == '%z') {
          abbr = utcOffset.toTimezoneAbbreviation();
        }

        return (utcOffset: utcOffset, isDst: isDst, abbr: abbr);
      }).toList();

  /// The 2nd part acts like a bridge between the offsets and the deltas
  /// that are applied to the offsets.
  ///
  /// For instance, in new york there are 5 offsets that can be applied.
  /// This looks like this:
  /// [1,2,1,2,1,2,1,2,1,2,1...]
  ///
  /// Each number represents the index of the offset that should be applied
  /// for that corresponding delta.
  var deltaOffsets = parts.elementAtOrNull(2)?.split('').map(_base60Encoder.parseint).toList();
  if (deltaOffsets?.isEmpty ?? false) {
    deltaOffsets = null;
  }

  final spans = <EmbeddedTimezoneSpan>[];
  if (deltaOffsets == null) {
    /// If there is no deltaOffsets, then the timezone is fixed
    /// and only has one offset.
    spans.add(
      EmbeddedTimezoneSpan(
        start: TimezoneSpan.range.min.value,
        end: TimezoneSpan.range.max.value,
        offset: offsetsData.first.utcOffset,
        dst: offsetsData.first.isDst,
        abbreviation: offsetsData.first.abbr,
      ),
    );
  } else {
    /// The 3rd part contains the actual deltas that are applied to the offsets.
    /// The 1st item in the list is the start time of the first span as
    /// microseconds since epoch.
    ///
    /// The rest of the items are the deltas that are applied to that original time.
    /// For instance, in New York [1883 (in milliseconds), ~35 years, ~7 months, ~5 months, ~7 months ... ]
    final transitionDeltas =
        parts[3]
            .split(' ')
            .map((e) {
              if (e.isEmpty) {
                return null;
              }
              return _base60Encoder.parseDuration(e);
            })
            .nonNulls
            .toList();

    /// Before the 1st transition, the offset is the 1st offset
    /// in the list. (For instance, LMT is used from the beginning of time
    /// until 1883 in New York)
    spans.add(
      EmbeddedTimezoneSpan(
        start: TimezoneSpan.range.min.value,
        end: transitionDeltas[0],
        offset: offsetsData.first.utcOffset,
        dst: offsetsData.first.isDst,
        abbreviation: offsetsData.first.abbr,
      ),
    );

    /// We will yield the offsets for each transition.
    var transition = transitionDeltas.first;
    for (final (index, delta) in transitionDeltas.indexed.skip(1)) {
      final nextTransition = transition + delta;
      // Use the offset that is at the index of the delta.
      final offset = offsetsData[deltaOffsets[index - 1]];
      spans.add(
        EmbeddedTimezoneSpan(
          start: transition,
          end: nextTransition,
          offset: offset.utcOffset,
          dst: offset.isDst,
          abbreviation: offset.abbr,
        ),
      );
      transition = nextTransition;
    }

    /// After the last transition, the offset is the last offset
    /// in the list until the end of time.
    final offset = offsetsData[deltaOffsets.last];
    spans.add(
      EmbeddedTimezoneSpan(
        start: transition,
        end: TimezoneSpan.range.max.value,
        offset: offset.utcOffset,
        dst: offset.isDst,
        abbreviation: offset.abbr,
      ),
    );
  }

  final dstRules = switch (parts.elementAtOrNull(4)) {
    final String rules when rules.isNotEmpty => DstRules(rules: rules, dstOffset: dstOffset, std: std),
    _ => null,
  };
  return EmbeddedTimezone(name, spans, dstRules);
}

/// The known timezones in the timezone database.
@internal
final knownTimezones = _tzdb.keys.toSet();

/// The timezone database stores durations in the format (-|+)HHMM or (-|+)HHMMSS
/// where HH is hours, MM is minutes, and SS is seconds.
///
/// This function parses the duration and returns it in microseconds.
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
    result = Duration(hours: int.parse(input.substring(0, 2)), minutes: int.parse(input.substring(2)));
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
