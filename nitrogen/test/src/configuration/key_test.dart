import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:nitrogen/src/configuration/configuration_exception.dart';
import 'package:nitrogen/src/configuration/key.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// ignore_for_file: avoid_dynamic_calls

void main() {
  group('parse', () {
    test('grpc-enum', () {
      final key = Key.parse(loadYaml('asset-key: grpc-enum').nodes['asset-key']);
      expect(key(['path', 'to', 'file.png']), 'TO_FILE');
    });

    test('file-name', () {
      final key = Key.parse(loadYaml('asset-key: file-name').nodes['asset-key']);
      expect(key(['path', 'to', 'file.png']), 'file');
    });

    test('null', () {
      final key = Key.parse(null);
      expect(key(['path', 'to', 'file.png']), 'file');
    });

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to configure asset key. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#asset-key.'))),
      );
      expect(() => Key.parse(loadYaml('asset-key: invalid').nodes['asset-key']), throwsA(isA<ConfigurationException>()));
    });
  });
}
