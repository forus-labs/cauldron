import 'dart:ui';

import 'package:meta/meta.dart';

import 'file:///C:/Users/Matthias/Documents/NetBeansProjects/cauldron/lingua/lib/src/old/element.dart';


final _delimiter = RegExp(r'(\s|-|_|\.)+');


class Normalizer extends Visitor<Locale, void> {

  void normalize(Map<Locale, Element> elements) {
    for (final entry in elements.entries) {
      entry.value.visit(this, entry.key);
    }
  }

  @visibleForTesting
  String camelCase(String name) {
    final buffer = StringBuffer();
    for (final part in name.trim().split(_delimiter)) {
      buffer.write(part[0].toUpperCase());
      if (part.length > 1) {
        buffer.write(part.substring(1, part.length));
      }
    }

    return buffer.toString();
  }

}