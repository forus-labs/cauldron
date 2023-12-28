import 'package:code_builder/code_builder.dart';

import 'package:stevia_runner/src/assets/ast.dart';
import 'package:stevia_runner/src/assets/elements.dart';

/// Provides functions for generating parts of a class.
extension ClassBuilders on ClassBuilder {

  /// Extends [Iterable] and implements the required methods and fields.
  void iterable(Folder folder) {
    this
      ..extend = TypeReference((builder) => builder..symbol = 'Iterable'..types.add(refer('SvgAsset', 'package:stevia/widgets.dart')))
      ..fields.add(_map(folder))
      ..methods.insertAll(0, [operator, iterator]);
  }

  /// Creates a private literal map of all assets in a folder and it's nested folders.
  Field _map(Folder folder) => Field((builder) =>
  builder
    ..static = true
    ..modifier = FieldModifier.constant
    ..type = TypeReference((builder) => builder..symbol = 'Map'..types.addAll([refer('SvgAssetKey'), refer('SvgAsset', 'package:stevia/widgets.dart')]))
    ..name = '_map'
    ..assignment = Block.of([
      const Code('{'),
      for (final folder in folder.folders.values)
        Code('...\$${folder.name}._map,'),

      for (final asset in folder.assets.values)
        Block.of([literal(asset.key).code, const Code(': '), asset.expression.code, const Code(', ')]),

      const Code('}'),
    ])
  );

  /// Generates a iterator getter.
  Method get iterator => Method((builder) =>
  builder
    ..annotations.add(refer('override'))
    ..returns = TypeReference((builder) => builder..symbol = 'Iterator'..types.add(refer('SvgAsset')))
    ..type = MethodType.getter
    ..name = 'iterator'
    ..lambda = true
    ..body = const Code('_map.values.iterator')
  );

  /// Implements `operator []`.
  Method get operator => Method((builder) =>
  builder
    ..returns = refer('SvgAsset?')
    ..name = 'operator []'
    ..requiredParameters.add(Parameter((builder) => builder..type = refer('SvgAssetKey?')..name = 'key'))
    ..lambda = true
    ..body = const Code('_map[key]')
  );

}
