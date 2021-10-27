import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:jeeves/src/formatting.dart';

/// A mixin that provides frequently used file operations.
mixin Files on Formatting {

  Map<String, String>? _bindings;
  Map<dynamic, dynamic>? _configuration;
  late final Directory environments;
  late final Directory root = _root;

  Map<String, String> get bindings {
    if (_bindings != null || _error) {
      return _bindings ?? {};
    }

    _bindings = {};

    final mappings = configuration['bindings'] as Map?;
    if (mappings == null) {
      return _bindings!;
    }

    final errors = <String, dynamic>{};
    for (final entry in mappings.entries) {
      if (entry.value is String) {
        bindings[entry.key] = entry.value;

      } else {
        errors[entry.key] = entry.value;
      }
    }

    if (errors.isEmpty) {
      return _bindings!;
    }

    final message = StringBuffer('Failed to execute `$actual`. Errors found in bindings.yaml:\n | \n |  bindings:\n');
    for (final entry in errors.entries) {
      message.writeln('''
 |    ...
 |    ${entry.key}:
 |    ${'~' * entry.key.length} value is a ${entry.value.runtimeType}, should be a string
 |
      ''');
    }

    stderr.writeln(message);
    _error = true;
    return {};
  }

  Map<dynamic, dynamic> get configuration {
    if (_configuration != null || _error) {
      return _configuration ?? {};
    }

    try {
      final file = File('${root!.path}/tool/jeeves/bindings.yaml');
      if (!file.existsSync()) {
        stdout.writeln('bindings.yaml not found. Creating bindings.yaml...');
        file..createSync(recursive: true)..writeAsStringSync('version: "1.0.0"');
      }

      return _configuration = loadYaml(file.readAsStringSync()).contents;

    } on IOException catch (e) {
      stderr.writeln('Failed to execute `$actual`, $e');
      _error = true;
      return {};
    }
  }


  Directory? get environments {
    if (_environments != null || _error) {
      return _environments;
    }

    try {
      _environments = Directory('${root!.path}/tool/jeeves/environments/');
      if (!_environments!.existsSync()) {
        stdout.writeln('Environments folder not found. Creating environments folder...');
        environments!.createSync(recursive: true);
      }

      return _environments;

    } on IOException catch (e) {
      stderr.writeln("Failed to execute `${globalResults!.arguments.join(' ')}`, $e");
      _error = true;
    }
  }


  Directory get _root {
    if (File('${Directory.current.path}/pubspec.yaml').existsSync()) {
      return Directory.current;
    }

    stderr.writeln("Failed to execute '$actual' in ${Directory.current.path}. Command should be invoked in a Dart/Flutter project's root.");
    exit(1);
  }

}