import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'package:stevia_runner/src/ansi.dart';
import 'package:stevia_runner/src/assets/icon/build.dart' as icons;
import 'package:stevia_runner/src/assets/illustrations/build.dart' as illustrations;
import 'package:stevia_runner/src/configurations.dart';

const _header = Code('''


// GENERATED CODE - DO NOT MODIFY BY HAND
// 
// **************************************************************************
// stevia_runner
// **************************************************************************
//
// ignore_for_file: type=lint

''');

/// A build step that generates Dart code accessing for assets.
void build(File file) {
  final configuration = pubspec(file);
  if (configuration == null) {
    return;
  }

  final stevia = configuration['stevia'] as YamlMap?;
  final section = stevia?['assets'] as YamlMap?;
  if (section == null) {
    stdout.writeln('Assets generation is not configured, skipping assets generation');
    return;
  }

  final target = section.nodes['target'];
  final path = target?.value;
  if (path is !String) {
    stderr.writeln((target ?? section).span.message(red('Could not resolve target file for assets generation. Is it a file relative to ./lib ?'), color: red.escape));
    return;
  }

  final pack = section.nodes['package'];
  final flag = pack?.value;
  if (flag is !bool) {
    stderr.writeln((pack ?? section).span.message(red('Could not resolve "package" flag for assets generation. Is "package" a boolean?'), color: red.escape));
    return;
  }

  final package = flag ? configuration['name'] : null;

  final library = LibraryBuilder()
    ..directives.add(Directive.import('package:stevia/widgets.dart'))
    ..body.add(_header);

  var success = icons.build(section, package, library);
  success &= illustrations.build(section, package, library);
  
  if (!success) {
    return;
  }

  final code = library.build().accept(DartEmitter(orderDirectives: true, useNullSafetySyntax: true)).toString();
  if (code.isNotEmpty) {
    final file = path.endsWith('.dart') ? path : '$path.dart';
    File(normalize('./lib/$file'))..createSync(recursive: true)..writeAsStringSync(DartFormatter(pageWidth: 160).format(code));
  }
}
