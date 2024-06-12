import 'package:build/build.dart';
import 'package:meta/meta.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';
import 'package:nitrogen/src/configuration/key.dart';
import 'package:yaml/yaml.dart';

/// Nitrogen's configuration.
final class Configuration {

  /// The Nitrogen section's valid keys.
  static const keys = { 'package', 'prefix', 'key', 'themes' };

  /// Lints the pubspec.
  static void lint(YamlMap? pubspec) {
    final nitrogen = pubspec?.nodes['nitrogen'].as<YamlMap>();

    for (final key in {...?nitrogen?.keys }..removeAll(keys)) {
      log.warning(nitrogen?.nodes[key]!.span.message('Unknown key, "$key", in pubspec.yaml\'s nitrogen section. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#configuration for valid configuration options.'));
    }

    final themes = nitrogen?.nodes['themes'].as<YamlMap>();
    for (final key in {...?themes?.keys }..removeAll({ 'fallback' })) {
      log.warning(themes?.nodes[key]!.span.message('Unknown key, "$key", in pubspec.yaml\'s nitrogen section. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#themes for valid configuration options.'));
    }
  }


  /// Parses the configuration from the project's pubspec.yaml.
  factory Configuration.parse(YamlMap pubspec) {
    final nitrogen = pubspec.nodes['nitrogen'].as<YamlMap>();
    return Configuration(
      package: parsePackage(pubspec.nodes['name'], nitrogen?.nodes['package']),
      prefix: parsePrefix(nitrogen?.nodes['prefix']),
      key: Key.parse(nitrogen?.nodes['key']),
      fallbackTheme: parseFallbackTheme(nitrogen?.nodes['themes']),
      flutterAssets: parseFlutterAssets(pubspec.nodes['flutter'].as<YamlMap>()?.nodes['assets']),
    );
  }

  /// Parses the package name from the project's pubspec.yaml.
  @visibleForTesting
  static String? parsePackage(YamlNode? name, YamlNode? enabled) {
    switch ((name?.value, enabled?.value)) {
      case (final String name, true):
        return name;

      case (_, true):
        log.severe(name?.span.message('Unable to read package name in pubspec.yaml. See https://dart.dev/tools/pub/pubspec#name.') ?? 'Package name is not specified.');
        throw NitrogenException();

      case (_, bool? _):
        return null;

      default:
        log.severe(enabled?.span.message('Unable to read package name. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#package.'));
        throw NitrogenException();
    }
  }

  /// Parses the class prefix from the nitrogen section in the project's pubspec.yaml.
  @visibleForTesting
  static String parsePrefix(YamlNode? node) {
    switch (node?.value) {
      case final String? prefix:
        return prefix ?? '';

      default:
        log.severe(node!.span.message('Unable to read prefix. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#prefix.'));
        throw NitrogenException();
    }
  }

  /// Parses the path to the fallback theme.
  @visibleForTesting
  static String? parseFallbackTheme(YamlNode? node) {
    switch (node?.value) {
      case null:
        return null;

      case { 'fallback': final String fallback }:
        return fallback;

      case _:
        log.severe(node!.span.message('Unable to read themes. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#themes.'));
        throw NitrogenException();
    }
  }

  /// Parses the flutter assets from the project's pubspec.yaml.
  @visibleForTesting
  static Set<String> parseFlutterAssets(YamlNode? node) {
    switch (node) {
      case null:
        return {};

      case final YamlList list:
        return { ...list };

      default:
        log.severe(node.span.message('Unable to read flutter assets. See https://docs.flutter.dev/tools/pubspec#assets.'));
        throw NitrogenException();
    }
  }

  /// The package name.
  final String? package;

  /// The class prefix.
  final String prefix;

  /// The function for generating asset keys.
  final String Function(List<String>) key;

  /// The path to the fallback theme.
  final String? fallbackTheme;

  /// The flutter assets.
  final Set<String> flutterAssets;

  /// Creates a [Configuration].
  Configuration({
    required this.package,
    required this.prefix,
    required this.key,
    required this.fallbackTheme,
    required this.flutterAssets,
  });

}

// TODO: replace with Sugar 4.0.0
extension on Object? {

  T? as<T extends Object>() => this is T ? this! as T : null;

}
