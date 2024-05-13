import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/tree.dart';
import 'package:sugar/sugar.dart';


/// Contains functions for generating a basic class from a tree.
extension type TreeBasicClass(Tree tree) implements Tree {

  /// Defines a basic tree class that contains only nested tree classes and assets.
  ClassBuilder define(String name) => ClassBuilder()
    ..name = name
    ..constructors.add(Constructor((builder) => builder..constant = true))
    ..methods.addAll([
      for (final child in tree.children.values.whereType<Tree>())
        treeGetter(child, '$name${child.segment.toPascalCase()}'),

      for (final child in tree.children.values.whereType<Leaf>())
        leafGetter(LeafExpression(child)),
    ]);

  /// Returns a getter for the nested [tree].
  Method treeGetter(Tree tree, String name) => Method((builder) =>
    builder..returns = refer(name)
      ..type = MethodType.getter
      ..name = tree.segment.toCamelCase()
      ..lambda = true
      ..body = refer(name).constInstance([]).code
  );

  /// Returns a getter for the nested [leaf] asset.
  Method leafGetter(LeafExpression leaf) => Method((builder) =>
    builder..returns = leaf.type
      ..type = MethodType.getter
      ..name = leaf.segment.toCamelCase()
      ..lambda = true
      ..body = leaf.creation.code
  );

}


/// Contains functions for generating code from a leaf.
extension type LeafExpression(Leaf leaf) implements Leaf {

  /// An invocation of the Asset subclass's constructor.
  Expression get creation => type.constInstance([
    literal(leaf.asset.package),
    literal(leaf.asset.key),
    literal(leaf.asset.path),
  ]);

  /// The Asset type.
  Reference get type => refer(leaf.asset.runtimeType.toString(), 'package:nitrogen_types/nitrogen_types.dart');

}
