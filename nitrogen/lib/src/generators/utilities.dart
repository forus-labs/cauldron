import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

/// A header.
const header = Code('''
// GENERATED CODE - DO NOT MODIFY BY HAND
// 
// **************************************************************************
// nitrogen
// **************************************************************************
//
// ignore_for_file: type=lint
''');

/// An import statement for the `nitrogen_types` package.
final nitrogenTypes = Directive.import('package:nitrogen_types/nitrogen_types.dart');

/// Provides functions for working with [Library].
extension FormattedDartLibrary on Library {

  static final _emitter = DartEmitter(orderDirectives: true, useNullSafetySyntax: true);
  static final _formatter = DartFormatter(pageWidth: 160);

  /// The library as formatted Dart code.
  String get code {
    final unformatted = accept(_emitter).toString();
    if (unformatted.isEmpty) {
      return unformatted;
    }

    return _formatter.format(unformatted);
  }

}
