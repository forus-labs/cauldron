import 'package:code_builder/code_builder.dart';
import 'package:nitrogen_types/assets.dart';
import 'package:test/test.dart';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/theme_generator.dart';

const _classesDocs = r'''
import 'package:nitrogen_types/assets.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// nitrogen
// **************************************************************************
//
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use

extension PrefixAssetTheme on Never {
  static DarkPrefixThemeAssets get dark => DarkPrefixThemeAssets();
  static LightPrefixThemeAssets get light => LightPrefixThemeAssets();
}

/// The fallback theme's assets.
///
/// Contains the assets in the `path/to/themes/light` directory that serve as a fallback for when a theme does not
/// contain those specific assets.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = PrefixThemeAssets.path.to.asset();
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
/// | Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |
class PrefixThemeAssets {
  const PrefixThemeAssets();

  /// The `path/to/themes/light/subdirectory` directory.
  $PrefixThemeAssetsSubdirectory get subdirectory => const $PrefixThemeAssetsSubdirectory();

  /// The `path/to/themes/light/foo.png`.
  ImageAsset get foo => const ImageAsset(
        'test_package',
        'foo',
        'path/to/themes/light/foo.png',
      );

  /// The contents of this directory.
  Map<String, Asset> get contents => const {
        'foo': const ImageAsset(
          'test_package',
          'foo',
          'path/to/themes/light/foo.png',
        ),
      };
}

/// The fallback theme's assets.
///
/// Contains the assets in the `path/to/themes/light/subdirectory` directory that serve as a fallback for when a theme does not
/// contain those specific assets.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = $PrefixThemeAssetsSubdirectory.path.to.asset();
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
/// | Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |
class $PrefixThemeAssetsSubdirectory {
  const $PrefixThemeAssetsSubdirectory();

  /// The contents of this directory.
  Map<String, Asset> get contents => const {};
}

/// A `dark` theme's directory.
///
/// Contains the assets in the `path/to/themes/dark` directory that serve as a fallback for when a theme does not
/// contain those specific assets.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = DarkPrefixThemeAssets.path.to.asset();
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
/// | Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |
final class DarkPrefixThemeAssets extends PrefixThemeAssets {
  const DarkPrefixThemeAssets();

  /// The `path/to/themes/dark/subdirectory` directory.
  $DarkPrefixThemeAssetsSubdirectory get subdirectory => const $DarkPrefixThemeAssetsSubdirectory();

  /// The `path/to/themes/dark/bar.txt`.
  GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/themes/dark/bar.txt',
      );

  /// The `path/to/themes/dark/foo.png`.
  GenericAsset get foo => const GenericAsset(
        'test_package',
        'foo',
        'path/to/themes/dark/foo.png',
      );

  /// The contents of this directory.
  Map<String, Asset> get contents => Map.unmodifiable({
        ...const PrefixThemeAssets().contents,
        'bar': const GenericAsset(
          'test_package',
          'bar',
          'path/to/themes/dark/bar.txt',
        ),
        'foo': const GenericAsset(
          'test_package',
          'foo',
          'path/to/themes/dark/foo.png',
        ),
      });
}

/// A `dark` theme's directory.
///
/// Contains the assets in the `path/to/themes/dark/subdirectory` directory that serve as a fallback for when a theme does not
/// contain those specific assets.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = $DarkPrefixThemeAssetsSubdirectory.path.to.asset();
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
/// | Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |
final class $DarkPrefixThemeAssetsSubdirectory extends $PrefixThemeAssetsSubdirectory {
  const $DarkPrefixThemeAssetsSubdirectory();

  /// The contents of this directory.
  Map<String, Asset> get contents => Map.unmodifiable({
        ...const $PrefixThemeAssetsSubdirectory().contents,
      });
}

/// A `light` theme's directory.
///
/// Contains the assets in the `path/to/themes/light` directory that serve as a fallback for when a theme does not
/// contain those specific assets.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = LightPrefixThemeAssets.path.to.asset();
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
/// | Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |
final class LightPrefixThemeAssets extends PrefixThemeAssets {
  const LightPrefixThemeAssets();

  /// The `path/to/themes/light/subdirectory` directory.
  $LightPrefixThemeAssetsSubdirectory get subdirectory => const $LightPrefixThemeAssetsSubdirectory();

  /// The `path/to/themes/light/foo.png`.
  ImageAsset get foo => const ImageAsset(
        'test_package',
        'foo',
        'path/to/themes/light/foo.png',
      );

  /// The contents of this directory.
  Map<String, Asset> get contents => Map.unmodifiable({
        ...const PrefixThemeAssets().contents,
        'foo': const ImageAsset(
          'test_package',
          'foo',
          'path/to/themes/light/foo.png',
        ),
      });
}

/// A `light` theme's directory.
///
/// Contains the assets in the `path/to/themes/light/subdirectory` directory that serve as a fallback for when a theme does not
/// contain those specific assets.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = $LightPrefixThemeAssetsSubdirectory.path.to.asset();
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
/// | Lottie animations | `lottie`      | `nitrogen_lottie`      | [![Pub Dev](https://img.shields.io/pub/v/nitrogen_lottie)](https://pub.dev/packages/nitrogen_lottie)           |
final class $LightPrefixThemeAssetsSubdirectory extends $PrefixThemeAssetsSubdirectory {
  const $LightPrefixThemeAssetsSubdirectory();

  /// The contents of this directory.
  Map<String, Asset> get contents => Map.unmodifiable({
        ...const $PrefixThemeAssetsSubdirectory().contents,
      });
}
''';

const _classesNoDocs = r'''
import 'package:nitrogen_types/assets.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// nitrogen
// **************************************************************************
//
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use

extension PrefixAssetTheme on Never {
  static DarkPrefixThemeAssets get dark => DarkPrefixThemeAssets();
  static LightPrefixThemeAssets get light => LightPrefixThemeAssets();
}

class PrefixThemeAssets {
  const PrefixThemeAssets();

  $PrefixThemeAssetsSubdirectory get subdirectory => const $PrefixThemeAssetsSubdirectory();

  ImageAsset get foo => const ImageAsset(
        'test_package',
        'foo',
        'path/to/themes/light/foo.png',
      );

  Map<String, Asset> get contents => const {
        'foo': const ImageAsset(
          'test_package',
          'foo',
          'path/to/themes/light/foo.png',
        ),
      };
}

class $PrefixThemeAssetsSubdirectory {
  const $PrefixThemeAssetsSubdirectory();

  Map<String, Asset> get contents => const {};
}

final class DarkPrefixThemeAssets extends PrefixThemeAssets {
  const DarkPrefixThemeAssets();

  $DarkPrefixThemeAssetsSubdirectory get subdirectory => const $DarkPrefixThemeAssetsSubdirectory();

  GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/themes/dark/bar.txt',
      );

  GenericAsset get foo => const GenericAsset(
        'test_package',
        'foo',
        'path/to/themes/dark/foo.png',
      );

  Map<String, Asset> get contents => Map.unmodifiable({
        ...const PrefixThemeAssets().contents,
        'bar': const GenericAsset(
          'test_package',
          'bar',
          'path/to/themes/dark/bar.txt',
        ),
        'foo': const GenericAsset(
          'test_package',
          'foo',
          'path/to/themes/dark/foo.png',
        ),
      });
}

final class $DarkPrefixThemeAssetsSubdirectory extends $PrefixThemeAssetsSubdirectory {
  const $DarkPrefixThemeAssetsSubdirectory();

  Map<String, Asset> get contents => Map.unmodifiable({
        ...const $PrefixThemeAssetsSubdirectory().contents,
      });
}

final class LightPrefixThemeAssets extends PrefixThemeAssets {
  const LightPrefixThemeAssets();

  $LightPrefixThemeAssetsSubdirectory get subdirectory => const $LightPrefixThemeAssetsSubdirectory();

  ImageAsset get foo => const ImageAsset(
        'test_package',
        'foo',
        'path/to/themes/light/foo.png',
      );

  Map<String, Asset> get contents => Map.unmodifiable({
        ...const PrefixThemeAssets().contents,
        'foo': const ImageAsset(
          'test_package',
          'foo',
          'path/to/themes/light/foo.png',
        ),
      });
}

final class $LightPrefixThemeAssetsSubdirectory extends $PrefixThemeAssetsSubdirectory {
  const $LightPrefixThemeAssetsSubdirectory();

  Map<String, Asset> get contents => Map.unmodifiable({
        ...const $PrefixThemeAssetsSubdirectory().contents,
      });
}
''';

void main() {
  final emitter = DartEmitter(useNullSafetySyntax: true);

  final light = AssetDirectory(['path', 'to', 'themes', 'light']);
  light.children['subdirectory'] = AssetDirectory(['path', 'to', 'themes', 'light', 'subdirectory']);
  light.children['foo.png'] = AssetFile(
    ['path', 'to', 'themes', 'light', 'foo.png'],
    const ImageAsset('test_package', 'foo', 'path/to/themes/light/foo.png'),
  );

  final dark = AssetDirectory(['path', 'to', 'themes', 'dark']);
  dark.children['subdirectory'] = AssetDirectory(['path', 'to', 'themes', 'dark', 'subdirectory']);
  dark.children['foo.png'] = AssetFile(
    ['path', 'to', 'themes', 'dark', 'foo.png'],
    const GenericAsset('test_package', 'foo', 'path/to/themes/dark/foo.png'),
  );
  dark.children['bar.txt'] = AssetFile(
    ['path', 'to', 'themes', 'dark', 'bar.txt'],
    const GenericAsset('test_package', 'bar', 'path/to/themes/dark/bar.txt'),
  );

  final themes = AssetDirectory(['path', 'to', 'themes']);
  themes.children['light'] = light;
  themes.children['dark'] = dark;

  group('ThemeGenerator', () {
    test('docs', () {
      final generator = ThemeGenerator('Prefix', themes, light, docs: true);
      expect(generator.generate(), _classesDocs);
    });

    test('no docs', () {
      final generator = ThemeGenerator('Prefix', themes, light, docs: false);
      expect(generator.generate(), _classesNoDocs);
    });
  });


  group('FallbackAssetDirectoryExpressions', () {
    group('type(...)', () {
      test('root fallback theme directory', () {
        final type = FallbackAssetDirectoryExpressions('Prefix', themes).type(light);
        expect(type.accept(emitter).toString(), r'$PrefixThemeAssetsLight');
      });

      test('nested fallback theme directory', () {
        final type = FallbackAssetDirectoryExpressions('Prefix', themes).type(light.children['subdirectory']! as AssetDirectory);
        expect(type.accept(emitter).toString(), r'$PrefixThemeAssetsLightSubdirectory');
      });
    });
  });

  group('ThemeAssetDirectoryExpressions', () {
    group('type(...)', () {
      test('root theme directory', () {
        final type = ThemeAssetDirectoryExpressions('Prefix', themes).type(light);
        expect(type.accept(emitter).toString(), 'LightPrefixThemeAssets');
      });

      test('nested theme directory', () {
        final type = ThemeAssetDirectoryExpressions('Prefix', themes).type(light.children['subdirectory']! as AssetDirectory);
        expect(type.accept(emitter).toString(), r'$LightPrefixThemeAssetsSubdirectory');
      });
    });
  });
}
