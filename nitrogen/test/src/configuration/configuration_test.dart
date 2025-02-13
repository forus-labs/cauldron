import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'package:nitrogen/src/configuration/build_configuration.dart';
import 'package:nitrogen/src/configuration/configuration.dart';
import 'package:nitrogen/src/configuration/key.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';

// ignore_for_file: avoid_dynamic_calls

const _pubspec = '''
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
  final buildConfiguration = BuildConfiguration(
    package: true,
    docs: false,
    prefix: 'MyPrefix',
    key: Key.grpcEnum,
    assets: (output: 'foo-output'),
    themes: (fallback: 'some-path', output: 'bar-output'),
  );

  group('merge(...)', () {
    test('valid pubspec', () {
      final configuration = Configuration.merge(buildConfiguration, loadYaml(_pubspec));

      expect(configuration.package, 'hi');
      expect(configuration.prefix, buildConfiguration.prefix);
      expect(configuration.key, buildConfiguration.key);
      expect(configuration.assets, buildConfiguration.assets);
      expect(configuration.themes, buildConfiguration.themes);
      expect(configuration.flutterAssets, {'path/to/first/', 'path/to/second/'});
    });
  });

  group('parsePackage(...)', () {
    test('use package name',
        () => expect(Configuration.parsePackage(loadYamlNode('nitrogen'), enabled: true), 'nitrogen'));

    test('use package name & invalid name', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(
            contains('Unable to read package name in pubspec.yaml. See https://dart.dev/tools/pub/pubspec#name.'))),
      );
      expect(
        () => Configuration.parsePackage(loadYamlNode('true'), enabled: true),
        throwsA(isA<NitrogenException>()),
      );
    });

    test('do not use package name & invalid name',
        () => expect(Configuration.parsePackage(loadYamlNode('true'), enabled: false), null));
  });

  group('parseFlutterAssets(...)', () {
    test(
        'assets',
        () => expect(
              Configuration.parseFlutterAssets(loadYaml(_flutterAssets).nodes['assets']),
              {'path/to/first/', 'path/to/second/'},
            ));

    test(
        'null',
        () => expect(
              Configuration.parseFlutterAssets(null),
              <String>{},
            ));

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(
            severeLogOf(contains('Unable to read flutter assets. See https://docs.flutter.dev/tools/pubspec#assets.'))),
      );
      expect(() => Configuration.parseFlutterAssets(loadYaml('assets: invalid').nodes['assets']),
          throwsA(isA<NitrogenException>()));
    });
  });
}
