import 'package:code_builder/code_builder.dart';
import 'package:sugar/sugar.dart';

import 'package:stevia_runner/src/assets/ast.dart';
import 'package:stevia_runner/src/assets/elements.dart';

/// Returns a deep copy of the given [folder] with the name replaced with [name].
Folder replace(String name, Folder folder) {
  final copy = Folder(name, '', folder.identifier, '', folder.package);
  copy.assets.addAll(folder.assets);
  copy.folders.addAll({
    for (final entry in folder.folders.entries)
      entry.key: replace('$name${entry.value.identifier.capitalize()}', entry.value),
  });

  return copy;
}

/// Provides functions for generating Dart code from [Folder]s.
extension FolderAst on Folder {

  /// Returns a constant field of the type which [skeleton] represents using parameters
  /// provided by this [Folder].
  Field themed(Folder skeleton) => Field((builder) =>
  builder..static = true
    ..modifier = FieldModifier.constant
    ..type = skeleton.type
    ..name = identifier
    ..assignment = instance(skeleton).code
  );

  /// Creates an instance of the type which [skeleton] represents using parameters
  /// provided by this [Folder].
  Expression instance(Folder skeleton) => skeleton.type.constInstance([], {
    for (final entry in folders.entries)
      entry.key: entry.value.instance(skeleton.folders[entry.key]!),

    for (final entry in assets.entries)
      entry.key: entry.value.expression,
  });

  /// A builder for a Dart class that represents this theme [Folder].
  ClassBuilder get themedDeclaration => ClassBuilder()
    ..name = '\$$name'
    ..fields.addAll([
      for (final folder in folders.values)
        Field((builder) =>
          builder..modifier = FieldModifier.final$
                 ..type = folder.type
                 ..name = folder.identifier
        ),

      for (final asset in assets.values)
        Field((builder) =>
        builder..modifier = FieldModifier.final$
          ..type = asset.type
          ..name = asset.identifier
        ),
    ])
    ..constructors.add(constructor);

  /// Returns a constructor for a type which represents this theme folder.
  Constructor get constructor => Constructor((builder) =>
    builder..constant = true
           ..optionalParameters.addAll([
             for (final folder in folders.values)
               folder.parameter,

             for (final asset in assets.values)
               asset.parameter,
           ])
  );

}

/// Provides functions for generating Dart code from [Element]s.
extension _ElementAst on Element {

  /// Returns a required named parameter that represents this [Element].
  Parameter get parameter => Parameter((builder) =>
    builder..required = true
           ..named = true
           ..toThis = true
           ..name = identifier
  );

}

/// Provides functions for generating parts of a class.
extension ClassBuilders on ClassBuilder {

  /// Adds a static method for retrieving a brightness's corresponding illustrations.
  void brightness(Iterable<Folder> themes) {
    final available = themes.map((theme) => theme.identifier).toSet();
    final light = available.contains('light');
    final dark = available.contains('dark');

    if (!light && !dark) {
      return;
    }

    methods.add(Method((builder) => builder
      ..static = true
      ..returns = refer(r'$ThemedIllustrations')
      ..name = 'of'
      ..requiredParameters.add(
          Parameter((builder) =>
          builder..type = refer('Brightness')
            ..name = 'brightness'
          )
      )
      ..body = Code('''
          switch (brightness) {
            case Brightness.light:
              return ${light ? 'light' : 'dark'};
            case Brightness.dark:
              return ${dark ? 'dark' : 'light'};
            default:
              return ${light ? 'light' : 'dark'};
          }
        ''')
    ));
  }

  /// Adds a static method for retrieving a theme's corresponding illustrations.
  void theme(Iterable<Folder> themes) {
    if (themes.isEmpty) {
      return;
    }

    methods.add(Method((builder) => builder
      ..static = true
      ..returns = refer(r'$ThemedIllustrations')
      ..name = 'theme'
      ..requiredParameters.add(
          Parameter((builder) =>
            builder..type = refer('Theme')
                   ..name = 'theme'
          )
      )
      ..body = Code('''
          switch (theme) {
            ${cases(themes)}
            default:
              return ${themes.first.identifier};
          }
        ''')
    ));
  }

  /// Returns the cases for themes.
  String cases(Iterable<Folder> themes) {
    final buffer = StringBuffer();
    for (final theme in themes) {
      final identifier = theme.identifier;
      buffer.write('''
      case Theme.$identifier:
        return $identifier;
      ''');
    }

    return buffer.toString();
  }

}
