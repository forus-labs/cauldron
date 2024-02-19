import 'dart:io';

import 'package:stevia_runner/src/ansi.dart';
import 'package:stevia_runner/src/assets/elements.dart';

/// Lints the parsed themes before code generation for illustrations.
bool lint(Iterable<Folder> themes) {
  if (themes.length < 2) {
    return true;
  }

  final expected = themes.first;

  var success = true;
  for (final theme in themes.skip(1)) {
    success &= expected.equals(theme);
  }

  return success;
}

extension _FolderEquality on Folder {

  bool equals(Folder other) {
    var success = contentsEqual(other);
    success &= other.contentsEqual(this);

    for (final folder in folders.values) {
      final child = other.folders[folder.identifier];
      success &= child != null && folder.equals(child);
    }

    for (final asset in assets.values) {
      final child = other.assets[asset.identifier];
      success &= child != null && asset.equals(child);
    }

    return success;
  }

  bool contentsEqual(Folder other) {
    var success = folders.containsAll(path, other.folders);
    return success &= assets.containsAll(path, other.assets);
  }

}

extension _AssetEquality on Asset {
  bool equals(Asset other) {
    if (kind != other.kind) {
      stderr.writeln(red('"$path" and "${other.path}" have the same names but different extensions'));
      return false;

    } else {
      return true;
    }
  }
}

extension _ElementEquality<T extends Element> on Map<String, T> {
  bool containsAll(String path, Map<String, T> other) {
    var success = true;
    for (final identifier in other.keys.toSet().difference(keys.toSet())) {
      stderr.writeln(red('"$path" does not contain a equivalence of "${other[identifier]?.path}"'));
      success = false;
    }

    return success;
  }
}
