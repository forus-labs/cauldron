import 'dart:io';

import 'package:sugar/core.dart';
import 'package:sugar/src/time/offset.dart';
import 'package:timezone/tzdata.dart';

/// An intermediate representation of a namespace.
class NamespaceIR {
  /// The name.
  final String name;
  /// The namespace in pascal case, i.e. `Asia` will be `Asia`.
  final String typeName;
  /// The nested namespaces.
  final List<NamespaceIR> namespaces = [];
  /// The locations.
  final List<TimezoneIR> timezones = [];

  NamespaceIR(this.name): typeName = name.toPascalCase();

  String toPackagePath() => 'package:sugar/src/time/zone/info/${name.toSnakeCase()}.g.dart';

  StringBuffer toExtension() {
    final buffer = StringBuffer('extension $typeName on Never {\n');
    for (final timezone in timezones) {
      buffer.writeln('  static final Timezone ${timezone.variableName} = ${timezone.toConstructor(4)}\n');
    }

    return buffer..writeln('}\n');
  }
}

/// An intermediate representation of a timezone.
sealed class TimezoneIR {

  /// The location derived from the corresponding zic compiled file.
  final Location location;
  /// The timezone's name in camel case, i.e. `Asia/Singapore` will be renamed as `singapore`.
  final String variableName;

  factory TimezoneIR(String path, File file) {
    final location = Location.fromBytes(path, file.readAsBytesSync());
    final variableName = path.split('/').last.toEscapedCamelCase();

    return switch (location) {
      _ when location.transitionAt.isNotEmpty && location.transitionZone.isNotEmpty => DynamicTimezoneIR(location, variableName),
      _ when location.transitionAt.isEmpty && location.transitionZone.isEmpty => FixedTimezoneIR(location, variableName),
      _ => throw StateError('${location.name} has ${location.transitionAt.length} times and ${location.transitionZone.length} zones'),
    };

  }

  TimezoneIR._(this.location, this.variableName);

  String toConstructor(int indentation);

}

/// An intermediate representation of a dynamic timezone.
final class DynamicTimezoneIR extends TimezoneIR {

  DynamicTimezoneIR(super.location, super.variableName): super._();

  @override
  String toConstructor(int indentation) {
    final (offsets, unit) = _offsets;
    return (StringBuffer('DynamicTimezone(\n')
    ..writeIndented(indentation, "'${location.name}',\n")
    ..writeIndented(indentation, '${_initial(indentation + 2)},\n')
    ..writeIndented(indentation, 'Int64List.fromList([ ${location.transitionAt.join(', ')} ]),\n')
    ..writeIndented(indentation, '$offsets,\n')
    ..writeIndented(indentation, '$unit,\n')
    ..writeIndented(indentation, '$_abbreviations,\n')
    ..writeIndented(indentation, '$_dsts,\n')
    ..writeIndented(indentation - 2, ');'))
    .toString();
  }

  (String, int) get _offsets {
    final zones = [
      for (int i = 0; i < location.transitionAt.length; i++)
        location.zones[location.transitionZone[i]].offset,
    ];

    return switch (zones) {
      _ when zones.every((z) => z % 3600 == 0) =>
        ('Int8List.fromList([ ${zones.map((z) => z ~/ 3600).toList().join(', ')} ])', Duration.microsecondsPerHour),

      _ when zones.every((z) => z % 60 == 0) =>
        ('Int16List.fromList([ ${zones.map((z) => z ~/ 60).toList().join(', ')} ])', Duration.microsecondsPerMinute),

      _ => ('Int32List.fromList([ ${zones.join(', ')} ])', Duration.microsecondsPerSecond),
    };
  }

  String _initial(int indentation) {
    final zone = location.first;
    return (StringBuffer('DynamicTimezoneSpan(\n')
      ..writeIndented(indentation, '-1,\n')
      ..writeIndented(indentation, '${zone.offset * 1000 * 1000},\n')
      ..writeIndented(indentation, "'${location.abbreviations[zone.abbreviationIndex]}',\n")
      ..writeIndented(indentation, 'TimezoneSpan.range.min.value,\n')
      ..writeIndented(indentation, '${location.transitionAt[0]},\n')
      ..writeIndented(indentation, 'dst: ${zone.isDst},\n')
      ..writeIndented(indentation - 2, ')'))
        .toString();
  }

  String get _abbreviations {
    final abbreviations = [
      for (int i = 0; i < location.transitionAt.length; i++)
        "'${location.abbreviations[location.zones[location.transitionZone[i]].abbreviationIndex]}'",
    ];

    return '[ ${abbreviations.join(', ')} ]';
  }

  String get _dsts {
    final dsts = [
      for (int i = 0; i < location.transitionAt.length; i++)
        location.zones[location.transitionZone[i]].isDst,
    ];

    return '[ ${dsts.join(', ')} ]';
  }

}

/// An intermediate representation of a fixed timezone.
final class FixedTimezoneIR extends TimezoneIR {

  FixedTimezoneIR(super.location, super.variableName): super._();

  @override
  String toConstructor(int indentation) {
    final zone = location.zones.single;
    return (StringBuffer('FixedTimezone(\n')
      ..writeIndented(indentation, "'${location.name}',\n")
      ..writeIndented(indentation, 'FixedTimezoneSpan(\n')
      ..writeIndented(indentation + 2, '${_offset(zone)},\n')
      ..writeIndented(indentation + 2, "'${location.abbreviations.single}',\n")
      ..writeIndented(indentation + 2, 'TimezoneSpan.range.min.value,\n')
      ..writeIndented(indentation + 2, 'TimezoneSpan.range.max.value,\n')
      ..writeIndented(indentation + 2, 'dst: ${zone.isDst},\n')
      ..writeIndented(indentation, '),\n')
      ..writeIndented(indentation - 2, ');'))
      .toString();
  }

  String _offset(TimeZone zone) => "const LiteralOffset('${format(zone.offset * Duration.microsecondsPerSecond)}', ${zone.offset})";

}


/// Copied from https://github.com/srawlins/timezone/blob/0.9.1/lib/src/location.dart#L183.
extension on Location {

  /// This method returns the [TimeZone] to use for times before the first
  /// transition time, or when there are no transition times.
  ///
  /// The reference implementation in localtime.c from
  /// http://www.iana.org/time-zones/repository/releases/tzcode2013g.tar.gz
  /// implements the following algorithm for these cases:
  ///
  /// 1. If the first zone is unused by the transitions, use it.
  /// 2. Otherwise, if there are transition times, and the first
  ///    transition is to a zone in daylight time, find the first
  ///    non-daylight-time zone before and closest to the first transition
  ///    zone.
  /// 3. Otherwise, use the first zone that is not daylight time, if
  ///    there is one.
  /// 4. Otherwise, use the first zone.
  ///
  TimeZone get first {
    // case 1
    if (!_firstZoneIsUsed()) {
      return zones.first;
    }

    // case 2
    if (transitionZone.isNotEmpty && zones[transitionZone.first].isDst) {
      for (var zi = transitionZone.first - 1; zi >= 0; zi--) {
        final z = zones[zi];
        if (!z.isDst) {
          return z;
        }
      }
    }

    // case 3
    for (final zi in transitionZone) {
      final z = zones[zi];
      if (!z.isDst) {
        return z;
      }
    }

    // case 4
    return zones.first;
  }

  /// firstZoneUsed returns whether the first zone is used by some transition.
  bool _firstZoneIsUsed() {
    for (final i in transitionZone) {
      if (i == 0) {
        return true;
      }
    }

    return false;
  }

}

extension on String {

  static final separators = RegExp(r'((\s|_|/)+)|(?<=[a-z])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])');

  String toEscapedCamelCase() => replaceAll(RegExp(r'-(?=\D)'), '_')
      .replaceAll(RegExp(r'-(?=\d)'), 'Minus')
      .replaceAll(RegExp(r'\+(?=\d)'), 'Plus')
      .toCamelCase(separators);

}
