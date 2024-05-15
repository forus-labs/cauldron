import 'dart:io';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:path/path.dart';

/// A walker that recursively walks through a directory and converts all entities into [Entity]s.
final class Walker {

  final String? _package;
  final Set<String> _allowed;
  final String Function(List<String>) _keyer;

  /// Creates a [Walker] with the given target package, allowed asset paths, and function for generating asset keys.
  Walker(this._package, this._allowed, this._keyer);

  /// Recursively creates an [AssetDirectory] from [current]. It assumes that [current]'s path is allowed.
  AssetDirectory walk(Directory current) {
    final directory = AssetDirectory(split(current.path));
    for (final entity in current.listSync()) {
      switch (entity) {
        // This works because asset directories require a trailing slash, https://github.com/flutter/flutter/issues/134794.
        case final Directory subdirectory when _allowed.any((p) => p.startsWith(subdirectory.uri.path)):
          final child = walk(subdirectory);
          directory.children[child.path.last] = child;

        case final File file when _allowed.any((p) => p == file.parent.uri.path || p == file.uri.path):
          final child = _file(file);
          directory.children[child.path.last] = child;
      }
    }

    return directory;
  }

  AssetFile _file(File file) {
    final path = split(file.path);
    return AssetFile(
        path,
        switch (extension(file.path)) {
          '.jpg' || '.jpeg' || '.png' => ImageAsset(_package, _keyer(path), file.uri.path),
          '.json' => LottieAsset(_package, _keyer(path), file.uri.path),
          '.svg' => SvgAsset(_package, _keyer(path), file.uri.path),
          _ => UnknownAsset(_package, _keyer(path), file.uri.path),
        }
    );
  }

}
