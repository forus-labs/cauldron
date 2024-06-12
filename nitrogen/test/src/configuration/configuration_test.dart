import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:nitrogen/src/configuration/configuration.dart';
import 'package:nitrogen/src/configuration/key.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// ignore_for_file: avoid_dynamic_calls

const _invalid = '''
name: hi
flutter:
  assets:
    - path/to/first/
    - path/to/second/
nitrogen:
  package: true
  prefix: 'MyPrefix'
  key: grpc-enum
  invalid-nitrogen: true
  themes:
    fallback: true
    invalid-theme: true
''';


const _pubspec = '''
name: hi
flutter:
  assets:
    - path/to/first/
    - path/to/second/
nitrogen:
  package: true
  prefix: 'MyPrefix'
  key: grpc-enum
  themes:
    fallback: assets/path/to/first/fallback
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
  group('lint(...)', () {
    test('invalid pubspec', () {
      expectLater(
        log.onRecord,
        emitsInOrder([
          warningLogOf(contains('Unknown key, "invalid-nitrogen", in pubspec.yaml\'s nitrogen section. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#configuration for valid configuration options.')),
          warningLogOf(contains('Unknown key, "invalid-theme", in pubspec.yaml\'s nitrogen section. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#themes for valid configuration options.')),
        ]),
      );

      Configuration.lint(loadYaml(_invalid));
    });
  });

  group('parse(...)', () {
    test('valid pubspec', () {
      final configuration = Configuration.parse(loadYaml(_pubspec));

      expect(configuration.package, 'hi');
      expect(configuration.prefix, 'MyPrefix');
      expect(configuration.key, Key.grpcEnum);
      expect(configuration.fallbackTheme, 'assets/path/to/first/fallback');
      expect(configuration.flutterAssets, { 'path/to/first/', 'path/to/second/' });
    });

    test('no nitrogen section', () {
      final configuration = Configuration.parse(loadYaml(_noNitrogen));

      expect(configuration.package, null);
      expect(configuration.prefix, '');
      expect(configuration.key, Key.fileName);
      expect(configuration.fallbackTheme, null);
      expect(configuration.flutterAssets, { 'path/to/first/', 'path/to/second/' });
    });
  });

  group('parsePackage(...)', () {
    test('use package name', () => expect(Configuration.parsePackage(loadYamlNode('nitrogen'), loadYamlNode('true')), 'nitrogen'));

    test('use package name & invalid name', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to read package name in pubspec.yaml. See https://dart.dev/tools/pub/pubspec#name.'))),
      );
      expect(
        () => Configuration.parsePackage(loadYamlNode('true'), loadYamlNode('true')),
        throwsA(isA<NitrogenException>()),
      );
    });

    test('do not use package name & invalid name', () => expect(Configuration.parsePackage(loadYamlNode('true'), loadYamlNode('false')), null));

    test('null & invalid name', () => expect(Configuration.parsePackage(loadYamlNode('true'), null), null));

    test('invalid package usage', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to read package name. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#package.'))),
      );
      expect(
        () => Configuration.parsePackage(loadYamlNode('nitrogen'), loadYamlNode('invalid')),
        throwsA(isA<NitrogenException>()),
      );
    });
  });

  group('parsePrefix(...)', () {
    test('prefix', () => expect(Configuration.parsePrefix(loadYamlNode('something')), 'something'));

    test('null', () => expect(Configuration.parsePrefix(null), ''));

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to read prefix. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#prefix.'))),
      );
      expect(() => Configuration.parsePrefix(loadYamlNode('true')), throwsA(isA<NitrogenException>()));
    });
  });

  group('parseFallbackTheme(...)', () {
    test('fallback theme', () => expect(Configuration.parseFallbackTheme(loadYamlNode('fallback: assets/path/to/fallback')), 'assets/path/to/fallback'));

    test('null', () => expect(Configuration.parseFallbackTheme(null), null));

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to read themes. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#themes.'))),
      );
      expect(() => Configuration.parseFallbackTheme(loadYamlNode('true')), throwsA(isA<NitrogenException>()));
    });
  });

  group('parseFlutterAssets(...)', () {
    test('assets', () => expect(
      Configuration.parseFlutterAssets(loadYaml(_flutterAssets).nodes['assets']),
      { 'path/to/first/', 'path/to/second/' },
    ));

    test('null', () => expect(
      Configuration.parseFlutterAssets(null),
      <String>{},
    ));

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to read flutter assets. See https://docs.flutter.dev/tools/pubspec#assets.'))),
      );
      expect(() => Configuration.parseFlutterAssets(loadYaml('assets: invalid').nodes['assets']), throwsA(isA<NitrogenException>()));
    });
  });
}
