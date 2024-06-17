import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:test/test.dart';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/asset_generator.dart';

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
  final formatter = DartFormatter(pageWidth: 160);
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

  test('AssetGenerator', () {
    final generator = AssetGenerator('Prefix', directory, {});
    expect(formatter.format(generator.generate()), _classes);
  });

  group('AssetClass', () {
    group('generate(...)', () {
      test('non static', () {
        const basic = AssetClass(directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_nonStaticAssetClass));
      });

      test('static', () {
        const basic = AssetClass(directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory, static: true).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_staticAssetClass));
      });

      test('excluded', () {
        final basic = AssetClass(directories: const AssetDirectoryExpressions('Prefix'), excluded: { subdirectory });
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_excludedAssetClass));
      });
    });
  });

  group('BasicAssetClass', () {
    group('generate(...)', () {
      test('non static', () {
        const basic = BasicAssetClass(directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_nonStaticBasicClass));
      });

      test('static', () {
        const basic = BasicAssetClass(directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory, static: true).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_staticBasicClass));
      });

      test('excluded', () {
        final basic = BasicAssetClass(directories: const AssetDirectoryExpressions('Prefix'), excluded: { subdirectory });
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
