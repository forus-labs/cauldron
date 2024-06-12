import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:nitrogen/src/configuration/configuration.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/asset_generator.dart';
import 'package:nitrogen/src/generators/theme_generator.dart';
import 'package:nitrogen/src/lints/reserved_keyword_lint.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';
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

      Configuration.lint(pubspec);
      final configuration = Configuration.parse(pubspec);

      final walker = Walker(configuration.package, configuration.flutterAssets, configuration.key.call);

      final assets = AssetDirectory(['assets']);
      await for (final asset in buildStep.findAssets(_assets)) {
        walker.walk(assets, asset);
      }

      lintReservedKeyword(assets);

      final assetsOutput = AssetId(buildStep.inputId.package, join('lib', 'src', 'assets.nitrogen.dart'));
      if (configuration.fallbackTheme case final fallback?) {
        var themes = assets;
        var fallbackTheme = assets;
        for (final segment in split(fallback).skip(1)) {
          themes = fallbackTheme;
          fallbackTheme = fallbackTheme.children[segment]! as AssetDirectory;
        }

        await buildStep.writeAsString(
          assetsOutput,
          AssetGenerator(configuration.prefix, assets, { themes }).generate(),
        );

        await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, join('lib', 'src', 'asset_themes.nitrogen.dart')),
          ThemeGenerator(configuration.prefix, themes, fallbackTheme).generate(),
        );

      } else {
        await buildStep.writeAsString(
          assetsOutput,
          AssetGenerator(configuration.prefix, assets, {}).generate(),
        );
      }

    } on NitrogenException {
      return;
    }
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    r'$package$': [
      'lib/src/assets.nitrogen.dart',
      'lib/src/asset_themes.nitrogen.dart',
    ],
  };
  
}
