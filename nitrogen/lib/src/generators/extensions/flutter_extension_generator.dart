import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/generators/extensions/image_asset_extension.dart';
import 'package:nitrogen/src/generators/libraries.dart';
import 'package:nitrogen_types/nitrogen_types.dart';

/// A generator for Flutter extensions on [Asset]s.
class FlutterExtensionGenerator {

  /// Generates extensions for interfacing between assets and Flutter.
  String generate() {
    final library = LibraryBuilder()
      ..directives.add(Libraries.importNitrogenTypes)
      ..directives.addAll(Image.imports)
      ..body.add(Libraries.header())
      ..body.add(Image.extension);

    return library.build().format();
  }

}
