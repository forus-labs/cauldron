import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart' show visibleForOverriding;
import 'package:nitrogen_types/assets.dart';
import 'package:sugar/sugar.dart';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/libraries.dart';

/// A generator for standard class representations of asset directories.
class AssetGenerator {
  final AssetClass _standardClass;
  final AssetDirectory _assets;
  final Set<AssetDirectory> _excluded;

  /// Creates a [AssetGenerator].
  AssetGenerator(String prefix, this._assets, this._excluded, {required bool docs})
      : _standardClass = AssetClass(
          directories: AssetDirectoryExpressions(prefix),
          excluded: _excluded,
          docs: docs,
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
class AssetClass extends BasicAssetClass {
  /// An [Asset] type.
  static final assetType = refer('Asset', 'package:nitrogen_types/nitrogen_types.dart');

  /// Creates a [AssetClass].
  const AssetClass({required super.directories, required super.docs, super.excluded, super.files});

  /// Generates the documentation for [directory].
  @visibleForOverriding
  String generateDocs(AssetDirectory directory) => '''
/// Contains the assets and nested directories in the `${directory.path.join('/')}` directory.
///
/// Besides the assets and nested directories, it also provides a [contents] for querying the assets in the current
/// directory.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = ${directories.type(directory).symbol!}.path.to.asset();
/// ```
/// 
/// The `call(...)` functions are provided by extensions. By default, only the [ImageAsset] extension is bundled.
///
/// 3rd party packages are supported via 'extension' packages. `extension` packages contain an `extension` that provide a 
/// `call(...)` function that transforms an `Asset` into a 3rd party type.
/// 
/// | Type              | Package       | Extension Package      | Version                                                                                                        |
/// |-------------------|---------------|------------------------|----------------------------------------------------------------------------------------------------------------|
/// | SVG images        | `flutter_svg` | `nitrogen_flutter_svg` | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_flutter_svg)](https://pub.dev/packages/nitrogen_flutter_svg) |
/// | Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |''';

  /// Generates a basic class that contains only nested folders and assets.
  @override
  ClassBuilder generate(AssetDirectory directory, {bool static = false}) => super.generate(directory, static: static)
    ..docs.addAll([
      if (docs) generateDocs(directory),
    ])
    ..methods.add(_contents(directory, static: static));

  Method _contents(AssetDirectory directory, {bool static = false}) => Method((builder) => builder
    ..docs.addAll([
      if (docs) '/// The contents of this directory.',
    ])
    ..static = static
    ..returns = TypeReference((builder) => builder
      ..symbol = 'Map'
      ..types.addAll([refer('String'), assetType]))
    ..type = MethodType.getter
    ..name = 'contents'
    ..lambda = true
    ..body = Block.of([
      const Code('const {'),
      for (final file in directory.children.values.whereType<AssetFile>())
        Block.of([literal(file.asset.key).code, const Code(': '), files.invocation(file).code, const Code(', ')]),
      const Code('}'),
    ]));
}

/// Contains functions for generating a basic class representation of a directory.
class BasicAssetClass {
  /// The excluded directories.
  final Set<AssetDirectory> excluded;

  /// The directory expressions.
  final AssetDirectoryExpressions directories;

  /// The file expressions.
  final AssetFileExpressions files;

  /// True if dart docs should be generated.
  final bool docs;

  /// Creates a [BasicAssetClass].
  const BasicAssetClass({
    required this.directories,
    required this.docs,
    this.excluded = const {},
    this.files = const AssetFileExpressions(),
  });

  /// Generates a basic class that contains only nested folders and assets.
  ClassBuilder generate(AssetDirectory directory, {bool static = false}) => ClassBuilder()
    ..name = directories.type(directory).symbol!
    ..constructors.add(Constructor((builder) => builder..constant = true))
    ..methods.addAll([
      for (final child in directory.children.values.whereType<AssetDirectory>().where((d) => !excluded.contains(d)))
        _assetDirectoryGetter(child, static: static),
      for (final child in directory.children.values.whereType<AssetFile>()) _assetFileGetter(child, static: static),
    ]);

  /// Returns a getter for the nested [directory].
  Method _assetDirectoryGetter(AssetDirectory directory, {bool static = false}) => Method((builder) => builder
    ..docs.addAll([if (docs) '/// The `${directory.path.join('/')}` directory.'])
    ..static = static
    ..returns = directories.type(directory)
    ..type = MethodType.getter
    ..name = directories.variable(directory)
    ..lambda = true
    ..body = directories.type(directory).constInstance([]).code);

  /// Returns a getter for the nested [file].
  Method _assetFileGetter(AssetFile file, {bool static = false}) => Method((builder) => builder
    ..docs.addAll([if (docs) '/// The `${file.path.join('/')}`.'])
    ..static = static
    ..returns = files.type(file)
    ..type = MethodType.getter
    ..name = files.variable(file)
    ..lambda = true
    ..body = files.invocation(file).code);
}

/// Contains functions for generating code from a asset directory.
class AssetDirectoryExpressions {
  /// The prefix for type names.
  final String prefix;

  /// Creates a [AssetDirectoryExpressions].
  const AssetDirectoryExpressions(this.prefix);

  /// The variable name.
  String variable(AssetDirectory directory) => directory.rawName.toCamelCase();

  /// The asset directory type.
  Reference type(AssetDirectory directory) =>
      refer('${directory.path.length > 1 ? '\$$prefix' : prefix}${directory.path.join('-').toPascalCase()}');
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
  Reference type(AssetFile file) =>
      refer(file.asset.runtimeType.toString(), 'package:nitrogen_types/nitrogen_types.dart');
}
