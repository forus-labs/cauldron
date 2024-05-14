import 'dart:io';

import 'package:nitrogen/src/generators/assets/basic_generator.dart';
import 'package:nitrogen/src/parser.dart';
import 'package:path/path.dart';
import 'package:sugar/sugar.dart';

/// TODO: replace with real implemenntation
void main() {
  final parser = Parser('essential_assets', {}, (prefix, suffix) => '${prefix.split('_').last}\_$suffix'.toScreamingCase());
  final folder = parser.parse(Directory(normalize('./assets')));
  BasicGenerator().generate(folder, File(normalize('./lib/sample.dart')));
}