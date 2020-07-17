abstract class Element {

  final String key;

  Element(this.key);

  R visit<T, R>(Visitor<T, R> visitor, T parameter);

}

class MapElement extends Element {

  final Type type;
  final Map<String, Element> children = {};

  MapElement(String key, this.type): super(key);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitMap(this, parameter);

}

enum Type {
  map, plural, gender
}


class ValueElement extends Element {

  final String value;
  final Set<String> variables;

  ValueElement(String key, this.value, this.variables): super(key);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitField(this, parameter);

}

class ErrorElement extends Element {

  final List<String> messages;

  ErrorElement(String key, this.messages): super(key);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitError(this, parameter);

}


abstract class Visitor<T, R> {

  R visitMap(MapElement map, T parameter) => visitUnknown(map, parameter);

  R visitField(ValueElement field, T parameter) => visitUnknown(field, parameter);

  R visitError(ErrorElement error, T parameter) => visitUnknown(error, parameter);

  R visitUnknown(Element element, T parameter) => null;

}