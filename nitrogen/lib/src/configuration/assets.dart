import 'package:build/build.dart';
import 'package:nitrogen/src/configuration/configuration_exception.dart';
import 'package:yaml/yaml.dart';

/// The generation type.
sealed class Assets {

  /// Parses the `assets` node if valid.
  static Assets parse(YamlNode? generation) {
    switch (generation?.value) {
      case 'none':
        return NoAssets();

      case 'basic':
        return BasicAssets();

      case 'standard' || null:
        return StandardAssets();

      case { 'theme': { 'fallback': final String fallback, 'path': final String path } }:
        return ThemeAssets(fallback: fallback, path: path);

      case _:
        log.severe(generation!.span.message('Unable to configure asset generation. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#assets.'));
        throw ConfigurationException();
    }
  }

}

/// Represents no generation.
final class NoAssets extends Assets {}

/// Represents basic generation.
final class BasicAssets extends Assets {}

/// Represents standard generation.
final class StandardAssets extends Assets {}

/// Represents theme generation.
final class ThemeAssets extends Assets {
  /// The fallback theme.
  final String fallback;
  /// The path to the themes folder, relative to the package root.
  final String path;

  /// Creates a [ThemeAssets].
  ThemeAssets({required this.fallback, required this.path});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeAssets && runtimeType == other.runtimeType && fallback == other.fallback && path == other.path;

  @override
  int get hashCode => fallback.hashCode ^ path.hashCode;

  @override
  String toString() => 'ThemeAssets{fallback: $fallback, path: $path}';
}
