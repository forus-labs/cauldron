import 'package:code_builder/code_builder.dart';

import 'package:stevia_runner/src/assets/ast.dart';
import 'package:stevia_runner/src/assets/elements.dart';
import 'package:stevia_runner/src/assets/illustrations/ast.dart';

const _documentation = '''
/// The illustrations in this project. The keys of all illustrations is NOT guaranteed to be unique.
/// 
/// The generated code supports themed illustrations. 
/// ```
/// final illustrations = Illustrations.theme(Theme);
/// ```
/// 
/// Light and dark themes are considered special. Following the example below, they 
/// can be dynamically retrieved based on the current brightness.
/// ```
/// final illustrations = Illustrations.of(Brightness);
/// ```
/// 
/// Ad-hoc illustrations that are not part of a theme are also supported.''';

/// A code generator for illustrations in a project.
class Generation {

  final LibraryBuilder _library;

  /// Creates a [Generation] with the given target [LibraryBuilder].
  Generation(this._library);

  /// Generates Dart code for manipulating both themed and ad-hoc illustrations.
  void generate(Folder? skeleton, Iterable<Folder> themes, Folder adhoc) {
    _library..directives.add(Directive.import('dart:ui'))..body.addAll([
      Class((builder) => builder
        ..docs.add(_documentation)
        ..name = 'Illustrations'
        ..fields.addAll([
          for (final theme in themes)
            theme.themed(skeleton!),

          for (final folder in adhoc.folders.values)
            folder.constant,

          for (final asset in adhoc.assets.values)
            asset.constant,
        ])
        ..brightness(themes)
        ..theme(themes)
      ),
      declareTheme(themes),
    ]);

    if (skeleton != null) {
      declareThemes(skeleton);
    }

    declareAdhoc(adhoc);
  }

  /// Generates a theme enum that contains all generated themes.
  Enum declareTheme(Iterable<Folder> themes) => Enum((builder) => builder
    ..name = 'Theme'
    ..values.addAll([
      for (final theme in themes)
        EnumValue((builder) => builder.name = theme.identifier),
    ])
  );

  /// Recursively generates code for manipulating code in a theme folder.
  void declareThemes(Folder theme) {
    _library.body.add(theme.themedDeclaration.build());
    theme.folders.values.forEach(declareThemes);
  }

  /// Recursively generates code for manipulating code in an ad-hoc folder.
  void declareAdhoc(Folder adhoc) {
    for (final folder in adhoc.folders.values) {
      _library.body.add(folder.declaration.build());
    }

    adhoc.folders.values.forEach(declareAdhoc);
  }

}
