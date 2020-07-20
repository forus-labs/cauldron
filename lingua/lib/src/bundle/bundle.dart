import 'dart:ui';

import 'package:lingua/src/tree/element.dart';

class Bundle {

  final Locale locale;
  final Bundle parent;
  final Map<Locale, Bundle> children = {};
  Element _element;


  Bundle(this.locale, this.parent, [this._element]);

  Bundle.root(this.locale, this._element): parent = null;

  factory Bundle.tree(Locale fallback, Map<Locale, Element> locales) {
    final root = Bundle.root(fallback, locales[fallback]);
    if (root.element == null) {
      throw ArgumentError.value(fallback, '${fallback.toLanguageTag()}.yaml does not exist, a file for the fallback locale should exist');
    }

    for (final entry in locales.entries) {
      final locale = entry.key;
      if (locale.countryCode != null) {
        root.child(Locale(locale.languageCode)).child(locale).element = entry.value;

      } else {
        root.child(locale).element = entry.value;
      }
    }

    return root;
  }


  Bundle child(Locale locale) => children[locale] ??= Bundle(locale, this);

  Element get element => _element;

  set element(Element element) {
    if (_element == null) {
      _element = element;

    } else {
      throw ArgumentError.value(locale, '${locale.toLanguageTag()}.yaml already exists');
    }
  }

}