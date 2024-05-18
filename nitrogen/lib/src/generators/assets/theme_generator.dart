import 'dart:collection';

import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/assets/basic_generator.dart';
import 'package:nitrogen/src/generators/assets/standard_generator.dart';
import 'package:nitrogen/src/generators/libraries.dart';
import 'package:sugar/sugar.dart';


/// A generator for theme class representations of asset directories.
class ThemeGenerator {

  static int _depth((String, int) a, (String, int) b) => a.$2.compareTo(b.$2);

  static int _name((String, int) a, (String, int) b) => a.$1.compareTo(b.$1);

  final ThemeExtension _extension;
  final StandardClass _fallbackClass;
  final StandardClass _themeSubclass;
  final ThemeClass _themeClass;
  final AssetDirectory _themes;
  final AssetDirectory _fallbackTheme;

  /// Creates a [ThemeGenerator].
  ThemeGenerator(String prefix, this._themes, this._fallbackTheme):
    _extension = ThemeExtension(prefix),
    _fallbackClass = StandardClass(directories: FallbackAssetDirectoryExpressions(prefix, _fallbackTheme)),
    _themeSubclass = StandardClass(directories: ThemeAssetDirectoryExpressions(prefix, _themes)),
    _themeClass = ThemeClass(ThemeAssetDirectoryExpressions(prefix, _themes));

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

  void _generateTheme(AssetDirectory directory, Map<(String, int), Class> current, Map<(String, int), Class> fallbacks, int depth) {
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
    ..body = refer(type.name).newInstance([]).code
  );

}

/// Contains functions for generating a theme class representation of a directory.
class ThemeClass {

  final BasicClass _basic;

  /// Creates a [ThemeClass].
  ThemeClass(AssetDirectoryExpressions directories): _basic = BasicClass(directories: directories);

  /// Generates a theme class that extends [fallback].
  ClassBuilder generate(AssetDirectory directory, Class fallback) => _basic.generate(directory)
    ..extend = refer(fallback.name)
    ..modifier = ClassModifier.final$
    ..fields.add(_contents(directory, fallback));

  Field _contents(AssetDirectory directory, Class fallback) => Field((builder) => builder
    ..static = true
    ..modifier = FieldModifier.final$
    ..type = TypeReference((builder) => builder..symbol = 'Map'..types.addAll([refer('String'), StandardClass.assetType]))
    ..name = 'contents'
    ..assignment = Block.of([
      const Code('Map.unmodifiable({'),
      Code('...${fallback.name}.contents,'),
      for (final file in directory.children.values.whereType<AssetFile>())
        Block.of([literal(file.asset.key).code, const Code(': '), _basic.files.invocation(file).code, const Code(', ')]),
      const Code('})'),
    ])
  );

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
    return refer('${path.isEmpty ? '' : r'$'}${directory.path[_themes.path.length].toPascalCase()}${prefix}ThemeAssets${path.join('-').toPascalCase()}');
  }

}
