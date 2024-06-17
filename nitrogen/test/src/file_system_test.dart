import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:test/test.dart';

import 'package:nitrogen/src/file_system.dart';

void main() {
  group('AssetDirectory', () {
    test('empty path', () {
      expect(() => AssetDirectory([]), throwsA(isA<StateError>()));
    });

    test('file path', () {
      expect(() => AssetDirectory(['file.dart']), throwsA(isA<AssertionError>()));
    });

    test('rawName', () {
      expect(AssetDirectory(['path', 'to', 'directory']).rawName, 'directory');
    });
  });
  
  group('AssetFile', () {
    test('empty path', () {
      expect(() => AssetFile([], const GenericAsset(null, 'key', '')), throwsA(isA<StateError>()));
    });

    test('file path', () {
      expect(() => AssetFile(['directory'], const GenericAsset(null, 'key', '')), throwsA(isA<AssertionError>()));
    });

    test('rawName', () {
      expect(AssetFile(['path', 'to', 'file.dart'], const GenericAsset(null, 'key', '')).rawName, 'file');
    });
  });
}
