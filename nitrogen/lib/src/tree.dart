import 'dart:collection';

import 'package:nitrogen_types/nitrogen_types.dart';

/// A vertex in a parse tree.
sealed class Vertex {
  /// The name, typically a directory or file's unaltered name without a file extension.
  final String segment;

  Vertex(this.segment);
}

/// A parse tree, typically a directory.
final class Tree extends Vertex {
  /// The children.
  final SplayTreeMap<String, Vertex> children = SplayTreeMap();

  /// Creates a [Tree].
  Tree(super.segment);
}

/// A leaf, typically an asset file.
final class Leaf extends Vertex {
  /// An asset.
  final Asset asset;

  /// Creates a [Leaf].
  Leaf(super.segment, this.asset);
}
