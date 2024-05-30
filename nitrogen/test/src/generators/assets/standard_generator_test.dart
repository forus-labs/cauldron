import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/assets/basic_generator.dart';
import 'package:nitrogen/src/generators/assets/standard_generator.dart';
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

const _nonStatic = r'''
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

const _static = r'''
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

const _excluded = r'''
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

  test('StandardGenerator', () {
    final generator = StandardGenerator('Prefix', directory, {});
    expect(formatter.format(generator.generate()), _classes);
  });

  group('StandardClass', () {
    group('generate(...)', () {
      test('non static', () {
        const basic = StandardClass(directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_nonStatic));
      });

      test('static', () {
        const basic = StandardClass(directories: AssetDirectoryExpressions('Prefix'));
        final type = basic.generate(directory, static: true).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_static));
      });

      test('excluded', () {
        final basic = StandardClass(directories: const AssetDirectoryExpressions('Prefix'), excluded: { subdirectory });
        final type = basic.generate(directory).build();

        expect(formatter.format(type.accept(emitter).toString()), formatter.format(_excluded));
      });
    });
  });
}
