import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'package:nitrogen/src/configuration/build_configuration.dart';
import 'package:nitrogen/src/configuration/configuration.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/asset_generator.dart';
import 'package:nitrogen/src/generators/theme_generator.dart';
import 'package:nitrogen/src/lints/reserved_keyword_lint.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';
import 'package:nitrogen/src/walker.dart';

/// Creates a [NitrogenBuilder].
Builder nitrogenBuilder(BuilderOptions options) {
  try {
    BuildConfiguration.lint(options.config);
    return NitrogenBuilder(BuildConfiguration.parse(options.config));

  } on NitrogenException {
    return EmptyBuilder();
  }
}

/// A Nitrogen builder.
class NitrogenBuilder extends Builder {

  static final _pubspec = Glob('pubspec.yaml');
  static final _assets = Glob('assets/**');

  final BuildConfiguration _configuration;

  /// Creates a [NitrogenBuilder].
  NitrogenBuilder(this._configuration);
  
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    try {
      final pubspec = loadYaml(await buildStep.readAsString(await buildStep.findAssets(_pubspec).first));
      final configuration = Configuration.merge(_configuration, pubspec);

      final walker = Walker(configuration.package, configuration.flutterAssets, configuration.key.call);

      final assets = AssetDirectory(['assets']);
      await for (final asset in buildStep.findAssets(_assets)) {
        walker.walk(assets, asset);
      }

      lintReservedKeyword(assets);

      final assetsOutput = AssetId(buildStep.inputId.package, configuration.assets.output);
      if (configuration.themes case (:final fallback, :final output)) {
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
          AssetId(buildStep.inputId.package, output),
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
      _configuration.assets.output,
      if (_configuration.themes != null)
        _configuration.themes!.output,
    ],
  };
  
}

/// A stub builder for when Nitrogen fails to build.
class EmptyBuilder extends Builder {
  @override
  void build(BuildStep buildStep) {}

  @override
  Map<String, List<String>> get buildExtensions => {};
}
