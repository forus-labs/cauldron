import 'package:lingua/src/tree/gender.dart';
import 'package:lingua/src/tree/range/expression.dart';
import 'package:lingua/src/tree/visitor.dart';


abstract class Element {

  final String key;
  final String lexeme;

  Element(this.key, this.lexeme);

  R visit<T, R>(Visitor<T, R> visitor, T parameter);

}

mixin Mapped<K> on Element {

  final Map<K, Element> children = {};

}


class MapElement extends Element with Mapped<String> {

  MapElement(String key, String lexeme): super(key, lexeme);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitMap(this, parameter);

}

class PluralElement extends Element with Mapped<Expression> {

  PluralElement(String key, String lexeme): super(key, lexeme);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitPlural(this, parameter);

}

class GenderElement extends Element with Mapped<Gender> {

  GenderElement(String key, String lexeme) : super(key, lexeme);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitGender(this, parameter);

}


class ValueElement extends Element {

  final String value;
  final List<String> parameters = [];

  ValueElement(String key, String lexeme, this.value): super(key, lexeme);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitValue(this, parameter);

}