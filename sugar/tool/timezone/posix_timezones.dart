import 'dart:io';

import 'irs.dart';

const _destination = 'lib/src/time/zone/platform/posix_timezones.g.dart';
const _header = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// Generated by: sugar/tool/timezone/generate_timezones.dart
// **************************************************************************
// 
// ignore_for_file: type=lint
import 'package:meta/meta.dart';

/// The TZ database timezones.
@internal const Set<String> known = {
''';


extension PosixTimezones on Never {

  static void generate(NamespaceIR namespace) {
    final buffer = StringBuffer(_header);
    _traverse(buffer, namespace);
    buffer.writeln('};');

    File(_destination).writeAsStringSync(buffer.toString());
  }

  static void _traverse(StringBuffer buffer, NamespaceIR namespace) {
    for (final timezone in namespace.timezones) {
      buffer.writeln("  '${timezone.location.name}',");
    }

    for (final namespace in namespace.namespaces) {
      _traverse(buffer, namespace);
    }
  }

}
