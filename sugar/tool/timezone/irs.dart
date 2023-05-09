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
abstract class TimezoneIR {

  /// The location derived from the corresponding zic compiled file.
  final Location location;
  /// The timezone's name in camel case, i.e. `Asia/Singapore` will be renamed as `singapore`.
  final String variableName;

  factory TimezoneIR(String path, File file) {
    final location = Location.fromBytes(path, file.readAsBytesSync());
    final variableName = path.split('/').last.toEscapedCamelCase();

    if (location.transitionAt.isNotEmpty && location.transitionZone.isNotEmpty) {
      return DynamicTimezoneIR(location, variableName);

    } else if (location.transitionAt.isEmpty && location.transitionZone.isEmpty) {
      return FixedTimezoneIR(location, variableName);

    } else {
      throw StateError('${location.name} has ${location.transitionAt.length} times and ${location.transitionZone.length} zones');
    }
  }

  TimezoneIR._(this.location, this.variableName);

  String toConstructor(int indentation);

}

/// An intermediate representation of a dynamic timezone.
class DynamicTimezoneIR extends TimezoneIR {

  DynamicTimezoneIR(super.path, super.file): super._();

  @override
  String toConstructor(int indentation) {
    final tuple = _compressOffsets(); // TODO: Dart 3 destructuring
    return (StringBuffer('DynamicTimezone(\n')
    ..writeIndented(indentation, "'${location.name}',\n")
    ..writeIndented(indentation, '${_initial(indentation + 2)},\n')
    ..writeIndented(indentation, 'Int64List.fromList([ ${location.transitionAt.join(', ')} ]),\n')
    ..writeIndented(indentation, '${_offsets(tuple.key, tuple.value)},\n')
    ..writeIndented(indentation, '${tuple.value},\n')
    ..writeIndented(indentation, '$_abbreviations,\n')
    ..writeIndented(indentation, '$_dsts,\n')
    ..writeIndented(indentation - 2, ');'))
    .toString();
  }

  MapEntry<List<int>, int> _compressOffsets() { // TODO: Dart 3, replace with tuple
    final zones = [
      for (int i = 0; i < location.transitionAt.length; i++)
        location.zones[location.transitionZone[i]].offset,
    ];

    final int divisor;
    final int unit;
    if (zones.every((z) => z % 3600 == 0)) {
      divisor = 3600;
      unit = Duration.microsecondsPerHour;

    } else if (zones.every((z) => z % 60 == 0)) {
      divisor = 60;
      unit = Duration.microsecondsPerMinute;

    } else {
      divisor = 1;
      unit = Duration.microsecondsPerSecond;
    }

    return MapEntry(zones.map((z) => z ~/ divisor).toList(), unit);
  }

  String _initial(int indentation) {
    final zone = location.first;
    return (StringBuffer('DynamicTimezoneSpan(\n')
      ..writeIndented(indentation, '-1,\n')
      ..writeIndented(indentation, '${zone.offset * 1000 * 1000},\n')
      ..writeIndented(indentation, "'${location.abbreviations[zone.abbreviationIndex]}',\n")
      ..writeIndented(indentation, 'TimezoneSpan.range.min,\n')
      ..writeIndented(indentation, '${location.transitionAt[0]},\n')
      ..writeIndented(indentation, 'dst: ${zone.isDst},\n')
      ..writeIndented(indentation - 2, ')'))
        .toString();
  }

  String _offsets(List<int> offsets, int unit) {
    switch (unit) {
      case Duration.microsecondsPerHour:
        return 'Int8List.fromList([ ${offsets.join(', ')} ])';
      case Duration.microsecondsPerMinute:
        return 'Int16List.fromList([ ${offsets.join(', ')} ])';
      case Duration.microsecondsPerSecond:
        return 'Int32List.fromList([ ${offsets.join(', ')} ])';
      default:
        throw StateError('Unknown unit: $unit');
    }
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
class FixedTimezoneIR extends TimezoneIR {

  FixedTimezoneIR(super.path, super.file): super._();

  @override
  String toConstructor(int indentation) {
    final zone = location.zones.single;
    return (StringBuffer('FixedTimezone(\n')
      ..writeIndented(indentation, "'${location.name}',\n")
      ..writeIndented(indentation, 'FixedTimezoneSpan(\n')
      ..writeIndented(indentation + 2, '${_offset(zone)},\n')
      ..writeIndented(indentation + 2, "'${location.abbreviations.single}',\n")
      ..writeIndented(indentation + 2, 'TimezoneSpan.range.min,\n')
      ..writeIndented(indentation + 2, 'TimezoneSpan.range.max,\n')
      ..writeIndented(indentation + 2, 'dst: ${zone.isDst},\n')
      ..writeIndented(indentation, '),\n')
      ..writeIndented(indentation - 2, ');'))
      .toString();
  }

  String _offset(TimeZone zone) => "const LiteralOffset('${format(zone.offset)}', ${zone.offset})";

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
