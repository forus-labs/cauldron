import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:nitrogen/src/configuration/assets.dart';
import 'package:nitrogen/src/configuration/configuration.dart';
import 'package:nitrogen/src/configuration/configuration_exception.dart';
import 'package:nitrogen/src/configuration/key.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// ignore_for_file: avoid_dynamic_calls

const _pubspec = '''
name: hi
flutter:
  assets:
    - path/to/first/
    - path/to/second/
nitrogen:
  package: true
  prefix: 'MyPrefix'
  flutter-extension: true
  asset-key: grpc-enum
  assets: basic
''';

const _noNitrogen = '''
name: hi
flutter:
  assets:
    - path/to/first/
    - path/to/second/
''';

const _flutterAssets = '''
assets:
  - path/to/first/
  - path/to/second/
''';

void main() {
  group('parse(...)', () {
    test('valid pubspec', () {
      final configuration = Configuration.parse(loadYaml(_pubspec));

      expect(configuration.package, 'hi');
      expect(configuration.prefix, 'MyPrefix');
      expect(configuration.flutterExtension, true);
      expect(configuration.key, Key.grpcEnum);
      expect(configuration.assets, isA<BasicAssets>());
      expect(configuration.flutterAssets, { 'path/to/first/', 'path/to/second/' });
    });

    test('no nitrogen section', () {
      final configuration = Configuration.parse(loadYaml(_noNitrogen));

      expect(configuration.package, null);
      expect(configuration.prefix, '');
      expect(configuration.flutterExtension, true);
      expect(configuration.key, Key.fileName);
      expect(configuration.assets, isA<StandardAssets>());
      expect(configuration.flutterAssets, { 'path/to/first/', 'path/to/second/' });
    });
  });

  group('parsePackage(...)', () {
    test('use package name', () => expect(Configuration.parsePackage(loadYamlNode('nitrogen'), loadYamlNode('true')), 'nitrogen'));

    test('use package name & invalid name', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains("Unable to read package name from project's pubspec.yaml. See https://dart.dev/tools/pub/pubspec#name."))),
      );
      expect(
        () => Configuration.parsePackage(loadYamlNode('true'), loadYamlNode('true')),
        throwsA(isA<ConfigurationException>()),
      );
    });

    test('do not use package name & invalid name', () => expect(Configuration.parsePackage(loadYamlNode('true'), loadYamlNode('false')), null));

    test('null & invalid name', () => expect(Configuration.parsePackage(loadYamlNode('true'), null), null));

    test('invalid package usage', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to configure package name. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#package.'))),
      );
      expect(
        () => Configuration.parsePackage(loadYamlNode('nitrogen'), loadYamlNode('invalid')),
        throwsA(isA<ConfigurationException>()),
      );
    });
  });

  group('parsePrefix(...)', () {
    test('prefix', () => expect(Configuration.parsePrefix(loadYamlNode('something')), 'something'));

    test('null', () => expect(Configuration.parsePrefix(null), ''));

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to configure class prefix. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#prefix.'))),
      );
      expect(() => Configuration.parsePrefix(loadYamlNode('true')), throwsA(isA<ConfigurationException>()));
    });
  });

  group('parseFlutterExtension(...)', () {
    test('true', () => expect(Configuration.parseFlutterExtension(loadYamlNode('true')), true));

    test('false', () => expect(Configuration.parseFlutterExtension(loadYamlNode('false')), false));

    test('null', () => expect(Configuration.parseFlutterExtension(null), true));

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to configure flutter extension. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#flutter-extension.'))),
      );
      expect(() => Configuration.parseFlutterExtension(loadYamlNode('invalid')), throwsA(isA<ConfigurationException>()));
    });
  });

  group('parseFlutterAssets(...)', () {
    test('assets', () => expect(
      Configuration.parseFlutterAssets(BasicAssets(), loadYaml(_flutterAssets).nodes['assets']),
      { 'path/to/first/', 'path/to/second/' },
    ));

    test('null', () => expect(
      Configuration.parseFlutterAssets(BasicAssets(), null),
      <String>{},
    ));

    test('NoAssets', () => expect(
      Configuration.parseFlutterAssets(NoAssets(), loadYaml(_flutterAssets).nodes['assets']),
      <String>{},
    ));

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to parse flutter assets. See https://docs.flutter.dev/tools/pubspec#assets.'))),
      );
      expect(() => Configuration.parseFlutterAssets(StandardAssets(), loadYaml('assets: invalid').nodes['assets']), throwsA(isA<ConfigurationException>()));
    });
  });
}
