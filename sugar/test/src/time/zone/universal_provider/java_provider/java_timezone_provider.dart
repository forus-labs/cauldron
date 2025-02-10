import 'dart:collection';

import 'package:jni/jni.dart';
import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/temporal_unit.dart';
import 'package:sugar/src/time/zone/timezone.dart';

import 'bindings.dart';

class JavaTimezoneProvider extends UnmodifiableMapBase<String, Timezone> {
  @override
  Timezone? operator [](Object? key) {
    if (key is String && keys.contains(key)) {
      return JavaTimezone(key);
    }
    return null;
  }

  @override
  Iterable<String> get keys => ZoneId.getAvailableZoneIds()!.use((ids) => ids
      .map((element) => element?.toDartString(releaseOriginal: true))
      .nonNulls
      .toSet());
}

/// A timezone that uses the Java timezone database.
class JavaTimezone extends Timezone {
  /// Creates a new Java timezone with the given [name].
  const JavaTimezone(super.name) : super.from();

  @override
  Offset offset({required EpochMicroseconds at}) {
    final instant = Instant.ofEpochMilli(at ~/ 1000);
    final result = _zoneId()
        .use((p0) => ZonedDateTime.ofInstant(instant, p0))!
        .use((p0) => p0.getOffset()!.use((offset) => offset.getTotalSeconds()));
    instant!.release();
    return Offset.fromSeconds(result);
  }

  ZoneId _zoneId() => JString.fromString(name).use(ZoneId.of$1)!;

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
    final nanoSeconds = (microsecond * 1000) + (millisecond * 1000000);

    return _zoneId().use(
      (zone) => ZonedDateTime.of$2(
        year,
        month,
        day,
        hour,
        minute,
        second,
        nanoSeconds,
        zone,
      )!
          .use((zonedDateTime) => Instant.from(zonedDateTime)!.use((instant) =>
              instant.getEpochSecond() * Duration.microsecondsPerSecond)),
    );
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
