import 'dart:io';

import 'irs.dart';

const _destination = 'lib/src/time/zone/timezones.g.dart';
const _header = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// Generated by: sugar/tool/timezone/main.dart
// **************************************************************************
// 
// ignore_for_file: type=lint
import 'package:meta/meta.dart';

import 'package:sugar/src/time/zone/timezone_rules.dart';
''';

const _setHeader = '''
/// The supported IANA TZ database timezones.
@internal const Set<String> iana = {''';

const _functionHeader = '''
/// Returns the [Timezone] associated with the given [name] if it exists. Otherwise returns the `Factory` [Timezone].
/// 
/// ## Implementation details:
/// To lazily initialize [Timezone]s, a switch statement is used instead of a [Map].
/// Since most use-cases only require a few [Timezone]s, it drastically reduces memory footprint.
@internal TimezoneRules parseTimezone(String timezone) {
  switch (timezone) {
''';


extension Timezones on Never {

  static void generate(NamespaceIR namespace) {
    final buffer = StringBuffer(_header)..writeln();
    _import(buffer, namespace);
    buffer.writeln();
    _set(buffer, namespace);
    buffer.writeln();
    _function(buffer, namespace);

    File(_destination).writeAsStringSync(buffer.toString());
  }

  static void _import(StringBuffer buffer, NamespaceIR namespace) {
    buffer.writeln("import '${namespace.toPackagePath()}';");

    for (final namespace in namespace.namespaces) {
      _import(buffer, namespace);
    }
  }


  static void _set(StringBuffer buffer, NamespaceIR namespace) {
    buffer.writeln(_setHeader);
    _traverse(buffer, namespace);
    buffer.writeln('};');
  }

  static void _traverse(StringBuffer buffer, NamespaceIR namespace) {
    for (final timezone in namespace.timezones) {
      buffer.writeln("  '${timezone.location.name}',");
    }

    for (final namespace in namespace.namespaces) {
      _traverse(buffer, namespace);
    }
  }


  static void _function(StringBuffer buffer, NamespaceIR namespace) {
    buffer.writeln(_functionHeader);
    _cases(buffer, namespace);
    buffer
      ..writeln('    default:')
      ..writeln('      return Root.factory;')
      ..writeln('  }')
      ..writeln('}');
  }

  static void _cases(StringBuffer buffer, NamespaceIR namespace) {
    for (final location in namespace.timezones) {
      buffer
        ..writeln("    case '${location.location.name}':")
        ..writeln('      return ${namespace.typeName}.${location.variableName};');
    }

    for (final namespace in namespace.namespaces) {
      _cases(buffer, namespace);
    }
  }

}
