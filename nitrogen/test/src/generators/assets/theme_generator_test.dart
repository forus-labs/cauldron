import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/assets/theme_generator.dart';
import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:test/test.dart';

const _classes = r'''
import 'package:nitrogen_types/nitrogen_types.dart';

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

  test('ThemeGenerator', () {
    final generator = ThemeGenerator('Prefix', themes, light);
    expect(generator.generate(), _classes);
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
