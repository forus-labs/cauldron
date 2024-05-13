import 'dart:io';

import 'package:nitrogen/src/tree.dart';
import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:path/path.dart';

final class Parser {

  final String? _package;
  final Set<String> _ignored;
  final String Function(String, String) _keyer;

  Parser(this._package, this._ignored, this._keyer);

  Tree parseTree(Directory directory, String prefix) {
    final segment = basenameWithoutExtension(directory.path);
    final tree = Tree(segment);

    for (final entity in directory.listSync()) {
      switch (entity) {
        case _ when _ignored.contains(entity.path) || basenameWithoutExtension(entity.path).startsWith('.'):
          continue;

        case final Directory directory:
          final child = parseTree(directory, _keyer(prefix, segment));
          tree.children[child.segment] = child;

        case final File file:
          final child = parseLeaf(file, _keyer(prefix, segment));
          tree.children[child.segment] = child;
      }
    }

    return tree;
  }

  Leaf parseLeaf(File file, String prefix) {
    final segment = basenameWithoutExtension(file.path);
    final key = _keyer(prefix, segment);
    final path = file.path.replaceAll(r'\', '/');
    return Leaf(
      segment,
        switch (file.path.split('.').last) {
          'jpg' || 'jpeg' || 'png' => ImageAsset(_package, key, path),
          'json' || 'zip' => LottieAsset(_package, key, path),
          'svg' => SvgAsset(_package, key, path),
          _ => UnknownAsset(_package, key, path),
        }
    );
  }

}
