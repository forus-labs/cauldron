import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/nitrogen_extension.dart';

/// A generator for extensions SVG assets.
class LottieExtensionGenerator {

  /// The imports.
  static final imports = [
    Directive.import('package:flutter/widgets.dart'),
    Directive.import('package:lottie/lottie.dart'),
    Libraries.importNitrogenTypes,
  ];

  /// The extension.
  static const extension = Code('''
/// Tested against lottie version: 3.1.1
/// 
/// Example:
/// ```dart
/// class Foo extends StatelessWidget {
///   final LottieAsset asset;
/// 
///   @override
///   Widget build(BuildContext context) => Container(
///     child: asset(
///       width: 100,
///       height: 100,
///     ),
///   );
/// }
/// ```
extension LottieAssetExtension on LottieAsset {

  LottieBuilder call({
    Animation<double>? controller,
    FrameRate? frameRate,
    bool? animate,
    bool? reverse,
    bool? repeat,
    LottieDelegates? delegates,
    LottieOptions? options,
    LottieImageProviderFactory? imageProviderFactory,
    void Function(LottieComposition)? onLoaded,
    Key? key,
    Widget Function(
      BuildContext context,
      Widget child,
      LottieComposition? composition,
    )? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    Alignment? alignment,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
    LottieDecoder? decoder,
    RenderCache? renderCache,
    bool? backgroundLoading,
  }) => LottieBuilder.asset(
    path,
    controller: controller,
    frameRate: frameRate,
    animate: animate,
    reverse: reverse,
    repeat: repeat,
    delegates: delegates,
    options: options,
    imageProviderFactory: imageProviderFactory,
    onLoaded: onLoaded,
    key: key,
    frameBuilder: frameBuilder,
    errorBuilder: errorBuilder,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    package: package,
    addRepaintBoundary: addRepaintBoundary,
    filterQuality: filterQuality,
    onWarning: onWarning,
    decoder: decoder,
    renderCache: renderCache,
    backgroundLoading: backgroundLoading,
  );

}
  ''');

  /// Generates extensions for interfacing between assets and 3rd party libraries.
  String generate() {
    final library = LibraryBuilder()
      ..directives.addAll(imports)
      ..body.add(Libraries.header('nitrogen_flutter_svg'))
      ..body.add(extension);

    return library.build().format();
  }

}
