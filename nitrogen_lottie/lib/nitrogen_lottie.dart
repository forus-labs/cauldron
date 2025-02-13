import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nitrogen_types/nitrogen_types.dart';

/// Provides functions for converting a [LottieAsset] to a [LottieBuilder].
///
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
  /// Converts a [LottieAsset] to a [LottieBuilder].
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
  }) =>
      LottieBuilder.asset(
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
