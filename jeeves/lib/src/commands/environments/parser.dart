import 'dart:io';

import 'package:jeeves/src/core/format.dart';
import 'package:jeeves/src/core/terminal.dart';

/// A parser for parsing the 'jeeves.yaml' files.
class Parser {

  final Terminal _terminal;
  final Map<dynamic, dynamic> _jeeves;
  final String _project;

  /// Creates a [Parser] with the given terminal and `jeeves.yaml` file.
  Parser(this._terminal, this._jeeves, this._project);

  /// Returns the replacements for the given [environment].
  Map<File, File> parse(String environment) {
    final section = _jeeves['files'] as Map?;
    if (section == null) {
      _terminal.print(yellow('No environment files specified in jeeves.yaml'));
      return {};
    }

    final files = <File, File>{};
    final message = StringBuffer(red('Errors found in jeeves.yaml:\n'))..indent('')..indent('files:');
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

      final replacement = File('$environment/${entry.value}');
      if (!replacement.existsSync()) {
        buffer.error(path, entry, entry.value, '${replacement.path} does not exist');
        continue;
      }

      files[original] = replacement;
    }
  }

}
