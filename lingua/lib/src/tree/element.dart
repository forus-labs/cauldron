import 'package:lingua/src/tree/gender.dart';
import 'package:lingua/src/tree/range/expression.dart';
import 'package:lingua/src/tree/visitor.dart';


abstract class Element {

  final String lexeme;

  Element(this.lexeme);

  R visit<T, R>(Visitor<T, R> visitor, T parameter);

}

mixin Mapped<K, V extends Element> on Element {

  final Map<K, V> children = {};

}


class MapElement extends Element with Mapped<String, Element> {

  MapElement(String lexeme): super(lexeme);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitMap(this, parameter);

}


class PluralElement extends Element with Mapped<Expression, ValueElement> {

  final ValueElement defaultValue;

  PluralElement(String lexeme, this.defaultValue): super(lexeme);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitPlural(this, parameter);

}


class GenderElement extends Element with Mapped<Gender, ValueElement> {

  GenderElement(String lexeme) : super(lexeme);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitGender(this, parameter);

}


class ValueElement extends Element {

  final String value;
  final List<String> parameters;

  ValueElement(String lexeme, this.value, this.parameters): super(lexeme);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitValue(this, parameter);

}