import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'package:stevia_runner/src/ansi.dart';
import 'package:stevia_runner/src/assets/elements.dart';
import 'package:stevia_runner/src/assets/icon/generation.dart';
import 'package:stevia_runner/src/assets/icon/lints.dart';

/// A build step that generates Dart code for icons.
bool build(YamlMap configuration, String? package, LibraryBuilder library) {
  final node = configuration.nodes['icons'];
  if (node == null) {
    stdout.writeln('Icon generation is not configured, skipping icon generation');
    return true;
  }

  final path = node.value;
  if (path is! String) {
    stderr.writeln(node.span.message(red('Could not resolve folder for icons during assets generation. Is $path a folder relative to ./assets ?'), color: red.escape));
    return false;
  }

  final directory = Directory(normalize('./assets/$path'));
  if (!directory.existsSync()) {
    stderr.writeln(node.span.message(red('Could not resolve ${directory.path} during assets generation. Is icons a folder relative to ./assets ?'), color: red.escape));
    return false;
  }

  final folder = parse(directory, package: package);
  final success = Lint()(folder);
  if (!success) {
    return false;
  }

  Generation(library).generate(folder);

  return true;
}
