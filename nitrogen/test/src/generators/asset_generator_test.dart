import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:nitrogen_types/assets.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/asset_generator.dart';

const _classesDocs =  r'''
import 'package:nitrogen_types/assets.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// nitrogen
// **************************************************************************
//
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use

/// Contains the assets and nested directories in the `path/to/directory` directory.
///
/// Besides the assets and nested directories, it also provides a [contents] for querying the assets in the current
/// directory.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = $PrefixPathToDirectory.path.to.asset();
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
class $PrefixPathToDirectory {
  const $PrefixPathToDirectory();

  /// The `path/to/directory/subdirectory` directory.
  static $PrefixPathToDirectorySubdirectory get subdirectory => const $PrefixPathToDirectorySubdirectory();

  /// The `path/to/directory/bar.txt`.
  static GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/directory/bar.txt',
      );

  /// The contents of this directory.
  static Map<String, Asset> get contents => const {
        'bar': const GenericAsset(
          'test_package',
          'bar',
          'path/to/directory/bar.txt',
        ),
      };
}

/// Contains the assets and nested directories in the `path/to/directory/subdirectory` directory.
///
/// Besides the assets and nested directories, it also provides a [contents] for querying the assets in the current
/// directory.
///
/// To convert an asset into a widget, [call the asset like a function](https://dart.dev/language/callable-objects].
/// ```dart
/// final widget = $PrefixPathToDirectorySubdirectory.path.to.asset();
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
class $PrefixPathToDirectorySubdirectory {
  const $PrefixPathToDirectorySubdirectory();

  /// The `path/to/directory/subdirectory/foo.png`.
  ImageAsset get foo => const ImageAsset(
        'test_package',
        'foo',
        'path/to/directory/subdirectory/foo.png',
      );

  /// The contents of this directory.
  Map<String, Asset> get contents => const {
        'foo': const ImageAsset(
          'test_package',
          'foo',
          'path/to/directory/subdirectory/foo.png',
        ),
      };
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

class $PrefixPathToDirectory {
  const $PrefixPathToDirectory();

  static $PrefixPathToDirectorySubdirectory get subdirectory => const $PrefixPathToDirectorySubdirectory();

  static GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/directory/bar.txt',
      );

  static Map<String, Asset> get contents => const {
        'bar': const GenericAsset(
          'test_package',
          'bar',
          'path/to/directory/bar.txt',
        ),
      };
}

class $PrefixPathToDirectorySubdirectory {
  const $PrefixPathToDirectorySubdirectory();

  ImageAsset get foo => const ImageAsset(
        'test_package',
        'foo',
        'path/to/directory/subdirectory/foo.png',
      );

  Map<String, Asset> get contents => const {
        'foo': const ImageAsset(
          'test_package',
          'foo',
          'path/to/directory/subdirectory/foo.png',
        ),
      };
}
''';

const _nonStaticAssetClass = r'''
class $PrefixPathToDirectory {
  const $PrefixPathToDirectory();

  $PrefixPathToDirectorySubdirectory get subdirectory => const $PrefixPathToDirectorySubdirectory();

  GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/directory/bar.txt',
      );

  Map<String, Asset> get contents => const {
        'bar': const GenericAsset(
          'test_package',
          'bar',
          'path/to/directory/bar.txt',
        ),
      };
}
''';

const _staticAssetClass = r'''
class $PrefixPathToDirectory {
  const $PrefixPathToDirectory();

  static $PrefixPathToDirectorySubdirectory get subdirectory => const $PrefixPathToDirectorySubdirectory();

  static GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/directory/bar.txt',
      );

  static Map<String, Asset> get contents => const {
        'bar': const GenericAsset(
          'test_package',
          'bar',
          'path/to/directory/bar.txt',
        ),
      };
}
''';

const _excludedAssetClass = r'''
class $PrefixPathToDirectory {
  const $PrefixPathToDirectory();

  GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/directory/bar.txt',
      );

  Map<String, Asset> get contents => const {
        'bar': const GenericAsset(
          'test_package',
          'bar',
          'path/to/directory/bar.txt',
        ),
      };
}
''';

const _nonStaticBasicClass = r'''
class $PrefixPathToDirectory {
  const $PrefixPathToDirectory();

  $PrefixPathToDirectorySubdirectory get subdirectory => const $PrefixPathToDirectorySubdirectory();

  GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/directory/bar.txt',
      );
}
''';

const _staticBasicClass = r'''
class $PrefixPathToDirectory {
  const $PrefixPathToDirectory();

  static $PrefixPathToDirectorySubdirectory get subdirectory => const $PrefixPathToDirectorySubdirectory();

  static GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/directory/bar.txt',
      );
}
''';

const _excludedBasicClass = r'''
class $PrefixPathToDirectory {
  const $PrefixPathToDirectory();

  GenericAsset get bar => const GenericAsset(
        'test_package',
        'bar',
        'path/to/directory/bar.txt',
      );
}
''';

void main() {
  final formatter = DartFormatter(pageWidth: 160, languageVersion: Version(3, 6, 0));
  final emitter = DartEmitter(useNullSafetySyntax: true);

  final subdirectory = AssetDirectory(['path', 'to', 'directory', 'subdirectory']);
  subdirectory.children['foo.png'] = AssetFile(
    ['path', 'to', 'directory', 'subdirectory', 'foo.png'],
    const ImageAsset('test_package', 'foo', 'path/to/directory/subdirectory/foo.png'),
  );

  final directory = AssetDirectory(['path', 'to', 'directory']);
  directory.children['subdirectory'] = subdirectory;
  directory.children['bar.txt'] = AssetFile(
    ['path', 'to', 'directory', 'bar.txt'],
    const GenericAsset('test_package', 'bar', 'path/to/directory/bar.txt'),
  );

  group('AssetGenerator', () {
    test('docs', () {
      final generator = AssetGenerator('Prefix', directory, {}, docs: true);
      expect(formatter.format(generator.generate()), _classesDocs);
    });

    test('no docs', () {
      final generator = AssetGenerator('Prefix', directory, {}, docs: false);
      expect(formatter.format(generator.generate()), _classesNoDocs);
    });
  });

  group('AssetClass', () {
    group('generate(...)', () {
      test('non static', () {
        const basic = AssetClass(docs: false, directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_nonStaticAssetClass));
      });

      test('static', () {
        const basic = AssetClass(docs: false, directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory, static: true).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_staticAssetClass));
      });

      test('excluded', () {
        final basic = AssetClass(docs: false, directories: const AssetDirectoryExpressions('Prefix'), excluded: { subdirectory });
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_excludedAssetClass));
      });
    });
  });

  group('BasicAssetClass', () {
    group('generate(...)', () {
      test('non static', () {
        const basic = BasicAssetClass(docs: false, directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_nonStaticBasicClass));
      });

      test('static', () {
        const basic = BasicAssetClass(docs: false, directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory, static: true).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_staticBasicClass));
      });

      test('excluded', () {
        final basic = BasicAssetClass(docs: false, directories: const AssetDirectoryExpressions('Prefix'), excluded: { subdirectory });
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_excludedBasicClass));
      });
    });
  });

  group('AssetDirectoryExpressions', () {
    final directory = AssetDirectory(
      ['path', 'to', 'directory-name'],
    );

    test('variable(...)', () => expect(const AssetDirectoryExpressions('Prefix').variable(directory), 'directoryName'));

    group('type(...)', () {
      test('with nested directory', () {
        final reference = const AssetDirectoryExpressions('Prefix').type(directory);
        expect(reference.accept(emitter).toString(), r'$PrefixPathToDirectoryName');
      });

      test('without nested directory', () {
        final reference = const AssetDirectoryExpressions('Prefix').type(AssetDirectory(['directory-name']));
        expect(reference.accept(emitter).toString(), 'PrefixDirectoryName');
      });
    });

  });

  group('AssetFileExpressions', () {
    final file = AssetFile(
      ['path', 'to', 'file-name.png'],
      const GenericAsset('test_package', 'name', 'path/to/file-name.png'),
    );

    test('variable(...)', () => expect(const AssetFileExpressions().variable(file), 'fileName'));

    test('invocation(...)', () {
      final invocation = const AssetFileExpressions().invocation(file);

      expect(
        invocation.accept(emitter).toString(),
        "const GenericAsset('test_package', 'name', 'path/to/file-name.png', )",
      );
    });

    test('type(...)', () {
      final reference = const AssetFileExpressions().type(file);
      expect(reference.accept(emitter).toString(), 'GenericAsset');
    });
  });
}
