import 'package:build/build.dart';
import 'package:path/path.dart';
import 'package:sugar/sugar.dart';

import 'package:nitrogen/src/nitrogen_exception.dart';

/// Provides functions for generating asset keys.
extension Key on Never {
  /// Parses the `asset-key` node if valid.
  static String Function(List<String>) parse(String key) {
    switch (key) {
      case 'grpc-enum':
        return grpcEnum;

      case 'file-name':
        return fileName;

      default:
        log.severe('Unknown asset key: "$key". See https://github.com/forus-labs/cauldron/tree/master/nitrogen#key.');
        throw NitrogenException();
    }
  }

  /// Returns a key that is composed of a folder and file name in screaming case, i.e. 'FOLDER_FILE'.
  static String grpcEnum(List<String> path) =>
      path.sublist(path.length - 2).map(basenameWithoutExtension).join('-').toScreamingCase();

  /// Returns a key that uses the file name, i.e. `myFile`.
  static String fileName(List<String> path) => basenameWithoutExtension(path.last);
}
