import 'dart:async';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/generators/assets/standard_generator.dart';
import 'package:nitrogen/src/walker.dart';
import 'package:path/path.dart';
import 'package:sugar/sugar.dart';
import 'package:yaml/yaml.dart';

Builder nitrogenBuilder(BuilderOptions options) => NitrogenBuilder();

class NitrogenBuilder extends Builder {

  static final _pubspec = Glob('pubspec.yaml');
  static final _assets = Glob('assets/**');
  
  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final pubspec = loadYaml(await buildStep.readAsString(await buildStep.findAssets(_pubspec).first));

    final walker = Walker(
      'essential_assets',
      { ...pubspec['flutter']['assets'] as YamlList },
      (paths) => paths.sublist(paths.length - 2).map(basenameWithoutExtension).join('-').toScreamingCase(),
    );

    final assets = AssetDirectory(['assets']);
    await for (final asset in buildStep.findAssets(_assets)) {
      walker.walk(assets, asset);
    }

    await buildStep.writeAsString(
      AssetId(buildStep.inputId.package, join('lib', 'assets.nitrogen.dart')),
      StandardGenerator(assets, {}).generate(),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => { r'$package$': [ 'lib/assets.nitrogen.dart' ] };
  
}
