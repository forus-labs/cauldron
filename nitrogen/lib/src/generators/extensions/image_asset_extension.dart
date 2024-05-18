import 'package:code_builder/code_builder.dart';

/// The extension to generate for image extension v1.
extension Image on Never {

  /// The imports.
  static final imports = [
    Directive.import('package:flutter/widgets.dart'),
  ];

  /// The extension.
  static const extension = Code('''
/// Tested against Flutter 3.19.4.
///
/// Example:
/// ```dart
/// class Foo extends StatelessWidget {
///   final ImageAsset asset;
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
extension ImageAssetExtension on ImageAsset {

  Image call({
    Key? key,
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
  ''');


}
