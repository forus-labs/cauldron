import 'dart:io';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:path/path.dart';

final class Parser {

  final String? _package;
  final Set<String> _ignored;
  final String Function(String, String) _keyer;

  Parser(this._package, this._ignored, this._keyer);

  Folder parseFolder(Directory directory, String prefix) {
    final name = basename(directory.path);
    final folder = Folder(name);

    for (final entity in directory.listSync()) {
      switch (entity) {
        case _ when _ignored.contains(entity.path) || basenameWithoutExtension(entity.path).startsWith('.'):
          continue;

        case final Directory directory:
          final child = parseFolder(directory, _keyer(prefix, name));
          folder.children[child.name] = child;

        case final File file:
          final child = parseAsset(file, _keyer(prefix, name));
          folder.children[child.name] = child;
      }
    }

    return folder;
  }

  AssetFile parseAsset(File file, String prefix) {
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
