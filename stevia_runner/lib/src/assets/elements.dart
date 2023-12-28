import 'dart:collection';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sugar/sugar.dart';

/// Recursively parses the given [directory] and produces a corresponding [Folder].
Folder parse(Directory directory, {required String? package, Folder? parent, Set<String> ignored = const {}}) {
  final identifier = parent == null ? '' : basenameWithoutExtension(directory.path);
  final folder = Folder(_name(parent, identifier), _key(parent, identifier), identifier.toCamelCase(), directory.path.replaceAll(r'\', '/'), package);

  for (final item in directory.listSync()) {
    final identifier = basenameWithoutExtension(item.path);
    if (ignored.contains(item.path) || identifier.startsWith('.')) { // Ignore hidden files and folders
      continue;
    }

    switch (item) {
      case Directory _:
        final child = parse(item, package: package, parent: folder);
        folder.folders[child.identifier] = child;
      case File _:
        final asset = Asset(_key(folder, identifier), identifier.toCamelCase(), item.path.replaceAll(r'\', '/'), package);
        folder.assets[asset.identifier] = asset;
    }
  }

  return folder;
}

String _key(Folder? parent, String key) {
  key = key.toScreamingCase();
  return switch (parent) {
    null => key,
    _ when parent.key.isEmpty => key,
    _ => '${parent.key}_$key',
  };
}

String _name(Folder? parent, String identifier) {
  identifier = identifier.toPascalCase();
  return switch (parent) {
    null => identifier,
    _ when parent.key.isEmpty => identifier,
    _ => '${parent.name}$identifier',
  };
}

/// An abstract representation of a resource in a project.
sealed class Element {
  /// A key in screaming case that identifies this [Element]s.
  final String key;
  /// This [Element]'s identifier in camel case.
  final String identifier;
  /// The path to this [Element].
  final String path;
  /// The package for this [Element].
  final String? package;

  /// Creates an [Element] with the given parameters.
  const Element(this.key, this.identifier, this.path, this.package);
}

/// Represents a folder in a project.
class Folder extends Element {
  /// This folder's name in pascal case.
  final String name;
  /// The nested folders in this folder.
  final SplayTreeMap<String, Folder> folders = SplayTreeMap();
  /// The assets in this folder.
  final SplayTreeMap<String, Asset> assets = SplayTreeMap();

  /// Creates a folder with the given parameters.
  Folder(this.name, String key, String identifier, String path, String? package) : super(key, identifier, path, package);
}

/// Represents a resource in a project.
class Asset extends Element {
  /// This [Asset]'s kind.
  final Kind kind;

  /// Creates a [Asset] with the given key, name and path.
  factory Asset(String key, String name, String path, String? package) => switch (path.split('.').last) {
    'json' || 'zip' => Asset._(Kind.lottie, key, name, path, package),
    'svg' => Asset._(Kind.svg, key, name, path, package),
    'jpg' || 'jpeg' || 'png' => Asset._(Kind.image, key, name, path, package),
    _ => Asset._(Kind.others, key, name, path, package),
  };

  const Asset._(this.kind, String key, String name, String path, String? package): super(key, name, path, package);
}

/// An [Asset]'s kind.
enum Kind {
  /// A lottie [Asset].
  lottie,
  /// A SVG [Asset].
  svg,
  /// A JPG/PNG  [Asset].
  image,
  /// An unknown type of [Asset].
  others,
}
