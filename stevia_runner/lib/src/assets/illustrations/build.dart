import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'package:stevia_runner/src/ansi.dart';
import 'package:stevia_runner/src/assets/elements.dart';
import 'package:stevia_runner/src/assets/illustrations/ast.dart';
import 'package:stevia_runner/src/assets/illustrations/generation.dart';
import 'package:stevia_runner/src/assets/illustrations/lints.dart';

/// A build step that generates Dart code for illustrations.
bool build(YamlMap configuration, String? package, LibraryBuilder library) {
  final illustrations = configuration.nodes['illustrations'] as YamlMap?;
  if (illustrations == null) {
    stdout.writeln('Illustration generation is not configured, skipping illustration generation');
    return true;
  }

  final pathNode = illustrations.nodes['path'];
  final path = pathNode?.value;
  if (pathNode == null || path is! String) {
    stderr.writeln(illustrations.span.message(red('Could not resolve folder for illustrations during assets generation. Is $path a folder relative to ./assets ?'), color: red.escape));
    return false;
  }

  final directory = Directory(normalize('./assets/$path'));
  if (!directory.existsSync()) {
    stderr.writeln(pathNode.span.message(red('Could not resolve ${directory.path} during assets generation. Is path a folder relative to ./assets ?'), color: red.escape));
    return false;
  }

  final themesNode = illustrations.nodes['themes'];
  if (themesNode is! YamlList) {
    stdout.writeln(yellow('Could not resolve themes for illustrations. Generating illustrations without support for themes'));
    return false;
  }

  final directories = {
    for (final node in themesNode.nodes)
      node: Directory(normalize('./assets/$pathNode/${node.value}')),
  };

  for (final entry in directories.entries) {
    final node = entry.key;
    final directory = entry.value;
    if (!directory.existsSync()) {
      stderr.writeln(node.span.message(red('Could not resolve ${directory.path} during assets generation. Is ${node.value} a folder relative to ./assets/$path ?'), color: red.escape));
      return false;
    }
  }

  final adhoc = parse(directory, package: package, ignored: directories.values.map((e) => e.path).toSet());
  final themes = directories.values.map((theme) => parse(theme, package: package, parent: adhoc));
  final skeleton = themes.isNotEmpty ? replace('ThemedIllustrations', themes.first) : null;

  final success = lint(themes);
  if (!success) {
    return false;
  }

  Generation(library).generate(skeleton, themes, adhoc);

  return true;
}
