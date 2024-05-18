import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

/// Provides utilities for working with libraries.
extension Libraries on Library {

  /// A header.
  static Code header([String package = 'nitrogen']) => Code('''
  
  
// GENERATED CODE - DO NOT MODIFY BY HAND
// 
// **************************************************************************
// $package
// **************************************************************************
//
// ignore_for_file: type=lint

''');

  /// An import statement for the `nitrogen_types` package.
  static final importNitrogenTypes = Directive.import('package:nitrogen_types/nitrogen_types.dart');

  static final _emitter = DartEmitter(orderDirectives: true, useNullSafetySyntax: true);
  static final _formatter = DartFormatter(pageWidth: 160);

  /// Returns this library, formatted.
  String format() {
    final code = accept(_emitter).toString();
    return _formatter.format(code);
  }

}
