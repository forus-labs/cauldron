import 'dart:io';

import 'package:jeeves/src/terminal.dart';

/// A parser for parsing 'jeeves.yaml' files.
class Parser {

  late final Map<File, File> files = _files;
  final Terminal _terminal;
  final Map<String, dynamic> _jeeves;

  /// Creates a [Parser] with the given terminal and `jeeves.yaml` file.
  Parser(this._terminal, this._jeeves);

  Map<File, File> get _files {
    final section = _jeeves['files'] as Map?;
    if (section == null) {
      _terminal.print(yellow('No environment files specified in jeeves.yaml'));
      return {};
    }

    final files = <File, File>{};
    final message = StringBuffer(red('Errors found in jeeves.yaml:'));
    final original = message.length;

    _map(section, [], files, message);
    if (original != message.length) {
      _terminal..error('Errors found in jeeves.yaml')..exit(1);
    }
  }

  void _map(Map<dynamic, dynamic> section, List<String> path, Map<File, File> files, StringBuffer buffer) {
    for (final entry in section.entries) {
      if (entry.key) {

      }
    }
  }

}

extension _A on StringBuffer {

}