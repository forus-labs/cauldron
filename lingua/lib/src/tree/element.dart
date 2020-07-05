mixin Element {

  R visit<T, R>(Visitor<T, R> visitor, T parameter);

}

class MapElement with Element {

  final Type type;
  final Map<String, Element> children = {};

  MapElement(this.type);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitMap(this, parameter);

}

enum Type {
  map, plural, gender
}


class ValueElement with Element {

  final String value;
  final Set<String> variables;

  ValueElement(this.value, this.variables);

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitField(this, parameter);

}

class ErrorElement with Element {

  final List<String> messages;

  ErrorElement(String message): messages = [message];

  @override
  R visit<T, R>(Visitor<T, R> visitor, T parameter) => visitor.visitError(this, parameter);

}


abstract class Visitor<T, R> {

  R visitMap(MapElement map, T parameter) => visitUnknown(map, parameter);

  R visitField(ValueElement field, T parameter) => visitUnknown(field, parameter);

  R visitError(ErrorElement error, T parameter) => visitUnknown(error, parameter);

  R visitUnknown(Element element, T parameter) => null;

}