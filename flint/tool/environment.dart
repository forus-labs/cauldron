import 'dart:io';

import 'package:yaml/yaml.dart';

final Uri remote = Uri.parse('https://dart.dev/tools/linter-rules/all');

final String projectDirectory = (Platform.script.path.split('/')..removeLast()..removeLast()).join('/');

final String version = loadFile(fromProject('pubspec.yaml'))['version'];

final File temp = fromProject('.temp/all_rules.yaml');

final File options = fromProject('lib/analysis_options.dart.yaml');

final YamlMap rules = loadFile(options);


YamlMap loadFile(File file) => loadYamlDocument(file.readAsStringSync()).contents as YamlMap;

File fromProject(String path) => File.fromUri(Uri.parse('$projectDirectory/$path'));
