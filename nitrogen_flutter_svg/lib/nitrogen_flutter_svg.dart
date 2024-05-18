import 'dart:async';

import 'package:build/build.dart';
import 'package:nitrogen_flutter_svg/src/svg_extension_generator.dart';
import 'package:path/path.dart';

/// Creates a [NitrogenFlutterSvgBuilder].
Builder nitrogenFlutterSvgBuilder(BuilderOptions options) => NitrogenFlutterSvgBuilder();

/// A Nitrogen builder.
class NitrogenFlutterSvgBuilder extends Builder {

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    await buildStep.writeAsString(
      AssetId(buildStep.inputId.package, join('lib', 'src', 'svg_extension.nitrogen.dart')),
      SvgExtensionGenerator().generate(),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    r'$package$': [
      'lib/src/svg_extension.nitrogen.dart',
    ],
  };

}
