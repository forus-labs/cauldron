import 'package:code_builder/code_builder.dart';
import 'package:nitrogen/nitrogen_extension.dart';

/// A generator for extensions SVG assets.
class SvgExtensionGenerator {

  /// The imports.
  static final imports = [
    Directive.import('package:flutter/widgets.dart'),
    Directive.import('package:flutter_svg/svg.dart'),
    Libraries.importNitrogenTypes,
  ];

  /// The extension.
  static const extension = Code('''
/// Tested against flutter_svg version: 2.0.10+1
/// 
/// Example:
/// ```dart
/// class Foo extends StatelessWidget {
///   final SvgAsset asset;
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
extension SvgAssetExtension on SvgAsset {

  SvgPicture call({
    Key? key,
    bool matchTextDirection = false,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    @Deprecated('Parameter is deprecated in flutter_svg') Color? color,
    @Deprecated('Parameter is deprecated in flutter_svg') BlendMode colorBlendMode = BlendMode.srcIn,
    @Deprecated('Parameter is deprecated in flutter_svg') bool cacheColorFilter = false,
  }) => SvgPicture.asset(
    path,
    key: key,
    matchTextDirection: matchTextDirection,
    package: package,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    placeholderBuilder: placeholderBuilder,
    semanticsLabel: semanticsLabel,
    excludeFromSemantics: excludeFromSemantics,
    clipBehavior: clipBehavior,
    theme: theme,
    colorFilter: colorFilter,
    color: color,
    colorBlendMode: colorBlendMode,
    cacheColorFilter: cacheColorFilter,
  );

}
  ''');

  /// Generates extensions for interfacing between assets and 3rd party libraries.
  String generate() {
    final library = LibraryBuilder()
      ..directives.addAll(imports)
      ..body.add(Libraries.header('nitrogen_lottie'))
      ..body.add(extension);

    return library.build().format();
  }

}
