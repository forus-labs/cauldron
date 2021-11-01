import 'dart:io';

import 'package:jeeves/src/files.dart';
import 'package:jeeves/src/parser.dart';
import 'package:jeeves/src/terminal.dart';

class LoadCommand extends TerminalCommand<void> with Files<void> {

  @override
  Future<void> run() async {
    final parser = Parser(terminal, jeeves, root, envs);

    final rest = argResults!.rest;
    if (rest.isEmpty) {
      terminal..error(highlight('Failed to execute "$line"', '$line ', ' ', 'no environment specified', red))..exit(1);

    } else if (rest.length > 1) {
      terminal..error(highlight('Failed to execute "$line"', line, remaining, 'environment may not contain spaces', red))..exit(1);
    }

    final environment = '$envs/${rest[0]}';
    if (!Directory(environment).existsSync()) {
      terminal..error(highlight('Failed to execute "$line"', line, rest[0], 'environment does not exist', red))..exit(1);
    }

    final results = parser.parse(environment);
    for (final entry in results.entries) {
      terminal.print('Replacing ${entry.key.path} with ${entry.value.path}');
      await entry.value.openRead().pipe(entry.key.openWrite());
    }

    terminal.print('Replaced ${environment.length} files');
  }

  @override
  String get name => 'load';

  @override
  String get description => 'Loads the given environment if it exists';

}