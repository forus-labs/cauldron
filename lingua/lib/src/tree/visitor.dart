import 'package:lingua/src/tree/element.dart';


mixin Visitor<T, R> {

  R visitMap(MapElement element, T parameter) => visitElement(element, parameter);

  R visitPlural(PluralElement element, T parameter) => visitElement(element, parameter);

  R visitGender(GenderElement element, T parameter) => visitElement(element, parameter);

  R visitValue(ValueElement element, T parameter) => visitElement(element, parameter);


  R visitElement(Element element, T parameter);

}