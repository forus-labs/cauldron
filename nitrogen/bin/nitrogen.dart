import 'dart:io';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/assets/standard_generator.dart';
import 'package:nitrogen/src/generators/assets/theme_generator.dart';
import 'package:nitrogen/src/generators/extensions/extension_generator.dart';
import 'package:nitrogen/src/walker.dart';
import 'package:path/path.dart';
import 'package:sugar/sugar.dart';

/// TODO: replace with real implementation
void main() {
  // const assets = {
  //   'assets/icons/application/',
  //   'assets/icons/premium/background/',
  //   'assets/icons/premium/logo/',
  //   'assets/icons/premium/banner/',
  //   'assets/motion/banner/',
  //   'assets/motion/light/',
  //   'assets/motion/light/f/',
  //   'assets/motion/dark/',
  //   'assets/motion/dark/banner/',
  //   'assets/motion/dark/f/',
  //   'assets/motion/logo/',
  // };
  //
  // final walker = Walker(
  //   'essential_assets',
  //   assets,
  //   (paths) => paths.sublist(paths.length - 2).map(basenameWithoutExtension).join('-').toScreamingCase(),
  // );
  // final directory = walker.walk(Directory(normalize('./assets')));
  // final themes = directory.children['motion']! as AssetDirectory;
  // final fallback = themes.children['light']! as AssetDirectory;
  // StandardGenerator(directory, { } ).generate(File(normalize('./lib/assets.nitrogen.dart')));
  // // ThemeGenerator(themes, fallback).generate(File(normalize('./lib/themed_assets.nitrogen.dart')));
  // ExtensionGenerator(image: 1, lottie: 1, svg: 1).generate(File(normalize('./lib/extensions.nitrogen.dart')));
}
