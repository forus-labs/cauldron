import 'package:code_builder/code_builder.dart';

import 'package:stevia_runner/src/assets/ast.dart';
import 'package:stevia_runner/src/assets/elements.dart';
import 'package:stevia_runner/src/assets/icon/ast.dart';

const _documentation = '''
/// The icons in this project. The keys of all icons in `SvgIcons` are guaranteed to be unique.
///
/// Following the example below, an icon can be accessed and transformed into an SvgPicture widget.
/// ```
/// SvgPicture icon = SvgIcons.my.path.icon();
/// ```
/// 
/// Icons in a folder (and its folders) can also be iterated over. For example:
/// ```
/// for (SvgAsset icon in SvgIcons.my.path) 
///   ...
/// }
/// ```
///
/// Lastly, an icon can be retrieved by its key. For example:
/// ```
/// SvgAsset icon = SvgIcons.my.path['MY_PATH_ICON_KEY'];
/// ```''';

const _typedef = Code('''
/// Represent an [SvgAsset]'s key. It is always in screaming case.
typedef SvgAssetKey = String;
''');

/// A code generator for icons in a project.
class Generation {

  final LibraryBuilder _library;

  /// Creates a [Generation] with the given target [LibraryBuilder].
  Generation(this._library);

  /// Generates Dart code for manipulating icons in the given [root].
  void generate(Folder root) {
    _library.body.addAll([
      _typedef,
      Class((builder) => builder
        ..docs.add(_documentation)
        ..name = 'SvgIcons'
        ..fields.addAll([
          for (final folder in root.folders.values)
            folder.constant,

          for (final asset in root.assets.values)
            asset.constant,
        ])
        ..constructors.add(Constructor((builder) => builder..constant = true))
        ..iterable(root)
    )]);

    root.folders.values.forEach(declare);
  }

  /// Recursively generates code for manipulating code in a folder.
  void declare(Folder folder) {
    final declaration = folder.declaration..iterable(folder);

    _library.body.add(declaration.build());
    folder.folders.values.forEach(declare);
  }

}
