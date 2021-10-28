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
#
''';

/// A mixin that provides frequently used file operations.
mixin Files on Formatting {

  late final Map<String, String> bindings = _bindings;

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
  }

}