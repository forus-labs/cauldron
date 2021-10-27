import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:jeeves/src/formatting.dart';

// TODO: improve template message
const _yaml = '''
version: "1.0.0"

# Uncomment this section to add bindings for different environments.
# 
# bindings:
#   original: replacement
''';

/// A mixin that provides frequently used file operations.
mixin Files on Formatting {

  late final Map<String, String> bindings = _bindings;
  late final Map<dynamic, dynamic> configuration = _configuration;
  late final Directory environments = _environments;
  late final Directory root = _root;

  Map<String, String> get _bindings {
    final mappings = configuration['bindings'] as Map?;
    if (mappings == null) {
      return {};
    }

    final bindings = <String, String>{};
    final errors = <String, dynamic>{};
    for (final entry in mappings.entries) {
      if (entry.value is String) {
        bindings[entry.key] = entry.value;

      } else {
        errors[entry.key] = entry.value;
      }
    }

    if (errors.isEmpty) {
      return bindings;
    }

    final message = StringBuffer('Failed to execute `$line`. Errors found in bindings.yaml:')
                              ..block('')
                              ..block('bindings:');

    for (final entry in errors.entries) {
      message..block('...', 2)
             ..highlight(entry.key, entry.key, 'value is a ${entry.value.runtimeType}, should be a string', 2)
             ..block('');
    }

    stderr.writeln(message);
    exit(1);
  }

  Map<dynamic, dynamic> get _configuration {
    try {
      final file = File('${root.path}/tool/jeeves/bindings.yaml');
      if (!file.existsSync()) {
        stdout.writeln('bindings.yaml not found. Creating bindings.yaml...');
        file..createSync(recursive: true)..writeAsStringSync(_yaml);
      }

      return loadYaml(file.readAsStringSync());

    } on IOException catch (e) {
      stderr.writeln('Failed to execute `$line`, $e');
      exit(1);
    }
  }

  Directory get _environments {
    try {
      final environments = Directory('${root.path}/tool/jeeves/environments');
      if (!environments.existsSync()) {
        stdout.writeln('Environments folder not found. Creating environments folder...');
        environments.createSync(recursive: true);
      }

      return environments;

    } on IOException catch (e) {
      stderr.writeln("Failed to execute '$line', $e");
      exit(1);
    }
  }

  Directory get _root {
    if (!File('${Directory.current.path}/pubspec.yaml').existsSync()) {
      stderr.writeln("Failed to execute '$line' in ${Directory.current.path}. Command should be invoked in a Dart/Flutter project's root.");
      exit(1);
    }

    return Directory.current;
  }

}