import 'dart:io';

const _icon = '''
class SvgIcon {

  final String _path;

  const SvgIcon._(this._path);

  SvgPicture call({required String semanticsLabel, Color? color, double? height, double? width}) => SvgPicture.asset(
    _path,
    color: color,
    height: height,
    width: width,
    semanticsLabel: semanticsLabel,
  );

}
''';