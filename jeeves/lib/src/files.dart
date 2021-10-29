import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:jeeves/src/terminal.dart';

const _yaml = '''
version: "1.0.0"

# Uncomment this section to add environment files that should be swapped between
# different environments.
#
# Keys should be paths to the original file, relative to the project's root directory. 
#
# Values should be paths to an environment-specific versions of the original file. 
# The paths should be relative to <project-root>/tool/envs/<some-env>.
# 
#  files:
#    "inline/original_1": "replacement_1"
''';

/// A mixin that provides frequently used file operations.
mixin Files<T> on TerminalCommand<T> {

  /// The jeeves.yaml file.
  late final Map<dynamic, dynamic> jeeves = _jeeves;
  /// The `envs` directory.
  late final String envs = _envs;
  /// The root directory of the project.
  late final String root = _root;

  Map<dynamic, dynamic> get _jeeves {
    try {
      final file = File('$root/tool/jeeves/jeeves.yaml');
      if (!file.existsSync()) {
        terminal.print('jeeves.yaml not found, creating jeeves.yaml ...');
        file..createSync(recursive: true)..writeAsStringSync(_yaml);
      }

      return loadYaml(file.readAsStringSync());

    } on IOException catch (e) {
      terminal..error(red('Failed to execute "$line", $e'))..exit(1);
    }
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

  String get _root {
    final project = Directory.current.path;
    if (!File('$project/pubspec.yaml').existsSync()) {
      terminal..error(red('Failed to execute "$line" in "$project", should be invoked in a project\'s root directory.'))..exit(1);
    }

    return project;
  }

}