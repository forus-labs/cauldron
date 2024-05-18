import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/assets/basic_generator.dart';
import 'package:nitrogen/src/generators/libraries.dart';
import 'package:nitrogen_types/nitrogen_types.dart';


/// A generator for standard class representations of asset directories.
class StandardGenerator {

  final StandardClass _standardClass;
  final AssetDirectory _assets;
  final Set<AssetDirectory> _excluded;

  /// Creates a [StandardGenerator].
  StandardGenerator(String prefix, this._assets, this._excluded):
    _standardClass = StandardClass(
      directories: AssetDirectoryExpressions(prefix),
      excluded: _excluded,
    );

  /// Generates basic asset classes.
  String generate() {
    final classes = <Class>[];
    _generate(_assets, classes, static: true);

    final library = LibraryBuilder()
      ..directives.add(Libraries.importNitrogenTypes)
      ..body.add(Libraries.header())
      ..body.addAll(classes);

    return library.build().format();
  }

  void _generate(AssetDirectory directory, List<Class> classes, {bool static = false}) {
    classes.add(_standardClass.generate(directory, static: static).build());
    for (final child in directory.children.values.whereType<AssetDirectory>().where((d) => !_excluded.contains(d))) {
      _generate(child, classes);
    }
  }

}

/// Contains functions for generating a standard class representation of a directory.
class StandardClass extends BasicClass {

  /// An [Asset] type.
  static final assetType = refer('Asset', 'package:nitrogen_types/nitrogen_types.dart');

  /// Creates a [StandardClass].
  const StandardClass({required super.directories, super.excluded, super.files});

  @override
  ClassBuilder generate(AssetDirectory directory, {bool static = false, bool sealed = false}) =>
    super.generate(directory, static: static)
      ..sealed = sealed
      ..fields.add(_contents(directory));


  Field _contents(AssetDirectory directory) => Field((builder) => builder
    ..static = true
    ..modifier = FieldModifier.constant
    ..type = TypeReference((builder) => builder..symbol = 'Map'..types.addAll([refer('String'), assetType]))
    ..name = 'contents'
    ..assignment = Block.of([
      const Code('{'),
      for (final file in directory.children.values.whereType<AssetFile>())
        Block.of([literal(file.asset.key).code, const Code(': '), files.invocation(file).code, const Code(', ')]),
      const Code('}'),
    ])
  );

}
