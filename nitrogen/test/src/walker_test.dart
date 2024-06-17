import 'package:build/build.dart';
import 'package:nitrogen_types/nitrogen_types.dart';
import 'package:test/test.dart';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/walker.dart';

void main() {
  group('walk(...)', () {
    test('ancestor asset directory is allowed', () {
      final walker = Walker('test_package', {'assets/path/'}, (segments) => segments.join('-'));
      final directory = AssetDirectory(['assets']);

      walker.walk(directory, AssetId('test_package', 'assets/path/to/file.txt'));

      expect(directory.children.isEmpty, true);
    });

    for (final (type, allowed) in [
      ('parent asset directory', 'assets/path/to/'),
      ('asset file', 'assets/path/to/file.txt'),
    ]) {
      test('$type is allowed', () {
        final walker = Walker('test_package', {allowed}, (segments) => segments.join('-'));
        final directory = AssetDirectory(['assets']);

        walker.walk(directory, AssetId('test_package', 'assets/path/to/file.txt'));

        final path = directory.children['path']! as AssetDirectory;
        final to = path.children['to']! as AssetDirectory;
        final file = to.children['file.txt']! as AssetFile;

        expect(file.path, ['assets', 'path', 'to', 'file.txt']);
        expect(
          file.asset,
          const GenericAsset(
            'test_package',
            'assets-path-to-file.txt',
            'assets/path/to/file.txt',
          ),
        );
        expect(file.rawName, 'file');
      });
    }

    for (final (extension, asset) in const [
      ('jpg', ImageAsset('test_package', 'assets-test.jpg', 'assets/test.jpg')),
      ('jpeg', ImageAsset('test_package', 'assets-test.jpeg', 'assets/test.jpeg')),
      ('png', ImageAsset('test_package', 'assets-test.png', 'assets/test.png')),
      ('json', LottieAsset('test_package', 'assets-test.json', 'assets/test.json')),
      ('svg', SvgAsset('test_package', 'assets-test.svg', 'assets/test.svg')),
      ('txt', GenericAsset('test_package', 'assets-test.txt', 'assets/test.txt')),
    ]) {
      test('$extension asset file', () {
        final walker = Walker('test_package', {'assets/'}, (segments) => segments.join('-'));
        final directory = AssetDirectory(['assets']);

        walker.walk(directory, AssetId('test_package', 'assets/test.$extension'));
        final file = directory.children['test.$extension']! as AssetFile;

        expect(file.path, ['assets', 'test.$extension']);
        expect(file.asset, asset);
        expect(file.rawName, 'test');
      });
    }
  });
}
