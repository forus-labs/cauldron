import 'dart:async';
import 'dart:ui';

import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';
import 'package:yaml/yaml.dart';

import 'locales.dart';


const _defaultAssets = 'assets/languages/**.yaml';


class LanguageGenerator extends Generator {

  final String _assets;
  final Locale _fallback;

  LanguageGenerator(Map<String, dynamic> configuration): _assets = configuration['assets'] ?? _defaultAssets, _fallback = Locales.parse(configuration['fallback']) {
    if (_fallback == null) {
      throw LocaleError('"$_fallback" in build.yaml is an invalid fallback locale tag, should be "languageCode-countryCode"');
    }
  }

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep step) async {
      final files = await read(step);
  }

  @visibleForTesting
  Future<Map<Locale, YamlNode>> read(BuildStep step) async {
    final files = <Locale, YamlNode>{};
    final invalid = <String>{};

    await for (final asset in step.findAssets(Glob(_assets)).where((asset) => asset.path.endsWith('.yaml'))) {
      final tag = Locales.parse(asset.pathSegments.last.replaceAll('.yaml', ''));
      if (tag != null) {
        if (invalid.isEmpty) {
          files[tag] = loadYamlNode(await step.readAsString(asset));
        }

      } else {
        invalid.add(asset.path);
      }
    }

    if (invalid.isNotEmpty) {
      for (final file in invalid) {
        print('"$file" is an invalid locale file, should match "languageCode-countryCode"');
      }

      throw LocaleError('Project contains invalid locale files');
    }

    if (files.containsKey(_fallback)) {
      return files;

    } else {
      throw LocaleError('Locale file for "$_fallback" is missing, project should contain a local file for the fallback locale');
    }
  }

}

class LocaleError extends Error {

  String message;

  LocaleError(this.message);

}