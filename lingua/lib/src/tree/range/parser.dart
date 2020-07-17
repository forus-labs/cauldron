import 'package:meta/meta.dart';

import 'package:lingua/src/tree/context.dart';
import 'package:lingua/src/tree/range/expression.dart';
import 'package:lingua/src/tree/range/operator.dart';


List<dynamic> lex(Context context, String expression) {
  expression = expression.trim();
  final tokens = [];

  for (final part in expression.split(RegExp('r\s+'))) {
    final literal = num.tryParse(part);
    if (literal != null) {
      tokens.add(literal);
      continue;
    }

    final operator = Comparisons.from(part) ?? Bitwises.from(part);
    if (operator != null) {
      tokens.add(operator);

    } else {
      return ['${context.location} is not a valid range'];
    }
  }

  return tokens;
}


dynamic parse(Context context, List<dynamic> tokens) {
  final expressions = binary(context, bound(literal(tokens)));
  if (expressions.length == 1) {
    return expressions[0];

  } else {
    return ['${context.location} is not a valid range'];
  }
}


@visibleForTesting
List<dynamic> literal(List<dynamic> tokens) => [
  for (final token in tokens)
    if (token is num)
      Literal(token)
    else
      token
];


@visibleForTesting
List<dynamic> bound(List<dynamic> tokens) {
  final results = [];
  while (tokens.isNotEmpty) {
    final token = tokens.removeAt(0);
    if (tokens.isEmpty) {
      return results..add(token);
    }

    if (token is Literal && tokens[0] is Comparison) {
      results.add(Bound(tokens.removeAt(0).flip(lhs: false), token.value));

    } else if (token is Comparison && tokens[0] is Literal) {
      results.add(Bound(token.flip(lhs: true), tokens.removeAt(0)).value);

    } else {
      results.add(token);
    }
  }

  return results;
}


@visibleForTesting
List<dynamic> binary(Context context, List<dynamic> tokens) {
  final results = [];
  while (tokens.isNotEmpty) {
    if (tokens.length < 3) {
      return results..addAll(tokens);
    }

    if (tokens[0] is Bound && tokens[1] is Bitwise && tokens[2] is Bound) {
      results.add(range(context, tokens.removeAt(0), tokens.removeAt(0), tokens.removeAt(0)));

    } else {
      results.add(tokens.removeAt(0));
    }
  }

  return results;
}

@visibleForTesting
dynamic range(Context context, Bound lhs, Bitwise bitwise, Bound rhs) {
  if (lhs.isMinimum && rhs.isMaximum) {
    return _range(context, bitwise, min: lhs, max: rhs);

  } else if (lhs.isMaximum && rhs.isMinimum) {
    return _range(context, bitwise, min: rhs, max: lhs);

  } else {
    return '${context.location} is invalid, range should have a minimum and maximum bound';
  }
}

dynamic _range(Context context, Bitwise bitwise, {@required Bound min, @required Bound max}) {
  if (bitwise == Bitwise.and) {
    final range = max.value - min.value;
    if (range > 0 || (range == 0 && min.operator == Comparison.greaterEqual && max.operator == Comparison.lessEqual)) {
      return Range(bitwise, min, max);

    } else {
      return '${context.location} is invalid, maximum bound should not be less than minimum bound';
    }

  } else {
    final range = min.value - max.value;
    if (range > 0 || (range == 0 && (min.operator == Comparison.greaterEqual || max.operator == Comparison.lessEqual))) {
      return Range(bitwise, min, max);

    } else {
      return '${context.location} is invalid, maximum bound should not be greater than minimum bound';
    }
  }
}