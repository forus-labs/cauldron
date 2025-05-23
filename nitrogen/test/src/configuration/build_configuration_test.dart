import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:nitrogen/src/configuration/build_configuration.dart';
import 'package:nitrogen/src/configuration/key.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

const valid = '''
package: true
docs: false
prefix: 'MyPrefix'
key: grpc-enum
assets:
  output: foo-output
themes:
  fallback: assets/path/to/first/fallback
  output: bar-output
''';

const invalid = '''
package: true
prefix: 'MyPrefix'
key: grpc-enum
invalid-nitrogen: true
assets:
  invalid-assets: true
themes:
  fallback: true
  invalid-theme: true
''';

void main() {
  group('lint(...)', () {
    test('invalid pubspec', () {
      expectLater(
        log.onRecord,
        emitsInOrder([
          warningLogOf(contains(
              'Unknown key, "invalid-nitrogen", in build.yaml\'s nitrogen configuration. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#configuration for valid configuration options.')),
          warningLogOf(contains(
              'Unknown key, "invalid-assets", in build.yaml\'s nitrogen assets configuration. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#assets for valid configuration options.')),
          warningLogOf(contains(
              'Unknown key, "invalid-theme", in build.yaml\'s nitrogen themes configuration. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#themes for valid configuration options.')),
        ]),
      );

      BuildConfiguration.lint(loadYaml(invalid));
    });
  });

  group('parseAssets(...)', () {
    test('valid configuration', () => expect(BuildConfiguration.parseAssets({'output': 'valid'}).output, 'valid'));

    test(
        'empty configuration', () => expect(BuildConfiguration.parseAssets({}).output, 'lib/src/assets.nitrogen.dart'));
  });

  group('parseThemes(...)', () {
    test('valid configuration', () {
      final configuration = BuildConfiguration.parseThemes({'fallback': 'valid-fallback', 'output': 'valid-output'});
      expect(configuration?.fallback, 'valid-fallback');
      expect(configuration?.output, 'valid-output');
    });

    test('no fallback', () => expect(BuildConfiguration.parseThemes({'output': 'valid-output'}), null));

    test(
        'no output',
        () => expect(
              BuildConfiguration.parseThemes({'fallback': 'valid-fallback'})?.output,
              'lib/src/asset_themes.nitrogen.dart',
            ));
  });

  group('parse(...)', () {
    test('valid configuration', () {
      final configuration = BuildConfiguration.parse(loadYaml(valid));

      expect(configuration.package, true);
      expect(configuration.docs, false);
      expect(configuration.prefix, 'MyPrefix');
      expect(configuration.key, Key.grpcEnum);
      expect(configuration.assets.output, 'foo-output');
      expect(configuration.themes?.fallback, 'assets/path/to/first/fallback');
      expect(configuration.themes?.output, 'bar-output');
    });
  });
}
