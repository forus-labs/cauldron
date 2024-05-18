import 'package:build/build.dart';
import 'package:path/path.dart';
import 'package:sugar/sugar.dart';
import 'package:yaml/yaml.dart';

// ignore_for_file: avoid_dynamic_calls

/// The configuration.
final class Configuration {

  String? _package;
  String _prefix;
  Key _key;
  Generation _generation;
  Set<String> _assets;

  Configuration._(): _package = null, _prefix = '', _key = Key.file, _generation = StandardGeneration(), _assets = {};

  /// Creates a configuration from the [pubspec] if valid.
  static Configuration? parse(dynamic pubspec) {
    final configuration = Configuration._();

    switch ((pubspec?['name'], pubspec?['nitrogen']?['use-package'])) {
      case (final String name, final bool enabled) when enabled:
        configuration._package = name;

      case (_, final bool enabled) when enabled:
        log.severe("Unable to read package name from project's pubspec.yaml. See https://dart.dev/tools/pub/pubspec#name.");
        return null;

      case (_, bool? _):
        configuration._package = null;

      case (_, final invalid):
        log.severe('Expected nitrogen.use-package to be a boolean, but was: $invalid');
        return null;
    }

    switch (pubspec?['nitrogen']?['prefix']) {
      case final String? prefix:
        configuration._prefix = prefix ?? '';

      case final invalid:
        log.severe('Expected nitrogen.prefix to be a string, but was: $invalid');
        return null;
    }

    switch (pubspec?['nitrogen']?['asset-key']) {
      case 'file' || null:
        configuration._key = Key.file;

      case 'grpc-enum':
        configuration._key = Key.grpcEnum;

      case final invalid:
        log.severe('Expected nitrogen.asset-key to be "file" or "grpc-enum", but was: $invalid');
        return null;
    }

    if (Generation.parse(pubspec) case final generation?) {
      configuration._generation = generation;

    } else {
      return null;
    }

    switch ((configuration._generation, pubspec['flutter']['assets'])) {
      case (NoGeneration _, _):
        break;

      case (_, final YamlList list):
        configuration._assets = { ...list };

      case (_, _):
        log.severe('Unable to read flutter.assets. See https://docs.flutter.dev/tools/pubspec#assets.');
        return null;
    }

    return configuration;
  }


  /// The package name.
  String? get package => _package;

  /// The prefix for class names.
  String get prefix => _prefix;

  /// The function for creating asset keys.
  Key get key => _key;

  /// The generation type.
  Generation get generation => _generation;

  /// The paths to assets.
  Set<String> get assets => _assets;
}


/// Functions for creating asset keys.
enum Key {

  /// Creates a key that is composed of a folder and file name in screaming case, i.e. 'FOLDER_FILE'.
  grpcEnum(_grpcEnum),

  /// Creates a key that uses the file name, i.e. `myFile`.
  file(_file);


  static String _grpcEnum(List<String> path) => path.sublist(path.length - 2).map(basenameWithoutExtension).join('-').toScreamingCase();

  static String _file(List<String> path) => basenameWithoutExtension(path.last);


  final String Function(List<String>) _name;

  const Key(this._name);

  /// Creates a key from the [path].
  String call(List<String> path) => _name(path);

}


/// The generation type.
sealed class Generation {

  /// Parses the nitrogen.generation configuration.
  static Generation? parse(dynamic pubspec) {
    switch (pubspec?['nitrogen']?['asset-generation']) {
      case 'none':
        return NoGeneration();

      case 'basic':
        return BasicGeneration();

      case 'standard' || null:
        return StandardGeneration();

      case final YamlMap generation when generation['theme']?['fallback'] is String && generation['theme']?['path'] is String:
        return ThemeGeneration(fallback: generation['theme']?['fallback'], path: generation['theme']?['path']);

      case _:
        log.severe('Unable to read nitrogen.asset-generation. See [TODO: add documentation].');
        return null;
    }
  }

}

/// Represents no generation.
final class NoGeneration extends Generation {}

/// Represents basic generation.
final class BasicGeneration extends Generation {}

/// Represents standard generation.
final class StandardGeneration extends Generation {}

/// Represents theme generation.
final class ThemeGeneration extends Generation {
  /// The fallback theme.
  final String fallback;
  /// The path to the themes folder, relative to the package root.
  final String path;

  /// Creates a [ThemeGeneration].
  ThemeGeneration({required this.fallback, required this.path});
}
