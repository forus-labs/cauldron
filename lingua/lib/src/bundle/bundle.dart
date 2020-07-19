import 'dart:ui';

import 'package:lingua/src/tree/element.dart';

class Bundle {

  final Locale locale;
  final Bundle parent;
  final Map<Locale, Bundle> children = {};
  Element element;


  Bundle(this.locale, this.parent, [this.element]);

  Bundle.root(Locale locale, Element element): this(locale, null, element);


  bool add(Locale locale, Element element) =>

}