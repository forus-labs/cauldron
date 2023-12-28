import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

/// An asset located in a project's assets directory.
///
/// **Note: **
/// This class is intended to be used in tandem with a code generation tool. Hence, an [Asset] should not be directly
/// created by a user.
sealed class Asset {
  /// This asset's key in SCREAMING_SNAKE_CASE.
  final String key;

  /// The path to this asset.
  final String path;

  /// The package that contains this asset.
  final String? package;

  /// Creates an [Asset] with the given parameters.
  const Asset(this.key, this.path, this.package);

}

/// An SVG image located in a projects assets directory.
///
/// The [call] method should be invoked to transform this asset into a widget.
///
/// **Note: **
/// This class is intended to be used in tandem with a code generation tool. Hence, an [SvgAsset] should not be directly
/// created by a user.
class SvgAsset extends Asset {
  /// Creates an [SvgAsset] with the given parameters.
  const SvgAsset(super.key, super.path, super.package);

  /// Creates a widget from this asset.
  SvgPicture call({
    bool matchTextDirection = false,
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
  }) => SvgPicture.asset(
    path,
    key: key,
    package: package,
    matchTextDirection: matchTextDirection,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    placeholderBuilder: placeholderBuilder,
    semanticsLabel: semanticsLabel,
    excludeFromSemantics: excludeFromSemantics,
    theme: theme,
    colorFilter: color == null ? null : ColorFilter.mode(color, colorBlendMode),
  );
}

/// A PNG/JPG image located in a projects assets directory.
///
/// The [call] method should be invoked to transform this asset into a widget.
///
/// **Note: **
/// This class is intended to be used in tandem with a code generation tool. Hence, an [ImageAsset] should not be directly
/// created by a user.
class ImageAsset extends Asset {
  /// Creates an [ImageAsset] with the given parameters.
  const ImageAsset(super.key, super.path, super.package);

  /// Creates a widget from this asset.
  Image call({
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
    Key? key,
  }) => Image.asset(
    path,
    package: package,
    frameBuilder: frameBuilder,
    errorBuilder: errorBuilder,
    semanticLabel: semanticLabel,
    excludeFromSemantics: excludeFromSemantics,
    scale: scale,
    width: width,
    height: height,
    color: color,
    opacity: opacity,
    colorBlendMode: colorBlendMode,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
    centerSlice: centerSlice,
    matchTextDirection: matchTextDirection,
    gaplessPlayback: gaplessPlayback,
    isAntiAlias: isAntiAlias,
    filterQuality: filterQuality,
    cacheWidth: cacheWidth,
    cacheHeight: cacheHeight,
    key: key,
  );
}

/// A Lottie animation located in a project's assets directory.
///
/// The [call] method should be invoked to transform this asset into a widget.
///
/// **Note: **
/// This class is intended to be used in tandem with a code generation tool. Hence, a [LottieAsset] should not be directly
/// created by a user.
class LottieAsset extends Asset {
  /// Creates a [LottieAsset] with the given path.
  const LottieAsset(super.key, super.path, super.package);

  /// Creates a widget from this asset.
  LottieBuilder call({
    Animation<double>? controller,
    bool? animate,
    FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    LottieDelegates? delegates,
    LottieOptions? options,
    void Function(LottieComposition)? onLoaded,
    LottieImageProviderFactory? imageProviderFactory,
    AssetBundle? bundle,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    Alignment? alignment,
    String? package,
    bool? addRepaintBoundary,
    Key? key,
  }) => LottieBuilder.asset(
    path,
    package: package ?? this.package,
    controller: controller,
    frameRate: frameRate,
    animate: animate,
    repeat: repeat,
    reverse: reverse,
    delegates: delegates,
    options: options,
    imageProviderFactory: imageProviderFactory,
    onLoaded: onLoaded,
    bundle: bundle,
    errorBuilder: errorBuilder,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    addRepaintBoundary: addRepaintBoundary,
    key: key,
  );
}
