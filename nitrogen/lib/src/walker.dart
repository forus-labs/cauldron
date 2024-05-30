import 'dart:collection';

import 'package:build/build.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen_types/nitrogen_types.dart';

/// A walker that recursively walks through a directory and converts all entities into [Entity]s.
final class Walker {

  final String? _package;
  final Set<String> _allowed;
  final String Function(List<String>) _keyer;

  /// Creates a [Walker] with the given target package, allowed asset paths, and function for generating asset keys.
  Walker(this._package, this._allowed, this._keyer);

  /// Walks through the [id]'s path, creating the necessary
  void walk(AssetDirectory directory, AssetId id) {
    final parent = '${id.pathSegments.sublist(0, id.pathSegments.length - 1).join('/')}/';
    if (!_allowed.any((p) => p == parent|| p == id.path)) {
      return;
    }

    for (final (index, segment) in id.pathSegments.indexed.take(id.pathSegments.length - 1).skip(1)) {
      directory.children[segment] ??= AssetDirectory(id.pathSegments.sublist(0, index + 1));
      directory = directory.children[segment]! as AssetDirectory;
    }

    final relativePath = id.pathSegments.join('/'); // id.uri.path returns the package name as well.
    directory.children[id.pathSegments.last] = AssetFile(
        id.pathSegments,
        switch (id.extension) {
          '.jpg' || '.jpeg' || '.png' => ImageAsset(_package, _keyer(id.pathSegments), relativePath),
          '.json' => LottieAsset(_package, _keyer(id.pathSegments), relativePath),
          '.svg' => SvgAsset(_package, _keyer(id.pathSegments), relativePath),
          _ => GenericAsset(_package, _keyer(id.pathSegments), relativePath),
        }
    );
  }

}
