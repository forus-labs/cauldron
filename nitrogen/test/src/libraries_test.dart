import 'package:code_builder/code_builder.dart';
import 'package:test/test.dart';

import 'package:nitrogen/src/libraries.dart';

void main() {
  test('format()', () {
    final library = Library((b) => b.body.addAll([
      Libraries.importNitrogenTypes,
      Libraries.header('test'),
    ]));

    expect(library.format(), equals(
'''
import 'package:nitrogen_types/nitrogen_types.dart';

// GENERATED CODE - DO NOT MODIFY BY HAND
//
// **************************************************************************
// test
// **************************************************************************
//
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use
'''));
  });
}
