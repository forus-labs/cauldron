import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'package:nitrogen/src/configuration/key.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';

// ignore_for_file: avoid_dynamic_calls

void main() {
  group('parse', () {
    test('grpc-enum', () {
      final key = Key.parse(loadYaml('key: grpc-enum')['key']);
      expect(key(['path', 'to', 'file.png']), 'TO_FILE');
    });

    test('file-name', () {
      final key = Key.parse(loadYaml('key: file-name')['key']);
      expect(key(['path', 'to', 'file.png']), 'file');
    });

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unknown asset key: "invalid". See https://github.com/forus-labs/cauldron/tree/master/nitrogen#key.'))),
      );
      expect(() => Key.parse(loadYaml('key: invalid')['key']), throwsA(isA<NitrogenException>()));
    });
  });
}
