import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:nitrogen/src/configuration/assets.dart';
import 'package:nitrogen/src/configuration/configuration.dart';
import 'package:nitrogen/src/configuration/configuration_exception.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/assets/basic_generator.dart';
import 'package:nitrogen/src/generators/assets/standard_generator.dart';
import 'package:nitrogen/src/generators/assets/theme_generator.dart';
import 'package:nitrogen/src/generators/extensions/flutter_extension_generator.dart';
import 'package:nitrogen/src/walker.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

/// Creates a [NitrogenBuilder].
Builder nitrogenBuilder(BuilderOptions options) => NitrogenBuilder();

/// A Nitrogen builder.
class NitrogenBuilder extends Builder {

  static final _pubspec = Glob('pubspec.yaml');
  static final _assets = Glob('assets/**');
  
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    try {
      final pubspec = loadYaml(await buildStep.readAsString(await buildStep.findAssets(_pubspec).first));
      final configuration = Configuration.parse(pubspec);

      final walker = Walker(configuration.package, configuration.flutterAssets, configuration.key.call);

      final assets = AssetDirectory(['assets']);
      await for (final asset in buildStep.findAssets(_assets)) {
        walker.walk(assets, asset);
      }

      final assetsOutput = AssetId(buildStep.inputId.package, join('lib', 'src', 'assets.nitrogen.dart'));
      switch (configuration.assets) {
        case NoAssets _:
          return;

        case BasicAssets _:
          await buildStep.writeAsString(
            assetsOutput,
            BasicGenerator(configuration.prefix, assets).generate(),
          );

        case StandardAssets _:
          await buildStep.writeAsString(
            assetsOutput,
            StandardGenerator(configuration.prefix, assets, {}).generate(),
          );

        case ThemeAssets(:final path, :final fallback):
          var themes = assets;
          for (final segment in split(path).skip(1)) {
            themes = themes.children[segment]! as AssetDirectory;
          }

          final fallbackTheme = themes.children[fallback]! as AssetDirectory;

          await buildStep.writeAsString(
            assetsOutput,
            StandardGenerator(configuration.prefix, assets, { themes }).generate(),
          );

          await buildStep.writeAsString(
            AssetId(buildStep.inputId.package, join('lib', 'src', 'asset_themes.nitrogen.dart')),
            ThemeGenerator(configuration.prefix, themes, fallbackTheme).generate(),
          );
      }

      if (configuration.flutterExtension) {
        await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, join('lib', 'src', 'flutter_extension.nitrogen.dart')),
          FlutterExtensionGenerator().generate(),
        );
      }

    } on ConfigurationException {
      return;
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    r'$package$': [
      'lib/src/assets.nitrogen.dart',
      'lib/src/asset_themes.nitrogen.dart',
      'lib/src/flutter_extension.nitrogen.dart'
    ],
  };
  
}
