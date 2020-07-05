import 'dart:ui';

import 'package:meta/meta.dart';

import 'package:lingua/src/tree/element.dart';

final _delimiter = RegExp(r'(\s|\.');

class Normalizer extends Visitor<Locale, void> {

  void normalize(Map<Locale, Element> elements) {
    for (final entry in elements.entries) {
      entry.value.visit(this, entry.key);
    }
  }

  @override
  void visitMap(MapElement element, Locale locale) {
    final children = <String, Element>{};
    for (final entry in element.children.entries) {
      final key = camelCase(entry.key);
    }
  }

  @visibleForTesting
  String camelCase(String key) {
    final buffer = StringBuffer();
    for (final part in key.split(_delimiter)) {
      if (part.isEmpty) {
        continue;
      }

      buffer.write(part[0].toUpperCase());
      if (part.length > 1) {
        buffer.write(part.substring(1, part.length));
      }
    }

    return buffer.toString();
  }

}