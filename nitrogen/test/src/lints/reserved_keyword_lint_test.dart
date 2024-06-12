import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/lints/reserved_keyword_lint.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';
import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:test/test.dart';

void main() {
  group('lintReservedKeyword', () {
    test('contains no keywords', () {
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


      expect(() => lintReservedKeyword(directory), returnsNormally);
    });

    test('contains Dart keywords in directory name', () {
      final subdirectory = AssetDirectory(['path', 'to', 'directory', 'class']);
      subdirectory.children['foo.png'] = AssetFile(
        ['path', 'to', 'directory', 'class', 'foo.png'],
        const ImageAsset('test_package', 'foo', 'path/to/directory/subdirectory/foo.png'),
      );

      final directory = AssetDirectory(['path', 'to', 'class']);
      directory.children['class'] = subdirectory;
      directory.children['bar.txt'] = AssetFile(
        ['path', 'to', 'directory', 'bar.txt'],
        const GenericAsset('test_package', 'bar', 'path/to/directory/bar.txt'),
      );

      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('contains a reserved keyword. Please rename the directory/file. See https://dart.dev/language/keywords.'))),
      );

      expect(() => lintReservedKeyword(directory), throwsA(isA<NitrogenException>()));
    });

    test('contains Nitrogen keywords', () {
      final subdirectory = AssetDirectory(['path', 'to', 'directory', 'contents']);
      subdirectory.children['foo.png'] = AssetFile(
        ['path', 'to', 'directory', 'contents', 'foo.png'],
        const ImageAsset('test_package', 'foo', 'path/to/directory/subdirectory/foo.png'),
      );

      final directory = AssetDirectory(['path', 'to', 'contents']);
      directory.children['contents'] = subdirectory;
      directory.children['bar.txt'] = AssetFile(
        ['path', 'to', 'directory', 'bar.txt'],
        const GenericAsset('test_package', 'bar', 'path/to/directory/bar.txt'),
      );

      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('contains a reserved identifier. Please rename the directory/file. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#reserved-keywords.'))),
      );

      expect(() => lintReservedKeyword(directory), throwsA(isA<NitrogenException>()));
    });
  });
}