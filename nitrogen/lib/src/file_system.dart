import 'dart:collection';

import 'package:nitrogen_types/nitrogen_types.dart';

/// A vertex in a parse tree.
sealed class FileSystemObject {
  /// The name, i.e. `my_folder` or `my-file.svg`.
  final String name;

  FileSystemObject(this.name);
}

/// A folder.
final class Folder extends FileSystemObject {
  /// The children.
  final SplayTreeMap<String, FileSystemObject> children = SplayTreeMap();

  /// Creates a [Folder].
  Folder(super.name);
}

/// An asset.
final class AssetFile extends FileSystemObject {
  /// An asset.
  final Asset asset;

  /// Creates a [AssetFile].
  AssetFile(super.name, this.asset);
}
