import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/tree.dart';
import 'package:nitrogen/src/generators/basic_theme_generator.dart';

final _assetType = refer('Asset', 'package:nitrogen_types/nitrogen_types.dart');

final _iterator = Method((builder) =>
  builder
    ..annotations.add(refer('override'))
    ..returns = TypeReference((builder) => builder..symbol = 'Iterator'..types.add(refer('Asset')))
    ..type = MethodType.getter
    ..name = 'iterator'
    ..lambda = true
    ..body = const Code('_map.values.iterator')
  );

final _operator = Method((builder) =>
  builder
    ..returns = refer('Asset?')
    ..name = 'operator []'
    ..requiredParameters.add(Parameter((builder) => builder..type = refer('String?')..name = 'key'))
    ..lambda = true
    ..body = const Code('_map[key]')
  );


/// Contains functions for generating a base rich class from which other generated rich classes inherit from.
extension type TreeBaseRichClass(TreeBasicClass tree) implements Tree {

  /// Defines a rich base class that additionally extends [Iterable] and implements [operator[]].
  ClassBuilder define(String name) => tree.define(name)
    ..extend = TypeReference((builder) => builder..symbol = 'Iterable'..types.add(_assetType))
    ..fields.add(map)
    ..methods.insertAll(0, [_operator, _iterator]);

  /// The `_map` field.
  Field get map => Field((builder) =>
  builder
    ..static = true
    ..modifier = FieldModifier.constant
    ..type = TypeReference((builder) => builder..symbol = 'Map'..types.addAll([refer('String'), _assetType]))
    ..name = '_map'
    ..assignment = Block.of([
      const Code('{'),
      for (final leaf in children.values.whereType<Leaf>().map(LeafExpression.new))
        Block.of([literal(leaf.asset.key).code, const Code(': '), leaf.creation.code, const Code(', ')]),
      const Code('}'),
    ])
  );

}

/// Contains functions for generating a rich class.
extension type TreeRichClass(TreeBasicClass tree) implements Tree {

  /// Defines a rich base class that additionally extends [Iterable] and implements [operator[]].
  ClassBuilder define(String name, ClassBuilder base) => tree.define(name)
    ..extend = refer(base.name!)
    ..fields.add(map(base))
    ..methods.insertAll(0, [_operator, _iterator]);

  /// The `_map` field.
  Field map(ClassBuilder base) => Field((builder) =>
  builder
    ..static = true
    ..modifier = FieldModifier.constant
    ..type = TypeReference((builder) => builder..symbol = 'Map'..types.addAll([refer('String'), _assetType]))
    ..name = '_map'
    ..assignment = Block.of([
      const Code('{'),
      Code('...${base.name!}._map'),
      for (final leaf in children.values.whereType<Leaf>().map(LeafExpression.new))
        Block.of([literal(leaf.asset.key).code, const Code(': '), leaf.creation.code, const Code(', ')]),
      const Code('}'),
    ])
  );

}
