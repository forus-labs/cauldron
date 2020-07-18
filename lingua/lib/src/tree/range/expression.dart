import 'dart:ui';

import 'package:lingua/src/tree/range/operator.dart';


abstract class Expression {

  const Expression();

  bool evaluate(num value);

  String syntax(String variable);

}


class Range extends Expression {

  final Bitwise operator;
  final Bound min;
  final Bound max;

  const Range(this.operator, this.min, this.max);
  
  @override
  bool evaluate(num value) => operator == Bitwise.and ? min.evaluate(value) && max.evaluate(value)
                                                       : min.evaluate(value) || max.evaluate(value);

  @override
  String syntax(String variable) => '${min.syntax(variable)} ${operator.syntax} ${max.syntax(variable)}';


  @override
  bool operator == (Object other) => other is Range && operator == other.operator && min == other.min && max == other.max;

  @override
  int get hashCode => hashValues(operator, min, max);


}


class Bound extends Expression {

  final Comparison operator;
  final num value;

  const Bound(this.operator, this.value);


  @override
  bool evaluate(num other) => operator.evaluate(other, value);

  @override
  String syntax(String variable) => '$variable ${operator.syntax} $value';

  bool get isMinimum => operator == Comparison.greater || operator == Comparison.greaterEqual;

  bool get isMaximum => !isMinimum;


  @override
  bool operator == (Object other) => other is Bound && operator == other.operator && value == other.value;

  @override
  int get hashCode => hashValues(operator, value);

}


class Literal extends Expression {

  final num value;

  const Literal(this.value);

  @override
  bool evaluate(num other) => value == other;

  @override
  String syntax(String variable) => '$variable == $value';


  @override
  bool operator == (Object other) => other is Literal && value == other.value;

  @override
  int get hashCode => value.hashCode;

}