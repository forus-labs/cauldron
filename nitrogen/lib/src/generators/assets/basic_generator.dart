import 'dart:io';

import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/libraries.dart';
import 'package:sugar/sugar.dart';


/// A generator for basic class representations of asset directories.
class BasicGenerator {

  final BasicClass _basicClass;
  final AssetDirectory _assets;

  /// Creates a [BasicGenerator].
  BasicGenerator(this._basicClass, this._assets);

  /// Generates basic asset classes in the given [target].
  void generate(File target) {
    final classes = <Class>[];
    _generate(_assets, classes, static: true);

    final library = LibraryBuilder()
      ..directives.add(Libraries.importNitrogenTypes)
      ..body.add(Libraries.header)
      ..body.addAll(classes);

    target..createSync(recursive: true)..writeAsStringSync(library.build().format());
  }

  void _generate(AssetDirectory directory, List<Class> classes, {bool static = false}) {
    classes.add(_basicClass.generate(directory, static: static).build());
    for (final child in directory.children.values.whereType<AssetDirectory>()) {
      _generate(child, classes);
    }
  }

}


/// Contains functions for generating a basic class representation of a directory.
class BasicClass {

  /// The excluded directories.
  final Set<AssetDirectory> excluded;
  /// The directory expressions.
  final AssetDirectoryExpressions directories;
  /// The file expressions.
  final AssetFileExpressions files;

  /// Creates a [BasicClass].
  const BasicClass({
    this.excluded = const {},
    this.directories = const AssetDirectoryExpressions(),
    this.files = const AssetFileExpressions(),
  });


  /// Generates a basic class that contains only nested folders and assets.
  ClassBuilder generate(AssetDirectory directory, {bool static = false}) => ClassBuilder()
    ..name = directories.type(directory).symbol!
    ..constructors.add(Constructor((builder) => builder..constant = true))
    ..methods.addAll([
      for (final child in directory.children.values.whereType<AssetDirectory>().where((d) => !excluded.contains(d)))
        _assetDirectoryGetter(child, static: static),

      for (final child in directory.children.values.whereType<AssetFile>())
        _assetFileGetter(child, static: static),
    ]);

  /// Returns a getter for the nested [directory].
  Method _assetDirectoryGetter(AssetDirectory directory, {bool static = false}) => Method((builder) => builder
    ..static = static
    ..returns = directories.type(directory)
    ..type = MethodType.getter
    ..name = directories.variable(directory)
    ..lambda = true
    ..body = directories.type(directory).constInstance([]).code
  );

  /// Returns a getter for the nested [file].
  Method _assetFileGetter(AssetFile file, {bool static = false}) => Method((builder) => builder
    ..static = static
    ..returns = files.type(file)
    ..type = MethodType.getter
    ..name = files.variable(file)
    ..lambda = true
    ..body = files.invocation(file).code
  );

}

/// Contains functions for generating code from a asset directory.
class AssetDirectoryExpressions {

  /// Creates a [AssetDirectoryExpressions].
  const AssetDirectoryExpressions();

  /// The variable name.
  String variable(AssetDirectory directory) => directory.rawName.toCamelCase();

  /// The asset directory type.
  Reference type(AssetDirectory directory) => refer('${directory.path.length >  1 ? r'$' : ''}${directory.path.join('-').toPascalCase()}');

}

/// Contains functions for generating code from a asset file.
class AssetFileExpressions {

  /// Creates a [AssetFileExpressions].
  const AssetFileExpressions();

  /// The variable name.
  String variable(AssetFile file) => file.rawName.toCamelCase();

  /// An invocation of this asset's constructor.
  Expression invocation(AssetFile file) => type(file).constInstance([
    literal(file.asset.package),
    literal(file.asset.key),
    literal(file.asset.path),
  ]);

  /// The asset type.
  Reference type(AssetFile file) => refer(file.asset.runtimeType.toString(), 'package:nitrogen_types/nitrogen_types.dart');

}
