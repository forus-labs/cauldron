import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/generators/extensions/image_asset_extension.dart';
import 'package:nitrogen/src/generators/extensions/svg_asset_extension.dart';
import 'package:nitrogen/src/generators/libraries.dart';
import 'package:nitrogen/src/generators/extensions/lottie_asset_extension.dart';
import 'package:nitrogen_types/nitrogen_types.dart';

/// A generator for extensions on [Asset]s th
class ExtensionGenerator {

  final int? _image;
  final int? _lottie;
  final int? _svg;

  /// Creates an [ExtensionGenerator].
  ExtensionGenerator({required int? image, required int? lottie, required int? svg}) : _image = image, _lottie = lottie, _svg = svg;

  /// Generates extensions for interfacing between assets and 3rd party libraries.
  void generate(File target) {
    final library = LibraryBuilder()
      ..directives.add(Libraries.importNitrogenTypes)
      ..body.add(Libraries.header);

    switch (_image) {
      case 1: library..directives.addAll(Image1.imports)..body.add(Image1.extension);
    }

    switch (_lottie) {
      case 1: library..directives.addAll(Lottie1.imports)..body.add(Lottie1.extension);
    }

    switch (_svg) {
      case 1: library..directives.addAll(Svg1.imports)..body.add(Svg1.extension);
    }

    target..createSync(recursive: true)..writeAsStringSync(library.build().format());
  }

}
