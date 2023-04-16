import 'dart:io';
import 'package:sugar/core.dart';

import 'irs.dart';

const _locationFolder = 'lib/src/time/zone/info';
const _header = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// Generated by: sugar/tool/timezone/main.dart
// **************************************************************************
// 
// ignore_for_file: type=lint

import 'package:sugar/src/time/offset.dart';
import 'package:sugar/src/time/zone/dynamic_timezone.dart';
import 'package:sugar/src/time/zone/timezone.dart';

''';

extension ZoneInfo on Never {

  static void generate(NamespaceIR namespace) => _namespace(namespace);

  static void _namespace(NamespaceIR namespace) {
    final buffer = StringBuffer(_header)..writeln(namespace.toExtension());

    File('$_locationFolder/${namespace.name.toSnakeCase()}.g.dart').writeAsStringSync(buffer.toString());
    namespace.namespaces.forEach(_namespace);
  }

}
