import 'dart:io';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:path/path.dart';

/// A parser that converts directories into an intermediate representation.
final class Parser {

  final String? _package;
  final Set<String> _ignored;
  final String Function(String, String) _keyer;

  /// Creates a [Parser] for the given package, with the given ignored folders/files and function for generating asset
  /// keys.
  Parser(this._package, this._ignored, this._keyer);

  /// Recursively creates a folder from the given [directory], using the [prefix] for generating asset keys.
  Folder parse(Directory directory, [String prefix = '']) {
    final name = basename(directory.path);
    final folder = Folder(name);

    for (final entity in directory.listSync()) {
      switch (entity) {
        case _ when _ignored.contains(entity.path) || basenameWithoutExtension(entity.path).startsWith('.'):
          continue;

        case final Directory directory:
          final child = parse(directory, _keyer(prefix, name));
          folder.children[child.name] = child;

        case final File file:
          final child = _parseAsset(file, _keyer(prefix, name));
          folder.children[child.name] = child;
      }
    }

    return folder;
  }

  /// Creates an asset file from the given [file], using the [prefix] for generating an asset key.
  AssetFile _parseAsset(File file, String prefix) {
    final name = basename(file.path);
    final key = _keyer(prefix, basenameWithoutExtension(file.path));
    final path = file.path.replaceAll(r'\', '/');
    return AssetFile(
      name,
        switch (file.path.split('.').last) {
          'jpg' || 'jpeg' || 'png' => ImageAsset(_package, key, path),
          'json' || 'zip' => LottieAsset(_package, key, path),
          'svg' => SvgAsset(_package, key, path),
          _ => UnknownAsset(_package, key, path),
        }
    );
  }

}
