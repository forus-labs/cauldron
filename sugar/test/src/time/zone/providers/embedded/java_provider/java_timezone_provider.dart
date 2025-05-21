import 'dart:collection';

import 'package:jni/jni.dart';
import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/time_zone.dart';

import 'bindings.dart';

class JavaTimezoneProvider extends UnmodifiableMapBase<String, Timezone> {
  final _cache = <String, Timezone>{};
  @override
  Timezone? operator [](Object? key) {
    if (key is String && keys.contains(key)) {
      if (_cache.containsKey(key)) {
        return _cache[key];
      }
      final timezone = JavaTimezone(key);
      _cache[key] = timezone;
      return timezone;
    }
    return null;
  }

  @override
  late final keys = ZoneId.getAvailableZoneIds()!.use(
    (ids) => ids.map((element) => element?.toDartString(releaseOriginal: true)).nonNulls.toSet(),
  );
}

/// A timezone that uses the Java timezone database.
class JavaTimezone extends Timezone {
  /// Creates a new Java timezone with the given [name].
  JavaTimezone(super.name) : super.from();

  @override
  TimezoneSpan span({required EpochMicroseconds at}) {
    final instant = Instant.ofEpochMilli(at ~/ 1000);
    final (offset, isDst, abbr) = ZonedDateTime.ofInstant(instant, _zoneId)!.use((zdt) {
      final isDst = zdt.getOffset()!.use(
        (zoneOffset) =>
            zoneOffset.getRules()!.use((zoneRules) => Instant.from(zdt)!.use((i) => zoneRules.isDaylightSavings(i))),
      );
      final abbr = 'zzz'
          .toJString()
          .use(DateTimeFormatter.ofPattern)!
          .use((f) => f.format(zdt)!.toDartString(releaseOriginal: true));
      final offset = zdt.getOffset()!.use((p0) => p0.getTotalSeconds());
      return (offset, isDst, abbr);
    });
    instant!.release();
    return JavaTimezoneSpan(offset: Offset.fromSeconds(offset), abbreviation: abbr, dst: isDst);
  }

  /// TODO: When we move this to the main library, we should remove
  /// this so that we don't have memory leaks. We should instead create
  /// a new zodeId object each time we need it.
  late final _zoneId = JString.fromString(name).use(ZoneId.of$1)!;

  @override
  (EpochMicroseconds, TimezoneSpan) convert(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) {
    final nanoSeconds = (microsecond * 1000) + (millisecond * 1000000);
    final micros = ZonedDateTime.of$2(year, month, day, hour, minute, second, nanoSeconds, _zoneId)!.use(
      (zonedDateTime) =>
          Instant.from(zonedDateTime)!.use((instant) => instant.getEpochSecond() * Duration.microsecondsPerSecond),
    );
    return (micros, span(at: micros));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is JavaTimezone && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

class JavaTimezoneSpan extends TimezoneSpan {
  /// Creates a new instance of [JavaTimezoneSpan].
  JavaTimezoneSpan({required super.offset, required super.abbreviation, required super.dst});

  /// The start of the span.
  @override
  EpochMicroseconds? get start => null;

  /// The end of the span.
  @override
  EpochMicroseconds? get end => null;
}
