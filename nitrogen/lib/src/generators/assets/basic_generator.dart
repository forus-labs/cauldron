import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/utilities.dart';
import 'package:path/path.dart';
import 'package:sugar/sugar.dart';


/// A generator for basic asset classes.
class BasicGenerator {

  /// Generates basic asset classes from the [folder] in the given [file].
  void generate(Folder folder, File file) {
    final builders = <ClassBuilder>[];
    _generate(folder, builders);

    final library = LibraryBuilder()
      ..directives.add(nitrogenTypes)
      ..body.add(header)
      ..body.addAll(builders.map((c) => c.build()));

    file..createSync(recursive: true)..writeAsStringSync(library.build().code);
  }

  void _generate(Folder folder, List<ClassBuilder> classes, [String? prefix]) {
    final name = '${prefix ?? r'$'}${folder.name.toPascalCase()}';
    classes.add(BasicClass(folder).define(name));

    for (final child in folder.children.values.whereType<Folder>()) {
      _generate(child, classes, name);
    }
  }

}


/// Contains functions for generating a basic class from a folder.
extension type BasicClass(Folder folder) implements Folder {

  /// Defines a basic class that contains only nested folders and assets.
  ClassBuilder define(String name) => ClassBuilder()
    ..name = name
    ..constructors.add(Constructor((builder) => builder..constant = true))
    ..methods.addAll([
      for (final child in folder.children.values.whereType<Folder>())
        folderGetter(child, '$name${child.name.toPascalCase()}'),

      for (final child in folder.children.values.whereType<AssetFile>())
        assetGetter(AssetExpression(child)),
    ]);

  /// Returns a getter for the nested [folder].
  Method folderGetter(Folder folder, String name) => Method((builder) =>
    builder..returns = refer(name)
      ..type = MethodType.getter
      ..name = folder.name.toCamelCase()
      ..lambda = true
      ..body = refer(name).constInstance([]).code
  );

  /// Returns a getter for the nested [asset].
  Method assetGetter(AssetExpression asset) => Method((builder) =>
    builder..returns = asset.type
      ..type = MethodType.getter
      ..name = basenameWithoutExtension(asset.name).toCamelCase()
      ..lambda = true
      ..body = asset.creation.code
  );

}


/// Contains functions for generating code from a asset file.
extension type AssetExpression(AssetFile file) implements AssetFile {

  /// An invocation of this asset subclass's constructor.
  Expression get creation => type.constInstance([
    literal(file.asset.package),
    literal(file.asset.key),
    literal(file.asset.path),
  ]);

  /// The Asset type.
  Reference get type => refer(file.asset.runtimeType.toString(), 'package:nitrogen_types/nitrogen_types.dart');

}
