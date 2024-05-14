import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/assets/basic_generator.dart';
import 'package:sugar/sugar.dart';

class RichGenerator {
  final String base;

  RichGenerator(this.base);


  Iterable<ClassBuilder> _generate(Folder folder) sync* {
    // We store an additional depth field to prevent ambiguity between levels.
    final classes = <(String, String, int), ClassBuilder>{};

    _generateSuperClasses(folder.children[base]! as Folder, classes, base, 0);
    for (final child in folder.children.values.whereType<Folder>().where((folder) => '\$${folder.name}' != base)) {
      _generateChildClasses(child, classes, child.name, child.name, 0);
    }

    for (final MapEntry(value: builder) in classes.entries
        .where((e) => e.key.$1 == base)
        .order(by: (e) => e.key.$2)
        .ascending
    ) {
      yield builder;
    }

    for (final MapEntry(value: builders) in classes.entries
        .where((e) => e.key.$1 != base)
        .group.lists(by: (e) => e.key.$1)
          .entries
          .order(by: (e) => e.key)
          .ascending
    ) {
      for (final MapEntry(value: builder) in builders.order(by: (e) => e.key.$2).ascending) {
        yield builder;
      }
    }
  }

  void _generateSuperClasses(Folder folder, Map<(String, String, int), ClassBuilder> classes, String prefix, int depth) {
    final name = '$prefix${folder.name.toPascalCase()}';
    classes[(base, folder.name, depth)] = RichSuperClass(BasicClass(folder)).define(name);
    for (final child in folder.children.values.whereType<Folder>()) {
      _generateSuperClasses(child, classes, name, depth + 1);
    }
  }

  void _generateChildClasses(Folder folder, Map<(String, String, int), ClassBuilder> classes, String theme, String prefix, int depth) {
    final name = '$prefix${folder.name.toPascalCase()}';
    
    classes[(theme, folder.name, depth)] = switch (classes[(base, folder.name, depth)]) {
      final baseClass? => RichChildClass(BasicClass(folder)).define(name, baseClass),
      null => RichSuperClass(BasicClass(folder)).define(name),
    };

    for (final child in folder.children.values.whereType<Folder>()) {
      _generateChildClasses(child, classes, theme, name, depth + 1);
    }
  }

}


/// Contains functions for generating a rich super class from which other rich classes inherit from.
extension type RichSuperClass(BasicClass tree) implements Folder {

  /// Defines a rich class that additionally extends [Iterable] and implements [operator[]].
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
        for (final leaf in children.values.whereType<AssetFile>().map(AssetExpression.new))
          Block.of([literal(leaf.asset.key).code, const Code(': '), leaf.creation.code, const Code(', ')]),
        const Code('}'),
      ])
  );

}

/// Contains functions for generating a rich class.
extension type RichChildClass(BasicClass basic) implements Folder {

  /// Defines a rich class that overrides a rich super class.
  ClassBuilder define(String name, ClassBuilder base) => basic.define(name)
    ..extend = refer(base.name!)
    ..fields.add(map(base))
    ..methods.insertAll(0, [_operator, _iterator]);

  /// The `_map` field.
  Field map(ClassBuilder superClass) => Field((builder) =>
    builder
      ..static = true
      ..modifier = FieldModifier.constant
      ..type = TypeReference((builder) => builder..symbol = 'Map'..types.addAll([refer('String'), _assetType]))
      ..name = '_map'
      ..assignment = Block.of([
        const Code('{'),
        Code('...${superClass.name!}._map'),
        for (final leaf in children.values.whereType<AssetFile>().map(AssetExpression.new))
          Block.of([literal(leaf.asset.key).code, const Code(': '), leaf.creation.code, const Code(', ')]),
        const Code('}'),
      ])
  );

}

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
