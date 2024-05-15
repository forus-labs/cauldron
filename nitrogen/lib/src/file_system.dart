import 'dart:collection';

import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:path/path.dart';

/// An entity in the file system.
sealed class Entity {
  /// The path to this entity, relative to the project directory.
  final List<String> path;

  /// Creates an entity.
  Entity(this.path): assert(path.isNotEmpty, 'Path to an entity cannot be empty.');

  /// The name, without an extension.
  String get rawName;
}

/// A directory that contains assets.
final class AssetDirectory extends Entity {
  /// The children in this directory.
  final SplayTreeMap<String, Entity> children = SplayTreeMap();

  /// Creates an [AssetDirectory].
  AssetDirectory(super.path): assert(path.last == basenameWithoutExtension(path.last), 'Path is not a directory.');

  @override
  String get rawName => path.last;
}

/// An asset.
final class AssetFile extends Entity {
  /// The asset.
  final Asset asset;

  /// Creates an [AssetFile].
  AssetFile(super.path, this.asset): assert(path.last != basenameWithoutExtension(path.last), 'Path is not a file.');

  @override
  String get rawName => basenameWithoutExtension(path.last);
}
