import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:jeeves/src/old/files.dart';
import 'package:jeeves/src/formatting.dart';

class LoadCommand extends Command<void> with Formatting, Files {

  @override
  Future<void> run() async {
    final rest = argResults!.rest;
    if (rest.isEmpty) {
      stderr.writeln(highlight("Failed to execute '$line'", line, ' ', 'no environment should be specified'));
      return;

    } else if (rest.length > 1) {
      stderr.writeln(highlight("Failed to execute '$line'", line, remaining, 'environment may not contain spaces'));
      return;
    }

    final environment = '${environments.path}/${rest[0]}';
    if (!Directory(environment).existsSync()) {
      stderr.writeln(highlight("Failed to execute '$line'", line, rest[0], 'environment does not exist'));
      return;
    }

    for (final entry in _bindings(environment).entries) {
      stdout.writeln('Replacing ${entry.key.path} with ${entry.value.path}');
      await entry.value.openRead().pipe(entry.key.openWrite());
    }

    stdout.writeln('Replaced ${bindings.length} files');
  }

  Map<File, File> _bindings(String environment) {
    final files = <File, File>{};
    final message = StringBuffer('Non-existing bindings found in bindings.yaml:')
      ..block('')
      ..block('bindings:');

    for (final entry in bindings.entries) {
      final original = File('${root.path}/${entry.key}');
      final replacement = File('$environment/${entry.value}');

      if (!original.existsSync()) {
        message..block('...', 2)
          ..highlight('${entry.key}: ${entry.value}' , entry.key, 'does not exist (${original.path})', 2)
          ..block('');
        continue;
      }

      if (!replacement.existsSync()) {
        message..block('...', 2)
          ..highlight('${entry.key}: ${entry.value}' , entry.value, 'does not exist (${replacement.path})', 2)
          ..block('');
        continue;
      }

      files[original] = replacement;
    }

    if (bindings.length != files.length) {
      stderr.writeln(message);
      exit(1);
    }

    return files;
  }

  @override
  String get name => 'load';

  @override
  String get description => 'Loads the given environment if it exists';

}