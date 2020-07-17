import 'package:meta/meta.dart';

enum Comparison {
  greater,
  greaterEqual,
  lessEqual,
  less,
}

extension Comparisons on Comparison {

  static Comparison from(String operator) {
    switch (operator) {
      case '>':
        return Comparison.greater;
      case '>=':
        return Comparison.greaterEqual;
      case '<=':
        return Comparison.lessEqual;
      case '<':
        return Comparison.less;
      default:
        return null;
    }
  }


  Comparison flip({@required bool lhs}) {
    switch (this) {
      case Comparison.greater:
        return lhs ? Comparison.greater : Comparison.less;
      case Comparison.greaterEqual:
        return lhs ? Comparison.greaterEqual : Comparison.lessEqual;
      case Comparison.lessEqual:
        return lhs ? Comparison.lessEqual : Comparison.greaterEqual;
      case Comparison.less:
        return lhs ? Comparison.less : Comparison.greater;
      default:
        return this;
    }
  }


  bool evaluate(num lhs, num rhs) {
    switch (this) {
      case Comparison.greater:
        return lhs > rhs;
      case Comparison.greaterEqual:
        return lhs >= rhs;
      case Comparison.lessEqual:
        return lhs <= rhs;
      case Comparison.less:
        return lhs < rhs;
      default:
        throw ArgumentError.value(syntax);
    }
  }


  String get syntax {
    switch (this) {
      case Comparison.greater:
        return '>';
      case Comparison.greaterEqual:
        return '>=';
      case Comparison.lessEqual:
        return '<=';
      case Comparison.less:
        return '<';
      default:
        throw UnimplementedError();
    }
  }

}

enum Bitwise {
  and,
  or,
}

extension Bitwises on Bitwise {

  static Bitwise from(String bitwise) {
    switch (bitwise) {
      case '&&':
        return Bitwise.and;
      case '||':
        return Bitwise.or;
      default:
        return null;
    }
  }

  String get syntax {
    switch (this) {
      case Bitwise.and:
        return '&&';
      case Bitwise.or:
        return '||';
      default:
        throw UnimplementedError();
    }
  }

}