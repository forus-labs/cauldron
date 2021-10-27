import 'dart:io';

import 'package:args/command_runner.dart';

import 'package:jeeves/src/files.dart';
import 'package:jeeves/src/formatting.dart';

class LoadCommand extends Command<void> with Formatting, Files {

  @override
  void run() {
    final folder = environments;
    if (folder == null) {
      return;
    }

    final rest = argResults!.rest;
    if (rest.isEmpty) {
      stderr.writeln(highlight("Failed to execute '$actual'", ' ', 'no environment should be specified', command: '$actual  '));
      return;

    } else if (rest.length > 1) {
      stderr.writeln(highlight("Failed to execute '$actual'", remaining, 'environment may not contain spaces'));
      return;
    }

    final environment = rest[0];
    if (!Directory('${folder.path}/$environment').existsSync()) {
      stderr.writeln(highlight("Failed to execute '$actual'", environment, 'environment does not exist'));
      return;
    }

    for (final entry in bindings.entries) {
      final original = File($entry.key
    }
  }

  @override
  String get name => 'load';

  @override
  String get description => 'Loads the given environment if it exists';

}