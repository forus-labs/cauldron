import 'dart:io';

import 'package:stevia_runner/src/ansi.dart';
import 'package:stevia_runner/src/assets/elements.dart';

/// Lints the parsed elements before code generation for icons.
class Lint {

  final UniqueKeyLint _keyLint = UniqueKeyLint();
  final SvgAssetLint _assetLint = SvgAssetLint();

  /// Lints the given [folder].
  bool call(Folder folder) {
    _assetLint(folder);

    var success = _keyLint(folder);
    for (final folder in folder.folders.values) {
      success &= call(folder);
    }

    for (final asset in folder.assets.values) {
      success &= _keyLint(asset);
    }

    return success;
  }

}

/// A lint that determines if all element keys are unique.
class UniqueKeyLint {

  final Map<String, Element> _keys = {};

  /// Returns `false` if another asset with the same key as [element] exists.
  bool call(Element element) {
    final existing = _keys[element.key];
    if (existing != null) {
      stderr.writeln(red('Conflicting keys between "${element.path}" and "${existing.path}". Consider renaming one of the files/folders.'));
      return false;
    }

    _keys[element.key] = element;
    return true;
  }

}

/// A lint that determines if a folder contains non-SVG files and subsequently removes
/// the non-SVG files in-memory. The actual non-SVG files are unmodified.
class SvgAssetLint {

  /// Determines if a folder contains non-SVG files and removes them.
  void call(Folder folder) {
    folder.assets.removeWhere((identifier, asset) {
      final unsupported = asset.kind != Kind.svg;
      if (unsupported) {
        stdout.writeln(yellow('Non-SVG file found when generating icons, ignoring ${asset.path}'));
      }

      return unsupported;
    });
  }

}
