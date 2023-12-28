import 'package:code_builder/code_builder.dart';

import 'package:stevia_runner/src/assets/elements.dart';

/// Provides functions for generating Dart code from [Folder]s.
extension FolderAst on Folder {

  /// A builder for a Dart class that represents this [Folder].
  ClassBuilder get declaration => ClassBuilder()
    ..name = '\$$name'
    ..constructors.add(constructor)
    ..methods.addAll(methods);

  /// An unnamed Dart constructor for creating an instance of [type].
  Constructor get constructor => Constructor((builder) => builder..constant = true);

  /// The methods that a Dart class that represents this [Folder] contains.
  List<Method> get methods => [
    for (final folder in folders.values)
      folder.method,

    for (final asset in assets.values)
      asset.method,
  ];

  /// A Dart constant assigned to an instance of [type].
  Field get constant => Field((builder) =>
    builder..static = true
           ..modifier = FieldModifier.constant
           ..type = type
           ..name = identifier
           ..assignment = type.constInstance([]).code
  );

  /// A Dart method that returns an instance of [type].
  Method get method => Method((builder) =>
    builder..returns = type
           ..type = MethodType.getter
           ..name = identifier
           ..lambda = true
           ..body = type.constInstance([]).code
  );

  /// The Dart type that represents this [Folder].
  Reference get type => refer('\$$name');

}

/// Provides functions for generating Dart code from [Asset]s.
extension AssetAst on Asset {

  /// A Dart constant assigned to an instance of [type].
  Field get constant => Field((builder) {
    builder..static = true
           ..modifier = FieldModifier.constant
           ..type = type
           ..name = identifier
           ..assignment = expression.code;
  });

  /// A Dart getter that returns an instance of [type].
  Method get method => Method((builder) =>
    builder..returns = type
           ..type = MethodType.getter
           ..name = identifier
           ..lambda = true
           ..body = expression.code
  );

  /// A Dart expression that creates an instance of [type].
  Expression get expression => switch (kind) {
    Kind.lottie || Kind.svg || Kind.image => type.constInstance([
      literal(key),
      literal(path),
      literal(package),
    ]),
    Kind.others => literal(path),
  };

  /// A Dart type that represents this [Asset].
  Reference get type => switch (kind) {
    Kind.lottie => refer('LottieAsset', 'package:stevia/widgets.dart'),
    Kind.image => refer('ImageAsset', 'package:stevia/widgets.dart'),
    Kind.svg => refer('SvgAsset', 'package:stevia/widgets.dart'),
    Kind.others => refer('String'),
  };

}
