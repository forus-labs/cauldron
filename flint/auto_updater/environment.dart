import 'dart:io';

import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';


String _path;

String get path => _path ??= (Platform.script.path.split('/')..removeLast()..removeLast()).join('/');


String _version;

String get version => _version ??= (loadYamlDocument(File.fromUri(Uri.parse('$path/pubspec.yaml')).readAsStringSync()).contents as YamlMap)['version'];


RegExp digit = RegExp(r'/d');

RegExp versionScheme = RegExp(r'(\.\d+){3}(-dev\.\d+)?');


YamlMap loadYamlFile(String relativePath) => loadYamlDocument(File.fromUri(Uri.parse('$path/$relativePath')).readAsStringSync()).contents;


const List<String> folders = [
  'dart/dev',
  'dart/stable',
  'flutter/dev',
  'flutter/stable',
];


Map<Uri, Environment> environments = <Uri, Environment>{};

class Environment {

  Environment parent;
  String inclusion;
  Set<String> all;
  Set<String> ignore;
  Set<String> rules;
  bool versioned;


  Environment(this.parent, this.inclusion, this.ignore, this.rules, {@required this.versioned}): all = <String>{
    ...?parent?.all,
    ...ignore,
    ...rules,
  };

}