import 'dart:collection';

import 'package:code_builder/code_builder.dart';
import 'package:sugar/sugar.dart';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/asset_generator.dart';
import 'package:nitrogen/src/libraries.dart';

/// A generator for theme class representations of asset directories.
class ThemeGenerator {
  static int _depth((String, int) a, (String, int) b) => a.$2.compareTo(b.$2);

  static int _name((String, int) a, (String, int) b) => a.$1.compareTo(b.$1);

  final ThemeExtension _extension;
  final FallbackAssetClass _fallbackClass;
  final FallbackAssetClass _themeSubclass;
  final ThemeClass _themeClass;
  final AssetDirectory _themes;
  final AssetDirectory _fallbackTheme;

  /// Creates a [ThemeGenerator].
  ThemeGenerator(String prefix, this._themes, this._fallbackTheme, {required bool docs})
      : _extension = ThemeExtension(prefix),
        _fallbackClass =
            FallbackAssetClass(directories: FallbackAssetDirectoryExpressions(prefix, _fallbackTheme), docs: docs),
        _themeSubclass = FallbackAssetClass(directories: ThemeAssetDirectoryExpressions(prefix, _themes), docs: docs),
        _themeClass = ThemeClass(ThemeAssetDirectoryExpressions(prefix, _themes), docs: docs);

  /// Generates themed asset classes.
  String generate() {
    final fallbackClasses = SplayTreeMap<(String, int), Class>(_depth.and(_name));
    final themeClasses = SplayTreeMap<String, SplayTreeMap<(String, int), Class>>();

    _generateFallbackTheme(
      _fallbackTheme,
      fallbackClasses,
      0,
    );

    for (final theme in _themes.children.values.whereType<AssetDirectory>()) {
      _generateTheme(theme, themeClasses[theme.rawName] ??= SplayTreeMap(_depth.and(_name)), fallbackClasses, 0);
    }

    final library = LibraryBuilder()
      ..directives.add(Libraries.importNitrogenTypes)
      ..body.add(Libraries.header())
      ..body.add(_extension.generate(themeClasses).build())
      ..body.addAll(fallbackClasses.values);

    for (final classes in themeClasses.values) {
      library.body.addAll(classes.values);
    }

    return library.build().format();
  }

  void _generateFallbackTheme(AssetDirectory directory, Map<(String, int), Class> classes, int depth) {
    final key = depth == 0 ? '' : directory.rawName;
    classes[(key, depth)] = _fallbackClass.generate(directory).build();
    for (final child in directory.children.values.whereType<AssetDirectory>()) {
      _generateFallbackTheme(child, classes, depth + 1);
    }
  }

  void _generateTheme(
      AssetDirectory directory, Map<(String, int), Class> current, Map<(String, int), Class> fallbacks, int depth) {
    final key = depth == 0 ? '' : directory.rawName;
    current[(key, depth)] = switch (fallbacks[(key, depth)]) {
      final fallback? => _themeClass.generate(directory, fallback).build(),
      null => _themeSubclass.generate(directory).build(),
    };

    for (final child in directory.children.values.whereType<AssetDirectory>()) {
      _generateTheme(child, current, fallbacks, depth + 1);
    }
  }
}

/// Contains functions for generating an extension that contains all generated themes.
class ThemeExtension {
  final String _prefix;

  /// Creates a [ThemeExtension].
  ThemeExtension(this._prefix);

  /// Generates an extension
  ExtensionBuilder generate(Map<String, Map<(String, int), Class>> themes) => ExtensionBuilder()
    ..name = '${_prefix}AssetTheme'
    ..on = refer('Never')
    ..methods.addAll(themes.entries.map((e) => _themeGetter(e.key, e.value[('', 0)]!)));

  Method _themeGetter(String theme, Class type) => Method((builder) => builder
    ..static = true
    ..returns = refer(type.name)
    ..type = MethodType.getter
    ..name = theme
    ..lambda = true
    ..body = refer(type.name).newInstance([]).code);
}

/// Contains functions for generating a standard class representation of a directory with theme-specific documentation.
class FallbackAssetClass extends AssetClass {
  /// Creates a [FallbackAssetClass].
  FallbackAssetClass({required super.directories, required super.docs});

  @override
  String generateDocs(AssetDirectory directory) => '''
/// The fallback theme's assets.
/// 
/// Contains the assets in the `${directory.path.join('/')}` directory that serve as a fallback for when a theme does not 
/// contain those specific assets.
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
}

/// Contains functions for generating a theme class representation of a directory.
class ThemeClass {
  final ThemeAssetDirectoryExpressions _directories;
  final BasicAssetClass _assets;
  final bool _docs;

  /// Creates a [ThemeClass].
  ThemeClass(ThemeAssetDirectoryExpressions directories, {required bool docs})
      : _directories = directories,
        _assets = BasicAssetClass(directories: directories, docs: docs),
        _docs = docs;

  /// Generates a theme class that extends [fallback].
  ClassBuilder generate(AssetDirectory directory, Class fallback) => _assets.generate(directory)
    ..docs.addAll([
      if (_docs)
        '''
/// A `${_directories.theme(directory)}` theme's directory.
/// 
/// Contains the assets in the `${directory.path.join('/')}` directory that serve as a fallback for when a theme does not 
/// contain those specific assets.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = ${_directories.type(directory).symbol!}.path.to.asset();
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
/// | Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |''',
    ])
    ..extend = refer(fallback.name)
    ..modifier = ClassModifier.final$
    ..methods.add(_contents(directory, fallback));

  Method _contents(AssetDirectory directory, Class fallback, {bool static = false}) => Method((builder) => builder
    ..docs.addAll([
      if (_docs) '/// The contents of this directory.',
    ])
    ..static = static
    ..returns = TypeReference((builder) => builder
      ..symbol = 'Map'
      ..types.addAll([refer('String'), AssetClass.assetType]))
    ..type = MethodType.getter
    ..name = 'contents'
    ..lambda = true
    ..body = Block.of([
      const Code('Map.unmodifiable({'),
      Code('...${static ? fallback.name : 'const ${fallback.name}()'}.contents,'),
      for (final file in directory.children.values.whereType<AssetFile>())
        Block.of(
            [literal(file.asset.key).code, const Code(': '), _assets.files.invocation(file).code, const Code(', ')]),
      const Code('})'),
    ]));
}

/// Contains functions for generating code from a asset directory.
class FallbackAssetDirectoryExpressions extends AssetDirectoryExpressions {
  final AssetDirectory _fallback;

  /// Creates a [FallbackAssetDirectoryExpressions].
  FallbackAssetDirectoryExpressions(super.prefix, this._fallback);

  @override
  Reference type(AssetDirectory directory) {
    final path = directory.path.sublist(_fallback.path.length);
    return refer(path.isEmpty ? '${prefix}ThemeAssets' : '\$${prefix}ThemeAssets${path.join('-').toPascalCase()}');
  }
}

/// Contains functions for generating code from a asset directory.
class ThemeAssetDirectoryExpressions extends AssetDirectoryExpressions {
  final AssetDirectory _themes;

  /// Creates a [ThemeAssetDirectoryExpressions].
  ThemeAssetDirectoryExpressions(super.prefix, this._themes);

  @override
  Reference type(AssetDirectory directory) {
    final path = directory.path.sublist(_themes.path.length + 1);
    return refer(
        '${path.isEmpty ? '' : r'$'}${theme(directory).toPascalCase()}${prefix}ThemeAssets${path.join('-').toPascalCase()}');
  }

  /// The theme.
  String theme(AssetDirectory directory) => directory.path[_themes.path.length];
}
