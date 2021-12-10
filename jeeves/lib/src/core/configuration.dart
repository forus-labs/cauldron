import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:jeeves/src/core/format.dart';
import 'package:jeeves/src/core/terminal.dart';

const _yaml = '''
version: "1.0.0"
# Uncomment this section to add the paths to icons and illustrations that should
# be generated in Dart.
# 
# The paths are relative to the assets folder.
#
#  assets:
#    icons: "path/to/icons-folder"
#    illustrations: "path/to/illustrations-folder"

# Uncomment this section to add environment files that should be swapped between
# different environments.
#
# Keys should be paths to the original file, relative to the project's root directory. 
#
# Values should be paths to an environment-specific versions of the original file. 
# The paths should be relative to <project-root>/tool/envs/<some-env>.
# 
#  environments:
#    files:
#      "inline/original_1": "replacement_1"
''';

/// A mixin that provides frequently used file operations.
mixin Configuration<T> on TerminalCommand<T> {

  /// The jeeves.yaml file.
  late final Map<dynamic, dynamic> jeeves = _jeeves;
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

  String get _root {
    final project = Directory.current.path;
    if (!File('$project/pubspec.yaml').existsSync()) {
      terminal..error(red('Failed to execute "$line" in "$project", should be invoked in a project\'s root directory.'))..exit(1);
    }

    return project;
  }

}
