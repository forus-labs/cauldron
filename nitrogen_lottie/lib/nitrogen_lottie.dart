import 'dart:async';

import 'package:build/build.dart';
import 'package:nitrogen_lottie/src/lottie_extension_generator.dart';
import 'package:path/path.dart';

/// Creates a [NitrogenLottieBuilder].
Builder nitrogenLottieBuilder(BuilderOptions options) => NitrogenLottieBuilder();

/// A Nitrogen builder.
class NitrogenLottieBuilder extends Builder {

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    await buildStep.writeAsString(
      AssetId(buildStep.inputId.package, join('lib', 'src', 'lottie_extension.nitrogen.dart')),
      LottieExtensionGenerator().generate(),
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    r'$package$': [
      'lib/src/lottie_extension.nitrogen.dart',
    ],
  };

}
