import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

const source =
    'https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-core/supplemental/windowsZones.json';
const output = 'lib/src/time/zone/platform/windows_timezones.g.dart';

const header = '''
import 'package:meta/meta.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// Generated by: sugar/tool/generate_windows_zones.dart
// **************************************************************************

// ignore_for_file: type=lint

/// The mappings for Windows Zone IDs (Standard names) to TZ database names. These mappings are mechanically derived from
/// the [CLDR-JSON](https://github.com/unicode-org/cldr-json/blob/main/cldr-json/cldr-core/supplemental/windowsZones.json) repository.
@internal const windowsTimezones = {
''';

// ignore_for_file: avoid_dynamic_calls

void main() async {
  final response = await get(Uri.parse(source));

  final raw = jsonDecode(response.body)['supplemental']['windowsZones']
      ['mapTimezones'] as List<dynamic>;

  final zones = <String, MapEntry<String, String>>{};
  for (final object in raw) {
    final zone = object['mapZone'];
    final windows = zone['_other'];
    final location = zone['_type'];
    final territory = zone['_territory'];

    final existing = zones[windows];
    if (existing == null || territory == '001') {
      // always prefer canonical location
      zones[windows] = MapEntry(location, territory);
    }
  }

  final buffer = StringBuffer(header);
  for (final entry in zones.entries) {
    buffer.writeln("  '${entry.key}': '${entry.value.key}',");
  }
  buffer.writeln('};');

  File(output).writeAsStringSync(buffer.toString());
}
