import 'dart:io';

import 'package:build/build.dart';

import 'package:stevia_runner/src/assets/build.dart' as assets;

/// An entry-point for `build_runner`.
Builder build(BuilderOptions options) {
  // This is usually frowned upon since we're directly modifying files on disk.
  // We do this because aggregating files using BuildSteps is a massive PITA.
  // Furthermore, when originally developed, build_runner refused to work with build_runners
  // declared as path dependencies. This made development extremely painful.
  assets.build(File('pubspec.yaml'));
  return EmptyBuilder();
}

/// An empty [Builder] that does not perform any operations.
class EmptyBuilder extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async {}

  @override
  Map<String, List<String>> get buildExtensions => {};
}
