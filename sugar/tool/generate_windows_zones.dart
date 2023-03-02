import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

const source = 'https://raw.githubusercontent.com/unicode-org/cldr-json/main/cldr-json/cldr-core/supplemental/windowsZones.json';
const output = 'lib/src/time/zone/platforms/windows_timezones.g.dart';

const header = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// sugar/tool/generate_windows_zones.dart
// **************************************************************************

// ignore_for_file: type=lint

/// The mappings for Windows Zone IDs (Standard names) to TZ database names. These mappings are mechanically derived from
/// the [CLDR-JSON](https://github.com/unicode-org/cldr-json/blob/main/cldr-json/cldr-core/supplemental/windowsZones.json) repository.
const windowsZones = {
''';

void main() async {
  final response = await get(Uri.parse(source));

  final raw = jsonDecode(response.body)['supplemental']['windowsZones']['mapTimezones'] as List<dynamic>; // ignore: avoid_dynamic_calls

  final zones = <String, String>{
    for (final mapping in raw)
      mapping['mapZone']['_other']: (mapping['mapZone']['_type'] as String).split(' ').first, // ignore: avoid_dynamic_calls
  };

  final buffer = StringBuffer(header);
  for (final entry in zones.entries) {
    buffer.writeln("  '${entry.key}': '${entry.value}',");
  }
  buffer.writeln('};');

  File(output).writeAsStringSync(buffer.toString());
}
