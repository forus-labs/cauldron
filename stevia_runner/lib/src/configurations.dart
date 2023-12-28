import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:stevia_runner/src/ansi.dart';

/// Determines if the given file is a valid pubspec.
YamlMap? pubspec(File pubspec) {
  if (!pubspec.existsSync()) {
    stderr.writeln(red('pubspec.yaml does not exist. Are you in the root directory of a Dart/Flutter project?'));
    return null;
  }

  return loadYamlNode(pubspec.readAsStringSync()) as YamlMap?;
}
