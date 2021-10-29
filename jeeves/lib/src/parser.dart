import 'dart:io';

import 'package:jeeves/src/terminal.dart';
import 'package:yaml/yaml.dart';

/// A parser for parsing 'jeeves.yaml' files.
class Parser {

  final Terminal _terminal;
  final Map<dynamic, dynamic> _jeeves;
  final String _project;
  final String _envs;

  /// Creates a [Parser] with the given terminal and `jeeves.yaml` file.
  Parser(this._terminal, this._jeeves, this._project, this._envs);

  Map<File, File> parse(String environment) {
    final section = _jeeves['files'] as Map?;
    if (section == null) {
      _terminal.print(yellow('No environment files specified in jeeves.yaml'));
      return {};
    }

    final files = <File, File>{};
    final message = StringBuffer(red('Errors found in jeeves.yaml:\n'))..code('')..code('files:');
    final original = message.length;

    _map(section, [], environment, files, message);
    if (original != message.length) {
      _terminal..error(message.toString())..exit(1);
    }

    return files;
  }

  void _map(Map<dynamic, dynamic> section, List<String> path, String environment, Map<File, File> files, StringBuffer buffer) {
    for (final entry in section.entries) {
      if (entry.value is! String) {
        buffer.error(path, entry, entry.value, 'is a ${entry.value.runtimeType}, should be a string');
        continue;
      }

      final original = File('$_project/${entry.key}');
      if (!original.existsSync()) {
        buffer.error(path, entry, entry.key, '${original.path} does not exist');
        continue;
      }

      final replacement = File('$_envs/$environment/${entry.value}');
      if (!replacement.existsSync()) {
        buffer.error(path, entry, entry.value, '${replacement.path} does not exist');
        continue;
      }

      files[original] = replacement;
    }
  }

}

extension _YamlCodeBlock on StringBuffer {

  void error(List<String> path, MapEntry<dynamic, dynamic> entry, String part, String message) =>
      this..code('...', (path.length + 1) * 2)
          ..highlight('${entry.key}: ${entry.value}', part, message, red, (path.length + 1) * 2)
          ..code('');

}