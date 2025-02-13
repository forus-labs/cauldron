import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'package:nitrogen/src/configuration/build_configuration.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';

/// Nitrogen's configuration.
final class Configuration {
  /// Parses the configuration from the project's pubspec.yaml.
  factory Configuration.merge(BuildConfiguration configuration, YamlMap pubspec) => Configuration(
        package: parsePackage(pubspec.nodes['name'], enabled: configuration.package),
        docs: configuration.docs,
        prefix: configuration.prefix,
        key: configuration.key,
        assets: configuration.assets,
        themes: configuration.themes,
        flutterAssets: parseFlutterAssets(pubspec.nodes['flutter'].as<YamlMap>()?.nodes['assets']),
      );

  /// Parses the package name from the project's pubspec.yaml.
  @visibleForTesting
  static String? parsePackage(YamlNode? name, {required bool enabled}) {
    switch ((name?.value, enabled)) {
      case (final String name, true):
        return name;

      case (_, true):
        log.severe(name?.span
                .message('Unable to read package name in pubspec.yaml. See https://dart.dev/tools/pub/pubspec#name.') ??
            'Package name is not specified.');
        throw NitrogenException();

      case (_, bool? _):
        return null;
    }
  }

  /// Parses the flutter assets from the project's pubspec.yaml.
  @visibleForTesting
  static Set<String> parseFlutterAssets(YamlNode? node) {
    switch (node) {
      case null:
        return {};

      case final YamlList list:
        return {...list};

      default:
        log.severe(
            node.span.message('Unable to read flutter assets. See https://docs.flutter.dev/tools/pubspec#assets.'));
        throw NitrogenException();
    }
  }

  /// The package name.
  final String? package;

  /// True if dart docs should be generated.
  final bool docs;

  /// The class prefix.
  final String prefix;

  /// The function for generating asset keys.
  final String Function(List<String>) key;

  /// The output location of the generated assets.
  final ({
    String output,
  }) assets;

  /// The fallback theme and output location of the generated themes.
  final ({String fallback, String output})? themes;

  /// The flutter assets.
  final Set<String> flutterAssets;

  /// Creates a [Configuration].
  Configuration({
    required this.package,
    required this.docs,
    required this.prefix,
    required this.key,
    required this.assets,
    required this.themes,
    required this.flutterAssets,
  });
}

// TODO: replace with Sugar 4.0.0
extension on Object? {
  T? as<T extends Object>() => this is T ? this! as T : null;
}
