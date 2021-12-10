import 'dart:io';

import 'package:jeeves/src/commands/environments/parser.dart';
import 'package:jeeves/src/core/configuration.dart';
import 'package:jeeves/src/core/format.dart';
import 'package:jeeves/src/core/terminal.dart';

/// A command that loads a given environment when executed.
class LoadCommand extends TerminalCommand<void> with Configuration<void> {

  @override
  Future<void> run() async {
    final parser = Parser(terminal, jeeves, root);

    final rest = argResults!.rest;
    if (rest.isEmpty) {
      terminal..error(highlight('Failed to execute "$line"', '$line ', ' ', 'no environment specified', red))..exit(1);

    } else if (rest.length > 1) {
      terminal..error(highlight('Failed to execute "$line"', line, remaining, 'environment may not contain spaces', red))..exit(1);
    }

    final environment = '$_envs/${rest[0]}';
    if (!Directory(environment).existsSync()) {
      terminal..error(highlight('Failed to execute "$line"', line, rest[0], 'environment does not exist', red))..exit(1);
    }

    final results = parser.parse(environment);
    for (final entry in results.entries) {
      terminal.print('Replacing ${entry.key.path} with ${entry.value.path}');
      await entry.value.openRead().pipe(entry.key.openWrite());
    }

    terminal.print('Replaced ${results.length} files');
  }

  String get _envs {
    try {
      final envs = Directory('$root/tool/jeeves/envs');
      if (!envs.existsSync()) {
        terminal.print('envs folder not found, creating envs folder...');
        envs.createSync(recursive: true);
      }

      return envs.path;

    } on IOException catch (e) {
      terminal..error(red('Failed to execute "$line", $e'))..exit(1);
    }
  }

  @override
  String get name => 'load';

  @override
  List<String> get aliases => ['ld'];

  @override
  String get description => 'Loads the given environment if it exists';

}
