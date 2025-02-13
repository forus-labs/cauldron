import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:nitrogen/src/configuration/key.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';

/// Nitrogen's build.yaml configuration.
final class BuildConfiguration {
  /// The Nitrogen configuration's valid keys.
  static const keys = {'package', 'docs', 'prefix', 'key', 'assets', 'themes'};

  /// Lints the pubspec.
  static void lint(Map<dynamic, dynamic> configuration) {
    for (final key in {...configuration.keys}..removeAll(keys)) {
      log.warning(
          'Unknown key, "$key", in build.yaml\'s nitrogen configuration. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#configuration for valid configuration options.');
    }

    final assets = configuration['assets'] as Map;
    for (final key in {...assets.keys}..removeAll({'output'})) {
      log.warning(
          'Unknown key, "$key", in build.yaml\'s nitrogen assets configuration. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#assets for valid configuration options.');
    }

    final themes = configuration['themes'] as Map;
    for (final key in {...themes.keys}..removeAll({'fallback', 'output'})) {
      log.warning(
          'Unknown key, "$key", in build.yaml\'s nitrogen themes configuration. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#themes for valid configuration options.');
    }
  }

  /// Parses the assets configuration.
  @visibleForTesting
  static ({
    String output,
  }) parseAssets(Map<dynamic, dynamic> configuration) {
    final copy = <dynamic, dynamic>{'output': 'lib/src/assets.nitrogen.dart'}..addAll(configuration);
    switch (copy) {
      case {'output': final String output}:
        return (output: output);

      default:
        log.severe(
            "Unable to read assets configuration in build.yaml's nitrogen configuration. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#assets.");
        throw NitrogenException();
    }
  }

  /// Parses the themes configuration.
  @visibleForTesting
  static ({String fallback, String output})? parseThemes(Map<dynamic, dynamic> configuration) {
    final copy = <dynamic, dynamic>{'output': 'lib/src/asset_themes.nitrogen.dart'}..addAll(configuration);
    switch (copy) {
      case {'fallback': final String fallback, 'output': final String output}:
        return (fallback: fallback, output: output);

      case {'output': String _}:
        return null;

      default:
        log.severe(
            "Unable to read themes configuration in build.yaml's nitrogen configuration. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#themes.");
        throw NitrogenException();
    }
  }

  /// Whether to generate assets for a package.
  final bool package;

  /// Whether to generate documentation.
  final bool docs;

  /// The prefix for generated classes.
  final String prefix;

  /// The function for generating asset keys.
  final String Function(List<String>) key;

  /// The output location of the generated assets.
  final ({
    String output,
  }) assets;

  /// The fallback theme and output location of the generated themes.
  final ({String fallback, String output})? themes;

  /// Parses the build configuration.
  factory BuildConfiguration.parse(Map<dynamic, dynamic> configuration) => BuildConfiguration(
        package: configuration['package'],
        docs: configuration['docs'] ?? true,
        prefix: configuration['prefix'],
        key: Key.parse(configuration['key']),
        assets: parseAssets(configuration['assets']),
        themes: parseThemes(configuration['themes']),
      );

  /// Creates a [BuildConfiguration].
  BuildConfiguration({
    required this.package,
    required this.docs,
    required this.prefix,
    required this.key,
    required this.assets,
    required this.themes,
  });
}
