import 'package:lingua/src/tree/range/expression.dart';

abstract class Visitor<T, R> {

  R visitRange(Range range, T parameter) => visitUnknown(range, parameter);

  R visitBound(Bound bound, T parameter) => visitUnknown(bound, parameter);

  R visitValue(Literal value, T parameter) => visitUnknown(value, parameter);

  R visitUnknown(Expression expression, T parameter);

}