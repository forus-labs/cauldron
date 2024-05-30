import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:nitrogen/src/configuration/assets.dart';
import 'package:nitrogen/src/configuration/configuration_exception.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// ignore_for_file: avoid_dynamic_calls

const _theme = '''
assets:
  theme:
    fallback: some-theme
    path: assets/path/to/themes
''';

void main() {
  group('parse(...)', () {
    test('none', () {
      expect(Assets.parse(loadYaml('assets: none').nodes['assets']), isA<NoAssets>());
    });

    test('basic', () {
      expect(Assets.parse(loadYaml('assets: basic').nodes['assets']), isA<BasicAssets>());
    });

    test('standard', () {
      expect(Assets.parse(loadYaml('assets: standard').nodes['assets']), isA<StandardAssets>());
    });

    test('null', () {
      expect(Assets.parse(null), isA<StandardAssets>());
    });

    test('theme', () {
      expect(
        Assets.parse(loadYaml(_theme).nodes['assets']),
        ThemeAssets(fallback: 'some-theme', path: 'assets/path/to/themes'),
      );
    });

    test('invalid', () {
      expectLater(
        log.onRecord,
        emits(severeLogOf(contains('Unable to configure asset generation. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#assets.'))),
      );
      expect(() => Assets.parse(loadYaml('assets: invalid').nodes['assets']), throwsA(isA<ConfigurationException>()));
    });
  });
}
