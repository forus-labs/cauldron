import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:nitrogen/src/configuration/assets.dart';
import 'package:nitrogen/src/configuration/configuration_exception.dart';
import 'package:nitrogen/src/configuration/key.dart';
import 'package:yaml/yaml.dart';

/// Nitrogen's configuration.
final class Configuration {

  /// Parses the configuration from the project's pubspec.yaml.
  factory Configuration.parse(YamlMap pubspec) {
    final nitrogen = pubspec.nodes['nitrogen'].as<YamlMap>();
    final assets = Assets.parse(nitrogen?.nodes['assets']);
    return Configuration(
      package: parsePackage(pubspec.nodes['name'], nitrogen?.nodes['package']),
      prefix: parsePrefix(nitrogen?.nodes['prefix']),
      flutterExtension: parseFlutterExtension(nitrogen?.nodes['flutter-extension']),
      key: Key.parse(nitrogen?.nodes['asset-key']),
      assets: assets,
      flutterAssets: parseFlutterAssets(assets, pubspec.nodes['flutter'].as<YamlMap>()?.nodes['assets']),
    );
  }

  /// Parses the package name from the project's pubspec.yaml.
  @visibleForTesting
  static String? parsePackage(YamlNode? name, YamlNode? enabled) {
    switch ((name?.value, enabled?.value)) {
      case (final String name, true):
        return name;

      case (_, true):
        log.severe(name?.span.message("Unable to read package name from project's pubspec.yaml. See https://dart.dev/tools/pub/pubspec#name.") ?? 'Package name is not specified.');
        throw ConfigurationException();

      case (_, bool? _):
        return null;

      default:
        log.severe(enabled?.span.message('Unable to configure package name. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#package.'));
        throw ConfigurationException();
    }
  }

  /// Parses the class prefix from the nitrogen section in the project's pubspec.yaml.
  @visibleForTesting
  static String parsePrefix(YamlNode? node) {
    switch (node?.value) {
      case final String? prefix:
        return prefix ?? '';

      default:
        log.severe(node!.span.message('Unable to configure class prefix. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#prefix.'));
        throw ConfigurationException();
    }
  }

  /// Parses the flutter extension from the nitrogen section in the project's pubspec.yaml.
  @visibleForTesting
  static bool parseFlutterExtension(YamlNode? node) {
    switch (node?.value) {
      case final bool? extension:
        return extension ?? true;

      default:
        log.severe(node!.span.message('Unable to configure flutter extension. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#flutter-extension.'));
        throw ConfigurationException();
    }
  }

  /// Parses the flutter assets from the project's pubspec.yaml.
  @visibleForTesting
  static Set<String> parseFlutterAssets(Assets assets, YamlNode? node) {
    switch (node) {
      case _ when node == null || assets is NoAssets:
        return {};

      case final YamlList list:
        return { ...list };

      default:
        log.severe(node.span.message('Unable to parse flutter assets. See https://docs.flutter.dev/tools/pubspec#assets.'));
        throw ConfigurationException();
    }
  }

  /// The package name.
  final String? package;
  /// The class prefix.
  final String prefix;
  /// Whether to generate the flutter extension.
  final bool flutterExtension;
  /// The function for generating asset keys.
  final String Function(List<String>) key;
  /// The assets configuration.
  final Assets assets;
  /// The flutter assets.
  final Set<String> flutterAssets;

  /// Creates a [Configuration].
  Configuration({
    required this.package,
    required this.prefix,
    required this.flutterExtension,
    required this.key,
    required this.assets,
    required this.flutterAssets,
  });

}

// TODO: replace with Sugar 4.0.0
extension on Object? {

  T? as<T extends Object>() => this is T ? this! as T : null;

}
