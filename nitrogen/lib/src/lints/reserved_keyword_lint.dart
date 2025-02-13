import 'package:build/build.dart';

import 'package:nitrogen/src/file_system.dart';
import 'package:nitrogen/src/nitrogen_exception.dart';

const _dartKeywords = {
  'assert',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'Function',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'sealed',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'with',
  'while',
  'yield',
};

const _nitrogenKeywords = {'contents'};

/// Lints the assets' paths for reserved keywords.
void lintReservedKeyword(AssetDirectory directory) {
  if (_lintReservedKeyword(directory)) {
    throw NitrogenException();
  }
}

bool _lintReservedKeyword(AssetDirectory directory) {
  var error = false;
  for (final entity in directory.children.values) {
    switch (entity.rawName) {
      case _ when _dartKeywords.contains(entity.rawName):
        log.severe(
            '"${entity.path.join('/')}" contains a reserved keyword. Please rename the directory/file. See https://dart.dev/language/keywords.');
        error = true;

      case _ when _nitrogenKeywords.contains(entity.rawName):
        log.severe(
            '"${entity.path.join('/')}" contains a reserved identifier. Please rename the directory/file. See https://github.com/forus-labs/cauldron/tree/master/nitrogen#reserved-keywords.');
        error = true;
    }

    if (entity is AssetDirectory) {
      error |= _lintReservedKeyword(entity);
    }
  }

  return error;
}
